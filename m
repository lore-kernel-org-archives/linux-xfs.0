Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83FCC17442
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 21:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C3BF206C3
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfKJVWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 16:22:04 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56341 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbfKJVWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 16:22:04 -0500
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 078567E9CE3;
        Mon, 11 Nov 2019 08:22:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iTuem-0006yM-5T; Mon, 11 Nov 2019 08:22:00 +1100
Date:   Mon, 11 Nov 2019 08:22:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: remove the xfs_qoff_logitem_t typedef
Message-ID: <20191110212200.GN4614@dread.disaster.area>
References: <20191110062404.948433-1-preichl@redhat.com>
 <20191110062404.948433-5-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110062404.948433-5-preichl@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=JEncCaGohUQau49S2V8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 07:24:04AM +0100, Pavel Reichl wrote:
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
>  fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
>  fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
>  fs/xfs/xfs_trans_dquot.c       | 14 +++++++-------
>  4 files changed, 40 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 271cca13565b..eb7fe42b1d61 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -741,7 +741,7 @@ xfs_calc_qm_dqalloc_reservation(
>  
>  /*
>   * Turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2

This should be

 *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2

>   *    the superblock for the quota flags: sector size
>   */
>  STATIC uint
> @@ -754,7 +754,7 @@ xfs_calc_qm_quotaoff_reservation(
>  
>  /*
>   * End of turning off quotas.
> - *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
> + *    sizeof(struct xfs_qoff_logitem) * 2

Ditto.

>   */
>  STATIC uint
>  xfs_calc_qm_quotaoff_end_reservation(void)
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 3a64a7fd3b8a..e94003271e74 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -12,24 +12,26 @@ struct xfs_mount;
>  struct xfs_qoff_logitem;
>  
>  struct xfs_dq_logitem {
> -	struct xfs_log_item	 qli_item;	/* common portion */
> +	struct xfs_log_item	qli_item;	/* common portion */
>  	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
> -	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
> +	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
>  };
>  
> -typedef struct xfs_qoff_logitem {
> -	struct xfs_log_item	 qql_item;	/* common portion */
> -	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
> +struct xfs_qoff_logitem {
> +	struct xfs_log_item	qql_item;	/* common portion */
> +	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
>  	unsigned int		qql_flags;
> -} xfs_qoff_logitem_t;
> +};
>  
>  
> -extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
> -extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
> -					struct xfs_qoff_logitem *, uint);
> -extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *, uint);
> -extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
> -					struct xfs_qoff_logitem *);
> +void			xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
> +struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem *start,
> +					uint flags);
> +struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
> +					struct xfs_qoff_logitem *startqoff,
> +					uint flags);
> +void			xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
> +					struct xfs_qoff_logitem *qlp);

I'd get rid of the tabs completely here:

void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
struct xfs_qoff_logitem *xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
				struct xfs_qoff_logitem *start, uint flags);
struct xfs_qoff_logitem *xfs_trans_get_qoff_item(struct xfs_trans *tp,
				struct xfs_qoff_logitem *startqoff, uint flags);
void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
				struct xfs_qoff_logitem *qlp);

>  
>  #endif	/* __XFS_DQUOT_ITEM_H__ */
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index da7ad0383037..e685b9ae90b9 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -19,9 +19,12 @@
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
>  
> -STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
> -STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
> -					uint);
> +STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem **qoffstartp,
> +					uint flags);
> +STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
> +					struct xfs_qoff_logitem *startqoff,
> +					uint flags);

And pull the indent back here.

STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
			struct xfs_qoff_logitem **qoffstartp, uint flags);
STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
			struct xfs_qoff_logitem *startqoff, uint flags);

Actaully, no, what would be better is another patch to move the
xfs_qm_log_quotaoff() and xfs_qm_log_quotaoff_end() functions above
the code that calls them, so the need for forward prototypes goes
away completely. i.e. reformat in one patch, move in another (or the
other way around). Code movement patches shouldn't make any
other changes in them.


> @@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
>  
>  STATIC int
>  xfs_qm_log_quotaoff(
> -	xfs_mount_t	       *mp,
> -	xfs_qoff_logitem_t     **qoffstartp,
> -	uint		       flags)
> +	struct xfs_mount	*mp,
> +	struct xfs_qoff_logitem	**qoffstartp,
> +	uint			flags)
>  {
> -	xfs_trans_t	       *tp;
> +	struct xfs_trans	*tp;
>  	int			error;
> -	xfs_qoff_logitem_t     *qoffi;
> +	struct xfs_qoff_logitem	*qoffi;
>  
>  	*qoffstartp = NULL;
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index d319347093d6..0fdc96ed805a 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
>  /*
>   * This routine is called to allocate a quotaoff log item.
>   */
> -xfs_qoff_logitem_t *
> +struct xfs_qoff_logitem *
>  xfs_trans_get_qoff_item(
> -	xfs_trans_t		*tp,
> -	xfs_qoff_logitem_t	*startqoff,
> -	uint			flags)
> +	struct xfs_trans		*tp,
> +	struct xfs_qoff_logitem	*startqoff,
> +	uint			 flags)

That doesn't look right. Extra tab before *tp, extra space
before flags.

FWIW, I use this rule in vim to highlight stray whitespace:

" highlight whitespace damage
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

Modify the regex to suit the whitespace damage you want it to
find...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
