Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E48C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbjEWJBO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbjEWJBM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A725811F
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:10 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EF9j027118;
        Tue, 23 May 2023 09:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=Rgl1Aesoba31wZHKLY+uiHxM5FfHwMtmgeRD3x+xmIs=;
 b=llpFo2uNsSVbHNiytkrr6psH0nddXLl4hUYFf6rNmiWjpnPwmSr4HgD+1M4ZpnZq+LnX
 WVj6LNwAODdwURXuK2w/b7oYb4EmNuGryGTViukjnyki4C0BqjLhhhpEK865wgVwvr3d
 OZFyMQ+LY5JlbsVZ3JJYPSFsUn2tnoeArP63JCuYCHDPCJh3BI39HkSiyDFAvlYQI2Ii
 TqJv0duCcnG0KiwmzWxUBt10UqmA6kPa0vA1QARRMKZV9sy5lbgGbXdpO1MIsOwuBULc
 PYzDGShn9ZGRlHRXnPnrTq+CRIjsDVzBbbU+B9PPT0aB52vKuT6mCvCoPJk5eBY5J/dB mw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp8ccp85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8SYxf029085;
        Tue, 23 May 2023 09:01:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj77s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:04 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrN007681;
        Tue, 23 May 2023 09:01:03 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-1;
        Tue, 23 May 2023 09:01:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 00/24] Metadump v2
Date:   Tue, 23 May 2023 14:30:26 +0530
Message-Id: <20230523090050.373545-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=873 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-ORIG-GUID: PUWKBTIb5jX5XYMcTF5oXYZSkXXJcvze
X-Proofpoint-GUID: PUWKBTIb5jX5XYMcTF5oXYZSkXXJcvze
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series extends metadump/mdrestore tools to be able to dump
contents of an external log device. It also adds the ability to copy
larger blocks (e.g. 4096 bytes instead of 512 bytes) into the metadump
file. These objectives are accomplished by introducing a new metadump
file format.

I have tested the patchset by extending metadump/mdrestore tests in
fstests to cover the newly introduced metadump v2 format. The tests
can be found at
https://github.com/chandanr/xfstests/commits/metadump-v2.

The patch series can also be obtained from
https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.

Chandan Babu R (24):
  metadump: Use boolean values true/false instead of 1/0
  mdrestore: Fix logic used to check if target device is large enough
  metadump: Define and use struct metadump
  metadump: Add initialization and release functions
  set_cur: Add support to read from external log device
  metadump: Dump external log device contents
  metadump: Postpone invocation of init_metadump()
  metadump: Introduce struct metadump_ops
  metadump: Introduce metadump v1 operations
  metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
  metadump: Define metadump v2 ondisk format structures and macros
  metadump: Define metadump ops for v2 format
  metadump: Add support for passing version option
  xfs_metadump.sh: Add support for passing version option
  xfs_metadump.8: Add description for the newly introduced -v option
  mdrestore: Define and use struct mdrestore
  mdrestore: Add open_device(), read_header() and show_info() functions
  mdrestore: Introduce struct mdrestore_ops
  mdrestore: Introduce mdrestore v1 operations
  mdrestore: Detect metadump version from metadump image
  mdrestore: Extract target device size verification into a function
  mdrestore: Define mdrestore ops for v2 format
  mdrestore: Add support for passing log device as an argument
  xfs_mdrestore.8: Add description for the newly introduced -l option

 db/io.c                   |  22 +-
 db/metadump.c             | 718 +++++++++++++++++++++++---------------
 db/type.c                 |   2 +
 db/type.h                 |   2 +-
 db/xfs_metadump.sh        |   3 +-
 include/xfs_metadump.h    |  34 +-
 man/man8/xfs_mdrestore.8  |   8 +
 man/man8/xfs_metadump.8   |  10 +
 mdrestore/xfs_mdrestore.c | 450 ++++++++++++++++++------
 9 files changed, 847 insertions(+), 402 deletions(-)

-- 
2.39.1

