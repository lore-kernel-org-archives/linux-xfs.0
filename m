Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DB5C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF4B522240
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 16:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V3BAeH6c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgIQQmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:42:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbgIQQmD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:42:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGZ2wq019094;
        Thu, 17 Sep 2020 16:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BABKfKrnUMmc9Fm/X30hwvwn4tnLxuOoMhK1E2imF7k=;
 b=V3BAeH6c2l7iS5jP2vqYgE7urVhEGaHmqY7yfkYC1Yt429E3b+S7/pXDRcYERQDszdPM
 m4W390WbLbqKkZF/Lih6d7UOD7tJ8kik0lEDqF/9Oea+bvD7zavvqV1e0RtwVRQcUlVy
 koz5XsTGzs/v4eOMg/2razIZvnnA3iZ5m7uqAWL6wBAlRAo0tIghQ1mx7FVyQxD31PKa
 nk/Ekv3tCCa8AwAdniKESbTUGDEHxjLBhw/2agwPU50d5iEOo7AiaFWpQ3pKLx/tNMjc
 e4DdtYajXYfVuNshmE09wHdT8Qnp6ezx5ghSB/Sktt5ed9Ff4X7/mNAeqF2MekYg4M6S vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33gp9mjefm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:42:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGZYG7061422;
        Thu, 17 Sep 2020 16:42:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h88buxph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:42:00 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HGfwL1010153;
        Thu, 17 Sep 2020 16:41:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:41:58 +0000
Date:   Thu, 17 Sep 2020 09:41:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: Add realtime group
Message-ID: <20200917164157.GG7955@magnolia>
References: <20200917042844.6063-1-chandanrlinux@gmail.com>
 <2800094.qH4kZmeDBE@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2800094.qH4kZmeDBE@garuda>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=1 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 10:01:14AM +0530, Chandan Babu R wrote:
> On Thursday 17 September 2020 9:58:43 AM IST Chandan Babu R wrote:
> > This commit adds a new group to classify tests that can work with
> > realtime devices.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> 
> Sorry, I forgot to add version number and also a changelog.
> 
> V1 -> V2:
>   Remove xfs/070 from realtime group.

I think you missed my comment in the last thread about xfs/291 being a
directory repair test.

--D

> >  tests/xfs/group | 50 ++++++++++++++++++++++++-------------------------
> >  1 file changed, 25 insertions(+), 25 deletions(-)
> > 
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ed0d389e..b99ca082 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -87,11 +87,11 @@
> >  087 fuzzers
> >  088 fuzzers
> >  089 fuzzers
> > -090 rw auto
> > +090 rw auto realtime
> >  091 fuzzers
> >  092 other auto quick
> >  093 fuzzers
> > -094 metadata dir ioctl auto
> > +094 metadata dir ioctl auto realtime
> >  095 log v2log auto
> >  096 mkfs v2log auto quick
> >  097 fuzzers
> > @@ -119,7 +119,7 @@
> >  119 log v2log auto freeze
> >  120 fuzzers
> >  121 shutdown log auto quick
> > -122 other auto quick clone
> > +122 other auto quick clone realtime
> >  123 fuzzers
> >  124 fuzzers
> >  125 fuzzers
> > @@ -128,7 +128,7 @@
> >  128 auto quick clone fsr
> >  129 auto quick clone
> >  130 fuzzers clone
> > -131 auto quick clone
> > +131 auto quick clone realtime
> >  132 auto quick
> >  133 dangerous_fuzzers
> >  134 dangerous_fuzzers
> > @@ -188,7 +188,7 @@
> >  188 ci dir auto
> >  189 mount auto quick
> >  190 rw auto quick
> > -191-input-validation auto quick mkfs
> > +191-input-validation auto quick mkfs realtime
> >  192 auto quick clone
> >  193 auto quick clone
> >  194 rw auto
> > @@ -272,7 +272,7 @@
> >  273 auto rmap fsmap
> >  274 auto quick rmap fsmap
> >  275 auto quick rmap fsmap
> > -276 auto quick rmap fsmap
> > +276 auto quick rmap fsmap realtime
> >  277 auto quick rmap fsmap
> >  278 repair auto
> >  279 auto mkfs
> > @@ -287,7 +287,7 @@
> >  288 auto quick repair fuzzers
> >  289 growfs auto quick
> >  290 auto rw prealloc quick ioctl zero
> > -291 auto repair
> > +291 auto repair realtime
> >  292 auto mkfs quick
> >  293 auto quick
> >  294 auto dir metadata
> > @@ -329,17 +329,17 @@
> >  330 auto quick clone fsr quota
> >  331 auto quick rmap clone
> >  332 auto quick rmap clone collapse punch insert zero
> > -333 auto quick rmap
> > -334 auto quick rmap
> > -335 auto rmap
> > -336 auto rmap
> > -337 fuzzers rmap
> > -338 auto quick rmap
> > -339 auto quick rmap
> > -340 auto quick rmap
> > -341 auto quick rmap
> > -342 auto quick rmap
> > -343 auto quick rmap collapse punch insert zero
> > +333 auto quick rmap realtime
> > +334 auto quick rmap realtime
> > +335 auto rmap realtime
> > +336 auto rmap realtime
> > +337 fuzzers rmap realtime
> > +338 auto quick rmap realtime
> > +339 auto quick rmap realtime
> > +340 auto quick rmap realtime
> > +341 auto quick rmap realtime
> > +342 auto quick rmap realtime
> > +343 auto quick rmap collapse punch insert zero realtime
> >  344 auto quick clone
> >  345 auto quick clone
> >  346 auto quick clone
> > @@ -402,10 +402,10 @@
> >  403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  404 dangerous_fuzzers dangerous_scrub dangerous_repair
> >  405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > -406 dangerous_fuzzers dangerous_scrub dangerous_repair
> > -407 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > -408 dangerous_fuzzers dangerous_scrub dangerous_repair
> > -409 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > +406 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> > +407 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> > +408 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> > +409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> >  410 dangerous_fuzzers dangerous_scrub dangerous_repair
> >  411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  412 dangerous_fuzzers dangerous_scrub dangerous_repair
> > @@ -415,7 +415,7 @@
> >  416 dangerous_fuzzers dangerous_scrub dangerous_repair
> >  417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> >  418 dangerous_fuzzers dangerous_scrub dangerous_repair
> > -419 auto quick swap
> > +419 auto quick swap realtime
> >  420 auto quick clone punch seek
> >  421 auto quick clone punch seek
> >  422 dangerous_scrub dangerous_online_repair
> > @@ -477,8 +477,8 @@
> >  478 dangerous_fuzzers dangerous_norepair
> >  479 dangerous_fuzzers dangerous_norepair
> >  480 dangerous_fuzzers dangerous_norepair
> > -481 dangerous_fuzzers dangerous_norepair
> > -482 dangerous_fuzzers dangerous_norepair
> > +481 dangerous_fuzzers dangerous_norepair realtime
> > +482 dangerous_fuzzers dangerous_norepair realtime
> >  483 dangerous_fuzzers dangerous_norepair
> >  484 dangerous_fuzzers dangerous_norepair
> >  485 dangerous_fuzzers dangerous_norepair
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
