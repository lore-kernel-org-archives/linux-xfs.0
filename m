Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FBDC388F9
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 15:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C26D22202
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 15:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPNh42V4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799892AbgJ0Pd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:33:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1799881AbgJ0Pdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 11:33:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFSjVD088283;
        Tue, 27 Oct 2020 15:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bE7fxRQFiczhfDNQ1V61FAet1B+QFOtXzioUfyMatK8=;
 b=UPNh42V4UwWazVwv+zt0OBErkztfr0VzT+g252DQ/C0Ay2EXG6eD23Gb5+2XAc9MY7nv
 dDQ53mzhnmeBD0J4GDvph/cgAy3sikfRy+gglK355NiIWslvw9mUBLhQqGN7hQEPoRGK
 QM4rrCPDMbw61JFMz2XUHY1fkRpT9WiWwKS97vSwOX5DqLvmsp/kGO+yrAJSZdl33bWY
 aT7QF273/6ITfUtcAeraZQliNtLQdIF7wbi76ozY5Ac9hvJio5DUbQK7I/rKn7odyOs3
 Vq7F4yAo73N8T135Jm/crvNXfF0F4gClBbkFT7n1bqSsp6OoTSoM3Q7DK/1X13rOvSPh 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm40bpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 15:33:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFUj6T160349;
        Tue, 27 Oct 2020 15:33:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwumhgg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 15:33:51 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RFXoWD014203;
        Tue, 27 Oct 2020 15:33:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 08:33:50 -0700
Date:   Tue, 27 Oct 2020 08:33:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: remove unnecessary parameter from
 scrub_scan_estimate_blocks
Message-ID: <20201027153350.GC853509@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375512596.879169.13683347692314634844.stgit@magnolia>
 <0b7fc968-8820-15c0-b84b-d430fddec3df@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b7fc968-8820-15c0-b84b-d430fddec3df@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=5 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270097
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 10:35:46PM -0700, Allison Henderson wrote:
> 
> 
> On 10/26/20 4:32 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The only caller that cares about the file counts uses it to compute the
> > number of files used, so return that and save a parameter.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >   scrub/fscounters.c |    8 +++-----
> >   scrub/fscounters.h |    2 +-
> >   scrub/phase6.c     |    7 +++----
> >   scrub/phase7.c     |    5 +----
> >   4 files changed, 8 insertions(+), 14 deletions(-)
> > 
> > 
> > diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> > index e9901fcdf6df..9a240d49477b 100644
> > --- a/scrub/fscounters.c
> > +++ b/scrub/fscounters.c
> > @@ -116,7 +116,7 @@ scrub_count_all_inodes(
> >   }
> >   /*
> > - * Estimate the number of blocks and inodes in the filesystem.  Returns 0
> > + * Estimate the number of blocks and used inodes in the filesystem.  Returns 0
> >    * or a positive error number.
> >    */
> >   int
> > @@ -126,8 +126,7 @@ scrub_scan_estimate_blocks(
> >   	unsigned long long		*d_bfree,
> >   	unsigned long long		*r_blocks,
> >   	unsigned long long		*r_bfree,
> > -	unsigned long long		*f_files,
> > -	unsigned long long		*f_free)
> > +	unsigned long long		*f_files_used)
> >   {
> >   	struct xfs_fsop_counts		fc;
> >   	int				error;
> > @@ -141,8 +140,7 @@ scrub_scan_estimate_blocks(
> >   	*d_bfree = fc.freedata;
> >   	*r_blocks = ctx->mnt.fsgeom.rtblocks;
> >   	*r_bfree = fc.freertx;
> > -	*f_files = fc.allocino;
> > -	*f_free = fc.freeino;
> > +	*f_files_used = fc.allocino - fc.freeino;
> Just a nit, I think I might have put in:
> 	if(f_files_used)
> 		*f_files_used = fc.allocino - fc.freeino;
> 
> That way calling functions that don't care can just pass NULL, instead of
> declaring a "dontcare" variable that has no other use.  Though I suppose
> none of the other variables do that.

<shrug> There's only two callers, and they both pass a pointer, so I
didn't bother...

--D

> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> Allison
> >   	return 0;
> >   }
> > diff --git a/scrub/fscounters.h b/scrub/fscounters.h
> > index 1fae58a6b287..13bd9967f004 100644
> > --- a/scrub/fscounters.h
> > +++ b/scrub/fscounters.h
> > @@ -9,7 +9,7 @@
> >   int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
> >   		unsigned long long *d_blocks, unsigned long long *d_bfree,
> >   		unsigned long long *r_blocks, unsigned long long *r_bfree,
> > -		unsigned long long *f_files, unsigned long long *f_free);
> > +		unsigned long long *f_files_used);
> >   int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
> >   #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 8d976732d8e1..87828b60fbed 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -719,12 +719,11 @@ phase6_estimate(
> >   	unsigned long long	d_bfree;
> >   	unsigned long long	r_blocks;
> >   	unsigned long long	r_bfree;
> > -	unsigned long long	f_files;
> > -	unsigned long long	f_free;
> > +	unsigned long long	dontcare;
> >   	int			ret;
> > -	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
> > -				&r_blocks, &r_bfree, &f_files, &f_free);
> > +	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
> > +			&r_bfree, &dontcare);
> >   	if (ret) {
> >   		str_liberror(ctx, ret, _("estimating verify work"));
> >   		return ret;
> > diff --git a/scrub/phase7.c b/scrub/phase7.c
> > index 96876f7c0596..bc652ab6f44a 100644
> > --- a/scrub/phase7.c
> > +++ b/scrub/phase7.c
> > @@ -111,8 +111,6 @@ phase7_func(
> >   	unsigned long long	d_bfree;
> >   	unsigned long long	r_blocks;
> >   	unsigned long long	r_bfree;
> > -	unsigned long long	f_files;
> > -	unsigned long long	f_free;
> >   	bool			complain;
> >   	int			ip;
> >   	int			error;
> > @@ -160,7 +158,7 @@ phase7_func(
> >   	}
> >   	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
> > -			&r_bfree, &f_files, &f_free);
> > +			&r_bfree, &used_files);
> >   	if (error) {
> >   		str_liberror(ctx, error, _("estimating verify work"));
> >   		return error;
> > @@ -177,7 +175,6 @@ phase7_func(
> >   	/* Report on what we found. */
> >   	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
> >   	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
> > -	used_files = f_files - f_free;
> >   	stat_data = totalcount.dbytes;
> >   	stat_rt = totalcount.rbytes;
> > 
