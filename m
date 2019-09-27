Return-Path: <SRS0=ETTY=XW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA10DC4360C
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2548207FF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Sep 2019 03:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AjzCRWf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfI0DuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 23:50:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728464AbfI0DuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 23:50:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3dcht108663;
        Fri, 27 Sep 2019 03:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=adBOMPNrOq/z8hEVb4xZ+kG9EuZ7kXaG9oqzu4OfOuU=;
 b=AjzCRWf8qF9GBIMOI4Zyf5HxmWpxi+WAJQJmyc5Q5b3Xx4bLSs0LVyDRypyMOyQLAcKS
 t+kfLGBkxHzZdzEPezrZVIR/C1wDLtYKzr76q3c5Rm5rojkJv2cfbx3mgw5imN+CHYa+
 dwfU/BRTC0X4PXRLHEZGEbvtXbBbVwJ5TPqCj5SJVdfJsNFXkTQSnloMfjw0gorvZJ73
 kZQweaY7YRn8TtBoH1CPMeXwJcyjLxXtkptmi9fKLuE5OrXUrpDbBaX5EbHBogB/LPUG
 syBxuE/Jq6GkqbQBs70OSLrTcbW7Uof1m/LV3OzziRPjU6p5eBgWi24TaZ4asMvpPPsO eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2v5cgrffd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:50:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8R3hxoA083923;
        Fri, 27 Sep 2019 03:50:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2v8yjxwk0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Sep 2019 03:50:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8R3oGpq024465;
        Fri, 27 Sep 2019 03:50:16 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Sep 2019 20:50:15 -0700
Date:   Thu, 26 Sep 2019 20:50:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] misc: convert xfrog_bulkstat functions to have v5
 semantics
Message-ID: <20190927035013.GN9916@magnolia>
References: <156944714720.297379.5532805895370082740.stgit@magnolia>
 <156944716532.297379.18153066949287059883.stgit@magnolia>
 <6574b7e6-c960-0918-4dbf-447f8eb140bc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6574b7e6-c960-0918-4dbf-447f8eb140bc@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909270034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9392 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909270034
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 04:01:43PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:32 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert xfrog_bulkstat() and xfrog_bulkstat_single() to take arguments
> > using v5 bulkstat semantics and return bulkstat information in v5
> > structures.  If the v5 ioctl is not available, the xfrog wrapper should
> > use the v1 ioctl to emulate v5 behaviors.  Add flags to the xfs_fd
> > structure to constrain emulation for debugging purposes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> gawd this is a lot of frobnication of ioctl results but I ... guess there's
> no way around it.
> 
> Presumably we want all callers to use v5 for the bigger fields, right,
> so it's not like we can just leave some old v1 callers as-is if they don't
> need new fields ....

Well... in theory we could leave them, but eventually we'll either want
new functionality or we'll want to deprecate the old ones.

