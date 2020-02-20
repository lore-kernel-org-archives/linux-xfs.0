Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ACDC5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DDDA21D56
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 01:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="he88YY7g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgBTBmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 20:42:39 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTBmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 20:42:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1c9Sk039762;
        Thu, 20 Feb 2020 01:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=yuNyl2uqQ6OX2aCqputqmUYcs71HUuR8EG6VnQW6KrQ=;
 b=he88YY7gpo3Q4P2sazI7V0y++RbC7GUsuoH7ErMKqujJYncRbdybf/X/ZRjiGfGahmuI
 xKKZzzNsikOLlhrLjXiRZsWlVRqcsq2Yrt4RNgy1mM9qYxFV9bkaWZsk/RGwDJbbCMUh
 BModzSF5naxNvtGXjaJC6x5svNO+WyUSbNON7eykEjN2xJf9kVV5mTfu1HI7vHOwJ8qW
 TqqCVTMMMmOMc+X0y6SkkZuzt6AP5pXRI5RdZ2msHujSBqpXZzAFlxhoEINJiaYAM2KR
 AdsbMb3SxvR0a2tgblJbebTS1s84IT907c0M2t6ypSql1ZMVghtvAOxmrq9XYujHjbU9 SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud16s9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01K1gEri189041;
        Thu, 20 Feb 2020 01:42:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8ud96xu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 01:42:36 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01K1gZQv005872;
        Thu, 20 Feb 2020 01:42:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 17:42:35 -0800
Subject: [PATCH 00/18] xfsprogs: refactor buffer function names
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Feb 2020 17:42:34 -0800
Message-ID: <158216295405.602314.2094526611933874427.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=566
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=617 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up several messes in the libxfs buffer handling code.
First, we get rid of the overloaded (and in some places hidden usages)
of LIBXFS_EXIT_ON_FAIL flag that is sprinkled throughout the buffer
callers.  Next, we rename the buffer get/read/put/write functions to
match their kernel counterparts, which enables us to remove a bunch of
ugly #defines.  Then, we replace the open-coded uncached buffer logic in
the callers with the same uncached buffer API as the kernel has.
Finally, we move as many callers as we feasibly can to use the
xfs_buf_(get|read) interfaces so that we don't have multiple entry
points to the same functionality.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-refactor-buffer-funcs
