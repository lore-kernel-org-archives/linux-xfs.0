Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 197C17F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 16:52:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDED830408F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 14:52:18 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QF6LEGdnasrn2ieu for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 14:52:17 -0700 (PDT)
Date: Wed, 10 Jul 2013 23:52:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v10 10/11] quota: Add proper versioning support to
	fs_quota_stat
Message-ID: <20130710215214.GA1641@quack.suse.cz>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-11-git-send-email-sekharan@us.ibm.com>
	<20130710155538.GY20932@sgi.com>
	<20130710162602.GB32444@quack.suse.cz>
	<20130710184704.GZ32736@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130710184704.GZ32736@sgi.com>
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
Cc: swhiteho@redhat.com, Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Wed 10-07-13 13:47:04, Ben Myers wrote:
> Hey Jan,
> 
> On Wed, Jul 10, 2013 at 06:26:02PM +0200, Jan Kara wrote:
> > On Wed 10-07-13 10:55:38, Ben Myers wrote:
> > > Hey Chandra,
> > > 
> > > On Thu, Jun 27, 2013 at 05:25:13PM -0500, Chandra Seetharaman wrote:
> > > > Added appropriate pads and code for backward compatibility.
> > > > 
> > > > Copied over the old version as it is different from the newer padded
> > > > version.
> > > > 
> > > > New callers of the system call have to set the version of the data
> > > > structure being passed, and kernel will fill as much data as requested.
> > > > 
> > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > I think we also need to
> > > 
> > > Cc: Jan Kara <jack@suse.cz>
> >   Thanks for CC.
> > 
> > > > diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> > > > index c7c840e..ca0dccd 100644
> > > > --- a/fs/gfs2/quota.c
> > > > +++ b/fs/gfs2/quota.c
> > > > @@ -1443,9 +1443,6 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
> > > >  {
> > > >  	struct gfs2_sbd *sdp = sb->s_fs_info;
> > > >  
> > > > -	memset(fqs, 0, sizeof(struct fs_quota_stat));
> > > > -	fqs->qs_version = FS_QSTAT_VERSION;
> > > > -
> > > >  	switch (sdp->sd_args.ar_quota) {
> > > >  	case GFS2_QUOTA_ON:
> > > >  		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
> > > > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > > > index c7314f1..ae6526e 100644
> > > > --- a/fs/quota/quota.c
> > > > +++ b/fs/quota/quota.c
> > > > @@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
> > > >  static int quota_getxstate(struct super_block *sb, void __user *addr)
> > > >  {
> > > >  	struct fs_quota_stat fqs;
> > > > -	int ret;
> > > > +	struct fs_quota_stat_v1 fqs_v1;
> > > > +	int ret, size;
> > > > +	void *fqsp;
> > > >  
> > > >  	if (!sb->s_qcop->get_xstate)
> > > >  		return -ENOSYS;
> > > > +
> > > > +	memset(&fqs, 0, sizeof(struct fs_quota_stat));
> > > > +	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
> > > > +		return -EFAULT;
> > > > +
> > > > +	switch (fqs.qs_version) {
> > > > +	case FS_QSTAT_VERSION_2:
> > > > +		size = FS_QSTAT_V2_SIZE;
> > > > +		break;
> > > > +	default:
> > > > +		fqs.qs_version = FS_QSTAT_VERSION;
> > > > +		/* fallthrough */
> > > > +	case FS_QSTAT_VERSION:
> > > > +		size = FS_QSTAT_V1_SIZE;
> > > > +		break;
> > > > +	}
> >   Guys, you cannot really do this. If anyone is using getxstate() with
> > uninitialized buffer (which is fine so far), you cannot suddently start to
> > rely on the contents of qs_version field. That's ABI (and even API)
> > breakage.
> 
> Looks like you are correct to me.  Seems that qs_version number was never
> checked until this patch.
> 
> > Unless I'm missing something, the only clean way is to use new quotactl
> > value for the interface with version field used for input as well.
> 
> If I understand... it would be something like this?
> 
> #define Q_XGETQSTATV     XQM_CMD(8)
   Yes.

> Or Q_XGETQSTAT2?
  I don't really care but the first name looks a bit better.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
