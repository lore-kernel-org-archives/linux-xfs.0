Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24BCC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70766208CA
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VviRaSJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbgIJWj3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 18:39:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgIJWj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 18:39:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AMcguc179557;
        Thu, 10 Sep 2020 22:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DagsgUenF+pXeyC6nfhJH6CE8I39zoYMl79wN86KJt4=;
 b=VviRaSJTXdZd4xvKlkZKtXzjBrmhX6PhpCPtyn1VWyBBVOTGTF28baNtUr/BJPS0iZnm
 MSnVQT9Z+L45ddUWKiB1pNQxfk40TMOUrEydWnXX8kbgsp7BMpWrW2XP5V1T7OZX/5nx
 iI2TrCr/viaifr36gAt/a06+pJfe9Kfoa/VQlleuzOBNCckJzmR0H+y4xf1TfZBMBizp
 DO5GP8VKDB5ua7MP/ZWX+GL74gzqv5E5Fm04hF3Jai4v2c2ON6L0GvubMxUSEwbUTvUf
 +sZn+TCXGKGvO1giKqsE2x/11JvTHjApnUboK7L5K3fAzDPY2dilgvi/HptIqwFXokqy hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33c2mmayvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 22:39:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AMZoTO050707;
        Thu, 10 Sep 2020 22:39:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33dacnvyrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 22:39:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AMdPDT011727;
        Thu, 10 Sep 2020 22:39:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 15:39:25 -0700
Date:   Thu, 10 Sep 2020 15:39:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: deprecate the V4 format
Message-ID: <20200910223924.GP7955@magnolia>
References: <20200910182706.GD7964@magnolia>
 <20200910213951.GU12131@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910213951.GU12131@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100197
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 07:39:51AM +1000, Dave Chinner wrote:
> On Thu, Sep 10, 2020 at 11:27:06AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The V4 filesystem format contains known weaknesses in the on-disk format
> > that make metadata verification diffiult.  In addition, the format will
> > does not support dates past 2038 and will not be upgraded to do so.
> > Therefore, we should start the process of retiring the old format to
> > close off attack surfaces and to encourage users to migrate onto V5.
> > 
> > Therefore, make XFS V4 support a configurable option.  For the first
> > period it will be default Y in case some distributors want to withdraw
> > support early; for the second period it will be default N so that anyone
> > who wishes to continue support can do so; and after that, support will
> > be removed from the kernel.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Kconfig     |   18 ++++++++++++++++++
> >  fs/xfs/xfs_mount.c |   11 +++++++++++
> >  2 files changed, 29 insertions(+)
> > 
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index e685299eb3d2..db54ca9914c7 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -22,6 +22,24 @@ config XFS_FS
> >  	  system of your root partition is compiled as a module, you'll need
> >  	  to use an initial ramdisk (initrd) to boot.
> >  
> > +config XFS_SUPPORT_V4
> > +	bool "Support deprecated V4 format"
> > +	default y
> > +	help
> > +	  The V4 filesystem format lacks certain features that are supported
> > +	  by the V5 format, such as metadata checksumming, strengthened
> > +	  metadata verification, and the ability to store timestamps past the
> > +	  year 2038.  Because of this, the V4 format is deprecated.  All users
> > +	  should upgrade by backing up their files, reformatting, and restoring
> > +	  from the backup.
> > +
> > +	  This option will become default N in September 2025.  Support for the
> > +	  V4 format will be removed entirely in September 2030.  Distributors
> > +	  can say N here to withdraw support earlier.
> > +
> > +	  To continue supporting the old V4 format, say Y.
> > +	  To close off an attack surface, say N.
> > +
> >  config XFS_QUOTA
> >  	bool "XFS Quota support"
> >  	depends on XFS_FS
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index ed69c4bfda71..48c0175b9457 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -315,6 +315,17 @@ xfs_readsb(
> >  		goto release_buf;
> >  	}
> >  
> > +#ifndef CONFIG_XFS_SUPPORT_V4
> > +	/* V4 support is undergoing deprecation. */
> > +	if (!xfs_sb_version_hascrc(sbp)) {
> > +		if (loud)
> > +			xfs_warn(mp,
> > +	"Deprecated V4 format not supported by kernel.");
> > +		error = -EINVAL;
> > +		goto release_buf;
> > +	}
> > +#endif
> 
> Fine by me.
> 
> You forgot to add the V4 format to the deprecation schedule in
> Documentation/filesystems/.....
> 
> <nggggh>
> 
> (where TF has this bit of XFS documentation been moved to???)
> 
> in Documentation/admin-guide/xfs.rst.

Aha, I knew I was missing something!  I looked for that this morning but
couldn't find the file.

> -Dave.
> 
> [ Why did that file get moved rather than just linked from it's
> original spot in all the -filesystem- documentation?  Can we move it
> back, please, like all the other <filesystem>.rst files in
> Documentation/filesystems/ ? ]

I think it got moved to the administration guide since mount options and
feature discussion is an ... administrative concern?

--D

> 
> -- 
> Dave Chinner
> david@fromorbit.com
