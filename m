Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72F8C35DF3
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A96FD24656
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oWONewEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBYEOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 23:14:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYEOu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 23:14:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4DcT1062880;
        Tue, 25 Feb 2020 04:13:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Chkr7AdsoEVQRYjiT9vzBx7CnTRVBZCgy/kHpKRgyUQ=;
 b=oWONewExLFzSDJ0NeAJSz3xsM1oq40+pMjVpHRTfmDRkx1YUwjdBUFKmsHHzPvKWQf6f
 O2SHO1v3alxob5LEJ/NoEKkjweX5U+qMErzHt8R1AYC6/mvIWH9lHdeR04yKkTJvzlLM
 7okqMSfReTHKoolsCQ+4oVRqfWIUn1RRM3BOyhwpCOH4O6ag/FXLx+yAGSc1LK4X4HIV
 UfHQ+qupH3UrABLqPXQ8lUfrVemVPwxUinRYSeLEIqFMgxPBwNTWkzUFejKAr9OSvR3S
 hOxEqtKuJ2qDKPLvrEpN3jmx+XikoqYuCLmq1NuaBCGSw3YqQtMOantGIyLnzvihbhff yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4qrw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:13:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4C6Rk021118;
        Tue, 25 Feb 2020 04:13:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ybdsjc2u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:13:33 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P4DT46029220;
        Tue, 25 Feb 2020 04:13:31 GMT
Received: from localhost (/10.159.137.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 20:13:28 -0800
Date:   Mon, 24 Feb 2020 20:13:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Richard Haines <richard_c_haines@btinternet.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
Message-ID: <20200225041327.GE6740@magnolia>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia>
 <20200220155938.GA1306@infradead.org>
 <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
 <20200220160820.GA14640@infradead.org>
 <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
 <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:41:17PM +0000, Richard Haines wrote:
> On Sat, 2020-02-22 at 14:49 -0500, Paul Moore wrote:
> > On Thu, Feb 20, 2020 at 11:08 AM Christoph Hellwig <hch@infradead.org
> > > wrote:
> > > On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley wrote:
> > > > > The dquot_* routines are not generic quota code, but a specific
> > > > > implementation used by most non-XFS file systems.  So if there
> > > > > is a bug
> > > > > it is that the security call is not in the generic dispatch
> > > > > code.
> > > > 
> > > > Hmm...any reason the security hook call couldn't be taken to
> > > > quota_quotaon()?
> > > 
> > > I haven't touched the quota code for a while, but yes, the existing
> > > calls should move to the quota_* routines in
> > > fs/quota/quota.c.  Note
> > > that you still need to add checks, e.g. for Q_XSETQLIM.
> > 
> > Who wanted to submit a patch for this?  Christoph were you planning
> > on
> > fixing this?  If not, Richard, do you want to give it a try?
> > 
> 
> I've had a go at this and found I can (almost) get it working. I've
> attached a sample patch just in case anyone is interested.

Almost?  Are you talking about the weird looking dentry?

> However if the calls do need to move to fs/quota/quota.c, then I think
> the xfs team are best placed to do this (I've had my playtime).
> 
> 

> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index 38669e827..c02cf9a63 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -14,7 +14,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_icache.h"
>  #include "xfs_qm.h"
> -
> +#include <linux/security.h>
>  
>  static void
>  xfs_qm_fill_state(
> @@ -161,11 +161,15 @@ xfs_quota_enable(
>  	unsigned int		uflags)
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
> +	struct dentry		*dentry = mp->m_super->s_root;
>  
>  	if (sb_rdonly(sb))
>  		return -EROFS;
>  	if (!XFS_IS_QUOTA_RUNNING(mp))
>  		return -ENOSYS;
> +	/* Emulates dquot_quota_on() Labeled correctly */
> +	if (!security_quota_on(dentry))
> +		return -EACCES;
>  
>  	return xfs_qm_scall_quotaon(mp, xfs_quota_flags(uflags));
>  }
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2094386af..59855d060 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -39,6 +39,7 @@
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
> +#include <linux/security.h>
>  
>  static const struct super_operations xfs_super_operations;
>  
> @@ -1507,6 +1508,22 @@ xfs_fc_fill_super(
>  		goto out_unmount;
>  	}
>  
> +	/*
> +	 * Emulates dquot_quota_on_mount() and works, however the dentry
> +	 * is unlabeled:
> +	 *    allow test_filesystem_t unlabeled_t:dir { quotaon };
> +	 */
> +	struct xfs_mount	*mpx = XFS_M(sb);
> +	struct dentry		*dentry = mpx->m_super->s_root;
> +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> +		error = security_quota_on(dentry);

Er... I'm not sure if this is doing what you really want it to?  Mostly
because I don't know what the quota security hooks are supposed to
activate against? :)

The other three filesystems (ext4/f2fs/reiserfs) keep their quota files
linked off the root directory, and dquot_quota_on_mount looks up the
dentry for a root directory quota file and feeds that into
security_quota_on.

This patch calls it on XFS' root directory itself (quota inodes are not
linked in the directory tree at all on xfs), which I guess is the best
you can do, but might not be what the security hooks is expecting.

<shrug> Apologies for my unfamiliarity.

--D

> +		if (error) {
> +			dput(sb->s_root);
> +			sb->s_root = NULL;
> +			goto out_unmount;
> +		}
> +	}
> +
>  	return 0;
>  
>   out_filestream_unmount:
> diff --git a/security/security.c b/security/security.c
> index db7b574c9..ac0cc9872 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -770,6 +770,7 @@ int security_quota_on(struct dentry *dentry)
>  {
>  	return call_int_hook(quota_on, 0, dentry);
>  }
> +EXPORT_SYMBOL(security_quota_on);
>  
>  int security_syslog(int type)
>  {

