Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1449C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6D320872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eN4GWsEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407409AbgJZXkC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:40:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58348 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407403AbgJZXkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:40:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXtM164622;
        Mon, 26 Oct 2020 23:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=esPJcbr1PaAqdR2RFEyzhWMnwthj5aHmVmPZO1mi5GM=;
 b=eN4GWsEwKYqOpugRYR1hM0ksek8Z34AaB8n+SV2TsVP4Oj7OBUF/Do+bK2nNvbBAEY+C
 9wycJ+aOMbTDl2h0+Xg262ziVn+Eg8fDaeWGpGD1hAt80y+9KPPU4Fp2L6ak8iHE+IvA
 kZhvE0cJGNN0S5ux7QpwhWdiR+wjJOo0feK39pHykOVwObjN8AwevLaM1D5qUMH110uI
 5cjiIR97x6SlfZG2Y0cORlCaNp/kBw2gqpj/QGVbCgjsGSr+VqwD/kfD5Cz1+IBycGm8
 CL31/QglXAmgr2/vh60QROmkyLG48tEZ2DhocxODzICo8v25v5WtXzGnEtAFipCNfhsN NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm3vuva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQN31058427;
        Mon, 26 Oct 2020 23:36:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwukr9qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:36:59 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNawRL008356;
        Mon, 26 Oct 2020 23:36:58 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:36:58 -0700
Subject: [PATCH 00/21] xfsprogs: sync with 5.10, part 2
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:36:57 -0700
Message-ID: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The second part of syncing libxfs with 5.10.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.10-sync-part2
---
 db/attrshort.c             |   46 ++++-----
 db/check.c                 |    4 -
 db/inode.c                 |    4 -
 db/metadump.c              |   12 +-
 include/platform_defs.h.in |   27 +++++
 include/xfs_inode.h        |    6 +
 include/xfs_trace.h        |    2 
 include/xfs_trans.h        |   25 +++++
 libxfs/libxfs_api_defs.h   |    1 
 libxfs/rdwr.c              |   11 ++
 libxfs/trans.c             |    1 
 libxfs/xfs_alloc.c         |    1 
 libxfs/xfs_attr.c          |   14 ++-
 libxfs/xfs_attr_leaf.c     |   43 ++++----
 libxfs/xfs_attr_remote.c   |    2 
 libxfs/xfs_attr_sf.h       |   29 ++++--
 libxfs/xfs_bmap.c          |   19 ++--
 libxfs/xfs_bmap.h          |    2 
 libxfs/xfs_da_format.h     |   24 ++---
 libxfs/xfs_defer.c         |  230 ++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_defer.h         |   37 +++++++
 libxfs/xfs_inode_buf.h     |    2 
 libxfs/xfs_rmap.c          |   27 +++--
 libxfs/xfs_rtbitmap.c      |   11 +-
 repair/attr_repair.c       |   24 ++---
 repair/dinode.c            |    6 +
 26 files changed, 464 insertions(+), 146 deletions(-)

