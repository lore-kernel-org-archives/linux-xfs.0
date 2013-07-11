Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E7B57F8D
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 02:55:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6434E304113
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:55:43 -0700 (PDT)
Subject: Re: [PATCH v10 10/11] quota: Add proper versioning support to
	fs_quota_stat
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <1373516161.4555.10.camel@chandra-laptop.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-11-git-send-email-sekharan@us.ibm.com>
	<20130710155538.GY20932@sgi.com> <20130710162602.GB32444@quack.suse.cz>
	<1373489390.6020.30.camel@chandra-dt.ibm.com>
	<20130711014501.GY3438@dastard>
	<1373516161.4555.10.camel@chandra-laptop.ibm.com>
Date: Thu, 11 Jul 2013 08:51:20 +0100
Message-ID: <1373529080.2721.0.camel@menhir>
Mime-Version: 1.0
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
To: sekharan@us.ibm.com
Cc: Jan Kara <jack@suse.cz>, Ben Myers <bpm@sgi.com>, adas@redhat.com, xfs@oss.sgi.com

Hi,

Copying in Abhi, since he is the quota expert on the GFS2 side,

Steve.

On Wed, 2013-07-10 at 23:16 -0500, Chandra Seetharaman wrote:
> On Thu, 2013-07-11 at 11:45 +1000, Dave Chinner wrote:
> > On Wed, Jul 10, 2013 at 03:49:50PM -0500, Chandra Seetharaman wrote:
> > > On Wed, 2013-07-10 at 18:26 +0200, Jan Kara wrote:
> > > > On Wed 10-07-13 10:55:38, Ben Myers wrote:
> > > > > Hey Chandra,
> > > 
> > > <snip>
> > > 
> > > > > > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > > > > > index c7314f1..ae6526e 100644
> > > > > > --- a/fs/quota/quota.c
> > > > > > +++ b/fs/quota/quota.c
> > > > > > @@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
> > > > > >  static int quota_getxstate(struct super_block *sb, void __user *addr)
> > > > > >  {
> > > > > >  	struct fs_quota_stat fqs;
> > > > > > -	int ret;
> > > > > > +	struct fs_quota_stat_v1 fqs_v1;
> > > > > > +	int ret, size;
> > > > > > +	void *fqsp;
> > > > > >  
> > > > > >  	if (!sb->s_qcop->get_xstate)
> > > > > >  		return -ENOSYS;
> > > > > > +
> > > > > > +	memset(&fqs, 0, sizeof(struct fs_quota_stat));
> > > > > > +	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
> > > > > > +		return -EFAULT;
> > > > > > +
> > > > > > +	switch (fqs.qs_version) {
> > > > > > +	case FS_QSTAT_VERSION_2:
> > > > > > +		size = FS_QSTAT_V2_SIZE;
> > > > > > +		break;
> > > > > > +	default:
> > > > > > +		fqs.qs_version = FS_QSTAT_VERSION;
> > > > > > +		/* fallthrough */
> > > > > > +	case FS_QSTAT_VERSION:
> > > > > > +		size = FS_QSTAT_V1_SIZE;
> > > > > > +		break;
> > > > > > +	}
> > > >   Guys, you cannot really do this. If anyone is using getxstate() with
> > > > uninitialized buffer (which is fine so far), you cannot suddently start to
> > > > rely on the contents of qs_version field. That's ABI (and even API)
> > > > breakage.
> > > 
> > > Agree, it is a API breakage.
> > > 
> > > Will fix it by adding a new quotactl value as you suggest. 
> > 
> > Please enforce the version number as being valid so we don't
> > need to add another new interface if we need to change this
> > structure again. :)
> 
> Yes, I am keeping the lower level interface same as before.
> 
> > 
> > FWIW, we're now going to need a new xfs_quota changes to go along
> > with this - it will need to use the new interface by default, and
> > fall back to the existing interface if it gets an error saying the
> > command does not exist.  We can't actually test the new interface
> > until we have xfs_quota patches that use it.
> 
> The lower level interface doesn't change. It will remain the same. I
> will send the code soon.
> 
> > 
> > And to play Devil's advocate: it is way too late in the merge cycle
> > to make these sorts of ABI changes to a patch and test/review them
> > adequately.
> 
> There is no ABI issues even in the earlier version, it was an API
> breakage. And with Jan's suggestion even that API breakage is being
> fixed. There is no change in API or ABI. We are just adding a new
> interface.
> 
> Old code and old binary will work as before.
> 
> > 
> > Cheers,
> > 
> > Dave.
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
