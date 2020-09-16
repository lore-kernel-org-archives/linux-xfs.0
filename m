Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40843C43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBCC21941
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mWEX1+IX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgIPUxA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:53:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgIPQyM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 12:54:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGhpk2148956;
        Wed, 16 Sep 2020 16:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IsQdDLZ7YNB42cf3r8eCXzgw6ZHLRkDvD8VMZxnetPw=;
 b=mWEX1+IXveiDDuCIeT5GYzFi8qf8o2zBujaCQylxsfPe6a33HCOD54WO67CL3bHIdPPE
 t1lQUwAlT1/Uf7b0xv0GBbAO17ubhbM6RqBZTALDlHEd8C7GBZPC2HJR+THrFQTbEwId
 Bev8G6VBWY3zmwelH8dC2vGGCCSvUgcnhXv6ewUSUMuAtBq5yCLbEYwMQO/joI+X5wz1
 ypuTBEJMy54x/cfoRU3ZLklmmtCzuhTTvIMNjbUnYkrO4IXfZRnUcuRVzzm9f9QD136S
 4pC3sBSvU8vb/h4QM5+hLxn5glzUEM3ZN98Q/DsYMiP1t8xpilr3gLChT5nQNXc83iO0 CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr4bbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 16:53:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGe7s3140608;
        Wed, 16 Sep 2020 16:51:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm334v6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 16:51:45 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08GGpitK028737;
        Wed, 16 Sep 2020 16:51:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 16:51:43 +0000
Date:   Wed, 16 Sep 2020 09:51:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: Add realtime group
Message-ID: <20200916165142.GD7954@magnolia>
References: <20200916053407.2036-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916053407.2036-1-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 11:04:06AM +0530, Chandan Babu R wrote:
> This commit adds a new group to classify tests that can work with
> realtime devices.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/group | 52 ++++++++++++++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..3bb0f674 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -67,7 +67,7 @@
>  067 acl attr auto quick
>  068 auto stress dump
>  069 ioctl auto quick
> -070 auto quick repair
> +070 auto quick repair realtime

This test has an open-coded call to repair + rt volume, but is not
itself a test of rt functionality.

>  071 rw auto
>  072 rw auto prealloc quick
>  073 copy auto
> @@ -87,11 +87,11 @@
>  087 fuzzers
>  088 fuzzers
>  089 fuzzers
> -090 rw auto
> +090 rw auto realtime
>  091 fuzzers
>  092 other auto quick
>  093 fuzzers
> -094 metadata dir ioctl auto
> +094 metadata dir ioctl auto realtime
>  095 log v2log auto
>  096 mkfs v2log auto quick
>  097 fuzzers
> @@ -119,7 +119,7 @@
>  119 log v2log auto freeze
>  120 fuzzers
>  121 shutdown log auto quick
> -122 other auto quick clone
> +122 other auto quick clone realtime

This is an ondisk structure size check.  It doesn't test rt
functionality, but I guess it doesn't really harm things to throw it on
the 'realtime' pile.  I'm not objecting to this; it's just a funny
thought I had while reading this patch.

(Not sure why it's in 'clone' either...)

>  123 fuzzers
>  124 fuzzers
>  125 fuzzers
> @@ -128,7 +128,7 @@
>  128 auto quick clone fsr
>  129 auto quick clone
>  130 fuzzers clone
> -131 auto quick clone
> +131 auto quick clone realtime
>  132 auto quick
>  133 dangerous_fuzzers
>  134 dangerous_fuzzers
> @@ -188,7 +188,7 @@
>  188 ci dir auto
>  189 mount auto quick
>  190 rw auto quick
> -191-input-validation auto quick mkfs
> +191-input-validation auto quick mkfs realtime
>  192 auto quick clone
>  193 auto quick clone
>  194 rw auto
> @@ -272,7 +272,7 @@
>  273 auto rmap fsmap
>  274 auto quick rmap fsmap
>  275 auto quick rmap fsmap
> -276 auto quick rmap fsmap
> +276 auto quick rmap fsmap realtime
>  277 auto quick rmap fsmap
>  278 repair auto
>  279 auto mkfs
> @@ -287,7 +287,7 @@
>  288 auto quick repair fuzzers
>  289 growfs auto quick
>  290 auto rw prealloc quick ioctl zero
> -291 auto repair
> +291 auto repair realtime

This is a directory repair test, which doesn't exercise any rt volume
functionality.

...

FWIW I checked all the other tests that you added to the realtime group,
and the changes I don't have any comments about all look ok to me.

--D

>  292 auto mkfs quick
>  293 auto quick
>  294 auto dir metadata
> @@ -329,17 +329,17 @@
>  330 auto quick clone fsr quota
>  331 auto quick rmap clone
>  332 auto quick rmap clone collapse punch insert zero
> -333 auto quick rmap
> -334 auto quick rmap
> -335 auto rmap
> -336 auto rmap
> -337 fuzzers rmap
> -338 auto quick rmap
> -339 auto quick rmap
> -340 auto quick rmap
> -341 auto quick rmap
> -342 auto quick rmap
> -343 auto quick rmap collapse punch insert zero
> +333 auto quick rmap realtime
> +334 auto quick rmap realtime
> +335 auto rmap realtime
> +336 auto rmap realtime
> +337 fuzzers rmap realtime
> +338 auto quick rmap realtime
> +339 auto quick rmap realtime
> +340 auto quick rmap realtime
> +341 auto quick rmap realtime
> +342 auto quick rmap realtime
> +343 auto quick rmap collapse punch insert zero realtime
>  344 auto quick clone
>  345 auto quick clone
>  346 auto quick clone
> @@ -402,10 +402,10 @@
>  403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  404 dangerous_fuzzers dangerous_scrub dangerous_repair
>  405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -406 dangerous_fuzzers dangerous_scrub dangerous_repair
> -407 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -408 dangerous_fuzzers dangerous_scrub dangerous_repair
> -409 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> +406 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> +407 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> +408 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> +409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
>  410 dangerous_fuzzers dangerous_scrub dangerous_repair
>  411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  412 dangerous_fuzzers dangerous_scrub dangerous_repair
> @@ -415,7 +415,7 @@
>  416 dangerous_fuzzers dangerous_scrub dangerous_repair
>  417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  418 dangerous_fuzzers dangerous_scrub dangerous_repair
> -419 auto quick swap
> +419 auto quick swap realtime
>  420 auto quick clone punch seek
>  421 auto quick clone punch seek
>  422 dangerous_scrub dangerous_online_repair
> @@ -477,8 +477,8 @@
>  478 dangerous_fuzzers dangerous_norepair
>  479 dangerous_fuzzers dangerous_norepair
>  480 dangerous_fuzzers dangerous_norepair
> -481 dangerous_fuzzers dangerous_norepair
> -482 dangerous_fuzzers dangerous_norepair
> +481 dangerous_fuzzers dangerous_norepair realtime
> +482 dangerous_fuzzers dangerous_norepair realtime
>  483 dangerous_fuzzers dangerous_norepair
>  484 dangerous_fuzzers dangerous_norepair
>  485 dangerous_fuzzers dangerous_norepair
> -- 
> 2.28.0
> 
