Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD3DC4321E
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 17:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiBGRVN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 12:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345412AbiBGRHa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 12:07:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76CAC0401D1
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 09:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FC78B81157
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 17:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D89C004E1;
        Mon,  7 Feb 2022 17:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644253647;
        bh=g8puCuyNkDAUZefMsQycACyjbf4OLY2gGTB9kPIKKCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTKSgfBu3I66o2cfuLqlyfUJWvoP2B7MmPOOWmTIFi2QUxCtpyKAjRi9WIdkxZL7T
         XMBpATRdpu6FdH8Z2Ews6IL8G+f2nzEKUpmm1CTMwSlhEQ84fZGf3+lEBYhCONa+3S
         TZyKD10cj9bJODRSOHB4J2EF9rPtOUWkT29GKUnHwfRHbqY8B/A5vBN6uSfNzUbpAf
         IpVTJYBTQM5yx74OK7u+OBqhtg95/HgoacCeGJZuig3+VZWP/T1Q3D5Q+Ru2UOc+OV
         /mfZXVcHvdz6aAjF/meAJTm1USDeP8rXceGil6icUgzeWnoCNL7UT6ASui6QjfYTIE
         2zn4MGAxkHlrw==
Date:   Mon, 7 Feb 2022 09:07:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: return error from sync_filesystem during remount
Message-ID: <20220207170726.GZ8313@magnolia>
References: <20220205025652.GY8313@magnolia>
 <20220206221825.GC59729@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220206221825.GC59729@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 09:18:25AM +1100, Dave Chinner wrote:
> On Fri, Feb 04, 2022 at 06:56:52PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In xfs_fs_reconfigure, check the return value from sync_filesystem and
> > fail the remount if there was an internal error.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_super.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 4c0dee78b2f8..5f3781879c63 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1831,7 +1831,9 @@ xfs_fs_reconfigure(
> >  	if (error)
> >  		return error;
> >  
> > -	sync_filesystem(mp->m_super);
> > +	error = sync_filesystem(mp->m_super);
> > +	if (error)
> > +		return error;
> >  
> >  	/* inode32 -> inode64 */
> >  	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
> 
> Ummm, so why do we even need to call sync_filesystem()
> unconditionally here?  The only case where we have to actually write
> back anything on a remount is the rw->ro case, otherwise we aren't
> changing any state that requires data or metadata writeback.
> 
> I had a look at why sync_filesytem() was there, and it goes back to
> this commit that moved it from the VFS remount code:
> 
> commit 02b9984d640873b7b3809e63f81a0d7e13496886
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Mar 13 10:14:33 2014 -0400
> 
>     fs: push sync_filesystem() down to the file system's remount_fs()
>     
>     Previously, the no-op "mount -o mount /dev/xxx" operation when the
>     file system is already mounted read-write causes an implied,
>     unconditional syncfs().  This seems pretty stupid, and it's certainly
>     documented or guaraunteed to do this, nor is it particularly useful,
>     except in the case where the file system was mounted rw and is getting
>     remounted read-only.
>     
>     However, it's possible that there might be some file systems that are
>     actually depending on this behavior.  In most file systems, it's
>     probably fine to only call sync_filesystem() when transitioning from
>     read-write to read-only, and there are some file systems where this is
>     not needed at all (for example, for a pseudo-filesystem or something
>     like romfs).
> 
> And later on __ext4_remount got modified to only call
> sync_filesystem() on rw->ro transition. We do not depend on
> sync_filesystem() for anything here except in the rw->ro remount
> case, so why don't we just move the sync_filesystem() call to
> xfs_remount_ro()? We already have an error path there for failing to
> clean the filesystem, and avoids the possibility of other random
> mount option changes failing because some because there is some
> random pending data writeback error....

That's a good question.  I was doing the minimum needed to fix a
callsite.  Ted's commit seems to have pushed an unconditional (and
unchecked) call from the VFS into the first line of the filesystem
implementation.

Anyway I'll change the patch to move the call to xfs_remount_ro and
report back.  (Or rather, I did that last night, so we'll see what the
CI system reports...)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
