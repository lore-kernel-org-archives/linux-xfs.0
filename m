Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE567C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54AA22261
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:39:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tux0GpaY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbgJIPjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 11:39:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389165AbgJIPjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 11:39:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099Fdi9U015671;
        Fri, 9 Oct 2020 15:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=RWvShas9CDcX0ny4kauU1Q9IUOWYNqJCpI7Bif0YlDE=;
 b=tux0GpaYRYvlvBTjn//8Pyl3KXLdPI96sjyuNj6EEuaoRs465THlxpod6jst7OgPZ/S+
 8oyA8tnmQtHbeklx0UNSrXBCL7/9qdG+TuU+8i5O8S6EVlRB0pfo8D/iqdkEt5gbea2f
 b1r/cgNkk86KhZptuL3NsFbWvlkr2q4r6qXrbwIKPWjlHqWH8ASEQIUr8cJRH2eLNwQZ
 Z3/VxgCLTuFebEmatHuvwELB5tUXPEor+KvfnL+CUEdtFvWA/pGo4d87bNcbiNXykdJl
 ylCuYTQbFPAnP6OqWMnwCTtJT2YEGAGY/oS9x14GM9MPeOFxR90EIasLIJmN2/vusdMu Zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3429jmm8du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 09 Oct 2020 15:39:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099FZJD9076999;
        Fri, 9 Oct 2020 15:37:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3429kjh439-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Oct 2020 15:37:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 099FbgIq024618;
        Fri, 9 Oct 2020 15:37:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Oct 2020 08:37:42 -0700
Date:   Fri, 9 Oct 2020 08:37:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <20201009153741.GT6540@magnolia>
References: <20201005163737.GE49547@magnolia>
 <20201009111812.GA769470@bfoster>
 <20201009113225.GB769470@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201009113225.GB769470@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=5 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=5
 clxscore=1015 phishscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010090117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 07:32:25AM -0400, Brian Foster wrote:
> On Fri, Oct 09, 2020 at 07:18:12AM -0400, Brian Foster wrote:
> > On Mon, Oct 05, 2020 at 09:37:37AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > The function scrub_scan_estimate_blocks naÃ¯vely uses the statvfs counts
> > > to estimate the size and free blocks on the data volume.  Unfortunately,
> > > it fails to account for the fact that statvfs can return the size and
> > > free counts for the realtime volume if the root directory has the
> > > rtinherit flag set, which leads to phase 7 reporting totally absurd
> > > quantities.
> > > 
> > > Eric pointed out a further problem with statvfs, which is that the file
> > > counts are clamped to the current user's project quota inode limits.
> > > Therefore, we must not use statvfs for querying the filesystem summary
> > > counts.
> > > 
> > > The XFS_IOC_FSCOUNTS ioctl returns all the data we need, so use that
> > > instead.
> > > 
> > > Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > > v2: drop statvfs entirely
> > > ---
> > 
> > This doesn't seem to apply to for-next..?
> > 
> 
> Oops, never mind. Wrong tree...
> 
> 
> > Brian
> > 
> > >  scrub/fscounters.c |   27 ++++-----------------------
> > >  1 file changed, 4 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> > > index f9d64f8c008f..e9901fcdf6df 100644
> > > --- a/scrub/fscounters.c
> > > +++ b/scrub/fscounters.c
> > > @@ -130,38 +130,19 @@ scrub_scan_estimate_blocks(
> > >  	unsigned long long		*f_free)
> > >  {
> > >  	struct xfs_fsop_counts		fc;
> > > -	struct xfs_fsop_resblks		rb;
> > > -	struct statvfs			sfs;
> > >  	int				error;
> > >  
> > > -	/* Grab the fstatvfs counters, since it has to report accurately. */
> > > -	error = fstatvfs(ctx->mnt.fd, &sfs);
> > > -	if (error)
> > > -		return errno;
> > > -
> > >  	/* Fetch the filesystem counters. */
> > >  	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
> > >  	if (error)
> > >  		return errno;
> > >  
> > > -	/*
> > > -	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
> > > -	 * blocks back to the free data counts.
> > > -	 */
> > > -	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
> > > -	if (error)
> > > -		return errno;
> > > -
> > > -	sfs.f_bfree += rb.resblks_avail;
> > > -
> > > -	*d_blocks = sfs.f_blocks;
> > > -	if (ctx->mnt.fsgeom.logstart > 0)
> > > -		*d_blocks += ctx->mnt.fsgeom.logblocks;
> > > -	*d_bfree = sfs.f_bfree;
> > > +	*d_blocks = ctx->mnt.fsgeom.datablocks;
> > > +	*d_bfree = fc.freedata;
> > >  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
> > >  	*r_bfree = fc.freertx;
> > > -	*f_files = sfs.f_files;
> > > -	*f_free = sfs.f_ffree;
> > > +	*f_files = fc.allocino;
> > > +	*f_free = fc.freeino;
> > >  
> 
> Aren't the free inode counters semantically different between statvfs
> and this ioctl? I thought stat had some logic to effectively show free
> data blocks as free inodes,

It does.

> whereas the ioctl looks like it just reads
> our internal counter (which IIRC is a subset of physically allocated
> inode chunks). Do we care about that semantic here either way?

Nope.  The one caller that cares (scrub/phase7.c) only wants to know the
number of inodes in use (f_free - f_files), which is unaffected by the
logic in xfs_fs_statfs.

I suppose I could trim the parameter list even further to return only
the file count...

--D

> Brian
> 
> > >  	return 0;
> > >  }
> > > 
> > 
> 
