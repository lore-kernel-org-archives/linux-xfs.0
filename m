Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2899C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5076206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DUPE0MjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgAABKP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:10:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49316 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:10:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xKN091218
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=7xX7Z+svbH0Bx795eBBrZC9B9kWshwLzjoZwvhY/NUE=;
 b=DUPE0MjSfpEvm/DPm/1XIQfi05mEGIAuq52zEqhh2wYJmCeB3T1h+WSfLP6c9bmb9YD/
 wNXq0kFw2WWuKUA5AabC0rL6jfrachQu+RtvIhOE92DFI49uIkOBSTlpmZZ7neUeCvoD
 tWExGpbpy+VRtOl4B/5wq2NVC4Q3/HsHtBB7zP9wziQ5wagQy7n8pKod8BJhlbQQQV2R
 CFrt/SGuqqh/t7BpjcMsSfih4TGeguSXJPh4LnlPGI2tVvxnu0DnJ3hXbkVUvasXLPnG
 hdX4d/E6dYW9pPiVOsWXrISnw6EMrc6lZOs5JEGQwc04jaXUwG+ib0B+yOIdmHRYatbO 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vx3045324
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfbrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:10:12 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011ABkY031839
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:10:11 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:10:11 -0800
Subject: [PATCH v22 0/5] xfs: online repair of rmap/quota/summary counters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:10:08 -0800
Message-ID: <157784100871.1364003.10658176827446969836.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this sixth part of the twenty-second revision of the online repair
patchset, we provide all the repair features that require the entire
filesystem to be frozen.

Patch 1 gives scrub the ability to freeze the filesystem so that it can
do scans and repairs in mostly-exclusive mode.

Patch 2 is unnecessary?  It provides async io for xfile, which has
massive overhead costs but mostly shuts up lockdep.

Patch 3 implements reverse mapping btree reconstruction.

Patch 4 reimplements quotacheck as an online operation.

Patch 5 implements a summary counter repair function.  In contrast to
its scrub-only counterpart, if we decide to repair the summary counters
we need to freeze the filesystem to prevent any concurrent operations
while we calculate the correct value for the summary counters.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-hard-problems

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-hard-problems
