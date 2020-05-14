Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9F3C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733A42065F
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 16:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SpPBRQMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENQ41 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 12:56:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgENQ40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 12:56:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGrBkp173775;
        Thu, 14 May 2020 16:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=nMwKqb4CRvedpVN/l27VoX6OOrl7LBWwkhbDEK0Vunk=;
 b=SpPBRQMhli2zPT1h+poqzdqqXrpUvrizZcv9b1uUipYW0lKbyj2FGQGzi3B5TYz0Jl2P
 0/1ZRi0lr+BT/2D11jF88mPvSFFmlFH3FNa9cu5Eoc0JwjGxtkeDcA0J49xQzqBjIbmi
 WuHLB4FBZeR886jfjDLMmDn1RgiCzlnkKXCAu5RfZBy8oGDtFGfGCVza/0Ma9E/Kf47v
 cK0Bt/cJqYosvpHnif5mvNw4aqiEEp7u0RSzOAa7Pafd/QSBKDosVaxyzclZWvh2Yhtx
 sTuMbyxZyvp+d+7t2RC9MDbB9BWWaciP2dVIiVwQ4TxncrCy+hPoW7J1xAxXAYTDZXmY rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3100xwurpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:56:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGs5iD154656;
        Thu, 14 May 2020 16:56:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3100yh5d6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:56:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EGuNSq022923;
        Thu, 14 May 2020 16:56:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:56:22 -0700
Subject: [PATCH v2 0/4] xfs_repair: check quota counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 May 2020 09:56:21 -0700
Message-ID: <158947538149.2482564.3112804204578429865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

One of the larger gaps between xfs_check and xfs_repair is that repair
doesn't have the ability to check quota counters against the filesystem
contents.  This series adds that checking ability to repair pass7, which
should suffice to drop xfs_check in fstests.  It also means that repair
no longer forces a quotacheck on the next mount even if the quota counts
were correct.

For v2, I moved the makefile changes to a separate patch; fixed various
labelling and error message things that Eric pointed out; and also fixed
a bug where repair wasn't clearing the CHKD flags correctly on V4 fses.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck
