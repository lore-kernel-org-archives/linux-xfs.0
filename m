Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B76C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63A4A20738
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cUhUdW81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgFBE1B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBE1A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524I62l121464;
        Tue, 2 Jun 2020 04:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cHZmOPFoJKxlwBVB2Ps/miCwZM6dRvI/jKoZGS2zFHE=;
 b=cUhUdW81V+CIumNDnAg1jc4P9dvv5LfFEmFFjoJLb+iXqabvQgDMqAnXwEFsFUSjiXGS
 YfxKtLfxG47+IlD8MKeeezHkRkxc0ZJRK6psZZDjtzpdBb3MJEVwmdmB8K0Q4JvDzqgY
 Sr4QxovzYKVb+YGdHf6dZa07rOfkKIYRblX9vzLXJ6RwozJ//b8R9tIU/WumbCj0vfVM
 IqXLfNQBgxfzAF392k0Ey5f3BQPck8gGgIZSfQnzSOIvbE0fuXRXN7o6px3EefnInvnJ
 UAnjl95Ym3UGdLF1lAnrIw3ibtyiMUt8+pUwNCjIg2uBkDCDL5LmGF3YKwO5r0r1in63 Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31d5qr20q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:26:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuLK126634;
        Tue, 2 Jun 2020 04:26:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25mnj9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:26:55 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524QsfD020957;
        Tue, 2 Jun 2020 04:26:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:26:54 -0700
Subject: [PATCH v6 00/12] xfs_repair: use btree bulk loading
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:26:53 -0700
Message-ID: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In preparation for landing the online fs repair feature, it was
necessary to design a generic btree bulk loading module that it could
use.  Fortunately, xfs_repair has four of these (for the four btree
types), so I synthesized one generic version and pushed it into the
kernel libxfs in 5.7.

That being done, port xfs_repair to use the generic btree bulk loader.
In addition to dropping a lot of code from xfs_repair, this also enables
us to control the fullness of the tree nodes in the rebuilt indices for
testing.

For v5 I rebased the support code from my kernel tree, and fixed some
of the more obvious warts that Brian found in v4.

For v6 I shortened function prefixes, stripped out all the code that
wasn't strictly necessary, and moved the new code to a separate file
so that phase5.c will be less cluttered.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-bulk-load
---
 include/libxfs.h         |    1 
 libxfs/libxfs_api_defs.h |    8 
 repair/Makefile          |    4 
 repair/agbtree.c         |  659 +++++++++++++
 repair/agbtree.h         |   62 +
 repair/bulkload.c        |  134 +++
 repair/bulkload.h        |   59 +
 repair/phase5.c          | 2397 ++++------------------------------------------
 repair/xfs_repair.c      |   17 
 9 files changed, 1164 insertions(+), 2177 deletions(-)
 create mode 100644 repair/agbtree.c
 create mode 100644 repair/agbtree.h
 create mode 100644 repair/bulkload.c
 create mode 100644 repair/bulkload.h

