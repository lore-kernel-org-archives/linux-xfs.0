Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F997C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 20:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 609CC2063A
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 20:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pAHzvV0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHRUwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 16:52:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36276 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRUwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 16:52:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IKqAQW095898;
        Tue, 18 Aug 2020 20:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZxZt2maswCXYYRaJXLJ74imUgp97hnPwqGeZuN5pqHE=;
 b=pAHzvV0gLwQKOK30w6L6j8jlo8+2ZZ4fEbnNQbW5ZcWs6o4bZNjHuHqLQFkNYMXaRLIC
 Z/hy5zTKvmZKZPdhKuoFFrY9RoD75dUSqcXqyjUB46uACRLFg13UnYV9E/d5W0LKOSGM
 TGCPtl6TUMq2f8YsUw58D8Wc78Ot5WsezOJlyUWCBdyir7rZ761/yJWXcqzeaVYn4wIJ
 0c8w71XWpND73rPQi25EuTJ5A1M8nmE24OK+u5M2hkqG35tYCyIHsasYIDKSgf4YuO9T
 D6XwubGbCl6fgbIs8GvztPBg6WgLrnaxpiaQyqxpX6HYcw5JeuxeHAz7qWD3c4L6nT4a BQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nmf85r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 20:52:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IKlltA017790;
        Tue, 18 Aug 2020 20:52:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm3s57r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 20:52:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IKq6DA012029;
        Tue, 18 Aug 2020 20:52:08 GMT
Received: from localhost (/10.159.135.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 13:52:06 -0700
Date:   Tue, 18 Aug 2020 13:52:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 08/11] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200818205204.GY6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770505894.3956827.5973810026298120596.stgit@magnolia>
 <CAOQ4uxj=K5TCTZoKxd9G4F0cTRYeE73-6iQgmp+3pR3QJKYdvg@mail.gmail.com>
 <CAOQ4uxgiVdzVNo00-mzDjRn4x3+40dXWGx78n-KucrOBxMcREA@mail.gmail.com>
 <20200818155345.GV6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818155345.GV6096@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 08:53:45AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 18, 2020 at 03:53:57PM +0300, Amir Goldstein wrote:
> > On Tue, Aug 18, 2020 at 3:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > >
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > >
> > > > Redesign the ondisk timestamps to be a simple unsigned 64-bit counter of
> > > > nanoseconds since 14 Dec 1901 (i.e. the minimum time in the 32-bit unix
> > > > time epoch).  This enables us to handle dates up to 2486, which solves
> > > > the y2038 problem.
> > > >
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > ...
> > >
> > > > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > > > index 9f036053fdb7..b354825f4e51 100644
> > > > --- a/fs/xfs/scrub/inode.c
> > > > +++ b/fs/xfs/scrub/inode.c
> > > > @@ -190,6 +190,11 @@ xchk_inode_flags2(
> > > >         if ((flags2 & XFS_DIFLAG2_DAX) && (flags2 & XFS_DIFLAG2_REFLINK))
> > > >                 goto bad;
> > > >
> > > > +       /* the incore bigtime iflag always follows the feature flag */
> > > > +       if (!!xfs_sb_version_hasbigtime(&mp->m_sb) ^
> > > > +           !!(flags2 & XFS_DIFLAG2_BIGTIME))
> > > > +               goto bad;
> > > > +
> > >
> > > Seems like flags2 are not the incore iflags and that the dinode iflags
> > > can very well
> > > have no bigtime on fs with bigtime support:
> > >
> > > xchk_dinode(...
> > > ...
> > >                 flags2 = be64_to_cpu(dip->di_flags2);
> > >
> > > What am I missing?
> > >
> > 
> > Another question. Do we need to worry about xfs_reinit_inode()?
> > It seems not because incore inode should already have the correct bigtime
> > flag. Right?
> 
> I sure hope so.  Any inode being fed to xfs_reinit_inode was fully read
> into memory, then we tore down the VFS inode, but before we tore down
> the XFS inode, someone wanted it back, so all we have to do is reset
> the VFS part of the incore state.
> 
> Therefore, we don't have to do anything about the XFS part of the incore
> state. :)
> 
> > But by same logic, xfs_ifree() should already have the correct
> > bigtime flag as well, so we don't need to set the flag, maybe assert the flag?
> 
> Right.  I think that piece can go since we set the incore flag
> opportunistically now.

Bleh.  I missed the subtlety of:

	ip->i_d.di_flags2 = 0;
	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb))
		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;

First we zero flags2 entirely, then we re-enable bigtime so that the
final ctime update is written in the correct format.  I guess that could
be simplified to:

	/*
	 * Preserve the bigtime flag so that ctime accurately stores the
	 * deletion time.
	 */
	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_BIGTIME;

> --D
> 
> > 
> > Thanks,
> > Amir.
