Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B839C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 21:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiCIVXM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 16:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbiCIVXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 16:23:12 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED3D09F3B6
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 13:22:12 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BBD7710E2923;
        Thu, 10 Mar 2022 08:22:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nS3l5-003XBh-5C; Thu, 10 Mar 2022 08:22:11 +1100
Date:   Thu, 10 Mar 2022 08:22:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: use setattr_copy to set vfs inode attributes
Message-ID: <20220309212211.GF661808@dread.disaster.area>
References: <164685372611.495833.8601145506549093582.stgit@magnolia>
 <164685373184.495833.7593050602112292799.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164685373184.495833.7593050602112292799.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62291a84
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=TYBLyS7eAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=TBllI8wU_OZdCRpmfEwA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=zvYvwCWiE4KgVXXeO06c:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 09, 2022 at 11:22:11AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Filipe Manana pointed out that XFS' behavior w.r.t. setuid/setgid
> revocation isn't consistent with btrfs[1] or ext4.  Those two
> filesystems use the VFS function setattr_copy to convey certain
> attributes from struct iattr into the VFS inode structure.
> 
> Andrey Zhadchenko reported[2] that XFS uses the wrong user namespace to
> decide if it should clear setgid and setuid on a file attribute update.
> This is a second symptom of the problem that Filipe noticed.
> 
> XFS, on the other hand, open-codes setattr_copy in xfs_setattr_mode,
> xfs_setattr_nonsize, and xfs_setattr_time.  Regrettably, setattr_copy is
> /not/ a simple copy function; it contains additional logic to clear the
> setgid bit when setting the mode, and XFS' version no longer matches.
> 
> The VFS implements its own setuid/setgid stripping logic, which
> establishes consistent behavior.  It's a tad unfortunate that it's
> scattered across notify_change, should_remove_suid, and setattr_copy but
> XFS should really follow the Linux VFS.  Adapt XFS to use the VFS
> functions and get rid of the old functions.
> 
> [1] https://lore.kernel.org/fstests/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/
> 
> Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iops.c |   56 +++--------------------------------------------------
>  fs/xfs/xfs_pnfs.c |    3 ++-
>  2 files changed, 5 insertions(+), 54 deletions(-)

Looks good, nice cleanup as well as being more correct.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
