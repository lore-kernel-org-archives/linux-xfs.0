Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D46CC32764
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E632064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BcCZaUCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgAABJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190Pw091259
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=RKJFK5Jgsnl/bIlT1wWTHqQynX0X/g6z9tcd0mHkKhY=;
 b=BcCZaUCzYWXMgiudbF6Pe3KTkl4u3GQATy5Bctq+irTxVNteedGYOf4Iul3sCsZmIsVQ
 u5HIvL9bfweJzEsmKkt/5YCwzRaIVHc91NVSexbpxGM1wiBr5QmkYgqo9h8Y3VOLfhsz
 YnMgfBfXCa8+472K8QNpdilQ9BwE6sanu6Ql+1uoKMuvMMoG2RwqsES+H8jrHCsNtJ3t
 Nd14EzaCvJfHTgxbtwV7C9g4oEWFGmTPPARQT00wiVekXjLnMO79NKQrOG0xcKq0uJyI
 uAk/GTUQQzGMYYOVR4W38w1oD46763IgMEjwHwXu0RFdpVqBRBOdfP+58fz4me4onpKL uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vwn045324
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x7medfaqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00117w8r027144
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:58 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:58 -0800
Subject: [PATCH 0/6] xfs: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:56 -0800
Message-ID: <157784087594.1361683.5987233633798863051.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=701
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=758 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, we treat the garbage collection of post-EOF preallocations
and copy-on-write preallocations as totally separate tasks -- different
incore inode tags, different workqueues, etc.  This is wasteful of radix
tree tags and workqueue resources since we effectively have parallel
code paths to do the same thing.

Therefore, consolidate both functions under one radix tree bit and one
workqueue function that scans an inode for both things at the same time.
At the end of the series we make the scanning per-AG instead of per-fs
so that the scanning can run in parallel.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=eofblocks-consolidation
