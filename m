Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F37C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 773B0206A5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:28:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dkXQatAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLAQ20 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:28:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLAQ2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:28:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GOvns042665;
        Tue, 1 Dec 2020 16:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4qcu6Nfs5xF2u5Qg4jr6YMM/a3EcfVZG1zl21TGLMXM=;
 b=dkXQatAi1P9zUiep6v22T0CFxHdPHPKx5g7pCiB95/PzUA4da/VT7L4xXHFJdqcSZtM6
 4vP62NkKR6F3V/Wv2wjaeCtsejx5TqtznHHkDnNwajfucnoE3vrAWLh8mLp1CHY0noHw
 bKNAx67GkOTE3OHEUkZDWheqQS6V8odIrPVgQm5DmHZy5iwFk1rkuPtEQ8OwyTUMvYqL
 nhQrXKwnUcxBXJWp2fWuR5qaOLSDFFq4UNeIGH7er0GY0E283qlZOeicXJA3scW+BL6M
 r8Niiqr1TgLRP/Br2I6ygKNYSEBFtAROONf2VxWCdgzYjD/t+XfHyAzJJ9vIo2VlRjZE +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkkf03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:27:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G65Df042667;
        Tue, 1 Dec 2020 16:25:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540ey6ht8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:25:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GPdu9030218;
        Tue, 1 Dec 2020 16:25:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:25:39 -0800
Date:   Tue, 1 Dec 2020 08:25:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201201162539.GB143045@magnolia>
References: <160679383892.447856.12907477074923729733.stgit@magnolia>
 <160679385127.447856.3129099457617444604.stgit@magnolia>
 <20201201161812.GD1205666@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201161812.GD1205666@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 11:18:12AM -0500, Brian Foster wrote:
> On Mon, Nov 30, 2020 at 07:37:31PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Define an incompat feature flag to indicate that the filesystem needs to
> > be repaired.  While libxfs will recognize this feature, the kernel will
> > refuse to mount if the feature flag is set, and only xfs_repair will be
> > able to clear the flag.  The goal here is to force the admin to run
> > xfs_repair to completion after upgrading the filesystem, or if we
> > otherwise detect anomalies.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> IIUC, we're using an incompat bit to intentionally ensure the filesystem
> cannot mount, even on kernels that predate this particular "needs
> repair" feature. The only difference is that an older kernel would
> complain about an unknown feature and return a different error code.
> Right?
> 
> That seems reasonable, but out of curiousity is there a need/reason for
> using an incompat bit over an ro_compat bit?

The general principle is to prevent /any/ mounting of the fs until the
admin runs repair, even if it's readonly mounting.  The specific reason
is so that xfs_db can set some other feature flag as part of an upgrade
and then set the incompat bit to force a repair run (which xfs_admin
will immediately take care of).

Hm.  Now that you got me thinking, maybe there should be an exception
for a norecovery mount?

--D

> Brian
> 
> >  fs/xfs/libxfs/xfs_format.h |    7 +++++++
> >  fs/xfs/xfs_mount.c         |    6 ++++++
> >  2 files changed, 13 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index dd764da08f6f..5d8ba609ac0b 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -468,6 +468,7 @@ xfs_sb_has_ro_compat_feature(
> >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> >  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
> > +#define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
> >  #define XFS_SB_FEAT_INCOMPAT_ALL \
> >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > @@ -584,6 +585,12 @@ static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
> >  		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
> >  }
> >  
> > +static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
> > +{
> > +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
> > +}
> > +
> >  /*
> >   * end of superblock version macros
> >   */
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 7bc7901d648d..2853ad49b27d 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -266,6 +266,12 @@ xfs_sb_validate_mount(
> >  	struct xfs_buf		*bp,
> >  	struct xfs_sb		*sbp)
> >  {
> > +	/* Filesystem claims it needs repair, so refuse the mount. */
> > +	if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> > +		xfs_warn(mp, "Filesystem needs repair.  Please run xfs_repair.");
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> >  	/*
> >  	 * Don't touch the filesystem if a user tool thinks it owns the primary
> >  	 * superblock.  mkfs doesn't clear the flag from secondary supers, so
> > 
> 