> > ---
> >  fsr/xfs_fsr.c      |   64 ++++++--
> >  io/open.c          |   27 ++-
> >  io/swapext.c       |    9 +
> >  libfrog/bulkstat.c |  431 +++++++++++++++++++++++++++++++++++++++++++++++++---
> >  libfrog/bulkstat.h |   14 +-
> >  libfrog/fsgeom.h   |    9 +
> >  quota/quot.c       |   29 ++-
> >  scrub/inodes.c     |   39 +++--
> >  scrub/inodes.h     |    2 
> >  scrub/phase3.c     |    6 -
> >  scrub/phase5.c     |    8 -
> >  scrub/phase6.c     |    2 
> >  scrub/unicrash.c   |    6 -
> >  scrub/unicrash.h   |    4 
> >  spaceman/health.c  |   33 ++--
> >  15 files changed, 572 insertions(+), 111 deletions(-)
> > 
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index a53eb924..af5d6169 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
<snip>
> > @@ -623,7 +643,14 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
> >  			     (p->bs_extents < 2))
> >  				continue;
> >  
> > -			fd = jdm_open(fshandlep, p, O_RDWR|O_DIRECT);
> > +			ret = xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
> 
> ew.  In the long run, I guess I'd rather convert these to take v5 when needed
> but alas.  I guess that has xfsdump implications too.  :(

Worse -- these are public libhandle functions, so we'll have to upgrade
its interfaces very carefully.

> > +			if (ret) {
> > +				fsrprintf(_("bstat conversion error: %s\n"),
> > +						strerror(ret));
> > +				continue;
> > +			}
> 
> ... but then we wouldn't potential fail on bstats w/ big numbers :(
> 
> Oh well, another day.
> 
> > +
> > +			fd = jdm_open(fshandlep, &bs1, O_RDWR | O_DIRECT);
> >  			if (fd < 0) {
> >  				/* This probably means the file was
> >  				 * removed while in progress of handling

<snip>

> > diff --git a/scrub/inodes.c b/scrub/inodes.c
> > index 580a845e..2112c9d1 100644
> > --- a/scrub/inodes.c
> > +++ b/scrub/inodes.c

<snip>

> > @@ -135,10 +135,12 @@ xfs_iterate_inodes_range(
> >  						errbuf, DESCR_BUFSZ));
> >  		}
> >  
> > -		xfs_iterate_inodes_range_check(ctx, &inogrp, bstat);
> > +		xfs_iterate_inodes_range_check(ctx, &inogrp, breq->bulkstat);
> >  
> >  		/* Iterate all the inodes. */
> > -		for (i = 0, bs = bstat; i < inogrp.xi_alloccount; i++, bs++) {
> > +		for (i = 0, bs = breq->bulkstat;
> > +		     i < inogrp.xi_alloccount;
> > +		     i++, bs++) {
> >  			if (bs->bs_ino > last_ino)
> >  				goto out;
> 
> leaks the breq here, no?
> 
> >  
> > @@ -184,6 +186,7 @@ _("Changed too many times during scan; giving up."));
> >  		str_liberror(ctx, error, descr);
> >  		moveon = false;
> >  	}
> > +	free(breq);
> >  out:
> 
> maybe free should be here?

Ugh, I think I mismerged that.  Fixed. :(

--D

> > diff --git a/scrub/inodes.h b/scrub/inodes.h
> > index 631848c3..3341c6d9 100644
> > --- a/scrub/inodes.h
> > +++ b/scrub/inodes.h
> > @@ -7,7 +7,7 @@
> >  #define XFS_SCRUB_INODES_H_
> >  
> >  typedef int (*xfs_inode_iter_fn)(struct scrub_ctx *ctx,
> > -		struct xfs_handle *handle, struct xfs_bstat *bs, void *arg);
> > +		struct xfs_handle *handle, struct xfs_bulkstat *bs, void *arg);
> >  
> >  #define XFS_ITERATE_INODES_ABORT	(-1)
> >  bool xfs_scan_all_inodes(struct scrub_ctx *ctx, xfs_inode_iter_fn fn,
> > diff --git a/scrub/phase3.c b/scrub/phase3.c
> > index 81c64cd1..a32d1ced 100644
> > --- a/scrub/phase3.c
> > +++ b/scrub/phase3.c
> > @@ -30,7 +30,7 @@ xfs_scrub_fd(
> >  	struct scrub_ctx	*ctx,
> >  	bool			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
> >  				      uint32_t gen, struct xfs_action_list *a),
> > -	struct xfs_bstat	*bs,
> > +	struct xfs_bulkstat	*bs,
> >  	struct xfs_action_list	*alist)
> >  {
> >  	return fn(ctx, bs->bs_ino, bs->bs_gen, alist);
> > @@ -45,7 +45,7 @@ struct scrub_inode_ctx {
> >  static void
> >  xfs_scrub_inode_vfs_error(
> >  	struct scrub_ctx	*ctx,
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> >  	char			descr[DESCR_BUFSZ];
> >  	xfs_agnumber_t		agno;
> > @@ -65,7 +65,7 @@ static int
> >  xfs_scrub_inode(
> >  	struct scrub_ctx	*ctx,
> >  	struct xfs_handle	*handle,
> > -	struct xfs_bstat	*bstat,
> > +	struct xfs_bulkstat	*bstat,
> >  	void			*arg)
> >  {
> >  	struct xfs_action_list	alist;
> > diff --git a/scrub/phase5.c b/scrub/phase5.c
> > index 3ff34251..99cd51b2 100644
> > --- a/scrub/phase5.c
> > +++ b/scrub/phase5.c
> > @@ -80,7 +80,7 @@ xfs_scrub_scan_dirents(
> >  	struct scrub_ctx	*ctx,
> >  	const char		*descr,
> >  	int			*fd,
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> >  	struct unicrash		*uc = NULL;
> >  	DIR			*dir;
> > @@ -140,7 +140,7 @@ xfs_scrub_scan_fhandle_namespace_xattrs(
> >  	struct scrub_ctx		*ctx,
> >  	const char			*descr,
> >  	struct xfs_handle		*handle,
> > -	struct xfs_bstat		*bstat,
> > +	struct xfs_bulkstat		*bstat,
> >  	const struct attrns_decode	*attr_ns)
> >  {
> >  	struct attrlist_cursor		cur;
> > @@ -200,7 +200,7 @@ xfs_scrub_scan_fhandle_xattrs(
> >  	struct scrub_ctx		*ctx,
> >  	const char			*descr,
> >  	struct xfs_handle		*handle,
> > -	struct xfs_bstat		*bstat)
> > +	struct xfs_bulkstat		*bstat)
> >  {
> >  	const struct attrns_decode	*ns;
> >  	bool				moveon = true;
> > @@ -228,7 +228,7 @@ static int
> >  xfs_scrub_connections(
> >  	struct scrub_ctx	*ctx,
> >  	struct xfs_handle	*handle,
> > -	struct xfs_bstat	*bstat,
> > +	struct xfs_bulkstat	*bstat,
> >  	void			*arg)
> >  {
> >  	bool			*pmoveon = arg;
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 506e75d2..b41f90e0 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -172,7 +172,7 @@ static int
> >  xfs_report_verify_inode(
> >  	struct scrub_ctx		*ctx,
> >  	struct xfs_handle		*handle,
> > -	struct xfs_bstat		*bstat,
> > +	struct xfs_bulkstat		*bstat,
> >  	void				*arg)
> >  {
> >  	char				descr[DESCR_BUFSZ];
> > diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> > index 17e8f34f..b02c5658 100644
> > --- a/scrub/unicrash.c
> > +++ b/scrub/unicrash.c
> > @@ -432,7 +432,7 @@ unicrash_init(
> >   */
> >  static bool
> >  is_only_root_writable(
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> >  	if (bstat->bs_uid != 0 || bstat->bs_gid != 0)
> >  		return false;
> > @@ -444,7 +444,7 @@ bool
> >  unicrash_dir_init(
> >  	struct unicrash		**ucp,
> >  	struct scrub_ctx	*ctx,
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> >  	/*
> >  	 * Assume 64 bytes per dentry, clamp buckets between 16 and 64k.
> > @@ -459,7 +459,7 @@ bool
> >  unicrash_xattr_init(
> >  	struct unicrash		**ucp,
> >  	struct scrub_ctx	*ctx,
> > -	struct xfs_bstat	*bstat)
> > +	struct xfs_bulkstat	*bstat)
> >  {
> >  	/* Assume 16 attributes per extent for lack of a better idea. */
> >  	return unicrash_init(ucp, ctx, false, 16 * (1 + bstat->bs_aextents),
> > diff --git a/scrub/unicrash.h b/scrub/unicrash.h
> > index fb8f5f72..feb9cc86 100644
> > --- a/scrub/unicrash.h
> > +++ b/scrub/unicrash.h
> > @@ -14,9 +14,9 @@ struct unicrash;
> >  struct dirent;
> >  
> >  bool unicrash_dir_init(struct unicrash **ucp, struct scrub_ctx *ctx,
> > -		struct xfs_bstat *bstat);
> > +		struct xfs_bulkstat *bstat);
> >  bool unicrash_xattr_init(struct unicrash **ucp, struct scrub_ctx *ctx,
> > -		struct xfs_bstat *bstat);
> > +		struct xfs_bulkstat *bstat);
> >  bool unicrash_fs_label_init(struct unicrash **ucp, struct scrub_ctx *ctx);
> >  void unicrash_free(struct unicrash *uc);
> >  bool unicrash_check_dir_name(struct unicrash *uc, const char *descr,
> > diff --git a/spaceman/health.c b/spaceman/health.c
> > index a8bd3f3e..b195a229 100644
> > --- a/spaceman/health.c
> > +++ b/spaceman/health.c
> > @@ -208,7 +208,7 @@ report_inode_health(
> >  	unsigned long long	ino,
> >  	const char		*descr)
> >  {
> > -	struct xfs_bstat	bs;
> > +	struct xfs_bulkstat	bs;
> >  	char			d[256];
> >  	int			ret;
> >  
> > @@ -217,7 +217,7 @@ report_inode_health(
> >  		descr = d;
> >  	}
> >  
> > -	ret = xfrog_bulkstat_single(&file->xfd, ino, &bs);
> > +	ret = xfrog_bulkstat_single(&file->xfd, ino, 0, &bs);
> >  	if (ret) {
> >  		errno = ret;
> >  		perror(descr);
> > @@ -266,11 +266,10 @@ static int
> >  report_bulkstat_health(
> >  	xfs_agnumber_t		agno)
> >  {
> > -	struct xfs_bstat	bstat[BULKSTAT_NR];
> > +	struct xfs_bulkstat_req	*breq;
> >  	char			descr[256];
> >  	uint64_t		startino = 0;
> >  	uint64_t		lastino = -1ULL;
> > -	uint32_t		ocount;
> >  	uint32_t		i;
> >  	int			error;
> >  
> > @@ -279,26 +278,34 @@ report_bulkstat_health(
> >  		lastino = cvt_agino_to_ino(&file->xfd, agno + 1, 0) - 1;
> >  	}
> >  
> > +	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, startino);
> > +	if (!breq) {
> > +		perror("bulk alloc req");
> > +		exitcode = 1;
> > +		return 1;
> > +	}
> > +
> >  	do {
> > -		error = xfrog_bulkstat(&file->xfd, &startino, BULKSTAT_NR,
> > -				bstat, &ocount);
> > +		error = xfrog_bulkstat(&file->xfd, breq);
> >  		if (error)
> >  			break;
> > -		for (i = 0; i < ocount; i++) {
> > -			if (bstat[i].bs_ino > lastino)
> > +		for (i = 0; i < breq->hdr.ocount; i++) {
> > +			if (breq->bulkstat[i].bs_ino > lastino)
> >  				goto out;
> > -			snprintf(descr, sizeof(descr) - 1, _("inode %llu"),
> > -					bstat[i].bs_ino);
> > -			report_sick(descr, inode_flags, bstat[i].bs_sick,
> > -					bstat[i].bs_checked);
> > +			snprintf(descr, sizeof(descr) - 1, _("inode %"PRIu64),
> > +					breq->bulkstat[i].bs_ino);
> > +			report_sick(descr, inode_flags,
> > +					breq->bulkstat[i].bs_sick,
> > +					breq->bulkstat[i].bs_checked);
> >  		}
> > -	} while (ocount > 0);
> > +	} while (breq->hdr.ocount > 0);
> >  
> >  	if (error) {
> >  		errno = error;
> >  		perror("bulkstat");
> >  	}
> >  out:
> > +	free(breq);
> >  	return error;
> >  }
> >  
> > 
