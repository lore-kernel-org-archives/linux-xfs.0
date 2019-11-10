Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56468C43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 21:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3552080F
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 21:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKJVHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 16:07:52 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53424 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbfKJVHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 16:07:52 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 52D533A1763;
        Mon, 11 Nov 2019 08:07:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iTuQz-0006xI-Dm; Mon, 11 Nov 2019 08:07:45 +1100
Date:   Mon, 11 Nov 2019 08:07:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
Message-ID: <20191110210745.GK4614@dread.disaster.area>
References: <20191110062404.948433-1-preichl@redhat.com>
 <20191110062404.948433-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110062404.948433-2-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=adUpjcq2HRw6X6VybQ4A:9
        a=OyZMg-w1c_6yPWko:21 a=2pwwcL41m_Z27jga:21 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 07:24:01AM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Looks good, but on minor nit.

<snip>

Personally, I'd just strip most of the comments here completely
as the variable names describe the function of them almost entirely.
This was an old pattern from Irix days, and we've slowly been
removing it as we go as it's mostly clutter and largely redundant
due to the code itself being self describing. Such as:

> @@ -30,33 +30,51 @@ enum {
>  /*
>   * The incore dquot structure
>   */
> -typedef struct xfs_dquot {
> -	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
> -	struct list_head q_lru;		/* global free list of dquots */
> -	struct xfs_mount*q_mount;	/* filesystem this relates to */
> -	uint		 q_nrefs;	/* # active refs from inodes */
> -	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
> -	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
> -	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
> -
> -	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
> -	xfs_dq_logitem_t q_logitem;	/* dquot log item */
> -	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
> -	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
> -	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
> -	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
> -	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
> -	int64_t		 q_low_space[XFS_QLOWSP_MAX];
> -	struct mutex	 q_qlock;	/* quota lock */
> -	struct completion q_flush;	/* flush completion queue */
> -	atomic_t          q_pincount;	/* dquot pin count */
> -	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
> -} xfs_dquot_t;
> +struct xfs_dquot {
> +	/* various flags (XFS_DQ_*) */
> +	uint			dq_flags;

Convention: xx_flags contain various flags for xx.  Self
documenting.

> +	/* global free list of dquots */
> +	struct list_head	q_lru;

Convention - xx_lru generally points to a LRU ordered free list.
Self documenting.

> +	/* filesystem this relates to */
> +	struct xfs_mount	*q_mount;

Convention - xx_mount always points to the filesystem context. Self
documenting.

> +	/* # active refs from inodes */
> +	uint			q_nrefs;

Convention: xx_refs is always an object reference count. Self
documenting.

> +	/* blkno of dquot buffer */
> +	xfs_daddr_t		q_blkno;

Convention: xfs_daddr_t = disk address, blkno = block number. Reads
as "block number on disk of quota object". Self documenting.

> +	/* off of dq in buffer (# dquots) */
> +	int			q_bufoffset;

That comment is wrong. It's not an offset in "# dquots", it's a byte
offset from the start of the buffer. So, the comment should be
removed because plain offsets are in bytes by convention and so
"int q_bufoffset;" is actually self documenting.

> +	/* offset in quotas file */
> +	xfs_fileoff_t		q_fileoffset;
> +	/* actual usage & quotas */
> +	struct xfs_disk_dquot	q_core;
> +	/* dquot log item */
> +	xfs_dq_logitem_t	q_logitem;

These are all self documenting, follow convention.

> +	/* total regular nblks used+reserved */
> +	xfs_qcnt_t		q_res_bcount;
> +	/* total inos allocd+reserved */
> +	xfs_qcnt_t		q_res_icount;
> +	/* total realtime blks used+reserved */
> +	xfs_qcnt_t		q_res_rtbcount;

These are actually Useful comments, because they count both used and
reserved objects.

> +	/* prealloc throttle wmark */
> +	xfs_qcnt_t		q_prealloc_lo_wmark;
> +	/* prealloc disabled wmark */
> +	xfs_qcnt_t		q_prealloc_hi_wmark;

Obvious from the name - watermarks are preallocation thresholds.

> +	int64_t			q_low_space[XFS_QLOWSP_MAX];

I never commented this one when I added it because it can't be
described in 3-4 words. :)

> +	/* quota lock */
> +	struct mutex		q_qlock;
> +	/* flush completion queue */
> +	struct completion	q_flush;
> +	/* dquot pin count */
> +	atomic_t		q_pincount;
> +	/* dquot pinning wait queue */
> +	struct wait_queue_head	q_pinwait;

And these are all self documenting.

So, really, most of the comments can be removed from this structure.
The only reason for a comment describing a variable is if it's
function or contents is not obvious from it's name, such as the
accounting variables above.

Note that we do the same thing to local variable declarations as we
are changing them. The original Irix code had the same comment
convention for function and local declarations - it's largely just
clutter and noise now, so we also remove them as we go...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
