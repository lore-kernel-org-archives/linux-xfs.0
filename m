Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004C5C2BC11
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 20:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD91F208FE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 20:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pGFfRxGQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgIKU2Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 16:28:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgIKU2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 16:28:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BKObom101393;
        Fri, 11 Sep 2020 20:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=qus1VcG7Cwz6b+CabbtBHwSqoH6Ro8hONlzAHuI2sjw=;
 b=pGFfRxGQNmdOrEtRwSe3dT1nR62+BUKO2kwkDl1AHO/tno0xdoIAWKCQLiNQ0gN+kGSo
 Uadxb6paiwqgrMvWNsISNpnmm0D9sqTwA/CHbYYplbD5QUPJEv3vn2+Il2hxxcGAKpQM
 EzgO1AY837eIYyhTrh433rWHv5dHlgZRSMQtz3U2eUwhWEG91U9NcFp9MitDosnm8qYo
 J3oGEfiivUntrGLemdBT5AOqtehSlF7WqxtK31iIf/rj69CU+kl/vKwOmp4wZCGMcTry
 ks+bCgjyY89gAJNH8BpVG7fW8hzgfXEjraOPCsV/R5W97DOgC2l2U/lDWzjgbmaVL04r Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33c2mmgb7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 20:28:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BKPcvn067683;
        Fri, 11 Sep 2020 20:28:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33cmextuj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 20:28:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08BKS0kW004874;
        Fri, 11 Sep 2020 20:28:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 13:27:59 -0700
Date:   Fri, 11 Sep 2020 13:27:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: General fire status announcement
Message-ID: <20200911202758.GV7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

FYI, almost the entire West Coast of the Untied States is on fire right
now[1], with major fires burning out of control 30 miles south of here.
The L3 evacuation zone (aka "GTFO NOW") is still 12 miles distant[2].
This all comes down to wind velocity.

I'm skeptical that the fires are going to burn through 30 miles of
suburb all the way to my house, but if you haven't heard anything from
me by a week from now, it will be reasonable to conclude that I've fled
somewhere.

At this point, I've distractedly pushed out 5.10 merge branches for
iomap and xfs to kernel.org.  They're missing willy's THP series, the V4
deprecation patch, and a couple of bug fixes; with any luck I'll land
those for the post-rc6 push.

SO, if something big comes up and nobody can get ahold of me, please
lean on Dave and Eric.  Though to put this in perspective, the primary
maintainer of the upstream kernel lives 6 miles away, so if I've gone,
chances are decent he's left too.

With any luck, next week will be boring AF and all of this will just be
me blathering on hysterically. :)

--D

[1] https://cdn.star.nesdis.noaa.gov/GOES17/ABI/SECTOR/pnw/GEOCOLOR/20202551956_GOES17-ABI-pnw-GEOCOLOR-2400x2400.jpg

[2] https://ccgis-mapservice.maps.arcgis.com/apps/webappviewer/index.html?id=fe0525732f1a4f679b75a5ccf1c84b30
