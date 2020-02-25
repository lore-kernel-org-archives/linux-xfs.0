Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F45C35E17
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36A3B20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IJIc+57q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgBYVfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:35:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51720 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 16:35:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PLXd5J155783;
        Tue, 25 Feb 2020 21:35:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6DFrm+3jy0KTyI9iqLTQcvk2VYkuXhHYO9WEEObdRZE=;
 b=IJIc+57qdyUeccW3uBbpzWFFMaXfL/G/KPQvg9IYfVqpJZ0CTNCxJJ+bXpjVYg669nZP
 TeMRJuZoDlL8CfXVz7in5kweiupD2wzHgE0/Ku3Yu4R3qxpmMunIelKtALqur4WNZUyH
 z4fDuCjx/bsvC4MQcgy7nJZJHIrNkkhM9c4Ajq+eMSYHIsTFzoozgO5SL++NaNq0FO/6
 NnZjp8Tpy6R1bgcTrAy3h/rdFVXjDCggLHjYRkBtjlY4fUiy6mlIIK7Rq7rcplScOUsq
 ddRiiZo4omMwG3mFJysyn3LReMgi+PS47L0iZFk3V5z0vHXrt+q24/Wg6QHRF4F1RtbZ rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yd093mcs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 21:35:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PLW85A082843;
        Tue, 25 Feb 2020 21:35:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2yd09bhysg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 21:35:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PLZY6F026959;
        Tue, 25 Feb 2020 21:35:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 13:35:34 -0800
Date:   Tue, 25 Feb 2020 13:35:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
Message-ID: <20200225213533.GW6740@magnolia>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia>
 <20200220155938.GA1306@infradead.org>
 <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
 <20200220160820.GA14640@infradead.org>
 <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
 <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
 <20200225041327.GE6740@magnolia>
 <575bec416692e93b599520f34d625de8d46bfb07.camel@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <575bec416692e93b599520f34d625de8d46bfb07.camel@btinternet.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 05:54:03PM +0000, Richard Haines wrote:
> On Mon, 2020-02-24 at 20:13 -0800, Darrick J. Wong wrote:
> > On Mon, Feb 24, 2020 at 04:41:17PM +0000, Richard Haines wrote:
> > > On Sat, 2020-02-22 at 14:49 -0500, Paul Moore wrote:
> > > > On Thu, Feb 20, 2020 at 11:08 AM Christoph Hellwig <
> > > > hch@infradead.org
> > > > > wrote:
> > > > > On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley
> > > > > wrote:
> > > > > > > The dquot_* routines are not generic quota code, but a
> > > > > > > specific
> > > > > > > implementation used by most non-XFS file systems.  So if
> > > > > > > there
> > > > > > > is a bug
> > > > > > > it is that the security call is not in the generic dispatch
> > > > > > > code.
> > > > > > 
> > > > > > Hmm...any reason the security hook call couldn't be taken to
> > > > > > quota_quotaon()?
> > > > > 
> > > > > I haven't touched the quota code for a while, but yes, the
> > > > > existing
> > > > > calls should move to the quota_* routines in
> > > > > fs/quota/quota.c.  Note
> > > > > that you still need to add checks, e.g. for Q_XSETQLIM.
> > > > 
> > > > Who wanted to submit a patch for this?  Christoph were you
> > > > planning
> > > > on
> > > > fixing this?  If not, Richard, do you want to give it a try?
> > > > 
> > > 
> > > I've had a go at this and found I can (almost) get it working. I've
> > > attached a sample patch just in case anyone is interested.
> > 
> > Almost?  Are you talking about the weird looking dentry?
> > 
> > > However if the calls do need to move to fs/quota/quota.c, then I
> > > think
> > > the xfs team are best placed to do this (I've had my playtime).
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> > > index 38669e827..c02cf9a63 100644
> > > --- a/fs/xfs/xfs_quotaops.c
> > > +++ b/fs/xfs/xfs_quotaops.c
> > > @@ -14,7 +14,7 @@
> > >  #include "xfs_trans.h"
> > >  #include "xfs_icache.h"
> > >  #include "xfs_qm.h"
> > > -
> > > +#include <linux/security.h>
> > >  
> > >  static void
> > >  xfs_qm_fill_state(
> > > @@ -161,11 +161,15 @@ xfs_quota_enable(
> > >  	unsigned int		uflags)
> > >  {
> > >  	struct xfs_mount	*mp = XFS_M(sb);
> > > +	struct dentry		*dentry = mp->m_super->s_root;
> > >  
> > >  	if (sb_rdonly(sb))
> > >  		return -EROFS;
> > >  	if (!XFS_IS_QUOTA_RUNNING(mp))
> > >  		return -ENOSYS;
> > > +	/* Emulates dquot_quota_on() Labeled correctly */
> > > +	if (!security_quota_on(dentry))
> > > +		return -EACCES;
> > >  
> > >  	return xfs_qm_scall_quotaon(mp, xfs_quota_flags(uflags));
> > >  }
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 2094386af..59855d060 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -39,6 +39,7 @@
> > >  #include <linux/magic.h>
> > >  #include <linux/fs_context.h>
> > >  #include <linux/fs_parser.h>
> > > +#include <linux/security.h>
> > >  
> > >  static const struct super_operations xfs_super_operations;
> > >  
> > > @@ -1507,6 +1508,22 @@ xfs_fc_fill_super(
> > >  		goto out_unmount;
> > >  	}
> > >  
> > > +	/*
> > > +	 * Emulates dquot_quota_on_mount() and works, however the
> > > dentry
> > > +	 * is unlabeled:
> > > +	 *    allow test_filesystem_t unlabeled_t:dir { quotaon };
> > > +	 */
> > > +	struct xfs_mount	*mpx = XFS_M(sb);
> > > +	struct dentry		*dentry = mpx->m_super->s_root;
> > > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > > +		error = security_quota_on(dentry);
> > 
> > Er... I'm not sure if this is doing what you really want it
> > to?  Mostly
> > because I don't know what the quota security hooks are supposed to
> > activate against? :)
> > 
> > The other three filesystems (ext4/f2fs/reiserfs) keep their quota
> > files
> > linked off the root directory, and dquot_quota_on_mount looks up the
> > dentry for a root directory quota file and feeds that into
> > security_quota_on.
> > 
> > This patch calls it on XFS' root directory itself (quota inodes are
> > not
> > linked in the directory tree at all on xfs), which I guess is the
> > best
> > you can do, but might not be what the security hooks is expecting.
> > 
> > <shrug> Apologies for my unfamiliarity.
> 
> Thanks for your comments.
> What I was trying to achieve is obtain a dentry for the root directory
> to call the security hooks with. My reasoning was that as xfs quotas
> are 'internal' (i.e. not files as in ext4 etc.), then using this as a
> reference, I could check that the SELinux 'quotaon' permission was set
> on this to allow quotas to be used (if set as mount options), if not
> fail the mount.

