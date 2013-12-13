Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BD8529E04
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 07:38:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 636CE8F8040
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:38:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id lPDEAQbk5YAiKUOr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 05:37:48 -0800 (PST)
Date: Fri, 13 Dec 2013 05:37:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: xfs_trans_dqresv() can be made lockless
Message-ID: <20131213133745.GC13689@infradead.org>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
	<1386841258-22183-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386841258-22183-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 08:40:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_trans_dqresv() serialises dquot modifications by taking the
> dquot lock while it is doing reservations. The thing is, nothing it
> does really requires exclusive access to the dquot except for the
> reservation accounting. We can do that locklessly with cmpxchg.

Can you split the various refactorings into separate patches to make
this more readable?

> +do_ninos:
> +	if (ninos == 0)
> +		goto do_trans;
> +
> +	smp_mb();
> +	timer = be32_to_cpu(dqp->q_core.d_itimer);
> +	warns = be16_to_cpu(dqp->q_core.d_iwarns);
> +	warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
> +	hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
> +	if (!hardlimit)
> +		hardlimit = q->qi_ihardlimit;
> +	softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
> +	if (!softlimit)
> +		softlimit = q->qi_isoftlimit;
> +	resbcountp = &dqp->q_res_icount;
> +
> +	oldcnt = xfs_dqresv_cmpxchg(mp, dqp, resbcountp, ninos, false, enforce,
> +				    hardlimit, softlimit, timer, warns,
> +				    warnlimit);
> +	if (oldcnt == (xfs_qcnt_t)-1ULL)
> +		goto error_undo_nblks;
> +
> +do_trans:

Instead of having all these goto labels maye this should be factored
into helpers for each of the stages?

>  	if (udqp) {
> +		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
> +			  udqp->q_core.d_id && XFS_IS_UQUOTA_ENFORCED(mp);
>  		error = xfs_trans_dqresv(tp, mp, udqp, nblks, ninos,
> -					(flags & ~XFS_QMOPT_ENOSPC));
> +					(flags & ~XFS_QMOPT_ENOSPC), enforce);

I have to say I'd much prefer having the enforcement decision hidden
inside xfs_trans_dqresv.

>  		if (error)
>  			return error;
>  	}
>  
>  	if (gdqp) {
> -		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
> +		enforce = !(flags & XFS_QMOPT_FORCE_RES) &&
> +			  gdqp->q_core.d_id && XFS_IS_GQUOTA_ENFORCED(mp);
> +		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags,
> +					 enforce);
>  		if (error)

Unrelated to the patch: why do we clear XFS_QMOPT_ENOSPC for user
quotas, but not for project quotas here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
