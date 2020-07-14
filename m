Return-Path: <SRS0=oQKh=AZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9C9C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE10F206F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jul 2020 21:46:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AnMpsaAB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGNVqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:46:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELauvt149941;
        Tue, 14 Jul 2020 21:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=70S0rt50OTSWkMlD6sNocrQR4yVzPX6ouuE9NBCs4+c=;
 b=AnMpsaABiLuQYANHpZxFD6pc7IEQEZ7+ffKWASpdisMZQmZJi1lHbzUoN6N+3ZWENapq
 PRPiVXsfEoPPGPS67OtihKOvfFnOsJdhycGU9CR5zl5mtk4ZnEi3Pfq6qT9+vP/R6Wla
 nhxZzMRGxRMT1ReVSRctTRQOLsAf2Hc+n74YgHRiHoRzzVd0P/bQ1oRLoXkgr2KvRg98
 wflRXCha4aHzMPF5HaxwL+nPfiAj0sGfRNpcS3uqbmNO41mVMhZWliJMyvcyWHQl8Yni
 A75zTRTZrb2bWFYT5hYBRkBZD2pLilV6OoH3k6YRqCILSYDzBbiI6lAhM8lGfUok/zUn oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm80gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhaWO051480;
        Tue, 14 Jul 2020 21:46:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 327qb5bc97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06ELk8Ol025182;
        Tue, 14 Jul 2020 21:46:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:08 -0700
Subject: [PATCH v2.2 0/4] xfs_repair: check quota counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:05 -0700
Message-ID: <159476316511.3156699.17998319555266568403.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
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

v2.2: Rebase against 5.7-rc1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck
---
 man/man8/xfs_repair.8 |    4 
 repair/Makefile       |   69 +++++-
 repair/phase7.c       |   21 ++
 repair/quotacheck.c   |  552 +++++++++++++++++++++++++++++++++++++++++++++++++
 repair/quotacheck.h   |   16 +
 repair/xfs_repair.c   |   13 +
 6 files changed, 660 insertions(+), 15 deletions(-)
 create mode 100644 repair/quotacheck.c
 create mode 100644 repair/quotacheck.h

