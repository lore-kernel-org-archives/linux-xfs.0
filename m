Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E14C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 695C8207E8
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 22:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgGAWu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 18:50:57 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55742 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgGAWu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 18:50:56 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 04DB33A353F;
        Thu,  2 Jul 2020 08:50:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqlZ7-0000sF-A4; Thu, 02 Jul 2020 08:50:53 +1000
Date:   Thu, 2 Jul 2020 08:50:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/18] xfs: stop using q_core.d_flags in the quota code
Message-ID: <20200701225053.GA2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353173676.2864738.5361850443664572160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353173676.2864738.5361850443664572160.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=hrUf8Ip_xhPh7R3v3U4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:42:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the incore dq_flags to figure out the dquot type.  This is the first
> step towards removing xfs_disk_dquot from the incore dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_quota_defs.h |    2 ++
>  fs/xfs/scrub/quota.c           |    4 ----
>  fs/xfs/xfs_dquot.c             |   33 +++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_dquot.h             |    2 ++
>  fs/xfs/xfs_dquot_item.c        |    6 ++++--
>  fs/xfs/xfs_qm.c                |    4 ++--
>  fs/xfs/xfs_qm.h                |    2 +-
>  fs/xfs/xfs_qm_syscalls.c       |    9 +++------
>  8 files changed, 45 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 56d9dd787e7b..459023b0a304 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -29,6 +29,8 @@ typedef uint16_t	xfs_qwarncnt_t;
>  
>  #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
>  
> +#define XFS_DQ_ONDISK		(XFS_DQ_ALLTYPES)

That's used as an on-disk flags mask. Perhaps XFS_DQF_ONDISK_MASK?

> +
>  #define XFS_DQ_FLAGS \
>  	{ XFS_DQ_USER,		"USER" }, \
>  	{ XFS_DQ_PROJ,		"PROJ" }, \
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 905a34558361..710659d3fa28 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -108,10 +108,6 @@ xchk_quota_item(
>  
>  	sqi->last_id = id;
>  
> -	/* Did we get the dquot type we wanted? */
> -	if (dqtype != (d->d_flags & XFS_DQ_ALLTYPES))
> -		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
> -
>  	if (d->d_pad0 != cpu_to_be32(0) || d->d_pad != cpu_to_be16(0))
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 46c8ca83c04d..59d1bce34a98 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -561,6 +561,16 @@ xfs_dquot_from_disk(
>  	return 0;
>  }
>  
> +/* Copy the in-core quota fields into the on-disk buffer. */
> +void
> +xfs_dquot_to_disk(
> +	struct xfs_disk_dquot	*ddqp,
> +	struct xfs_dquot	*dqp)
> +{
> +	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
> +	ddqp->d_flags = dqp->dq_flags & XFS_DQ_ONDISK;
> +}
> +
>  /* Allocate and initialize the dquot buffer for this in-core dquot. */
>  static int
>  xfs_qm_dqread_alloc(
> @@ -1108,6 +1118,17 @@ xfs_qm_dqflush_done(
>  	xfs_dqfunlock(dqp);
>  }
>  
> +/* Check incore dquot for errors before we flush. */
> +static xfs_failaddr_t
> +xfs_qm_dqflush_check(
> +	struct xfs_dquot	*dqp)
> +{
> +	if (hweight8(dqp->dq_flags & XFS_DQ_ALLTYPES) != 1)
> +		return __this_address;

This only checks the low 8 bits in dq_flags, which is a 32 bit
field. If we ever renumber the dq flags and the dquot types end up
outside the LSB, this code will break.

I don't really see a need to micro-optimise the code so much it
leaves landmines like this in the code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
