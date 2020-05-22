Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393F6C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F11207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZINPTE8v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgEVCzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:55:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38546 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgEVCzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:55:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lhfV069710;
        Fri, 22 May 2020 02:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=xOSpJfUyPbNjo+ougPYD60CodtBBlO5952vWfZmOBJc=;
 b=ZINPTE8vJmaEyc32HD/FFTJfgOfj2H49WeM33WTnktfRikqouQFViuHbecWMJcGKzuUC
 Xt+yLFZYL9xi01tOMfqWnw4t2T6qtgSEqvcCBCMqXYxt93AYl82jg7VmleWJzX/QqEVT
 9ASs+TED3polTZMsCuiGkXqyJtohj1N6do5FgguZfYixFfxdfnHCNutq86c5G26+e7Vo
 MfHpuJdQCtO/qKG73g5Vbn4Vwgt1rKWGKswTXdJxL/4qd3fhKOKN9m4r/twcQfqt7+LG
 QxPGh96tY2RGRw5FvrJa3SADcMeU/HTxLbHzpE2IwLxsJOlphr5+etuN2hBNO1aB9XK4 tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31501rj2n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:55:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2mhUp008812;
        Fri, 22 May 2020 02:52:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj6puep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:52:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2qunr004186;
        Fri, 22 May 2020 02:52:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:52:55 -0700
Subject: [PATCH v3 0/4] xfs: fix stale disk exposure after crash
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        hch@infradead.org, bfoster@redhat.com
Date:   Thu, 21 May 2020 19:52:54 -0700
Message-ID: <159011597442.76931.7800023221007221972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set of patches try to shrink the window during which a crash during
writeback can expose stale disk contents.  The first patch causes
delalloc reservations to be converted to unwritten extents for any
writeback that's going on within EOF.  The second patch fixes a minor
error encountered during writeback; and the third patch fixes
speculative preallocation to work when the EOF block could be unwritten.

v3 puts the extent tree walk into the dynamic prealloc sizing function.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=stale-exposure

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=stale-exposure
---
 fs/xfs/libxfs/xfs_bmap.c |   28 ++++++++----
 fs/xfs/xfs_iomap.c       |  104 +++++++++++++++++++++++-----------------------
 2 files changed, 69 insertions(+), 63 deletions(-)

