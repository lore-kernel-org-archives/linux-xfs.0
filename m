Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6341C35E0C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A276E24670
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=btinternet.com header.i=@btinternet.com header.b="pvSuQ00m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgBYRyI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:54:08 -0500
Received: from mailomta9-sa.btinternet.com ([213.120.69.15]:27658 "EHLO
        sa-prd-fep-047.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730864AbgBYRyH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:54:07 -0500
Received: from sa-prd-rgout-001.btmx-prd.synchronoss.net ([10.2.38.4])
          by sa-prd-fep-047.btinternet.com with ESMTP
          id <20200225175404.GOCI7408.sa-prd-fep-047.btinternet.com@sa-prd-rgout-001.btmx-prd.synchronoss.net>;
          Tue, 25 Feb 2020 17:54:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1582653244; 
        bh=l6epApwVc9fmpwE1MJjiYAHLYjGtuTd6FxT4oYdC+DQ=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=pvSuQ00mK1UFM9J+iGBTrEluo0iS+ZUp9ObqzkOuJ1DVd9VGvl7F3cf26EWUTnoGycqK1y9BZT+cOWnoEQkXUIdXaOK7PP+zoc8fc8mUDrP+qK9k3GQnWCmiXbxZNJeAKQRE1WDFYUyYOsL7jYQC2kdEHNY0ys9VqbJMGuj2y2K+ftKobHj12XSokcg0pPqNrNwyuDx0CdPotfimbuh6y9i6RZmSCcyoch+I88Z8kkonvZRUT2z3OfHtMFEnCFhlcBiwgsLE6NQQ3K1pmVNKT3h+UNyA6jey7SD1YfBM6ufUf3WH2S7kwqZ5nwJHiMFvgfujoGtaVQ2jDzXfjkbfww==
Authentication-Results: btinternet.com;
    auth=pass (PLAIN) smtp.auth=richard_c_haines@btinternet.com
X-Originating-IP: [31.49.58.0]
X-OWM-Source-IP: 31.49.58.0 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedrledvgddutdehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuueftkffvkffujffvgffngfevqffopdfqfgfvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpeftihgthhgrrhguucfjrghinhgvshcuoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqeenucfkphepfedurdegledrheekrddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeefuddrgeelrdehkedrtddpmhgrihhlfhhrohhmpeeorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmqedprhgtphhtthhopeeohhgthhesihhnfhhrrgguvggrugdrohhrgheqpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeophgruhhlsehprghulhdqmhhoohhrvgdrtghomheqpdhrtghpthhtohepoehrihgthhgrrhgupggtpghhrghinhgvsheshhhothhmrghilhdrtghomheqpdhrtghpthhtohepoehsughs
        sehthigthhhordhnshgrrdhgohhvqedprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from localhost.localdomain (31.49.58.0) by sa-prd-rgout-001.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5E3A24110336F644; Tue, 25 Feb 2020 17:54:04 +0000
Message-ID: <575bec416692e93b599520f34d625de8d46bfb07.camel@btinternet.com>
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Date:   Tue, 25 Feb 2020 17:54:03 +0000
In-Reply-To: <20200225041327.GE6740@magnolia>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
         <20200220155731.GU9506@magnolia> <20200220155938.GA1306@infradead.org>
         <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
         <20200220160820.GA14640@infradead.org>
         <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
         <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
         <20200225041327.GE6740@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2020-02-24 at 20:13 -0800, Darrick J. Wong wrote:
> On Mon, Feb 24, 2020 at 04:41:17PM +0000, Richard Haines wrote:
> > On Sat, 2020-02-22 at 14:49 -0500, Paul Moore wrote:
> > > On Thu, Feb 20, 2020 at 11:08 AM Christoph Hellwig <
> > > hch@infradead.org
> > > > wrote:
> > > > On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley
> > > > wrote:
> > > > > > The dquot_* routines are not generic quota code, but a
> > > > > > specific
> > > > > > implementation used by most non-XFS file systems.  So if
> > > > > > there
> > > > > > is a bug
> > > > > > it is that the security call is not in the generic dispatch
> > > > > > code.
> > > > > 
> > > > > Hmm...any reason the security hook call couldn't be taken to
> > > > > quota_quotaon()?
> > > > 
> > > > I haven't touched the quota code for a while, but yes, the
> > > > existing
> > > > calls should move to the quota_* routines in
> > > > fs/quota/quota.c.  Note
> > > > that you still need to add checks, e.g. for Q_XSETQLIM.
> > > 
> > > Who wanted to submit a patch for this?  Christoph were you
> > > planning
> > > on
> > > fixing this?  If not, Richard, do you want to give it a try?
> > > 
> > 
> > I've had a go at this and found I can (almost) get it working. I've
> > attached a sample patch just in case anyone is interested.
> 
> Almost?  Are you talking about the weird looking dentry?
> 
> > However if the calls do need to move to fs/quota/quota.c, then I
> > think
> > the xfs team are best placed to do this (I've had my playtime).
> > 
> > 
> > diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> > index 38669e827..c02cf9a63 100644
> > --- a/fs/xfs/xfs_quotaops.c
> > +++ b/fs/xfs/xfs_quotaops.c
> > @@ -14,7 +14,7 @@
> >  #include "xfs_trans.h"
> >  #include "xfs_icache.h"
> >  #include "xfs_qm.h"
> > -
> > +#include <linux/security.h>
> >  
> >  static void
> >  xfs_qm_fill_state(
> > @@ -161,11 +161,15 @@ xfs_quota_enable(
> >  	unsigned int		uflags)
> >  {
> >  	struct xfs_mount	*mp = XFS_M(sb);
> > +	struct dentry		*dentry = mp->m_super->s_root;
> >  
> >  	if (sb_rdonly(sb))
> >  		return -EROFS;
> >  	if (!XFS_IS_QUOTA_RUNNING(mp))
> >  		return -ENOSYS;
> > +	/* Emulates dquot_quota_on() Labeled correctly */
> > +	if (!security_quota_on(dentry))
> > +		return -EACCES;
> >  
> >  	return xfs_qm_scall_quotaon(mp, xfs_quota_flags(uflags));
> >  }
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 2094386af..59855d060 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/magic.h>
> >  #include <linux/fs_context.h>
> >  #include <linux/fs_parser.h>
> > +#include <linux/security.h>
> >  
> >  static const struct super_operations xfs_super_operations;
> >  
> > @@ -1507,6 +1508,22 @@ xfs_fc_fill_super(
> >  		goto out_unmount;
> >  	}
> >  
> > +	/*
> > +	 * Emulates dquot_quota_on_mount() and works, however the
> > dentry
> > +	 * is unlabeled:
> > +	 *    allow test_filesystem_t unlabeled_t:dir { quotaon };
> > +	 */
> > +	struct xfs_mount	*mpx = XFS_M(sb);
> > +	struct dentry		*dentry = mpx->m_super->s_root;
> > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > +		error = security_quota_on(dentry);
> 
> Er... I'm not sure if this is doing what you really want it
> to?  Mostly
> because I don't know what the quota security hooks are supposed to
> activate against? :)
> 
> The other three filesystems (ext4/f2fs/reiserfs) keep their quota
> files
> linked off the root directory, and dquot_quota_on_mount looks up the
> dentry for a root directory quota file and feeds that into
> security_quota_on.
> 
> This patch calls it on XFS' root directory itself (quota inodes are
> not
> linked in the directory tree at all on xfs), which I guess is the
> best
> you can do, but might not be what the security hooks is expecting.
> 
> <shrug> Apologies for my unfamiliarity.

Thanks for your comments.
What I was trying to achieve is obtain a dentry for the root directory
to call the security hooks with. My reasoning was that as xfs quotas
are 'internal' (i.e. not files as in ext4 etc.), then using this as a
reference, I could check that the SELinux 'quotaon' permission was set
on this to allow quotas to be used (if set as mount options), if not
fail the mount.
Once mounted with quotas enabled, I could then use quotactl(2) to turn
them off/on, get stats etc. providing of course the mount directory
also had the SELinux quotamod and quotaget permissions as well (hence
the hook in xfs_quota_enable()).

As I don't know the xfs code at all, I was just experimenting to test
my theory, however the xfs dev team is better placed to resolve this as
its been suggested that the calls are moved to fs/quota/quota.c.


> 
> --D
> 
> > +		if (error) {
> > +			dput(sb->s_root);
> > +			sb->s_root = NULL;
> > +			goto out_unmount;
> > +		}
> > +	}
> > +
> >  	return 0;
> >  
> >   out_filestream_unmount:
> > diff --git a/security/security.c b/security/security.c
> > index db7b574c9..ac0cc9872 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -770,6 +770,7 @@ int security_quota_on(struct dentry *dentry)
> >  {
> >  	return call_int_hook(quota_on, 0, dentry);
> >  }
> > +EXPORT_SYMBOL(security_quota_on);
> >  
> >  int security_syslog(int type)
> >  {

