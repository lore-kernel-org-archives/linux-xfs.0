Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D33C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B3B207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k6/Ck94y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgEVCxc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35222 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgEVCxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lQqH110486;
        Fri, 22 May 2020 02:53:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=JQ3BhrUnEMI5yMvbsjZgAGqSAR68Pt/FlY639BqtABM=;
 b=k6/Ck94y43IwUr0YPP/eHe+Ht0+xO22qCWKLpBEimedSLJz+vPu9wxkfrRZMJc683NC0
 MVh67ngnlRi4CKC0ojAOoiUC+jYR6hR8xO1/Hr4fxrHE45mQJRle9wGQ1oiBi17niLbb
 1ccWoPAcxWvV1Dc3ICCir2yBkMcXXRHg20CX6O4Wd5HEig5J5BKhq3npxzbAr9zHDz7H
 GG9KcTOqNFgjPNTiGQblo0VIwrFmrtPKl6u48PcovCJGk/+nOLsFwLibtzrjVWMy5bcs
 OpcOQoMhqkc8rh/bmckOJNJCGQ1gkBSd/QdoRV4smKTEMvlNqFmnSRParwTcOyDsEovp 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krkk0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nFRI173991;
        Fri, 22 May 2020 02:53:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3d3w5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2rREW029971;
        Fri, 22 May 2020 02:53:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:27 -0700
Subject: [PATCH v4 00/12] xfs: refactor incore inode walking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:53:26 -0700
Message-ID: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series prepares the incore inode walking code used by the
eofblocks/cowblocks scanner to handle deferred inode inactivation.
First we clean up the eofblocks/cowblocks incore inode walking code to
get rid of some of the warts left by reflink development.  Next, we
rip out the many trivial wrapper functions that don't add much value.
Finally, we refactor the various helpers and predicate functions to
reduce open-coded logic.

For v4 we get rid of the "ici" prefixes and merely straighten out the
inode walk function names to "xfs_inode_walk*".

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-inode-walk
---
 fs/xfs/xfs_icache.c      |  283 +++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h      |   51 +-------
 fs/xfs/xfs_ioctl.c       |   35 ++++++
 fs/xfs/xfs_qm_syscalls.c |   17 +--
 4 files changed, 176 insertions(+), 210 deletions(-)

