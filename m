Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD1CC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F85D20853
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 18:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ad9JHVvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgJESVb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 14:21:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44032 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJESVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 14:21:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA8l8148457;
        Mon, 5 Oct 2020 18:21:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=QB49Bm7H3lZB0K74MEPO2GTon/xwVxY3dt6usbTPdmM=;
 b=Ad9JHVvE5iuHLlUw623bQNXhm4S5eBaj6j0VdmXI6otR1t6vRtBXTQ6yJhrldNGxOiSG
 dRx0vWggVsLQoDqkwAy/Y6F77mkY/4+wSH6oJbVk1SLDudG1NehGM5yiuzWGHvcLZO6X
 ygKK1zuxSBp/2WnfKk7wNhv/bTsjqeYXSN0iN36S6dO2x8Wmo1/tPFQlmzm9uIekT1/t
 18QJhOBevt4c5bA4xivDlfJF1mnaIAGsW9IwsTKhQSvKsU9t2oFEVzVcVGghSU53aW8r
 VwL9vk9qcdmwmR4UcuR3j3gXz9MlAGfuoL/Bdh6siIPH2tzBLKE8Dv7ZX7kD/wTdjr5q jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetaq759-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 18:21:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095IA6oR019269;
        Mon, 5 Oct 2020 18:21:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y37vn4v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 18:21:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 095ILPhu031138;
        Mon, 5 Oct 2020 18:21:25 GMT
Received: from localhost (/10.159.154.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 11:21:25 -0700
Subject: [PATCH v2 0/2] xfs: a few fixes and cleanups to GETFSMAP
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, chandanrlinux@gmail.com
Date:   Mon, 05 Oct 2020 11:21:23 -0700
Message-ID: <160192208358.2569942.13189278742183856412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050134
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This quick series cleans up a few warts in the XFS GETFSMAP ioctl
implementation.  The first patch prevents an integer overflow when
counting the mappings.  The second patch improves performance of the
ioctl by formatting reverse mappings to an in-kernel buffer and then
copying the entire buffer to userspace (instead of copying the records
one by one).  That eliminates an indirect call and a lot of overhead
from copying things to userspace, which is a bit expensive.  It also
fixes a deadlock when formatting rt fsmappings into a mmap region
backed by sparse file on the rt device.

v2: constrain the in-kernel memory buffer size

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-cleanups-5.10
---
 fs/xfs/xfs_fsmap.c |   48 ++++++++++-------
 fs/xfs/xfs_fsmap.h |    6 --
 fs/xfs/xfs_ioctl.c |  146 +++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 128 insertions(+), 72 deletions(-)

