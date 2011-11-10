Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAHgSJU111709 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 11:42:28 -0600
Date: Thu, 10 Nov 2011 11:42:42 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111110174242.GZ20464@sgi.com>
References: <20111108085614.478431403@bombadil.infradead.org>
	<20111108085846.291838677@bombadil.infradead.org>
	<20111108231118.GP5534@dastard>
	<20111109075847.GA20604@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111109075847.GA20604@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hey Christoph,

On Wed, Nov 09, 2011 at 02:58:47AM -0500, Christoph Hellwig wrote:
> +STATIC int
> +xfs_init_mount_workqueues(
> +	struct xfs_mount	*mp)
> +{
> +#define XFS_WQ_NAME_LEN		512
> +	char			name[XFS_WQ_NAME_LEN];
> +
> +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
> +	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> +	if (!mp->m_data_workqueue)
> +		goto out;

Looks to me like alloc_workqueue holds on to that name pointer in
wq->name... won't overwriting the name below be a problem?

> +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-conv/%s", mp->m_fsname);
> +	mp->m_unwritten_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> +	if (!mp->m_unwritten_workqueue)
> +		goto out_destroy_data_iodone_queue;

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