Hmm, maybe let's back up a step here.  What's the purpose of being able
to set quota_on privileges on a file?  Is it so that sysadmins can
designate a particular file as a "quota" file and thereby prevent the
kernel from being tricked into loading some other file as the quota data
file?

I ask this because AFAICT in ext4, the "usrjquota=<path>" mount options
are for the old quota system wherein quotas are files that are managed
separately from the filesystem.

The new ext4 quota system links the quota inode pointers only from the
superblock, and it calls dquot_load_quota_inode, which doesn't seem to
have a security callout.  Seeing as there's no user-visible file for new
style quotas, I don't see why you'd need a selinux hook either.

I guess it could be generally useful to be able to be able to apply the
same quota_on labels to root directories of filesystems that have new
style quotas that one can apply to quota files on fses with old style
quotas... but (a) I don't see that being the case right now, and (b) if
you're trying to /add/ that functionality then yes it ought to be in
fs/quota/... and yes xfs will have to play catch up once it's there.

Is there already a precedent for setting quota_on labels to the root
dir?  It's entirely possible that I'm simply unaware of what's going on
in fs/quota/ because xfs mostly does its own things wrt quota.

--D

> Once mounted with quotas enabled, I could then use quotactl(2) to turn
> them off/on, get stats etc. providing of course the mount directory
> also had the SELinux quotamod and quotaget permissions as well (hence
> the hook in xfs_quota_enable()).
> 
> As I don't know the xfs code at all, I was just experimenting to test
> my theory, however the xfs dev team is better placed to resolve this as
> its been suggested that the calls are moved to fs/quota/quota.c.
> 
> 
> > 
> > --D
> > 
> > > +		if (error) {
> > > +			dput(sb->s_root);
> > > +			sb->s_root = NULL;
> > > +			goto out_unmount;
> > > +		}
> > > +	}
> > > +
> > >  	return 0;
> > >  
> > >   out_filestream_unmount:
> > > diff --git a/security/security.c b/security/security.c
> > > index db7b574c9..ac0cc9872 100644
> > > --- a/security/security.c
> > > +++ b/security/security.c
> > > @@ -770,6 +770,7 @@ int security_quota_on(struct dentry *dentry)
> > >  {
> > >  	return call_int_hook(quota_on, 0, dentry);
> > >  }
> > > +EXPORT_SYMBOL(security_quota_on);
> > >  
> > >  int security_syslog(int type)
> > >  {
> 
