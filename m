Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EF8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 00:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F388207D8
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 00:09:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HouEHQ54"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFBAJW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 20:09:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFBAJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 20:09:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0520826a137480;
        Tue, 2 Jun 2020 00:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KkBAEATkyU1nYJav9kttY2F5KEqzP9BcUKd1hFjhtJE=;
 b=HouEHQ54VbsefSgXaZYXF7e5W6bIiPjl4Nku78bYiD77v9neZ0eXnFWtt5tHmc+vC3Ac
 ryx4F+jAd6WYk9gIlnqpSoEZEtZOmg3+2HfDkltnY1+IAjyPXHzHx9dsidtUnqo9wnwv
 yER1REWBm9AKAZUCJb4E50/rEJ75fYNep8y9IzOlr98P0jVeYBd7NXCuTx6p9KAb1mKF
 966F9PeBMwFfwzA7vlawPQh8cEkqPlRolCciKvtL8qhTxlQ4wu3W8bxylISZ8mMv3CvZ
 B2qn/cf70zE30zxGozV2fbnneysPpZoYy8qVvugn5aMA3JaJ9dbCEIjjng9LsPH7kX+8 rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31d5qr1g7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 00:09:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05207tpO112881;
        Tue, 2 Jun 2020 00:09:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25m4nx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 00:09:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05209IWY015789;
        Tue, 2 Jun 2020 00:09:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 17:09:18 -0700
Date:   Mon, 1 Jun 2020 17:09:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 13/14] xfs: enable bigtime for quota timers
Message-ID: <20200602000917.GE2162697@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784114490.1364230.7521571821422773694.stgit@magnolia>
 <CAOQ4uxgvnuVtfxz41W+FuTxy2GZ5QZwwUhacHgfMzJMKJ_db1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgvnuVtfxz41W+FuTxy2GZ5QZwwUhacHgfMzJMKJ_db1g@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=1 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 31, 2020 at 08:07:59PM +0300, Amir Goldstein wrote:
> On Wed, Jan 1, 2020 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Enable the bigtime feature for quota timers.  We decrease the accuracy
> > of the timers to ~4s in exchange for being able to set timers up to the
> > bigtime maximum.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_dquot_buf.c  |   72 ++++++++++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_format.h     |   22 ++++++++++++
> >  fs/xfs/libxfs/xfs_quota_defs.h |   11 ++++--
> >  fs/xfs/scrub/quota.c           |    5 +++
> >  fs/xfs/xfs_dquot.c             |   71 +++++++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_ondisk.h            |    6 +++
> >  fs/xfs/xfs_qm.c                |   13 ++++---
> >  fs/xfs/xfs_qm.h                |    8 ++--
> >  fs/xfs/xfs_qm_syscalls.c       |   19 ++++++-----
> >  9 files changed, 186 insertions(+), 41 deletions(-)
> >
> >
> > diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> > index 72e0fcfef580..2b5d51a6d64b 100644
> > --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> > +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> > @@ -40,6 +40,8 @@ xfs_dquot_verify(
> >         xfs_dqid_t              id,
> >         uint                    type)   /* used only during quotacheck */
> >  {
> > +       uint8_t                 dtype;
> > +
> >         /*
> >          * We can encounter an uninitialized dquot buffer for 2 reasons:
> >          * 1. If we crash while deleting the quotainode(s), and those blks got
> > @@ -60,11 +62,22 @@ xfs_dquot_verify(
> >         if (ddq->d_version != XFS_DQUOT_VERSION)
> >                 return __this_address;
> >
> > -       if (type && ddq->d_flags != type)
> > +       dtype = ddq->d_flags & XFS_DQ_ALLTYPES;
> 
> Suggest dtype = XFS_DQ_TYPE(ddq->d_flags);
> 
> [...]
> 
> > @@ -540,13 +551,28 @@ xfs_dquot_from_disk(
> >         dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
> >         dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
> >
> > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_btimer);
> > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_btimer);
> >         dqp->q_btimer = tv.tv_sec;
> > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_itimer);
> > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_itimer);
> >         dqp->q_itimer = tv.tv_sec;
> > -       xfs_dquot_from_disk_timestamp(&tv, ddqp->d_rtbtimer);
> > +       xfs_dquot_from_disk_timestamp(ddqp, &tv, ddqp->d_rtbtimer);
> >         dqp->q_rtbtimer = tv.tv_sec;
> >
> > +       /* Upgrade to bigtime if possible. */
> > +       if (xfs_dquot_add_bigtime(dqp->q_mount, iddq)) {
> > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_btimer);
> > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_btimer, &tv);
> > +               dqp->q_btimer = tv.tv_sec;
> > +
> > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_itimer);
> > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_itimer, &tv);
> > +               dqp->q_itimer = tv.tv_sec;
> > +
> > +               tv.tv_sec = xfs_dquot_clamp_timer(iddq, dqp->q_rtbtimer);
> > +               xfs_dquot_to_disk_timestamp(iddq, &iddq->d_rtbtimer, &tv);
> > +               dqp->q_rtbtimer = tv.tv_sec;
> > +       }
> > +
> 
> This is better than the inode timestamp conversion because at
> least the bigtime flag incore is always consistent with the incore values.
> But I think it would be safer if the conversion happened inside the helper.

This code, like the inode timestamp handling code, reads the ondisk
timer value into the incore dquot, and sets the bigtime flag on the
incore dquot.  We then wait until someone dirties the dquot to transform
the ondisk dquot to be in bigtime format with the flag set.

The dquot conversion is /much/ messier than the inode, because the dquot
infrastructure maintains an incore copy of the ondisk dquot as well as
an incore time64_t value, and we have to keep that whole mess
consistent.

TBH someone should probably go fix the incore dquots to have only the
incore values (instead of the embedded xfs_disk_dquot) but I'd rather
that go in as a cleanup after adding this series, because this series is
already 13 patches, and if you combine cleaning up dquots with hch's
incore inode removal now we have Yet Another Friggin 40-patch series.

--D

> Thanks,
> Amir.
