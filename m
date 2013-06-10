Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB17A7F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 18:17:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C83DC304051
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 16:17:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jMzg0VuseWuWrHHt for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 16:17:33 -0700 (PDT)
Date: Tue, 11 Jun 2013 09:17:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 2/5] xfs: Add pquota fields where gquota is used.
Message-ID: <20130610231729.GD29376@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-3-git-send-email-sekharan@us.ibm.com>
	<20130517042303.GN24635@dastard>
	<1369432625.9551.946.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369432625.9551.946.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, May 24, 2013 at 04:57:05PM -0500, Chandra Seetharaman wrote:
> On Fri, 2013-05-17 at 14:23 +1000, Dave Chinner wrote: 
> > On Fri, May 10, 2013 at 04:21:26PM -0500, Chandra Seetharaman wrote:
> > > Add project quota changes to all the places where group quota field
> > > is used:
> > >    * add separate project quota members into various structures
> > >    * split project quota and group quotas so that instead of overriding
> > >      the group quota members incore, the new project quota members are
> > >      used instead
> > >    * get rid of usage of the OQUOTA flag incore, in favor of separate
> > >    * group
> > >      and project quota flags.
> > >    * add a project dquot argument to various functions.
> > > 
> > > No externally visible interfaces changed.
> > 
> > Looks pretty good. Some relatively minor changes below.
.....
> > >  		if (code)
> > >  			return code;
> > >  	}
> > > @@ -994,8 +994,8 @@ xfs_ioctl_setattr(
> > >  		    XFS_IS_PQUOTA_ON(mp) &&
> > >  		    xfs_get_projid(ip) != fa->fsx_projid) {
> > >  			ASSERT(tp);
> > > -			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
> > > -						capable(CAP_FOWNER) ?
> > > +			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
> > > +						pdqp, capable(CAP_FOWNER) ?
> > >  						XFS_QMOPT_FORCE_RES : 0);
> > > @@ -1113,7 +1113,7 @@ xfs_ioctl_setattr(
> > >  		if (xfs_get_projid(ip) != fa->fsx_projid) {
> > >  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> > >  				olddquot = xfs_qm_vop_chown(tp, ip,
> > > -							&ip->i_gdquot, gdqp);
> > > +							&ip->i_pdquot, pdqp);
> > 
> > xfs_qm_vop_chown() is only called on one dquot at a time, so it can
> > only exchange one dquot at a time. and udqp is not used for hints,
> > so it looks to me like udqp and gdqp are wholly unnecessary in this
> > function....
> 
> Did not fully understand this comment. Can you please elaborate ?

What I was saying here is that throughout the function udqp and gdqp
are passed to the various quota functions, but they are not used at
all by the functions being called. i.e. you could pass NULL instead,
and the code would still function identically. IOWs, we don't
actually need to define anything other than the project quota
related variables...

> > > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > > index d82efaa..7c54ea4 100644
> > > --- a/fs/xfs/xfs_iops.c
> > > +++ b/fs/xfs/xfs_iops.c
> > > @@ -517,7 +517,7 @@ xfs_setattr_nonsize(
> > >  		ASSERT(udqp == NULL);
> > >  		ASSERT(gdqp == NULL);
> > >  		error = xfs_qm_vop_dqalloc(ip, uid, gid, xfs_get_projid(ip),
> > > -					 qflags, &udqp, &gdqp);
> > > +					 qflags, &udqp, &gdqp, NULL);
> > 
> > Why is there no project quota support here, even though we pass in a
> > project ID? I know the answer, but please add a comment so that a
> > couple of years down the track I don't need to go remind myself of
> > why....
> 
> Not clear what you are expecting here.

I'm expecting you to write a comment explaining why we pass
uid/gid/projid to the xfs_qm_vop_dqalloc() function, but then only
pass udqp and gdqp but NULL instead of a project quota dquot
pointer. Indeed, I already don't remember why this is a valid, so it
clearly needs a comment explaining it....


> > 
> > 
> > 			qino = xfs_sb_version_has_pquota(&mp->m_sb) ?
> > 						mp->m_sb.sb_pquotino :
> > 						mp->m_sb.sb_gquotino;
> > 
> > And the correct on-disk inode is read....
> > 
> The object of this patch is to replace all gquota with pquota stuff. I
> am not using the pquotino or xfs_sb_version_has_pquota() until patch 3.
> 
> If I get the change forward, I have to merge patch 3 and part of this
> patch into patch 1, which adds up lots of work.
> 
> The way the patches are split now, IMO, is easy to follow and works
> independently.

That's fine. I review the patches one by one, so I make comments
that are relevant to the current patch context. It may be that you
changed it in a later patch and that often is fine - comments like
this indicate that perhaps the commit message hasn't quite described
the full context of the patch within the series correctly...

> > > +	if (pdqp) {
> > > +		ASSERT(ip->i_pdquot == NULL);
> > > +		ASSERT(XFS_IS_PQUOTA_ON(mp));
> > > +		ASSERT(xfs_get_projid(ip) == be32_to_cpu(pdqp->q_core.d_id));
> > > +
> > > +		ip->i_pdquot = xfs_qm_dqhold(pdqp);
> > > +		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
> > > +	}
> > >  }
> > 
> > Something this just triggered. All transaction reservations that
> > reserve space for dquots need to be upped from 2 to 3 dquots.
> 
> Can you elaborate please.

A transaction ithat modifies space can now modify 3 dquots (u+g+p)
instead of only 2 (u+(g or p)), and so the log space for any such 
transaction goes up. It may be that you've already handled this, but
if you're asking for an explanation then maybe not :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
