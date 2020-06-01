Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A411C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DC9206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgFAVVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:21:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53369 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728182AbgFAVVU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:21:20 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 147B88212CB;
        Tue,  2 Jun 2020 07:21:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfrrv-0000H1-Q3; Tue, 02 Jun 2020 07:21:15 +1000
Date:   Tue, 2 Jun 2020 07:21:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Bypass sb alignment checks when custom values
 are used
Message-ID: <20200601212115.GC2040@dread.disaster.area>
References: <20200601140153.200864-1-cmaiolino@redhat.com>
 <20200601140153.200864-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601140153.200864-3-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=5C5rYPro-uwb6TO-3F0A:9 a=5ZeiVN0zY8mOWEOR:21 a=297Jt6nLueST41wV:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 04:01:53PM +0200, Carlos Maiolino wrote:
> This patch introduces a new mount flag: XFS_MOUNT_ALIGN that is set when
> custom alignment values are set, making easier to identify when user
> passes custom alignment options via mount command line.
> 
> Then use this flag to bypass on-disk alignment checks.
> 
> This is useful specifically for users which had filesystems created with
> wrong alignment provided by buggy storage, which, after commit
> fa4ca9c5574605, these filesystems won't be mountable anymore. But, using
> custom alignment settings, there is no need to check those values, once
> the alignment used will be the one provided during mount time, avoiding
> the issues in the allocator caused by bad alignment values anyway. This
> at least give a chance for users to remount their filesystems on newer
> kernels, without needing to reformat it.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 30 +++++++++++++++++++-----------
>  fs/xfs/xfs_mount.h     |  2 ++
>  fs/xfs/xfs_super.c     |  1 +
>  3 files changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 4df87546bd40..72dae95a5e4a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -360,19 +360,27 @@ xfs_validate_sb_common(
>  		}
>  	}
>  
> -	if (sbp->sb_unit) {
> -		if (!xfs_sb_version_hasdalign(sbp) ||
> -		    sbp->sb_unit > sbp->sb_width ||
> -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> -			xfs_notice(mp, "SB stripe unit sanity check failed");
> +	/*
> +	 * Ignore superblock alignment checks if sunit/swidth mount options
> +	 * were used or alignment turned off.
> +	 * The custom alignment validation will happen later on xfs_mountfs()
> +	 */
> +	if (!(mp->m_flags & XFS_MOUNT_ALIGN) &&
> +	    !(mp->m_flags & XFS_MOUNT_NOALIGN)) {

mp->m_dalign tells us at this point if a user specified sunit as a
mount option.  That's how xfs_fc_validate_params() determines the user
specified a custom sunit, so there is no need for a new mount flag
here to indicate that mp->m_dalign was set by the user....

Also, I think if the user specifies "NOALIGN" then we should still
check the sunit/swidth and issue a warning that they are
bad/invalid, or at least indicate in some way that the superblock is
unhealthy and needs attention. Using mount options to sweep issues
that need fixing under the carpet is less than ideal...

Also, I see nothing that turns off XFS_MOUNT_ALIGN when the custom
alignment is written to the superblock and becomes the new on-disk
values. Once we have those values in the in-core superblock, the
write of the superblock should run the verifier to validate them.
i.e. leaving this XFS_MOUNT_ALIGN set allows fields of the
superblock we just modified to be written to disk without verifier
validation.

From that last perspective, I _really_ don't like the idea of
having user controlled conditional validation like this in the
common verifier.

From a user perspective, I think this "use mount options to override
bad values" approach is really nasty. How do you fix a system that
won't boot because the root filesystem has bad sunit/swidth values?
Telling the data center admin that they have to go boot every
machine in their data center into a rescue distro after an automated
upgrade triggered widespread boot failures is really not very user
or admin friendly.

IMO, this bad sunit/swidth condition should be:

	a) detected automatically at mount time,
	b) corrected automatically at mount time, and
	c) always verified to be valid at superblock write time.

IOWs, instead of failing to mount because sunit/swidth is invalid,
we issue a warning and automatically correct it to something valid.
There is precedence for this - we've done it with the AGFL free list
format screwups and for journal structures that are different shapes
on different platforms.

Hence we need to move this verification out of the common sb
verifier and move it into the write verifier (i.e. write is always
verified).  Then in the mount path where we set user specified mount
options, we should extent that to validate the existing on-disk
values and then modify them if they are invalid. Rules for fixing
are simple:

	1. if !hasdalign(sb), set both sunit/swidth to zero.
	2. If sunit is zero, zero swidth.
	1. If swidth is not valid, round it up it to the nearest
	   integer multiple of sunit.

The user was not responsible for this mess (combination of missing
validation in XFS code and bad storage firmware providing garbage)
so we should not put them on the hook for fixing it. We can do it
easily and without needing user intervention and so that's what we
should do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
