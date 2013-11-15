Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9A077F93
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 11:26:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78A57304059
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:26:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id yATTHzhRKP6DnWIV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 09:26:26 -0800 (PST)
Date: Fri, 15 Nov 2013 09:26:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 4/4] xfs: implement parallism quota check
Message-ID: <20131115172626.GD16942@infradead.org>
References: <5281F527.3040200@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5281F527.3040200@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

As Dave pointed out this really should be xfs_bukstat_ag.  But looking
at the code you're almost 90% there anyway.

The actual workqueue code should probably stay in the quota files as
other users of the per-ag bulkstate would drive the parallelsim by
themselves.  

> +STATIC void
> +xfs_qm_dq_adjust_worker(
> +	struct work_struct	*work)
> +{
> +	struct xfs_dq_adjuster	*qa = container_of(work,
> +				      struct xfs_dq_adjuster, qa_work);
> +	int			error;
> +
> +	error = xfs_qm_dqusage_adjust_perag(qa);
> +	complete(&qa->qa_complete);

Seems like xfs_quotacheck should just have a nr_inprogress counter
and a single waitqueue, that way we'd only wake the waiter once 
the whole quotacheck is done.

Actually you even just do a flush_workqueue on the workqueue as it's
per-quotacheck, which simplifies this even more.

> +STATIC int
> +xfs_qm_init_quotacheck(
> +	struct xfs_mount	*mp,
> +	struct xfs_quotacheck	*qc)
> +{
> +	memset(qc, 0, sizeof(*qc));
> +
> +	INIT_LIST_HEAD(&qc->qc_adjusters);
> +	spin_lock_init(&qc->qc_lock);
> +	qc->qc_mp = mp;
> +	qc->qc_wq = alloc_workqueue("xfs-dqcheck/%s", WQ_NON_REENTRANT,

The WQ_NON_REENTRANT behaviour is now the default, no need to use the
flag.

> +				    0, mp->m_fsname);
> +	if (!qc->qc_wq) {
> +		list_del(&qc->qc_adjusters);

I don't see why you'd do a list_del here given that we never added
anything to the list.  either way no need for the list once we use
the flush_workqueue trick above :)

In fact once that is implemented the xfs_quotacheck structure will
contain nothing but the workqueue and can go away entirely.

> +STATIC struct xfs_dq_adjuster *
> +xfs_qm_alloc_adjuster(
> +	struct xfs_quotacheck	*qc,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_dq_adjuster	*qa;
> +
> +	qa = kzalloc(sizeof(*qa), GFP_NOFS);
> +	if (!qa)
> +		return NULL;

> +		spin_lock(&qc->qc_lock);
> +		qa = xfs_qm_alloc_adjuster(qc, i);
> +		if (!qa) {
> +			error = ENOMEM;
> +			spin_unlock(&qc->qc_lock);
> +			goto out_destroy_adjusters;
> +		}
> +		queue_work(qc->qc_wq, &qa->qa_work);
> +		spin_unlock(&qc->qc_lock);

This gives you a sleeping allocation under a spinlock.  But I can't
really find any reason for the lock to be taken here anyway, nor
anywhere else.

But to catch this please test the code with lockdep enabled for the
next version.

Thanks for looking into this!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
