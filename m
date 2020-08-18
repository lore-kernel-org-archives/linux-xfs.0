Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7AEC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 16:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6985F207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 16:02:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MMd8Q1FA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHRQCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:02:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgHRQBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 12:01:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFkt4e010648;
        Tue, 18 Aug 2020 16:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XH+cWCyumgHXDda7veUdDTvdebjviyqgR6fas9yR5o4=;
 b=MMd8Q1FAho7X9v6JXIcCtFV1lTyc9rjVV1vG9XdfAe4zvmZdk1plWttn2Yv+c8RioCB5
 cd1tMJyCpU7wo2FvJwpXMU2x/kgHqaN+Y54ew8+Smp8QO6HSMFP0PTE6i6l8oF0/zbBI
 MO8TlC4M3xc5xwc0k0MzhTbdOBnClvKGmSfKoCaidB9uSarJAKPxqaa4XOyIhdg+sppO
 GoAj3pxDvlXP7FbaaXxDANPgx+d8TMto2e4cFe74NIY6biUQJn30kiczfvmoiUXv7+Nq
 Iil53XkOVpEYb4HLfgjEpJ/k+CgLzBQYOTCb5CILHh+nsS/Y4FBHkLcLcoDTCvUup4rx GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn5pee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 16:01:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFmChH083541;
        Tue, 18 Aug 2020 15:59:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32xs9n4faw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:59:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFxURf020566;
        Tue, 18 Aug 2020 15:59:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:59:30 -0700
Date:   Tue, 18 Aug 2020 08:59:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 10/11] xfs: enable bigtime for quota timers
Message-ID: <20200818155929.GW6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770507160.3956827.6960595082057299697.stgit@magnolia>
 <CAOQ4uxjMUicQ9202SHuad4W+5QpDeQabNqHCNqV=8ksxNE6Avg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjMUicQ9202SHuad4W+5QpDeQabNqHCNqV=8ksxNE6Avg@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 04:58:35PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Enable the bigtime feature for quota timers.  We decrease the accuracy
> > of the timers to ~4s in exchange for being able to set timers up to the
> > bigtime maximum.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Minor suggestion below...
> 
> 
> > @@ -306,5 +327,24 @@ xfs_dquot_to_disk_timestamp(
> >         __be32                  *dtimer,
> >         time64_t                timer)
> >  {
> > +       /* Zero always means zero, regardless of encoding. */
> > +       if (!timer) {
> > +               *dtimer = cpu_to_be32(0);
> > +               return;
> > +       }
> > +
> > +       if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> > +               uint64_t        t = timer;
> > +
> > +               /*
> > +                * Round the end of the grace period up to the nearest bigtime
> > +                * interval that we support, to give users the most time to fix
> > +                * the problems.
> > +                */
> > +               t = roundup_64(t, 1U << XFS_DQ_BIGTIME_SHIFT);
> > +               *dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
> > +               return;
> > +       }
> > +
> >         *dtimer = cpu_to_be32(timer);
> >  }
> 
> This suggestion has to do with elegance which is subjective...
> 
> /*
>  * When bigtime is enabled, we trade a few bits of precision to expand the
>  * expiration timeout range to match that of big inode timestamps.  The grace
>  * periods stored in dquot 0 are not shifted, since they record an interval,
>  * not a timestamp.
>  */
> #define XFS_DQ_BIGTIME_SHIFT   (2)
> #define XFS_DQ_BIGTIME_SLACK ((1U << XFS_DQ_BIGTIME_SHIFT)-1)
> 
>                /*
>                 * Round the end of the grace period up to the nearest bigtime
>                 * interval that we support, to give users the most time to fix
>                 * the problems.
>                 */
>                uint64_t        t = timer + XFS_DQ_BIGTIME_SLACK;
>                *dtimer = cpu_to_be32(t >> XFS_DQ_BIGTIME_SHIFT);
> 
> Take it or leave it.

Hm.  Normally I don't really like open-coding a rounding operation, but
it does eliminate an integer division.

(I dunno about "SLACK", but I can't think of a better word for
imprecision...)

--D

> Thanks,
> Amir.
