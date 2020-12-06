Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986D0C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E3223120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgLFXKb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:10:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgLFXKa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:10:30 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N9jjw022985;
        Sun, 6 Dec 2020 23:09:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=kUauaTZjKTzd/XzZhq0zhmxC128wnGtOnOwT0/GpbX0=;
 b=cCdIQvrx+3HGXYnleZkCduvDvvLs1iUjcT8WnyD1XXe0RcDa3XdyF1MneHJujI//NdOP
 okpT9uxdJ03juiMMcd1USvh6sRNkGxAWJKT9mDC2m4dUL+Tm6qluHwWjIzVgo0ecxfx9
 kmmXxiaMa0w8kq0XC/qmL1WoJHzCOuD8J0MXXpCCOwBUP8NujXOorvyr4U5c0ng/GxWb
 Q8ZZ6HPQT19eY/BrPPDqlQQ/zFTHbvpQFdJjQXSu8bH8mMks6t1cs1XpY82H0NXBdvWv
 HC6vnhWFkimrK0IYeNgxJAJOed11HKEtceEzakE1WPaPl2yoJzFvS8yTfybXhkZhytYW xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqbk0uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:09:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6MQR192663;
        Sun, 6 Dec 2020 23:09:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3vpcs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:09:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6N9iuT007002;
        Sun, 6 Dec 2020 23:09:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:09:43 -0800
Subject: [PATCH v3 00/10] xfs: strengthen log intent validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sun, 06 Dec 2020 15:09:42 -0800
Message-ID: <160729618252.1607103.863261260798043728.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset hoists the code that checks log intent record validation
into separate functions, and reworks them to use the standard field
validation predicates instead of open-coding them.  This strengthens log
recovery against (some) fuzzed log items.

v2: rearrange some of the checks per hch; report intent item corruption
v3: call XFS_CORRUPTION_ERROR to dump the bad intent item to dmesg

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-recovered-log-intent-validation-5.11
---
 fs/xfs/xfs_bmap_item.c     |   78 +++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_extfree_item.c  |   32 ++++++++++++++----
 fs/xfs/xfs_log_recover.c   |    5 ++-
 fs/xfs/xfs_refcount_item.c |   61 +++++++++++++++++++++++-----------
 fs/xfs/xfs_rmap_item.c     |   76 +++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trace.h         |   18 ++++++++++
 6 files changed, 188 insertions(+), 82 deletions(-)

