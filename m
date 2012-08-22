Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7MNe0nW081016 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 18:40:01 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id Tr9ZAIFPeQIZq6gI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 16:40:46 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 22 Aug 2012 17:40:46 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 3D1C419D8040
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 17:40:43 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q7MNedpO099070 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 17:40:40 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q7MNedEE026798
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 17:40:39 -0600
Subject: Re: [RFC v6 PATCH 5/5] xfs: Add a new field to fs_quota_stat to
	get pquota information
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120815023742.GU2877@dastard>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120720230305.20477.41556.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120815023742.GU2877@dastard>
Date: Wed, 22 Aug 2012 18:40:38 -0500
Message-ID: <1345678838.2260.34.camel@chandra-lucid.austin.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks for the review..

On Wed, 2012-08-15 at 12:37 +1000, Dave Chinner wrote:
> On Fri, Jul 20, 2012 at 06:03:05PM -0500, Chandra Seetharaman wrote:
> > Use separate structure for filling the project quota information
> > for the Q_XGETQSTAT quota command.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> >  fs/xfs/xfs_qm_syscalls.c |   26 +++++++++++++-------------
> >  1 files changed, 13 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index f011cf3..482efc0 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -421,7 +421,6 @@ xfs_qm_scall_getqstat(
> >  	tempuqip = tempgqip = temppqip = B_FALSE;
> >  	memset(out, 0, sizeof(fs_quota_stat_t));
> >  
> > -	out->qs_version = FS_QSTAT_VERSION;
> >  	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
> >  		out->qs_uquota.qfs_ino = NULLFSINO;
> >  		out->qs_gquota.qfs_ino = NULLFSINO;
> > @@ -434,8 +433,6 @@ xfs_qm_scall_getqstat(
> >  	out->qs_pad = 0;
> >  	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
> >  	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
> > -	if (&out->qs_gquota != &out->qs_pquota)
> > -		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> >  
> >  	if (q) {
> >  		uip = q->qi_uquotaip;
> > @@ -452,11 +449,6 @@ xfs_qm_scall_getqstat(
> >  					0, 0, &gip) == 0)
> >  			tempgqip = B_TRUE;
> >  	}
> > -	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
> > -		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> > -					0, 0, &pip) == 0)
> > -			temppqip = B_TRUE;
> > -	}
> >  	if (uip) {
> >  		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
> >  		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
> > @@ -469,11 +461,19 @@ xfs_qm_scall_getqstat(
> >  		if (tempgqip)
> >  			IRELE(gip);
> >  	}
> > -	if (pip) {
> > -		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> > -		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> > -		if (temppqip)
> > -			IRELE(pip);
> > +	if (out->qs_version >= FS_QSTAT_VERSION_2) {
> > +		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
> > +		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
> > +			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
> > +						0, 0, &pip) == 0)
> > +				temppqip = B_TRUE;
> > +		}
> > +		if (pip) {
> > +			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
> > +			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
> > +			if (temppqip)
> > +				IRELE(pip);
> > +		}
> 
> Doesn't this mean that we'll never report project quota for
> FS_QSTAT_VERSION structures and the old quota format? i.e. existing
> tools with a new kernel won't return the project quota info in the
> group quota fields?

Good catch. I will add additional code to check the qs_version and the
new pquota flag to cover that combination.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
