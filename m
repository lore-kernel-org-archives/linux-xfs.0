Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE48C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D512207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kn8Atlgv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHRPkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:40:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgHRPkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:40:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFRdgi091367;
        Tue, 18 Aug 2020 15:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eok2II/h/mA/52LE9XX0+JH4X8e0bMqFKj5KpBX+DZw=;
 b=kn8AtlgvR3zaSrfNDFRvEW+ImdJJTyMSHmTlcZd1d9VhbSzxeTKhlGfrZSmWp7xDr+bP
 wgl7TuMGAdWTzWPLGatqLnsVqoqiUN0IOvhgSICt/CcLCnG6NrjIrHQXIWMVJ9NpZVCz
 NtQwmkN2Wu3w4+yXDfF5o0IW0+XOg0ZNxG8w6xtk8cDV4W3GXV6T3on3hR9gu0zWZ0b9
 Rv/kv5o2TbgPw5lNZmv1XdXZ/xCPl4zUR0zCXErsPKi4rhoMGCVBHSTYpNcNpZ6ApMIW
 h2AtKRNF8j9xxpgGB+w1YGuo/9JOndzxfH6uJdRl/VtndrbE3RAiue3fn3Dhuy/YVRNC RQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32x7nmdmjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:40:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFYtdx129517;
        Tue, 18 Aug 2020 15:40:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsmxcq6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:40:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFe30L009023;
        Tue, 18 Aug 2020 15:40:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:40:03 -0700
Date:   Tue, 18 Aug 2020 08:40:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
Message-ID: <20200818154002.GS6096@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
 <159770502083.3956827.8660123941779980742.stgit@magnolia>
 <CAOQ4uxiekcHPfyjvJJMBhW-7uSDZ3Gb=Zyu5ZpyKhxz1QmMcnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiekcHPfyjvJJMBhW-7uSDZ3Gb=Zyu5ZpyKhxz1QmMcnw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 09:48:14AM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 1:59 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Define explicit limits on the range of quota grace period expiration
> > timeouts and refactor the code that modifies the timeouts into helpers
> > that clamp the values appropriately.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Question below...
> 
> ...
> 
> > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > index 1c542b4a5220..b16d533a6feb 100644
> > --- a/fs/xfs/xfs_qm_syscalls.c
> > +++ b/fs/xfs/xfs_qm_syscalls.c
> > @@ -483,9 +483,14 @@ xfs_setqlim_timer(
> >         struct xfs_quota_limits *qlim,
> >         s64                     timer)
> >  {
> > -       res->timer = timer;
> > -       if (qlim)
> > +       if (qlim) {
> > +               /* Set the length of the default grace period. */
> > +               res->timer = timer;
> >                 qlim->time = timer;
> > +       } else {
> > +               /* Set the grace period expiration on a quota. */
> > +               xfs_dquot_set_timeout(&res->timer, timer);
> > +       }
> >  }
> 
> I understand why you did this. This is mid series craft, but it looks very odd
> to your average reviewer.
> 
> Maybe leave a TODO comment above res->timer = timer which will be
> removed later in the series?
> 
> Not critical.

<shrug> The grace period case gets changed in the very next patch, but I
suppose it wouldn't hurt to mention that in the commit log.

--D

> 
> Thanks,
> Amir.
