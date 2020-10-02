Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BB4C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2436B20796
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 04:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eC8gGUV3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgJBEtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 00:49:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40640 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgJBEtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 00:49:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924mAi5092526
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HU8HtXBpdiL8cp3pYCeHbpAyCt8dN71H2bua3PHdQUw=;
 b=eC8gGUV3rVefdFTrowvhvDDTs525sH+JNesp6JS4vGJRHLtkk6LpYlzvI0ArynBCuDvX
 SHIvofdkwhkHm9EjOVxqbjNuj32pWRtaOX+h+ohONOB2uuhUXlSjGWKCWcYkRtUBU7uo
 yezgvrz51uQWR782E4T8uijMFAMUvSvYST3YXqHEGIi51ZdcFHvfGGXNlQsmjm/wNtRe
 wpo9ylt7Dbi7JrU3yw+V8tlC+9EHeS/I9kgAiTBVmLHoLtUY0bEqkFLa+db9MDrXu4e7
 A6ADauGFokqZVuHcthXZvT+txH8m13KxpLeL1zh5YDpLrbkkz+66iQmRhBLQCXePsKaV eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33wupg064w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 04:49:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0924isad008449
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdx1r0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 04:49:20 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0924nJQG026186
        for <linux-xfs@vger.kernel.org>; Fri, 2 Oct 2020 04:49:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 21:49:19 -0700
Subject: [PATCH 0/2] xfs: a few fixes and cleanups to GETFSMAP
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 01 Oct 2020 21:49:18 -0700
Message-ID: <160161415855.1967459.13623226657245838117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=956 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=965
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020035
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
from copying things to userspace, which is a bit expensive.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-cleanups-5.10
---
 fs/xfs/xfs_fsmap.c |   38 +++++++++++++++++------------
 fs/xfs/xfs_fsmap.h |    6 +----
 fs/xfs/xfs_ioctl.c |   69 ++++++++++++++++++++++------------------------------
 3 files changed, 53 insertions(+), 60 deletions(-)

