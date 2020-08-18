Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAFAC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6766220674
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MOa/AkdK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHRPmL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:42:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgHRPmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:42:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFSPC8006767;
        Tue, 18 Aug 2020 15:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ertlmH34CuXN9mTj5zN38HLPABXVB4pEbE6kha2eyaM=;
 b=MOa/AkdKWmZTOVs504z1AdnFxsNoTy2QACW3lC9SEpGGB2zbEafiEZGglZLbKJGDR34H
 GHIV7EINc8k5CdG65V+v6+siAPOQTGvnXD8t61Quc4zQEGRg2pOliPEwTio15N4Ilz5H
 GVBcdNDDsNDAnARsPeqfvJLF/gxMSWfSJYjNcyUsOblyJLmVlNMJoIo4dwigLb6yg1VK
 QmGU99aMKN7CpuKbmLsAo/uHBTE3pojI7/kTSflsVNC5B0X7X7nwcbxmB6qYwvjPUU3L
 rKrO/cJijZa/jpD56h9Uzp9WvuAcgdA9nzXJd3OVBDc6S5jo4dzAOemVUHoRP20tWwRq Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74r5p8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:42:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFY0DG027414;
        Tue, 18 Aug 2020 15:42:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32xsm359q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:42:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IFg5LU028455;
        Tue, 18 Aug 2020 15:42:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:42:04 -0700
Date:   Tue, 18 Aug 2020 08:42:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 06/11] xfs: refactor inode timestamp coding
Message-ID: <20200818154203.GT6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770504627.3956827.1457402206153045570.stgit@magnolia>
 <CAOQ4uxhcf1-MKsyenuHnJ5WhpZk7eM53DSmyKYr-EGoSCieTSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhcf1-MKsyenuHnJ5WhpZk7eM53DSmyKYr-EGoSCieTSg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 02:20:22PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Refactor inode timestamp encoding and decoding into helper functions so
> > that we can add extra behaviors in subsequent patches.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> With nit below...
> 
> ...
> 
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index d95a00376fad..c2f9a0adeed2 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -295,6 +295,15 @@ xfs_inode_item_format_attr_fork(
> >         }
> >  }
> >
> > +static inline void
> > +xfs_from_log_timestamp(
> > +       struct xfs_timestamp            *ts,
> > +       const struct xfs_ictimestamp    *its)
> > +{
> > +       ts->t_sec = cpu_to_be32(its->t_sec);
> > +       ts->t_nsec = cpu_to_be32(its->t_nsec);
> > +}
> > +
> >  void
> >  xfs_log_dinode_to_disk(
> 
> Following convention of xfs_inode_{to,from}_disk_timestamp()
> I think it would be less confusing to name these helpers
> xfs_log_to_disk_timestamp()
> 
> and...
> 
> >
> > +static inline void
> > +xfs_to_log_timestamp(
> > +       struct xfs_ictimestamp          *its,
> > +       const struct timespec64         *ts)
> > +{
> > +       its->t_sec = ts->tv_sec;
> > +       its->t_nsec = ts->tv_nsec;
> > +}
> > +
> >  static void
> >  xfs_inode_to_log_dinode(
> 
> xfs_inode_to_log_timestamp()
> 
> Because xfs_{to,from}_log_timestamp() may sound like a matching pair,
> to your average code reviewer, but they are not.

Ok, will do.

--D

> Thanks,
> Amir.
