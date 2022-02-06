Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3066AC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Feb 2022 22:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiBFWlQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Feb 2022 17:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiBFWlQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Feb 2022 17:41:16 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE3A5C061348
        for <linux-xfs@vger.kernel.org>; Sun,  6 Feb 2022 14:41:15 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 93BB152C6DC;
        Mon,  7 Feb 2022 09:18:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nGprV-008vVa-3g; Mon, 07 Feb 2022 09:18:25 +1100
Date:   Mon, 7 Feb 2022 09:18:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: return error from sync_filesystem during remount
Message-ID: <20220206221825.GC59729@dread.disaster.area>
References: <20220205025652.GY8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205025652.GY8313@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62004932
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=2nPPRpDZnjbgIPhhDykA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 04, 2022 at 06:56:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xfs_fs_reconfigure, check the return value from sync_filesystem and
> fail the remount if there was an internal error.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4c0dee78b2f8..5f3781879c63 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1831,7 +1831,9 @@ xfs_fs_reconfigure(
>  	if (error)
>  		return error;
>  
> -	sync_filesystem(mp->m_super);
> +	error = sync_filesystem(mp->m_super);
> +	if (error)
> +		return error;
>  
>  	/* inode32 -> inode64 */
>  	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {

Ummm, so why do we even need to call sync_filesystem()
unconditionally here?  The only case where we have to actually write
back anything on a remount is the rw->ro case, otherwise we aren't
changing any state that requires data or metadata writeback.

I had a look at why sync_filesytem() was there, and it goes back to
this commit that moved it from the VFS remount code:

commit 02b9984d640873b7b3809e63f81a0d7e13496886
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Mar 13 10:14:33 2014 -0400

    fs: push sync_filesystem() down to the file system's remount_fs()
    
    Previously, the no-op "mount -o mount /dev/xxx" operation when the
    file system is already mounted read-write causes an implied,
    unconditional syncfs().  This seems pretty stupid, and it's certainly
    documented or guaraunteed to do this, nor is it particularly useful,
    except in the case where the file system was mounted rw and is getting
    remounted read-only.
    
    However, it's possible that there might be some file systems that are
    actually depending on this behavior.  In most file systems, it's
    probably fine to only call sync_filesystem() when transitioning from
    read-write to read-only, and there are some file systems where this is
    not needed at all (for example, for a pseudo-filesystem or something
    like romfs).

And later on __ext4_remount got modified to only call
sync_filesystem() on rw->ro transition. We do not depend on
sync_filesystem() for anything here except in the rw->ro remount
case, so why don't we just move the sync_filesystem() call to
xfs_remount_ro()? We already have an error path there for failing to
clean the filesystem, and avoids the possibility of other random
mount option changes failing because some because there is some
random pending data writeback error....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
