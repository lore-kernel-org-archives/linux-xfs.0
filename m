Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6883C4338F
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 00:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78297610FD
	for <linux-xfs@archiver.kernel.org>; Sat,  7 Aug 2021 00:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhHGAVW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 20:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhHGAVV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Aug 2021 20:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46DF3603E7;
        Sat,  7 Aug 2021 00:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628295665;
        bh=xH4xyX2CspgpVQ2GuoDsfdW5ErpC5I1/X+IpafBVLb4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=H808Y2q3BF27tzeA3wfA5UJbReR9709sikaHDJTgiO6Wj1B6zd/YBm0hym3ChETvc
         LeAFlTsWU4PPAmwDLugiSjOetCzyHEkxBPmJxZTpat+jH63GkTTe624uHbx00QSl0y
         zkOw8JPqbXpUNBdi1mV7qMaIighqIAl4CF83H6nNWNJCvv6ip8G7NGipC1IgqraNSD
         Kbb/FKxqyzrYTzfFjRIiW5HMi2VZ5URmp45Fg2eY0Zw49MS6U3udlblIKVgkiWZut1
         CpyvwHur5KXYMLHxjDTJ0JxsKYvk2h5eNt8Ey9h6JWUfVTRwPKF9PlG5DJ5YK9Szbq
         oXCt0ynPMf04w==
Date:   Fri, 6 Aug 2021 17:21:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 05/14] xfs: per-cpu deferred inode inactivation queues
Message-ID: <20210807002104.GB3601443@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812921040.2589546.137433781469727121.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812921040.2589546.137433781469727121.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:06:50PM -0700, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>

<megasnip> A couple of minor changes that aren't worth reposting the
entire series:

> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index b9214733d0c3..fedfa40e3cd6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c

<snip>

> @@ -1767,30 +1801,276 @@ xfs_inode_mark_reclaimable(
>  		ASSERT(0);
>  	}
>  
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	spin_lock(&ip->i_flags_lock);
> +
> +	trace_xfs_inode_set_reclaimable(ip);
> +	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
> +	ip->i_flags |= XFS_IRECLAIMABLE;
> +	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			XFS_ICI_RECLAIM_TAG);
> +
> +	spin_unlock(&ip->i_flags_lock);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +}
> +
> +/*
> + * Free all speculative preallocations and possibly even the inode itself.
> + * This is the last chance to make changes to an otherwise unreferenced file
> + * before incore reclamation happens.
> + */
> +static void
> +xfs_inodegc_inactivate(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount        *mp = ip->i_mount;
> +
> +	/*
> +	* Inactivation isn't supposed to run when the fs is frozen because
> +	* we don't want kernel threads to block on transaction allocation.
> +	*/
> +	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
> +

I solved the problems Dave was complaining about (g/390, x/517) by
removing this ASSERT.

> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 19260291ff8b..bd8abb50b33a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -157,6 +157,48 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
>  DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
>  
> +#define XFS_STATE_FLAGS \
> +	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }

I've also changed the name of this to XFS_OPSTATE_STRINGS because we use
_STRINGS everywhere else in this file.

--D

> +
> +DECLARE_EVENT_CLASS(xfs_fs_class,
> +	TP_PROTO(struct xfs_mount *mp, void *caller_ip),
> +	TP_ARGS(mp, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned long long, mflags)
> +		__field(unsigned long, opstate)
> +		__field(unsigned long, sbflags)
> +		__field(void *, caller_ip)
> +	),
> +	TP_fast_assign(
> +		if (mp) {
> +			__entry->dev = mp->m_super->s_dev;
> +			__entry->mflags = mp->m_flags;
> +			__entry->opstate = mp->m_opstate;
> +			__entry->sbflags = mp->m_super->s_flags;
> +		}
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d m_flags 0x%llx opstate (%s) s_flags 0x%lx caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->mflags,
> +		  __print_flags(__entry->opstate, "|", XFS_STATE_FLAGS),
> +		  __entry->sbflags,
> +		  __entry->caller_ip)
> +);
> +
> +#define DEFINE_FS_EVENT(name)	\
> +DEFINE_EVENT(xfs_fs_class, name,					\
> +	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
> +	TP_ARGS(mp, caller_ip))
> +DEFINE_FS_EVENT(xfs_inodegc_flush);
> +DEFINE_FS_EVENT(xfs_inodegc_start);
> +DEFINE_FS_EVENT(xfs_inodegc_stop);
> +DEFINE_FS_EVENT(xfs_inodegc_worker);
> +DEFINE_FS_EVENT(xfs_inodegc_queue);
> +DEFINE_FS_EVENT(xfs_inodegc_throttle);
> +DEFINE_FS_EVENT(xfs_fs_sync_fs);
> +
>  DECLARE_EVENT_CLASS(xfs_ag_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
>  	TP_ARGS(mp, agno),
> @@ -616,14 +658,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> +		__field(unsigned long, iflags)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
> +		__entry->iflags = ip->i_flags;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx",
> +	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->ino)
> +		  __entry->ino,
> +		  __entry->iflags)
>  )
>  
>  #define DEFINE_INODE_EVENT(name) \
> @@ -667,6 +712,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
>  DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
> +DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
> +DEFINE_INODE_EVENT(xfs_inode_reclaiming);
> +DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
> +DEFINE_INODE_EVENT(xfs_inode_inactivating);
>  
>  /*
>   * ftrace's __print_symbolic requires that all enum values be wrapped in the
> 
