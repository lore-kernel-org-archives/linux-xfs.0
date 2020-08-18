Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE00C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F031820786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="phWIAltg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgHRPgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:36:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgHRPgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:36:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFR8ei160119;
        Tue, 18 Aug 2020 15:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fM4EhbDtCplbETGEGzZ3mqfNQjXM+BKaPcH/xZb39hs=;
 b=phWIAltgQRHD94X8o7Z3b990GEqJTWEV1K3M/GogDLrevRbBLzyuXj9HtABVoRwKOgIk
 32lpLV4OjB6YtFMZ+lUvjClTrqLOIoVncxPgTUWazgAHfQfvrX3inLMdK5L5KHxfOMQ2
 wNg1Nz/+wt+8R3g2Oq8dr7rESgWDRiufddGuxxbTw8anpHuFrXQUkZcKQXpaLGn8uhvA
 PL0xGv70iXOLhCK46o0Y1c4xr7YAxGiJXE/UeB3wPONATmgxLRMCm8DOLIeaGEirP5xi
 6Yd/IM/N94gAYA8exWK5tb4s59usPd1GGNtDDGrn5FB67BhZXnl/mFrSbRrsEjGS1b57 OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn5h8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:36:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IFYZVn110860;
        Tue, 18 Aug 2020 15:34:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsfs12d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:34:37 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IFYQDq004614;
        Tue, 18 Aug 2020 15:34:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:34:25 -0700
Date:   Tue, 18 Aug 2020 08:34:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 18/18] mkfs: format bigtime filesystems
Message-ID: <20200818153424.GQ6096@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
 <159770524797.3958786.6498012041319904192.stgit@magnolia>
 <CAOQ4uxgL9cUm3wqbSgRnRC-uOpDAJ4_KaZA+3CUx5rLDLaY19A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgL9cUm3wqbSgRnRC-uOpDAJ4_KaZA+3CUx5rLDLaY19A@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:45:41PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Allow formatting with large timestamps.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> Other than one comment below...
> 
> > ---
> >  man/man8/mkfs.xfs.8 |   16 ++++++++++++++++
> >  mkfs/xfs_mkfs.c     |   24 +++++++++++++++++++++++-
> >  2 files changed, 39 insertions(+), 1 deletion(-)
> >
> >
> > diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> > index 082f3ab6c063..7434b9f2b4cd 100644
> > --- a/man/man8/mkfs.xfs.8
> > +++ b/man/man8/mkfs.xfs.8
> > @@ -154,6 +154,22 @@ valid
> >  are:
> >  .RS 1.2i
> >  .TP
> > +.BI bigtime= value
> > +This option enables filesystems that can handle inode timestamps from December
> > +1901 to July 2486, and quota timer expirations from January 1970 to July 2486.
> > +The value is either 0 to disable the feature, or 1 to enable large timestamps.
> > +.IP
> > +If this feature is not enabled, the filesystem can only handle timestamps from
> > +December 1901 to January 2038, and quota timers from January 1970 to February
> > +2106.
> > +.IP
> > +By default,
> > +.B mkfs.xfs
> > +will not enable this feature.
> > +If the option
> > +.B \-m crc=0
> > +is used, the large timestamp feature is not supported and is disabled.
> > +.TP
> >  .BI crc= value
> >  This is used to create a filesystem which maintains and checks CRC information
> >  in all metadata objects on disk. The value is either 0 to disable the feature,
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 037246effd70..f9f78a020092 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -120,6 +120,7 @@ enum {
> >         M_RMAPBT,
> >         M_REFLINK,
> >         M_INOBTCNT,
> > +       M_BIGTIME,
> >         M_MAX_OPTS,
> >  };
> >
> > @@ -667,6 +668,7 @@ static struct opt_params mopts = {
> >                 [M_RMAPBT] = "rmapbt",
> >                 [M_REFLINK] = "reflink",
> >                 [M_INOBTCNT] = "inobtcount",
> > +               [M_BIGTIME] = "bigtime",
> >         },
> >         .subopt_params = {
> >                 { .index = M_CRC,
> > @@ -703,6 +705,12 @@ static struct opt_params mopts = {
> >                   .maxval = 1,
> >                   .defaultval = 1,
> >                 },
> > +               { .index = M_BIGTIME,
> > +                 .conflicts = { { NULL, LAST_CONFLICT } },
> > +                 .minval = 0,
> > +                 .maxval = 1,
> > +                 .defaultval = 1,
> 
>                  .defaultval = 0 ?

The (somewhat misnamed) defaultval determines the implied value if the
user doesn't specify one, e.g. "-m bigtime" instead of "-m bigtime=1".
Therefore, we want it to default to 1 like all the other feature flag
arguments.

Thanks for reviewing most of this featureset! :)

--D

> 
> Thanks,
> Amir.
