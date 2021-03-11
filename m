Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6034C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B8464E21
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 00:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCKAMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:12:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhCKALt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 19:11:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4326E64E21;
        Thu, 11 Mar 2021 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615421509;
        bh=YyZOIPabntlTrDEQ2tgOlLFGOfC4rAsuNDd3+Xg8q+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmqu4jchsWUovw3grUNPDvQLMwMjTMVIRP4VZ7p2ZN+D0CcQv4Xz2weAfXd7Eck31
         0wG5N4JUTEOMFGD/Rd7U1meKqBbFZge/BQnDhNhy+xjW2pjIzBH1RgIfnxrRUdK3DU
         kia7i4pUvvTTYtOUzmv1ArhNhcbhZIC1T9hTB6zkVJnEdeq383kmdgLl5ge/qISxxd
         eDYoFb8/0AT8NVgLPL9/AA8CjXP+t34Vh0mKeW4LmrdweagJUyra0qZ+JoDRNnJsJl
         M8vOhYV80TkrBUd4rfC2PdXi2B3Yu7b2IbJHlwsXMzW04Tjx9RfSYHK2NBbbgqzoDV
         teyGaBsorz0Ig==
Date:   Wed, 10 Mar 2021 16:11:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/45] xfs: introduce per-cpu CIL tracking sructure
Message-ID: <20210311001143.GI3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-36-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-36-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:33PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The CIL push lock is highly contended on larger machines, becoming a
> hard bottleneck that about 700,000 transaction commits/s on >16p
> machines. To address this, start moving the CIL tracking
> infrastructure to utilise per-CPU structures.
> 
> We need to track the space used, the amount of log reservation space
> reserved to write the CIL, the log items in the CIL and the busy
> extents that need to be completed by the CIL commit.  This requires
> a couple of per-cpu counters, an unordered per-cpu list and a
> globally ordered per-cpu list.
> 
> Create a per-cpu structure to hold these and all the management
> interfaces needed, as well as the hooks to handle hotplug CPUs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c       | 94 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_priv.h      | 15 ++++++
>  include/linux/cpuhotplug.h |  1 +
>  3 files changed, 110 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f8fb2f59e24c..1bcf0d423d30 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1365,6 +1365,93 @@ xfs_log_item_in_current_chkpt(
>  	return true;
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static LIST_HEAD(xlog_cil_pcp_list);
> +static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
> +static bool xlog_cil_pcp_init;
> +
> +static int
> +xlog_cil_pcp_dead(
> +	unsigned int		cpu)
> +{
> +	struct xfs_cil		*cil;
> +
> +        spin_lock(&xlog_cil_pcp_lock);
> +        list_for_each_entry(cil, &xlog_cil_pcp_list, xc_pcp_list) {

Weird indentation.

> +		/* move stuff on dead CPU to context */

Should this have some actual code?  I don't think any of the remaining
patches add anything here.

> +	}
> +	spin_unlock(&xlog_cil_pcp_lock);
> +	return 0;
> +}
> +
> +static int
> +xlog_cil_pcp_hpadd(
> +	struct xfs_cil		*cil)
> +{
> +	if (!xlog_cil_pcp_init) {
> +		int	ret;
> +		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
> +						"xfs/cil_pcp:dead", NULL,
> +						xlog_cil_pcp_dead);
> +		if (ret < 0) {
> +			xfs_warn(cil->xc_log->l_mp,
> +	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",

How likely is to happen?

> +				ret);
> +			ASSERT(0);

I guess not that often?

> +			return -ENOMEM;

Why not return ret here?  I guess it's because ret could be any number
of (not centrally documented?) error codes, and we don't really care to
expose that to userspace?

--D

> +		}
> +		xlog_cil_pcp_init = true;
> +	}
> +
> +	INIT_LIST_HEAD(&cil->xc_pcp_list);
> +	spin_lock(&xlog_cil_pcp_lock);
> +	list_add(&cil->xc_pcp_list, &xlog_cil_pcp_list);
> +	spin_unlock(&xlog_cil_pcp_lock);
> +	return 0;
> +}
> +
> +static void
> +xlog_cil_pcp_hpremove(
> +	struct xfs_cil		*cil)
> +{
> +	spin_lock(&xlog_cil_pcp_lock);
> +	list_del(&cil->xc_pcp_list);
> +	spin_unlock(&xlog_cil_pcp_lock);
> +}
> +
> +#else /* !CONFIG_HOTPLUG_CPU */
> +static inline void xlog_cil_pcp_hpadd(struct xfs_cil *cil) {}
> +static inline void xlog_cil_pcp_hpremove(struct xfs_cil *cil) {}
> +#endif
> +
> +static void __percpu *
> +xlog_cil_pcp_alloc(
> +	struct xfs_cil		*cil)
> +{
> +	struct xlog_cil_pcp	*cilpcp;
> +
> +	cilpcp = alloc_percpu(struct xlog_cil_pcp);
> +	if (!cilpcp)
> +		return NULL;
> +
> +	if (xlog_cil_pcp_hpadd(cil) < 0) {
> +		free_percpu(cilpcp);
> +		return NULL;
> +	}
> +	return cilpcp;
> +}
> +
> +static void
> +xlog_cil_pcp_free(
> +	struct xfs_cil		*cil,
> +	struct xlog_cil_pcp	*cilpcp)
> +{
> +	if (!cilpcp)
> +		return;
> +	xlog_cil_pcp_hpremove(cil);
> +	free_percpu(cilpcp);
> +}
> +
>  /*
>   * Perform initial CIL structure initialisation.
>   */
> @@ -1379,6 +1466,12 @@ xlog_cil_init(
>  	if (!cil)
>  		return -ENOMEM;
>  
> +	cil->xc_pcp = xlog_cil_pcp_alloc(cil);
> +	if (!cil->xc_pcp) {
> +		kmem_free(cil);
> +		return -ENOMEM;
> +	}
> +
>  	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
>  	spin_lock_init(&cil->xc_cil_lock);
> @@ -1409,6 +1502,7 @@ xlog_cil_destroy(
>  
>  	ASSERT(list_empty(&cil->xc_cil));
>  	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
> +	xlog_cil_pcp_free(cil, cil->xc_pcp);
>  	kmem_free(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index e72d14c76e03..2562f29c8986 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -231,6 +231,16 @@ struct xfs_cil_ctx {
>  	struct work_struct	push_work;
>  };
>  
> +/*
> + * Per-cpu CIL tracking items
> + */
> +struct xlog_cil_pcp {
> +	uint32_t		space_used;
> +	uint32_t		curr_res;
> +	struct list_head	busy_extents;
> +	struct list_head	log_items;
> +};
> +
>  /*
>   * Committed Item List structure
>   *
> @@ -264,6 +274,11 @@ struct xfs_cil {
>  	wait_queue_head_t	xc_commit_wait;
>  	xfs_csn_t		xc_current_sequence;
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
> +
> +	struct xlog_cil_pcp __percpu *xc_pcp;
> +#ifdef CONFIG_HOTPLUG_CPU
> +	struct list_head	xc_pcp_list;
> +#endif
>  } ____cacheline_aligned_in_smp;
>  
>  /* xc_flags bit values */
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index f14adb882338..b13b21d825b3 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -52,6 +52,7 @@ enum cpuhp_state {
>  	CPUHP_FS_BUFF_DEAD,
>  	CPUHP_PRINTK_DEAD,
>  	CPUHP_MM_MEMCQ_DEAD,
> +	CPUHP_XFS_CIL_DEAD,
>  	CPUHP_PERCPU_CNT_DEAD,
>  	CPUHP_RADIX_DEAD,
>  	CPUHP_PAGE_ALLOC_DEAD,
> -- 
> 2.28.0
> 
