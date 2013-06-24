Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27DCA7F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:33:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90327AC002
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 15:33:39 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id FWiTUvzg6oAFmSQ5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 15:33:35 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 24 Jun 2013 16:33:34 -0600
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 5720AC90043
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 18:33:01 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5OMX2bX310140 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 18:33:02 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5OMX1V7003790 for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 18:33:01 -0400
Subject: Re: [PATCH v9 3/6] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130624080000.GN29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-4-git-send-email-sekharan@us.ibm.com>
	<20130624080000.GN29376@dastard>
Date: Mon, 24 Jun 2013 17:33:00 -0500
Message-ID: <1372113180.22504.85.camel@chandra-dt.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2013-06-24 at 18:00 +1000, Dave Chinner wrote:
> On Sun, Jun 23, 2013 at 09:48:24PM -0500, Chandra Seetharaman wrote:
> > Add project quota changes to all the places where group quota field
> > is used:
> >    * add separate project quota members into various structures
> >    * split project quota and group quotas so that instead of overriding
> >      the group quota members incore, the new project quota members are
> >      used instead
> >    * get rid of usage of the OQUOTA flag incore, in favor of separate
> >    * group
> >      and project quota flags.
> 
> Formatting is a bit off there.
> 

will fix.
> ....
> 
> > @@ -949,21 +950,29 @@ xfs_qm_dqput_final(
> >  
> >  	/*
> >  	 * If we just added a udquot to the freelist, then we want to release
> > -	 * the gdquot reference that it (probably) has. Otherwise it'll keep
> > -	 * the gdquot from getting reclaimed.
> > +	 * the gdquot/pdquot reference that it (probably) has. Otherwise it'll
> > +	 * keep the gdquot/pdquot from getting reclaimed.
> >  	 */
> >  	gdqp = dqp->q_gdquot;
> >  	if (gdqp) {
> >  		xfs_dqlock(gdqp);
> >  		dqp->q_gdquot = NULL;
> >  	}
> > +
> > +	pdqp = dqp->q_pdquot;
> > +	if (pdqp) {
> > +		xfs_dqlock(pdqp);
> > +		dqp->q_pdquot = NULL;
> > +	}
> >  	xfs_dqunlock(dqp);
> 
> FWIW, this is one of the reasons I mentioned being consistent about
> order of quota processing being u/g/p - that's the lock ordering we
> have to follow when locking multiple dquots.
> 
> > @@ -559,8 +596,13 @@ xfs_qm_dqattach_locked(
> >  		 * 100% all the time. It is just a hint, and this will
> >  		 * succeed in general.
> >  		 */
> > -		if (ip->i_udquot->q_gdquot != ip->i_gdquot)
> > -			xfs_qm_dqattach_grouphint(ip->i_udquot, ip->i_gdquot);
> > +		if (XFS_IS_GQUOTA_ON(mp) &&
> > +				ip->i_udquot->q_gdquot != ip->i_gdquot)
> > +			xfs_qm_dqattach_hint(ip, XFS_DQ_GROUP);
> > +
> > +		if (XFS_IS_PQUOTA_ON(mp) &&
> > +				ip->i_udquot->q_pdquot != ip->i_pdquot)
> > +			xfs_qm_dqattach_hint(ip, XFS_DQ_PROJ);
> 
> Why do we need the XFS_IS_GQUOTA_ON/XFS_IS_PQUOTA_ON checks there?
> If group quotas are not on, then both the hint and in the
> inode pointers to the group dquot will be NULL, and therefore equal?
> i.e. we don't need to even check if quotas are enabled here...

ok.

> 
> Indeed, why pass (ip, quota type) to xfs_qm_dqattach_hint()? why not
> just pass the locations directly like:
> 
> 			xfs_qm_dqattach_hint(&ip->i_udquot->q_pdquot,
> 					     ip->i_pdquot):

will change.
> 
> > @@ -1423,6 +1484,15 @@ xfs_qm_init_quotainos(
> >  			if (error)
> >  				goto error_rele;
> >  		}
> > +		/* Use gquotino for now */
> 
> 		/* XXX: Use gquotino for now */
> 
> > +		if (XFS_IS_PQUOTA_ON(mp) &&
> > +		    mp->m_sb.sb_gquotino != NULLFSINO) {
> > +			ASSERT(mp->m_sb.sb_gquotino > 0);
> > +			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
> > +					     0, 0, &pip);
> > +			if (error)
> > +				goto error_rele;
> > +		}
> .....
> > @@ -1444,17 +1514,26 @@ xfs_qm_init_quotainos(
> >  
> >  		flags &= ~XFS_QMOPT_SBVERSION;
> >  	}
> > -	if (XFS_IS_OQUOTA_ON(mp) && gip == NULL) {
> > -		flags |= (XFS_IS_GQUOTA_ON(mp) ?
> > -				XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
> > +	if (XFS_IS_GQUOTA_ON(mp) && gip == NULL) {
> >  		error = xfs_qm_qino_alloc(mp, &gip,
> > -					  sbflags | XFS_SB_GQUOTINO, flags);
> > +					  sbflags | XFS_SB_GQUOTINO,
> > +					  flags | XFS_QMOPT_GQUOTA);
> > +		if (error)
> > +			goto error_rele;
> > +
> > +		flags &= ~XFS_QMOPT_SBVERSION;
> > +	}
> > +	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> > +		error = xfs_qm_qino_alloc(mp, &pip,
> > +					  sbflags | XFS_SB_GQUOTINO,
> > +					  flags | XFS_QMOPT_PQUOTA);
> 
> 	/* XXX: Use gquotino for now */
> 
> .....
> 
> > @@ -1958,13 +2057,18 @@ xfs_qm_vop_create_dqattach(
> >  	}
> >  	if (gdqp) {
> >  		ASSERT(ip->i_gdquot == NULL);
> > -		ASSERT(XFS_IS_OQUOTA_ON(mp));
> > -		ASSERT((XFS_IS_GQUOTA_ON(mp) ?
> > -			ip->i_d.di_gid : xfs_get_projid(ip)) ==
> > -				be32_to_cpu(gdqp->q_core.d_id));
> > -
> > +		ASSERT(XFS_IS_GQUOTA_ON(mp));
> > +		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
> >  		ip->i_gdquot = xfs_qm_dqhold(gdqp);
> >  		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
> >  	}
> > +	if (pdqp) {
> > +		ASSERT(ip->i_pdquot == NULL);
> > +		ASSERT(XFS_IS_PQUOTA_ON(mp));
> > +		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
> > +
> > +		ip->i_pdquot = xfs_qm_dqhold(pdqp);
> > +		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> > +	}
> >  }
> 
> 3 dquots can be modified in transactions that call this function
> now, not 2. That means transaction reservations for dquots need to
> be increased by a dquot in size....
> 
> > @@ -107,18 +111,20 @@ extern void	xfs_trans_mod_dquot(struct xfs_trans *,
> >  					struct xfs_dquot *, uint, long);
> >  extern int	xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
> >  			struct xfs_mount *, struct xfs_dquot *,
> > -			struct xfs_dquot *, long, long, uint);
> > +			struct xfs_dquot *, struct xfs_dquot *,
> > +			long, long, uint);
> >  extern void	xfs_trans_dqjoin(struct xfs_trans *, struct xfs_dquot *);
> >  extern void	xfs_trans_log_dquot(struct xfs_trans *, struct xfs_dquot *);
> >  
> >  /*
> > - * We keep the usr and grp dquots separately so that locking will be easier
> > - * to do at commit time. All transactions that we know of at this point
> > + * We keep the usr, grp, and prj dquots separately so that locking will be
> > + * easier to do at commit time. All transactions that we know of at this point
> >   * affect no more than two dquots of one type. Hence, the TRANS_MAXDQS value.
> >   */
> >  enum {
> >  	XFS_QM_TRANS_USR = 0,
> >  	XFS_QM_TRANS_GRP,
> > +	XFS_QM_TRANS_PRJ,
> >  	XFS_QM_TRANS_DQTYPES
> >  };
> >  #define XFS_QM_TRANS_MAXDQS		2
> 
> OK, that works, but I still don't see anything about dquot
> transaction reservations (i.e. XFS_DQUOT_LOGRES()) in this patch.
> It defines the log space resservation for dquots being modified in a
> transaction and we just bumped it by one for all transactions that
> do block allocation or freeing.
> 
> Actually, I suspect that it is already wrong because it currently
> reserves space for 3 dquots yet a chown operation can modify both
> ATTR_UID and ATTR_GID at the same time.  That will therefore modify
> {old, new} x {udq, gdq}, and so we've got 4 dquots being modified.
> Are there any cases where we might do {old, new} x {udq, gdq} + pdq
> or {old, new} x {udq, gdq, pdq}, and hence need the reservation to
> be 5 or 6 dquots?
> 
> <dig, ferret, dig, dig, blow away dust, ferret some more, dig, dig>
> 
> Indeed, the XFS_DQUOT_LOGRES() definition and comment around it is
> unchanged from when it was first introduced in 1996. So whatever the
> limitations on dquots in the one transaction are, they go back to
> what was limited by Irix, not Linux....
> 
> And I just learnt something interesting - XFS on Irix only supported
> user quota and project quota, there was no Irix group quota at all
> prior to the linux port being completed. Group quotas weren't
> implemented on Linux until well after the port to linux was out
> there in 2001:
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commit;h=749b2bf3ed5ff064efd69370e6b31ea44c4a78a6
> 
> And that commit basically swapped the project ID support for group
> quota support (i.e. no more project quota!), and that meant XFS at
> this point in time was not on-disk compatible between Irix and Linux
> if you used project quotas on Irix or group quotas on Linux. But
> because most of the code was common, the LInux code didn't change
> the XFS_DQUOT_LOGRES() value which was defined at 3. And this
> comment above xfs_trans_dqlockedjoin() is modified in that commit
> like so:
> 
> @@ -303,8 +303,8 @@ xfs_trans_mod_dquot(
>  /*
>   * Given an array of dqtrx structures, lock all the dquots associated
>   * and join them to the transaction, provided they have been modified.
> - * We know that the highest number of dquots (of one type - usr OR prj),
> - * involved in a transaction is 2 and that both usr and prj combined - 3.
> + * We know that the highest number of dquots (of one type - usr OR grp),
> + * involved in a transaction is 2 and that both usr and grp combined - 3.
>   * So, we don't attempt to make this very generic.
>   */
> 
> It was a search and replace that modified the comment, leaving the
> value unchanged and, as such, incorrect.
> 
> IOWs, XFS_DQUOT_LOGRES() was defined on Irix where a chown call
> could only change the UID.  Hence there's only two dquots modified
> in that operation and if blocks needed to be allocated/freed during
> that setattr operation the project dquot would need to be modified
> as well. So, there's the reason for it being defined as 3 dquots -
> no support for group quota at all, despite what the comments say....
> 
> Hence I think XFS_DQUOT_LOGRES() actually needs to reserve space for
> 5 dquots that can be modified in a transaction on Linux. i.e. {old,
> new} x {udq, gdq} + pdq, and that really needs a patch of it's own.

Nice explanation. Thanks a lot for digging into this. 

I replied to your earlier message in the previous revision
(http://oss.sgi.com/archives/xfs/2013-06/msg00295.html), and didn't get
any response. So, assumed my approach is correct.

> 
> Chandra, do you want me to write that patch and commit message?

After your explanation the change looks very simple and straight
forward. But, I do not think I can write a commit message including all
the rationale :)

Please go ahead and provide a pa
> Cheers,
> 
> Dave.
> 
> PS: if anyone was wondering - it took about 3 hours of code
> archaeology to pull that information out of the archives.
> 
> PPS: FWIW, project quota support wasn't reintroduced until 2005
> where the differences between Irix and Linux were re-unified at the
> source level via the "OQUOTA" names we have now.
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commit;h=0ab041f659d7d51489a026b16d83ffddc80285bd
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
