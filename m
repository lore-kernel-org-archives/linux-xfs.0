Return-Path: <SRS0=NqjT=CT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8E2C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED0C208CA
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:41:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dts9WiLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgIJWl5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 18:41:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33924 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgIJWly (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 18:41:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AMdKD9179766;
        Thu, 10 Sep 2020 22:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hKsXo33XRE6p1NpnWiDQSZSTNrPy1X6Ayoqc7WkYmM4=;
 b=Dts9WiLMl3nBQQVx+dK+nxnACxNtoZjc5jdek/QlLIYECZc7eaaoJKqRv/c9YiRqrSLf
 6x8Q+NE8FQJ1ZlzX+nWtqN8Tp+RJ27xUDc57Gr3D3Xg5hVf1uhGrJCvIKqSyCagv8XHl
 sw70vQGkyVxt0fQZHKt6solZt5eu5Sp5RzbtIthctPMZ7xfz6e/oIJ/o8w1Q61G0+L0J
 L2rqNcsmgM5kGJ5+amRXZJMn0aoMqln5oUHcT/ZYQDNFtpWuaSQxsAriqffNP2Yb0Dg0
 9LLA5ofzn3YUcUbK2w7DiASZ4K9rHjWLsvtXtj7MaM0PMdbNcjS4taHYlL4jZYGq7ctK mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mmb03h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 22:41:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AMZ8rg119146;
        Thu, 10 Sep 2020 22:39:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmkay6cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 22:39:51 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AMdoXZ026020;
        Thu, 10 Sep 2020 22:39:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 15:39:50 -0700
Date:   Thu, 10 Sep 2020 15:39:49 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: deprecate the V4 format
Message-ID: <20200910223949.GQ7955@magnolia>
References: <20200910182706.GD7964@magnolia>
 <f1cb76c7-9a23-36ab-4a25-a3bd344f77db@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1cb76c7-9a23-36ab-4a25-a3bd344f77db@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100197
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

On Thu, Sep 10, 2020 at 03:47:21PM -0500, Eric Sandeen wrote:
> On 9/10/20 1:27 PM, Darrick J. Wong wrote:
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
> 
> As Arekm pointed out, nobody outside of our clique knows what "V4" and "V5" means.
> 
> (there is no mention of such things in the mkfs.xfs(8) or xfs(5), for example)
> 
> admin-facing statements should probably reference CRC capability, not "V4/5"

Ok.  "Deprecated V4 format (crc=0) not supported by kernel." then.

--D

> -Eric
> 
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
> > +
> >  	/*
> >  	 * We must be able to do sector-sized and sector-aligned IO.
> >  	 */
> > 
