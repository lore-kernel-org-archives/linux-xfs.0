Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2290C7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 18:23:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 111758F8033
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 16:23:33 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id Sux1hlEKmaSSyNND (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 16:23:32 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 24 Jun 2013 17:23:22 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C53751FF001D
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:18:03 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5ONNJQW380302 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:23:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5ONNIH3017640
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:23:19 -0600
Subject: Re: [PATCH v9 1/6] xfs: Move code around and remove typedefs
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130624213656.GA20932@sgi.com>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-2-git-send-email-sekharan@us.ibm.com>
	<20130624213656.GA20932@sgi.com>
Date: Mon, 24 Jun 2013 18:23:18 -0500
Message-ID: <1372116198.22504.89.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, 2013-06-24 at 16:36 -0500, Ben Myers wrote:
> Hi Chandra,
> 
> On Sun, Jun 23, 2013 at 09:48:22PM -0500, Chandra Seetharaman wrote:
> > Removed some typedefs, defined new functions, made some code clean up all in
> > preparation of the series.
> > 
> > No functional changes.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> As Dave mentioned, there are a few categories of changes that would probably be
> better as separate patches.  I count 6:
> 
> 1) the addition of xfs_is_quota_inode
> 
> 2) conversion of XFS_DQUOT_TREE macro to xfs_dquot_tree inlined function
> 
> 3) addition of xfs_dq_to_quota_inode
> 
> 4) cleanups in xfs_dquot.c (xfs_qm_quotacheck,xfs_qm_init_quotainos,
>    xfs_qm_vop_dqalloc,xfs_qm_vop_chown_reserve) and xfs_trans_dquot.c
>    (xfs_trans_reserve_quota_bydquots)
> 
> 5) changes to struct xfs_quotainfo.  I don't have an aversion to the comments
>    in the structure.  I'm guessing that you updated from xfs_inode_t to
>    struct xfs_inode and then ran into an 80 column issue later in the
>    structure.  It'd be nice to have the entries all line up, but I think
>    your compromise is fine.  Might have been better off touching only
>    the quota inodes and leaving the rest, but... style.
> 
> 6) add dqtypes enum, make an array in xfs_dquot_acct, update
>    xfs_trans_dup_dqinfo.  Now we have a two dimensional array in there, and 
>    I wonder if it would be better if it were more strongly typed.  e.g.
> 
>    tp->t_dqinfo->dq_type[j]->dqt_ents[i]
> 
>    (or something)

I will repost based on these suggestions.

<snip>

> > @@ -1697,14 +1695,14 @@ xfs_qm_vop_dqalloc(
> >  			 * holding ilock.
> >  			 */
> >  			xfs_iunlock(ip, lockflags);
> > -			if ((error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
> > +			error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t) uid,
> >  						 XFS_DQ_USER,
> >  						 XFS_QMOPT_DQALLOC |
> >  						 XFS_QMOPT_DOWARN,
> > -						 &uq))) {
> > -				ASSERT(error != ENOENT);
> > +						 &uq);
> > +			ASSERT(error != ENOENT);
> 
> You have a series of these asserts which used to be in the error case taken out
> of the error case.  Clearly the assertion is still true when error == 0... but
> I tend to prefer that it still be in the error curlies.  A silly style thing
> which I welcome you to reject with prejudice.

This way I avoided a set of curly-braces for the error case. thats all.

> 
<snip>
> > @@ -113,7 +111,9 @@ xfs_trans_dup_dqinfo(
> >  	if(otp->t_flags & XFS_TRANS_DQ_DIRTY)
> >  		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
> >  
> > -	for (j = 0; j < 2; j++) {
> > +	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> > +		oqa = otp->t_dqinfo->dqs[j];
> > +		nqa = ntp->t_dqinfo->dqs[j];
> >  		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
> >  			if (oqa[i].qt_dquot == NULL)
> >  				break;
> > @@ -138,8 +138,6 @@ xfs_trans_dup_dqinfo(
> >  			oq->qt_ino_res = oq->qt_ino_res_used;
> >  
> 
> Could clean up this extra line...

will do
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
