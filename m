Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BEE857F5A
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 07:01:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86A6A304032
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 05:01:43 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eLCKLjXjwYfAd3o4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 05:01:39 -0800 (PST)
Message-ID: <5288BE14.1050302@oracle.com>
Date: Sun, 17 Nov 2013 21:01:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 4/4] xfs: implement parallism quota check
References: <5281F527.3040200@oracle.com>
	<20131115172626.GD16942@infradead.org>
In-Reply-To: <20131115172626.GD16942@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/16 2013 01:26 AM, Christoph Hellwig wrote:
> As Dave pointed out this really should be xfs_bukstat_ag.  But looking
> at the code you're almost 90% there anyway.
One main reason I did not make a per ag bulkstat is because bulkstat() will
skip an allocation group if read agi buffer failed, i.e,

while (XFS_BULKSTAT_UBLEFT(ubleft) && agno < mp->m_sb.sb_agcount) {
	cond_resched();
	error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
	if (error) {
		/*
		 * Skip this allocation group and go to the next one.
		 */
		agno++;
                agino = 0;
		continue;
	}
	....
}

Should it capture this issue and drop a warning in this case?

> The actual workqueue code should probably stay in the quota files as
> other users of the per-ag bulkstate would drive the parallelsim by
> themselves.  
> 
>> +STATIC void
>> +xfs_qm_dq_adjust_worker(
>> +	struct work_struct	*work)
>> +{
>> +	struct xfs_dq_adjuster	*qa = container_of(work,
>> +				      struct xfs_dq_adjuster, qa_work);
>> +	int			error;
>> +
>> +	error = xfs_qm_dqusage_adjust_perag(qa);
>> +	complete(&qa->qa_complete);
> 
> Seems like xfs_quotacheck should just have a nr_inprogress counter
> and a single waitqueue, that way we'd only wake the waiter once 
> the whole quotacheck is done.
> 
> Actually you even just do a flush_workqueue on the workqueue as it's
> per-quotacheck, which simplifies this even more.
It looks perform flush_work() should just works fine, I do see less coding
efforts in this way although the revised version is not yet ready to post. 
>> +STATIC int
>> +xfs_qm_init_quotacheck(
>> +	struct xfs_mount	*mp,
>> +	struct xfs_quotacheck	*qc)
>> +{
>> +	memset(qc, 0, sizeof(*qc));
>> +
>> +	INIT_LIST_HEAD(&qc->qc_adjusters);
>> +	spin_lock_init(&qc->qc_lock);
>> +	qc->qc_mp = mp;
>> +	qc->qc_wq = alloc_workqueue("xfs-dqcheck/%s", WQ_NON_REENTRANT,
> 
> The WQ_NON_REENTRANT behaviour is now the default, no need to use the
> flag.
Well, I realized this change before, but forgot to get rid of this flag
for rebasing the code after writing it done for several months.
> 
>> +				    0, mp->m_fsname);
>> +	if (!qc->qc_wq) {
>> +		list_del(&qc->qc_adjusters);
> 
> I don't see why you'd do a list_del here given that we never added
> anything to the list.  either way no need for the list once we use
> the flush_workqueue trick above :)
Ah, a stupid mistake! :-P.
> In fact once that is implemented the xfs_quotacheck structure will
> contain nothing but the workqueue and can go away entirely.
> 
>> +STATIC struct xfs_dq_adjuster *
>> +xfs_qm_alloc_adjuster(
>> +	struct xfs_quotacheck	*qc,
>> +	xfs_agnumber_t		agno)
>> +{
>> +	struct xfs_dq_adjuster	*qa;
>> +
>> +	qa = kzalloc(sizeof(*qa), GFP_NOFS);
>> +	if (!qa)
>> +		return NULL;
> 
>> +		spin_lock(&qc->qc_lock);
>> +		qa = xfs_qm_alloc_adjuster(qc, i);
>> +		if (!qa) {
>> +			error = ENOMEM;
>> +			spin_unlock(&qc->qc_lock);
>> +			goto out_destroy_adjusters;
>> +		}
>> +		queue_work(qc->qc_wq, &qa->qa_work);
>> +		spin_unlock(&qc->qc_lock);
> 
> This gives you a sleeping allocation under a spinlock.  But I can't
> really find any reason for the lock to be taken here anyway, nor
> anywhere else.
Sorry, I can not recall it all why I need to introduce a spinlock here.
but yes, that is not a normal way and especially cause a sleeping allocation.
> 
> But to catch this please test the code with lockdep enabled for the
> next version.
Sure.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
