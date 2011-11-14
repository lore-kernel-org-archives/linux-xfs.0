Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEAYFwj205112 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 04:34:16 -0600
Date: Mon, 14 Nov 2011 05:34:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111114103410.GD31043@infradead.org>
References: <20111108085614.478431403@bombadil.infradead.org>
	<20111108085846.291838677@bombadil.infradead.org>
	<20111108231118.GP5534@dastard>
	<20111109075847.GA20604@infradead.org>
	<20111110174242.GZ20464@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111110174242.GZ20464@sgi.com>
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
To: Ben Myers <bpm@sgi.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 11:42:42AM -0600, Ben Myers wrote:
> > +STATIC int
> > +xfs_init_mount_workqueues(
> > +	struct xfs_mount	*mp)
> > +{
> > +#define XFS_WQ_NAME_LEN		512
> > +	char			name[XFS_WQ_NAME_LEN];
> > +
> > +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
> > +	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> > +	if (!mp->m_data_workqueue)
> > +		goto out;
> 
> Looks to me like alloc_workqueue holds on to that name pointer in
> wq->name... won't overwriting the name below be a problem?

It applies deep magic to make sure a pattern like mine is fine for
the lockdep lock name, but just uses it directly for the workqueue name.

Oddly enough the names seem to display correctly on my test systems
anyway.

Tejun, any chance to change alloc_workqueue to use the string pasting
trick also for the normal workqueue name, or even better add a varargs
version of alloc_workqueue?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
