Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4BD2E7F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 15:50:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A1118F8071
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 13:50:30 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id 8wDQ2OlqHdlzicEH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 13:50:29 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 14:49:58 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 968D11FF001B
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 14:44:36 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6AKnpWx141570 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 14:49:52 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6AKnp0Y023652
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 14:49:51 -0600
Subject: Re: [PATCH v10 10/11] quota: Add proper versioning support to
	fs_quota_stat
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130710162602.GB32444@quack.suse.cz>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-11-git-send-email-sekharan@us.ibm.com>
	<20130710155538.GY20932@sgi.com> <20130710162602.GB32444@quack.suse.cz>
Date: Wed, 10 Jul 2013 15:49:50 -0500
Message-ID: <1373489390.6020.30.camel@chandra-dt.ibm.com>
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, swhiteho@redhat.com, xfs@oss.sgi.com

On Wed, 2013-07-10 at 18:26 +0200, Jan Kara wrote:
> On Wed 10-07-13 10:55:38, Ben Myers wrote:
> > Hey Chandra,

<snip>

> > > diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> > > index c7314f1..ae6526e 100644
> > > --- a/fs/quota/quota.c
> > > +++ b/fs/quota/quota.c
> > > @@ -207,12 +207,57 @@ static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
> > >  static int quota_getxstate(struct super_block *sb, void __user *addr)
> > >  {
> > >  	struct fs_quota_stat fqs;
> > > -	int ret;
> > > +	struct fs_quota_stat_v1 fqs_v1;
> > > +	int ret, size;
> > > +	void *fqsp;
> > >  
> > >  	if (!sb->s_qcop->get_xstate)
> > >  		return -ENOSYS;
> > > +
> > > +	memset(&fqs, 0, sizeof(struct fs_quota_stat));
> > > +	if (copy_from_user(&fqs, addr, 1)) /* just get the version */
> > > +		return -EFAULT;
> > > +
> > > +	switch (fqs.qs_version) {
> > > +	case FS_QSTAT_VERSION_2:
> > > +		size = FS_QSTAT_V2_SIZE;
> > > +		break;
> > > +	default:
> > > +		fqs.qs_version = FS_QSTAT_VERSION;
> > > +		/* fallthrough */
> > > +	case FS_QSTAT_VERSION:
> > > +		size = FS_QSTAT_V1_SIZE;
> > > +		break;
> > > +	}
>   Guys, you cannot really do this. If anyone is using getxstate() with
> uninitialized buffer (which is fine so far), you cannot suddently start to
> rely on the contents of qs_version field. That's ABI (and even API)
> breakage.

Agree, it is a API breakage.

Will fix it by adding a new quotactl value as you suggest. 
Does 

#define Q_XGETQSTAT2     XQM_CMD(8)

sound good ?
> 
> Unless I'm missing something, the only clean way is to use new quotactl
> value for the interface with version field used for input as well.
> 
> 								Honza
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
