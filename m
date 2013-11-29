Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D9E47F3F
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 03:36:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE67B8F8064
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 01:36:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ocNTrJ4HArV79knD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 01:36:43 -0800 (PST)
Message-ID: <52986001.9040101@oracle.com>
Date: Fri, 29 Nov 2013 17:36:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] xfs: fix infinite loop by detaching the
	group/project hints from user dquot
References: <5294A469.1060000@oracle.com>
	<20131128104336.GE26927@infradead.org>
In-Reply-To: <20131128104336.GE26927@infradead.org>
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

On 11/28 2013 18:43 PM, Christoph Hellwig wrote:
> On Tue, Nov 26, 2013 at 09:38:49PM +0800, Jeff Liu wrote:
>> +	if (flags & XFS_QMOPT_UQUOTA)
>> +		return xfs_qm_dqpurge(dqp, NULL);
> 
> To me it doesn't make any sense to overload this function for the user
> quotas that don't have hints.
To me it would like a silly compromise.
> 
> I'd suggest dropping this hunk and keeping a separate walk for
> releasing the uquots.
I thought this over and yup, that is an overload if neither group nor project
are enabled, or we don't want to turn user quota off.

But even so, we currently also have overloads by checking group/project hints
before releasing any type of quota in xfs_qm_purge().  In this point, this fix
can reduce a bit overloads by moving those checkups to xfs_qm_purge_hints() if
we want to turn group/project quotas off.

If we considering to drop above hunk to release user quota separately, we finally
would have to walk through user quota to remove those hints again, i.e,

/* Remove group/project hints from user dquot */
STATIC int
xfs_qm_dqpurge_hints(
	struct xfs_dquot        *dqp,
	void                    *data)
{
	uint                    flags = *((uint *)data);
	struct xfs_dquot        *gdqp;
	struct xfs_dquot        *pdqp;

	xfs_dqlock(dqp);
	if (dqp->dq_flags & XFS_DQ_FREEING) {
		xfs_dqunlock(dqp);
		return EAGAIN;
	}

	/* If this quota has a hint attached, prepare for releasing it now */
        gdqp = dqp->q_gdquot;
	if (gdqp)
		dqp->q_gdquot = NULL;

	pdqp = dqp->q_pdquot;
	if (pdqp)
		dqp->q_pdquot = NULL;

	xfs_dqunlock(dqp);

	if (gdqp)
		xfs_qm_dqrele(gdqp);
	if (pdqp)
		xfs_qm_dqrele(pdqp);

	return 0;
}

void
xfs_qm_dqpurge_all()
{
	xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge_hints, NULL);

	if (flags & XFS_QMOPT_UQUOTA)
		xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, NULL);
	if (flags & XFS_QMOPT_GQUOTA)
		xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, NULL);
	if (flags & XFS_QMOPT_PQUOTA)
		xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, NULL);
}

Above code is what I can figured out as per your suggestions for now, but it
would introduce overheads for walking through user dquots to release hints
separately if we want to turn user quota off.

Any thoughts?

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
