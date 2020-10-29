Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C9AC55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B3D207E8
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vmsdgezo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgJ2BCM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:02:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37684 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730996AbgJ2BCH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 21:02:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0jeer012690;
        Thu, 29 Oct 2020 01:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tsY9bppPQoqz1ic0Ue+K1Q/u3ySsEKMXBYF+mHXVom0=;
 b=vmsdgezoKQSjUnxEHjo1kyWjaCdA6P6/BAMf0kJOfAPj2AGDPYW2dC+tRE//rJhC76gD
 0LYucUpWUp4I4r1VErG1tFThqpUFjsduESuBn2XkGVaedWg3T0qTpYvtYXCFGnB+T45S
 g0SBWETVZi5Ay/CaE5hJBXgpKas0GPGdylr5dcnyYRGklD6q1ZidImeLqJ927m6Qmnnk
 e6brdZt6MyqvQQzyICzGnYNf+jln7BVLbea4f8DoXoDYZscDRczh7thXcIgMQlpUqNK8
 8e+lyI5L7eo9ita0JFHMBVJ/us2svIG+NqSiW34MEXgfaVHxtge7IfFa96HfMGGvQqac Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34cc7m2b58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 01:02:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0jOs9028766;
        Thu, 29 Oct 2020 01:02:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34cx6xvx35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 01:02:03 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09T122fC032237;
        Thu, 29 Oct 2020 01:02:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 18:02:01 -0700
Date:   Wed, 28 Oct 2020 18:02:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] mkfs: enable the inode btree counter feature
Message-ID: <20201029010201.GI1061252@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375523682.880355.16796358046529188083.stgit@magnolia>
 <20201028173038.GG1611922@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028173038.GG1611922@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 01:30:38PM -0400, Brian Foster wrote:
> On Mon, Oct 26, 2020 at 04:33:56PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Teach mkfs how to enable the inode btree counter feature.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man8/mkfs.xfs.8 |   15 +++++++++++++++
> >  mkfs/xfs_mkfs.c     |   34 +++++++++++++++++++++++++++++++++-
> >  2 files changed, 48 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index 0a7858748457..1a6a5f93f0ea 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> ...
> > @@ -862,7 +871,8 @@ usage( void )
> >  {
> >  	fprintf(stderr, _("Usage: %s\n\
> >  /* blocksize */		[-b size=num]\n\
> > -/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
> > +/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
> > +			    inobtcnt=0|1]\n\
> >  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> >  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> >  			    sectsize=num\n\
> 
> Any plans to add a geometry flag so the feature state is reported on
> success? Otherwise LGTM:

<shrug> This feature doesn't enable any user-visible functionality, so I
don't see much point in doing so.

Thanks for the review!

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > @@ -1565,6 +1575,9 @@ meta_opts_parser(
> >  	case M_REFLINK:
> >  		cli->sb_feat.reflink = getnum(value, opts, subopt);
> >  		break;
> > +	case M_INOBTCNT:
> > +		cli->sb_feat.inobtcnt = getnum(value, opts, subopt);
> > +		break;
> >  	default:
> >  		return -EINVAL;
> >  	}
> > @@ -1988,6 +2001,22 @@ _("reflink not supported without CRC support\n"));
> >  			usage();
> >  		}
> >  		cli->sb_feat.reflink = false;
> > +
> > +		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
> > +			fprintf(stderr,
> > +_("inode btree counters not supported without CRC support\n"));
> > +			usage();
> > +		}
> > +		cli->sb_feat.inobtcnt = false;
> > +	}
> > +
> > +	if (!cli->sb_feat.finobt) {
> > +		if (cli->sb_feat.inobtcnt && cli_opt_set(&mopts, M_INOBTCNT)) {
> > +			fprintf(stderr,
> > +_("inode btree counters not supported without finobt support\n"));
> > +			usage();
> > +		}
> > +		cli->sb_feat.inobtcnt = false;
> >  	}
> >  
> >  	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
> > @@ -2955,6 +2984,8 @@ sb_set_features(
> >  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
> >  	if (fp->reflink)
> >  		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
> > +	if (fp->inobtcnt)
> > +		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> >  
> >  	/*
> >  	 * Sparse inode chunk support has two main inode alignment requirements.
> > @@ -3617,6 +3648,7 @@ main(
> >  			.spinodes = true,
> >  			.rmapbt = false,
> >  			.reflink = true,
> > +			.inobtcnt = false,
> >  			.parent_pointers = false,
> >  			.nodalign = false,
> >  			.nortalign = false,
> > 
> 
