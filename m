Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6R1lPHU057377 for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 20:47:25 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E8668F8040
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2009 18:48:08 -0700 (PDT)
Message-Id: <B9B513F1-7883-45F2-AF7B-DD0C056AFBBA@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090718221732.034903000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 1/9] xfs: avoid memory allocation under m_peraglock in
	growfs code
Date: Sun, 26 Jul 2009 20:48:07 -0500
References: <20090718221452.594956000@bombadil.infradead.org>
	<20090718221732.034903000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: sage@newdream.net, xfs@oss.sgi.com


On Jul 18, 2009, at 5:14 PM, Christoph Hellwig wrote:

> Allocate the memory for the larger m_perag array before taking the
> per-AG lock as the per-AG lock can be taken under the i_lock which
> can be taken from reclaim context.
>
> Reported by the new reclaim context tracing in lockdep.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the whole series:

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: linux-2.6/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_fsops.c	2009-07-10 13:05:24.798364926  
> +0200
> +++ linux-2.6/fs/xfs/xfs_fsops.c	2009-07-10 13:16:00.827394975 +0200
> @@ -167,17 +167,25 @@ xfs_growfs_data_private(
> 	new = nb - mp->m_sb.sb_dblocks;
> 	oagcount = mp->m_sb.sb_agcount;
> 	if (nagcount > oagcount) {
> +		void *new_perag, *old_perag;
> +
> 		xfs_filestream_flush(mp);
> +
> +		new_perag = kmem_zalloc(sizeof(xfs_perag_t) * nagcount,
> +					KM_MAYFAIL);
> +		if (!new_perag)
> +			return XFS_ERROR(ENOMEM);
> +
> 		down_write(&mp->m_peraglock);
> -		mp->m_perag = kmem_realloc(mp->m_perag,
> -			sizeof(xfs_perag_t) * nagcount,
> -			sizeof(xfs_perag_t) * oagcount,
> -			KM_SLEEP);
> -		memset(&mp->m_perag[oagcount], 0,
> -			(nagcount - oagcount) * sizeof(xfs_perag_t));
> +		memcpy(new_perag, mp->m_perag, sizeof(xfs_perag_t) * oagcount);
> +		old_perag = mp->m_perag;
> +		mp->m_perag = new_perag;
> +
> 		mp->m_flags |= XFS_MOUNT_32BITINODES;
> 		nagimax = xfs_initialize_perag(mp, nagcount);
> 		up_write(&mp->m_peraglock);
> +
> +		kmem_free(old_perag);
> 	}
> 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
> 	tp->t_flags |= XFS_TRANS_RESERVE;
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
