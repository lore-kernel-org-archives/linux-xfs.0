Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC48C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD33B2075A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGXhyiPY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgJFPeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 11:34:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57510 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgJFPeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 11:34:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096FUCuH105652;
        Tue, 6 Oct 2020 15:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+SUrQh6AGjt6QcxlNB0FYELut79ZjXL+IhLpvtTqjM8=;
 b=NGXhyiPYQ+GcH9HAcFtWTapqdcpAe8yOtsVnUoXAhP0BDySvZhSehwevd77kAbfMvc1y
 mZkEU8zQPJhzCP85OJ7u/oe1qIYf1qa1Ro+lDTpYC/QdKXVtmlMURR/gREtqnQjWi5o2
 wY+YsODw/UjhTM02ntX/9Iig5V5rP9wjQkTnZ/4//wOs84ESLNisI8V7e66835v90RkA
 rFA4KC+WZ6Q64YqAZlmjYy6qAvlgPMk1zGlMRVg+oR1x+lkKEI2NK7lHcKD4g7XGk/eA
 IFwxkpGe3YWHESjD/Wg9L9AFazKh2xi4Wh7VXqjhyIynIbITFuWkRdfmCsot6Wffm6/G xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetavwfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 15:34:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096FUAbn054997;
        Tue, 6 Oct 2020 15:32:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y37x5eej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 15:32:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096FWCZG004258;
        Tue, 6 Oct 2020 15:32:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 08:32:12 -0700
Date:   Tue, 6 Oct 2020 08:32:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfsprogs: fix ioctl_xfs_geometry manpage naming
Message-ID: <20201006153211.GX49547@magnolia>
References: <e0379d8e-ada3-0ca7-18f8-511114d6af52@redhat.com>
 <1f0cf92b-3dc6-a380-f86c-a3286ced102d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f0cf92b-3dc6-a380-f86c-a3286ced102d@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060101
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Subject: [PATCH V2] xfsprogs: fix ioctl_xfs_geometry manpage naming

The subject line should name the old manpage, right?

On Tue, Oct 06, 2020 at 10:25:42AM -0500, Eric Sandeen wrote:
> Somehow "fsop_/FSOP_" snuck into this manpage's name, filename, and
> ioctl name.  It's not XFS_IOC_FSOP_GEOMETRY, it's XFS_IOC_FSGEOMETRY
> so change all references, including the man page name, filename, and
> references from xfsctl(3).
> 
> (the structure and flags do have the fsop_ string, which certainly
> makes this a bit confusing)
> 
> Fixes: b427c816847e ("man: create a separate GEOMETRY ioctl manpage")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: don't rename it to the wrong thing. o_O
> (fsgeometry not geometry)
> 
> Note the file rename below
> 
> Do we need to install link from the old name or can we just wing this one
> and let "apropos" et al find it ...

Up to you; if you decide to leave a breadcrumb, see ioctl_xfs_getbmap.2
for how you're (apparently?) supposed to do that in manpageland.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> similarity index 95%
> rename from man/man2/ioctl_xfs_fsop_geometry.2
> rename to man/man2/ioctl_xfs_fsgeometry.2
> index a35bbaeb..6b7c83da 100644
> --- a/man/man2/ioctl_xfs_fsop_geometry.2
> +++ b/man/man2/ioctl_xfs_fsgeometry.2
> @@ -3,18 +3,18 @@
>  .\" %%%LICENSE_START(GPLv2+_DOC_FULL)
>  .\" SPDX-License-Identifier: GPL-2.0+
>  .\" %%%LICENSE_END
> -.TH IOCTL-XFS-FSOP-GEOMETRY 2 2019-06-17 "XFS"
> +.TH IOCTL-XFS-FSGEOMETRY 2 2019-06-17 "XFS"
>  .SH NAME
> -ioctl_xfs_fsop_geometry \- report XFS filesystem layout and features 
> +ioctl_xfs_fsgeometry \- report XFS filesystem layout and features
>  .SH SYNOPSIS
>  .br
>  .B #include <xfs/xfs_fs.h>
>  .PP
> -.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geom*" arg );
> +.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY, struct xfs_fsop_geom *" arg );
>  .br
> -.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
> +.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY_V4, struct xfs_fsop_geom_v4 *" arg );
>  .br
> -.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
> +.BI "int ioctl(int " fd ", XFS_IOC_FSGEOMETRY_V1, struct xfs_fsop_geom_v1 *" arg );
>  .SH DESCRIPTION
>  Report the details of an XFS filesystem layout, features, and other descriptive items.
>  This information is conveyed in a structure of the following form:
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index dfebd12d..43c2f4eb 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -333,7 +333,7 @@ for more information.
>  .TP
>  .B XFS_IOC_FSGEOMETRY
>  See
> -.BR ioctl_xfs_fsop_geometry (2)
> +.BR ioctl_xfs_fsgeometry (2)
>  for more information.
>  
>  .TP
> @@ -393,7 +393,7 @@ as they are not of general use to applications.
>  
>  .SH SEE ALSO
>  .BR ioctl_xfs_fsgetxattr (2),
> -.BR ioctl_xfs_fsop_geometry (2),
> +.BR ioctl_xfs_fsgeometry (2),
>  .BR ioctl_xfs_fsbulkstat (2),
>  .BR ioctl_xfs_scrub_metadata (2),
>  .BR ioctl_xfs_fsinumbers (2),
> 
