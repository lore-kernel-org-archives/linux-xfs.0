Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3E1C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6FB820786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DJ8mWsXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgHRPck (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:32:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47692 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgHRPch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:32:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFRe6w091497;
        Tue, 18 Aug 2020 15:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dMxEZOoPSz41A5fmtDug0JWkOCZL/JAd4Te1L5aASUQ=;
 b=DJ8mWsXFPCeAcmWdo+Y5TaUHpgFnWPmHbjA7FNDH4zezzwWWtqMsI0iEsXxSCBAXpq4g
 AiPuKL6bu+QfX5N10TgJwalgmF5TvKzFeJQnxUom/MornocR0uC+A9YMz0qDrjQouVMx
 A0Ir1JH2ee9KO97oZWh6sa+qSV2UR1fs66FCERpoMLvwlbCF/vsZcWXy+cF+Tut2ezgt
 sa4V76tTOAVjbyDtiR2mJfqasyEoGz906AfaJ5bCf5S6RuN64ep0cM6+5+ahw76wViAC
 sJPGbwbY9h7F7WLrFGUEsgH5LYniTv13+bYxEJm53J9qbZZDVqDnPKzdp/DrilP7tuqc EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32x7nmdjyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:32:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFTD6M107470;
        Tue, 18 Aug 2020 15:32:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsmxcdsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:32:33 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFWWg4011474;
        Tue, 18 Aug 2020 15:32:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:32:32 -0700
Date:   Tue, 18 Aug 2020 08:32:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 17/18] xfs_repair: support bigtime
Message-ID: <20200818153231.GP6096@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
 <159770524187.3958786.13522554876108493954.stgit@magnolia>
 <CAOQ4uxiw7oPFwy2J-hGAoN6qTu_Hnx9E2vy2qBO9x5M-oaT5AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiw7oPFwy2J-hGAoN6qTu_Hnx9E2vy2qBO9x5M-oaT5AQ@mail.gmail.com>
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

On Tue, Aug 18, 2020 at 05:58:11PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Check the bigtime iflag in relation to the fs feature set.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> and some questions below...
> 
> > ---
> >  repair/dinode.c |   13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> >
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index ad2f672d8703..3507cd06075d 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -2173,7 +2173,8 @@ check_nsec(
> >         union xfs_timestamp     *t,
> >         int                     *dirty)
> >  {
> > -       if ((dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_BIGTIME)) ||
> > +       if ((dip->di_version >= 3 &&
> 
> It seems a bit strange that di_version check was added by this commit.

Ooh, yeah.  That was added a few patches back, though it shouldn't have
been.

> > +            (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME))) ||
> >             be32_to_cpu(t->t_nsec) < NSEC_PER_SEC)
> >                 return;
> >
> > @@ -2601,6 +2602,16 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
> >                         flags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> >                 }
> >
> > +               if ((flags2 & XFS_DIFLAG2_BIGTIME) &&
> > +                   !xfs_sb_version_hasbigtime(&mp->m_sb)) {
> > +                       if (!uncertain) {
> > +                               do_warn(
> > +       _("inode %" PRIu64 " is marked bigtime but file system does not support large timestamps\n"),
> > +                                       lino);
> > +                       }
> > +                       flags2 &= ~XFS_DIFLAG2_BIGTIME;
> 
> Should we maybe also reset the timestamps to epoc in this case?

Yeah, since it's possible that the timestamp would then have an invalid
nsec field once the bigtime field is cleared.  This also needs to log
something about logging "...would zero timestamps and clear flag".

Thanks for catching this. :)

--D

> 
> Thanks,
> Amir.
