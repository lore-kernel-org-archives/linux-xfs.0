Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11FAC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73FB221D6C
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 16:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w/3+NHzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgIKQDi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:03:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55996 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIKQCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 12:02:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BG07kn107571;
        Fri, 11 Sep 2020 16:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=V6ke8Cq1n6wcFqEzpKijYDVb/Pqi0IR4aKLJYOVKwRY=;
 b=w/3+NHzin16yboHBWp0W5dFWZDaCVi24cKJ9vyoyct3kdhFqJ0oY4U7P1TdcAzwGYCUB
 ErFGGGs8HZ7Vyi/XgD8Fto1fXgSSj6jyOUMh4C2PvJU54sXGBMq0DC6DQcCKVASEOAI0
 PbVokvlwwlf0OV0x+Ah9uEQfwLzCv5W3hVsjGdjcR0kc/VtETBFXjZKIXdrZBFktD5OT
 T36Hfk7c6c2c686Px6lGOvEg7eJaH3sVFs9yecRZvhR5iTMGNrQEes83S6KsZrVQCC8P
 NfQC/Ux0ANrdVbRz0i7+a0o1CAKQh8nTQ0NQYGuWrJrHwotZrjPOgbI8FPa4i9PlSCAb Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33c3aneyv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 16:02:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BFxjC0010371;
        Fri, 11 Sep 2020 16:02:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33dacq5wgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 16:02:24 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08BG2Nh8024822;
        Fri, 11 Sep 2020 16:02:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 09:02:23 -0700
Date:   Fri, 11 Sep 2020 09:02:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfs: deprecate the V4 format
Message-ID: <20200911160222.GF7964@magnolia>
References: <20200910224842.GR7955@magnolia>
 <20200911113158.GA1194939@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911113158.GA1194939@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 07:31:58AM -0400, Brian Foster wrote:
> On Thu, Sep 10, 2020 at 03:48:42PM -0700, Darrick J. Wong wrote:
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
> > v2: define what is a V4 filesystem, update the administrator guide
> > ---
> 
> Seems reasonable to me...
> 
> >  Documentation/admin-guide/xfs.rst |   20 ++++++++++++++++++++
> >  fs/xfs/Kconfig                    |   23 +++++++++++++++++++++++
> >  fs/xfs/xfs_mount.c                |   11 +++++++++++
> >  3 files changed, 54 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> > index f461d6c33534..68d69733a1df 100644
> > --- a/Documentation/admin-guide/xfs.rst
> > +++ b/Documentation/admin-guide/xfs.rst
> > @@ -210,6 +210,25 @@ When mounting an XFS filesystem, the following options are accepted.
> >  	inconsistent namespace presentation during or after a
> >  	failover event.
> >  
> > +Deprecation of V4 Format
> > +========================
> > +
> > +The V4 filesystem format lacks certain features that are supported by
> > +the V5 format, such as metadata checksumming, strengthened metadata
> > +verification, and the ability to store timestamps past the year 2038.
> > +Because of this, the V4 format is deprecated.  All users should upgrade
> > +by backing up their files, reformatting, and restoring from the backup.
> > +
> > +Administrators and users can detect a V4 filesystem by running xfs_info
> > +against a filesystem mountpoint and checking for a string beginning with
> > +"crc=".  If the string "crc=0" is found, or no "crc=" string is found,
> > +the filesystem is a V4 filesystem.
> > +
> > +The deprecation will take place in two parts.  Support for mounting V4
> > +filesystems can now be disabled at kernel build time via Kconfig option.
> > +The option will default to yes until September 2025, at which time it
> > +will be changed to default to no.  In September 2030, support will be
> > +removed from the codebase entirely.
> >  
> >  Deprecated Mount Options
> >  ========================
> > @@ -217,6 +236,7 @@ Deprecated Mount Options
> >  ===========================     ================
> >    Name				Removal Schedule
> >  ===========================     ================
> > +Mounting with V4 filesystem     September 2030
> >  ===========================     ================
> >  
> >  
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index e685299eb3d2..5970d0f77db9 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -22,6 +22,29 @@ config XFS_FS
> >  	  system of your root partition is compiled as a module, you'll need
> >  	  to use an initial ramdisk (initrd) to boot.
> >  
> > +config XFS_SUPPORT_V4
> > +	bool "Support deprecated V4 (crc=0) format"
> > +	default y
> > +	help
> > +	  The V4 filesystem format lacks certain features that are supported
> > +	  by the V5 format, such as metadata checksumming, strengthened
> > +	  metadata verification, and the ability to store timestamps past the
> > +	  year 2038.  Because of this, the V4 format is deprecated.  All users
> > +	  should upgrade by backing up their files, reformatting, and restoring
> > +	  from the backup.
> > +
> > +	  Administrators and users can detect a V4 filesystem by running
> > +	  xfs_info against a filesystem mountpoint and checking for a string
> > +	  beginning with "crc=".  If the string "crc=0" is found, or no "crc="
> > +	  string is found, the filesystem is a V4 filesystem.
> > +
> > +	  This option will become default N in September 2025.  Support for the
> > +	  V4 format will be removed entirely in September 2030.  Distributors
> > +	  can say N here to withdraw support earlier.
> > +
> > +	  To continue supporting the old V4 format (crc=0), say Y.
> > +	  To close off an attack surface, say N.
> > +
> >  config XFS_QUOTA
> >  	bool "XFS Quota support"
> >  	depends on XFS_FS
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index ed69c4bfda71..3678dfeecd64 100644
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
> > +	"Deprecated V4 format (crc=0) not supported by kernel.");
> > +		error = -EINVAL;
> > +		goto release_buf;
> > +	}
> > +#endif
> > +
> 
> Should we not have a (oneshot?) warning for systems that choose to
> continue to support and use v4 filesystems? ISTM that's the best way to
> ensure there's feedback on this change earlier rather than later, or
> otherwise encourage such users to reformat with v5 at the next available
> opportunity...

hm, yes.

> BTW, any reason this is in xfs_readsb() vs. xfs_fc_fill_super() where we
> have various other version/feature checks and warnings?

no particular reason.  i like the idea of moving this chunk over there.

--d

> Brian
> 
> >  	/*
> >  	 * We must be able to do sector-sized and sector-aligned IO.
> >  	 */
> > 
> 
