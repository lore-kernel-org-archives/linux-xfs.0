Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E1DB7F59
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4CDB88F8035
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 21:16:57 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id ka4Qri0d0v4X5qiY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 21:16:56 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 22:16:55 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 98B2AC90041
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:16:51 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6B4GqaA8258042
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:16:52 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r6B4Gqpd008134 for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:16:52 -0400
Subject: Re: [PATCH v10 10/11] quota: Add proper versioning support to
	fs_quota_stat
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130711014501.GY3438@dastard>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-11-git-send-email-sekharan@us.ibm.com>
	<20130710155538.GY20932@sgi.com> <20130710162602.GB32444@quack.suse.cz>
	<1373489390.6020.30.camel@chandra-dt.ibm.com>
	<20130711014501.GY3438@dastard>
Date: Wed, 10 Jul 2013 23:16:01 -0500
Message-ID: <1373516161.4555.10.camel@chandra-laptop.ibm.com>
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
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, swhiteho@redhat.com, xfs@oss.sgi.com

On Thu, 2013-07-11 at 11:45 +1000, Dave Chinner wrote:
> On Wed, Jul 10, 2013 at 03:49:50PM -0500, Chandra Seetharaman wrote:
> > On Wed, 2013-07-10 at 18:26 +0200, Jan Kara wrote:
> > > On Wed 10-07-13 10:55:38, Ben Myers wrote:
> > > > Hey Chandra,
> > 
> > <snip>
> > 
> > > > > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > > > > index c7314f1..ae6526e 100644
> > > > > --- a/fs/quota/quota.c
> > > > > +++ b/fs/quota/quota.c
> > > > > @@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
> > > > >  static int quota_getxstate(struct super_block *sb, void __user *addr)
> > > > >  {
> > > > >  	struct fs_quota_stat fqs;
> > > > > -	int ret;
> > > > > +	struct fs_quota_stat_v1 fqs_v1;
> > > > > +	int ret, size;
> > > > > +	void *fqsp;
> > > > >  
> > > > >  	if (!sb->s_qcop->get_xstate)
> > > > >  		return -ENOSYS;
> > > > > +
> > > > > +	memset(&fqs, 0, sizeof(struct fs_quota_stat));
> > > > > +	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
> > > > > +		return -EFAULT;
> > > > > +
> > > > > +	switch (fqs.qs_version) {
> > > > > +	case FS_QSTAT_VERSION_2:
> > > > > +		size = FS_QSTAT_V2_SIZE;
> > > > > +		break;
> > > > > +	default:
> > > > > +		fqs.qs_version = FS_QSTAT_VERSION;
> > > > > +		/* fallthrough */
> > > > > +	case FS_QSTAT_VERSION:
> > > > > +		size = FS_QSTAT_V1_SIZE;
> > > > > +		break;
> > > > > +	}
> > >   Guys, you cannot really do this. If anyone is using getxstate() with
> > > uninitialized buffer (which is fine so far), you cannot suddently start to
> > > rely on the contents of qs_version field. That's ABI (and even API)
> > > breakage.
> > 
> > Agree, it is a API breakage.
> > 
> > Will fix it by adding a new quotactl value as you suggest. 
> 
> Please enforce the version number as being valid so we don't
> need to add another new interface if we need to change this
> structure again. :)

Yes, I am keeping the lower level interface same as before.

> 
> FWIW, we're now going to need a new xfs_quota changes to go along
> with this - it will need to use the new interface by default, and
> fall back to the existing interface if it gets an error saying the
> command does not exist.  We can't actually test the new interface
> until we have xfs_quota patches that use it.

The lower level interface doesn't change. It will remain the same. I
will send the code soon.

> 
> And to play Devil's advocate: it is way too late in the merge cycle
> to make these sorts of ABI changes to a patch and test/review them
> adequately.

There is no ABI issues even in the earlier version, it was an API
breakage. And with Jan's suggestion even that API breakage is being
fixed. There is no change in API or ABI. We are just adding a new
interface.

Old code and old binary will work as before.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
