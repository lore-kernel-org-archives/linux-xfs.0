Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42Mq2T1092908 for <xfs@oss.sgi.com>; Wed, 2 May 2012 17:52:03 -0500
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id dh58UrgskNIPHcxn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 May 2012 15:52:01 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 2 May 2012 16:51:57 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 6A7E93E4004C
	for <xfs@oss.sgi.com>; Wed,  2 May 2012 16:51:55 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q42MptEY177972 for <xfs@oss.sgi.com>; Wed, 2 May 2012 16:51:55 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q42MptFY010852
	for <xfs@oss.sgi.com>; Wed, 2 May 2012 16:51:55 -0600
Subject: Re: [RFC v5 PATCH 2/4] xfs: Add pquota fields where gquota is used.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120502204903.GO16881@sgi.com>
References: <20120314202623.17044.90045.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120314202636.17044.11836.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120502204903.GO16881@sgi.com>
Date: Wed, 02 May 2012 17:51:53 -0500
Message-ID: <1335999113.1118.10.camel@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2012-05-02 at 15:49 -0500, Ben Myers wrote:
> On Wed, Mar 14, 2012 at 03:26:36PM -0500, Chandra Seetharaman wrote:
> > >From 0ed09750a12c6265861415bdb431c14f8eb02437 Mon Sep 17 00:00:00 2001
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > Date: Wed, 14 Mar 2012 14:17:47 -0500
> > Subject: [PATCH 2/4] Add project quota changes to all the places where group quota field
> >  is used.
> > 
> > No externally visible changed and no superblock changes, yet.
> 
> Looks like this patch does a few things:
> * add separate project quota members into various structures
> * split project quota and group quotas so that instead of overriding
>   the group quota members incore, the new project quota members are
>   used instead
> * get rid of usage of the OQUOTA flag incore, in favor of separate group
>   and project quota flags.
> * add a project dquot argument to various functions

Yes. Nothing is external yet.

I understand you want details on what changes have been made. If so, I
can add them.

> .
> 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> ...
> 
> > @@ -1593,9 +1662,23 @@ xfs_qm_init_quotainos(
> >  			return XFS_ERROR(error);
> >  		}
> >  	}
> > +	if (XFS_IS_PQUOTA_ON(mp) && pip == NULL) {
> > +		error = xfs_qm_qino_alloc(mp, &pip,
> > +					     sbflags | XFS_SB_GQUOTINO,
> 							^^^^
> So... you're still using the group quota inode at this point.

Yes, that is by design. There is no PQUOTINO with this patch. It is
added in the next patch.

Change all internal stuff in this patch so that the next patch which
changes the superblock has very limited change (for easier read/review
of the patch).

> 
> > +					     flags | XFS_QMOPT_PQUOTA);
> > +		if (error) {
> > +			if (uip)
> > +				IRELE(uip);
> > +			if (gip)
> > +				IRELE(gip);
> > +
> > +			return XFS_ERROR(error);
> > +		}
> > +	}
> 
> ...
> 
> > @@ -342,9 +354,12 @@ xfs_trans_apply_dquot_deltas(
> >  
> >  	ASSERT(tp->t_dqinfo);
> >  	qa = tp->t_dqinfo->dqa_usrdquots;
> > -	for (j = 0; j < 2; j++) {
> > +	for (j = 0; j < 3; j++) { /* 0 - usr, 1 - grp, 2 - prj */
> >  		if (qa[0].qt_dquot == NULL) {
>                     ^^^^^^^^^^^^^^^^^^^^^^
> That really looks weird to me.  Can you explain what is going on there?

Just to make it clear, I didn't add it :).

Per my understanding, it means is that there is no dquot structure of
this type(user, group, project) in this transaction, so we just skip
over it and move to the next type.

> 
> 
> > -			qa = tp->t_dqinfo->dqa_grpdquots;
> > +			if (qa == tp->t_dqinfo->dqa_usrdquots)
> > +				qa = tp->t_dqinfo->dqa_grpdquots;
> > +			else
> > +				qa = tp->t_dqinfo->dqa_prjdquots;
> >  			continue;
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
