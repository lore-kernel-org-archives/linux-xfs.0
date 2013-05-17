Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BF0C7F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:01:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B4028F8049
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 20:01:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zLB2NIoZBm8VE534 for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 20:01:32 -0700 (PDT)
Date: Fri, 17 May 2013 13:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 2/5] xfs: Add pquota fields where gquota is used.
Message-ID: <20130517030125.GT29466@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
	<51906528.3030307@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51906528.3030307@oracle.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Mon, May 13, 2013 at 11:59:36AM +0800, Jeff Liu wrote:
> Hi,
> 
> > +struct xfs_inode *
> > +xfs_dq_to_quota_inode(struct xfs_dquot *dqp)
> > +{
> > +	if (XFS_QM_ISUDQ(dqp))
> > +		return dqp->q_mount->m_quotainfo->qi_uquotaip;
> > +	if (XFS_QM_ISGDQ(dqp))
> > +		return dqp->q_mount->m_quotainfo->qi_gquotaip;
> > +	ASSERT(XFS_QM_ISPDQ(dqp));
> > +	return dqp->q_mount->m_quotainfo->qi_pquotaip;
> > +}
> Is it better to replace above conditional judgment with 'switch...case'?
> i.e.
> static inline struct xfs_inode *
> xfs_dq_to_qip(struct xfs_dquot *dqp)
> {
> 	switch (dqp->dq_flags) {
> 	case XFS_DQ_USER:
> 		return dqp->q_mount->m_quotainfo->qi_uquotaip;
> 	case XFS_DQ_GROUP:
> 		return dqp->q_mount->m_quotainfo->qi_gqoutaip;
> 	case XFS_DQ_PROJ:
> 		return dqp->q_mount->m_quotainfo->qi_pquotaip;
> 	}

Doesn't work because dq_flags can have other fields set in it (e.g
XFS_DQ_DIRTY). It would need to be:

	switch (dqp->dq_flags & XFS_DQ_ALLTYPES) {
	....
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
