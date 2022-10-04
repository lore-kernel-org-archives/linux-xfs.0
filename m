Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7D8C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJDK2m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJDK2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:28:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E692CC9A
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:28:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2947UjHK000867;
        Tue, 4 Oct 2022 10:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=g4YlbEhHDwhzMmIZvku7bG62+WYwUzCH2938wCQMLrI=;
 b=r8TUyZJ7p6Kx2O8VEl9syo0kbVcB3CCnw+TB5ZcBrtwbqdznbX++w8/lF+qbZYpfh0nM
 jh4QhuBWyCedQU0pR8JfnKZIDUv40mjsxn3afRupqsp2xQtmn7gkxr8P1a/SA4dhHsJz
 uthtFOLNrORD5L/UD3I0cyy5q4fLPLZ3bmg0ZH7rUzOo7aeL3msaIPIgDmSh7rwlEZyH
 Tp37N4Rx/uBkAlGSbotR7AsI/cKzvW8nQgcKU5veP8HCO77bzbWdasj42U/MlkWpWQXO
 fEaUbfsYniXl7h9znuLCjDnw2MzXQQ0K1pug2HgO4M3K9HWulieNcIqA0slG7Qwh9Y0D uw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxd5tdxec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AWtA019846;
        Tue, 4 Oct 2022 10:28:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0abh0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:28:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbwHW+/F1k9IFHL0oa+Fd2U6mWrYqIZXPFn5FGFNQ+kzHTpnAlgtHl12MAl5FNva3gaZWshr53GF3QL3fjjKjOFU/WMFRerSEv1X1kbjOQJLLi2AIOinYsyCK0k34hDxiqIMs14FKO7Qmyt/jMn2GDGIphS07eMmEQoH8QmY/KEjX9jFgY9mJXd12AYi+Lb/cF2Vin91hWhaLJoHElGlvThm03j+JjstQQXKji9DY7xx+g9T8aGQlBhK3w/eGM484phh9Ce0D682SpdTLsw16IHPT0jlWTS0paa+BVKPYN8nBiXv05WaUV7PHUGE4jj22KhkIGDb9acoUxPj2m+ETQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4YlbEhHDwhzMmIZvku7bG62+WYwUzCH2938wCQMLrI=;
 b=GG1Q/29idyh0QIBZT205g3AfAngrWDLCrNgL4+O7Ghgta6IrTC9HlOCPooDPfnGq92wn1b8eqGQTKnKqZtLQE7bb7WXdz2TF1aw/LTni8UWr0WsFNfsZinSLFM8nJj2/Hz2qtmr/7/OOAoubuyDBErifbNTwcfT/tEcm7ctDAHeV7nqN/H1EDTGWUNGJTc1hAxeAAcFV9/N9UWJnmZD5Q76OrkYmEbvjGonJjJQy37q4Lr+hTbLttLpRSnAABHDjNGAxf79ztIR9i1zV6hMweIWYBtOxlr0u5PFLvzwT7rfsKLvXuRGMMqidcBD9zORRmZYpl0AxFO1RTKDNgxNhMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4YlbEhHDwhzMmIZvku7bG62+WYwUzCH2938wCQMLrI=;
 b=YC7JshfCp1rXbFhKb63xk2bcT1KJ7wWHtaBflDG++Rbq8AdfOl/84VCjgdyjLf/OaPKvQ7mVTIRgaO93tfZBrGLWaJHBXMcjs7Kr/8H+cvyxLDjOMtizzoeWkMqdlNbmW5RMfYJau7aRZZeIAdBwqnFE/3ozg9DMe5JCDINUttQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:28:29 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:28:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 00/11] xfs stable candidate patches for 5.4.y (from v5.6)
Date:   Tue,  4 Oct 2022 15:58:12 +0530
Message-Id: <20221004102823.1486946-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0017.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 4957a6c7-5f2b-4470-695f-08daa5f32de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ShC3zuDVHkHn+U2U50mbTA+giuluCnecn/QiJxygMBh2R1XsXYPoTSScvnjsPdr/LklaenY3YnDjHHDbcCvrjCMwskbzdel5+i8pVQfqDynWVGFzCNVJm/sWbh8TiyXToAZ6mEXJTms9kwp0NVLUkU02jo7FojmmQKWbiaWPZVP3ddtSK//r3h1vhLhq/xSUhvOEIoF4Um4sbjX25JZ/t1xCEN8aA03r/BtZedzHpNr535Yc412A1MorofGZVgTAYV3niD8AeZzji1rqQd89O/FR0ETE+FDqQ0+iuEKDOTnmqj5FKCkzxePruTV/2+C+dfZQNhnjYwjnDsFVDlcIB8M4c7sNG4Bu0gACYor8EvDN7mrZuxtI+g0m6cUY0y6HmEg9h0kRus4ai0pF2W+YHXiUaTQoeHIC7C5KWwmFyH4eliU8QXEvxSUr155pShaJ7DmUxdsoGFF+UTUyAkSQiCdUMIemvFLnaJYh1zQTDEgGmNf+bG8FZpoFgtfv7c0WmDY7T2PUcOIhR4MXdYg06tSj44lcaihS2F0OgDJeQrBnVl90MSmg2FibM6NKW+urlXl3/KzD0clqajwQhhl0uGitbin5WCBpojUq4n3/twjM51Xc2rjxR5RY/6mJ8nrfFyAGvH8Kpc0cjc846iETkiCcOqOe+esI3vnfwrc5FGZ4eeOMW8aRX2gfKkTq/BBgtKe6l1C4kmRLNGIObcIlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LZdTgasSUfzsHpSwGTRS/Zqe3l0aFQKQUia6MpcxJ63Q2BOV0o41SNUiuCTC?=
 =?us-ascii?Q?nx/IwSl4XqU7Y1ODlhHo91BGTaAXBRRU+pw3Ls+7TG8nX+dCGD3/WgAxcP6F?=
 =?us-ascii?Q?TeshQ253jpAKFt63sIQDTTeU3/hyFg7VxVBeiCEU97a0xkKPFgeYLuvWrXkk?=
 =?us-ascii?Q?qNmgVszD+VawMiyi/i9b2/dcgrb6dwZb98VEBCXMPXAUs5Q8BMf45T74GSv2?=
 =?us-ascii?Q?BW3OFZnqvoec21PQmIGPrl4OD5OuVIxR/CR+q/t+3FWqQHtTlFxceq5CFdVV?=
 =?us-ascii?Q?mRcVaIkhpxuKUelRQVYmWmQ1dWJOXXSjZG/bYUnbBbZoNLMOx4mrN+tlTqyA?=
 =?us-ascii?Q?XV7OLm4ZE0NhHm+H0p0Umca/llE1mK+qhXbEd4UVkTv6BJzhzgYz9P5tNHeW?=
 =?us-ascii?Q?mQDORO05XH0SgDhtDZ3dIWBZLfynpeH0aaIxVAVAvi+t19QJauEW5QZzS+Ab?=
 =?us-ascii?Q?wIj0n1p/JmJ3GZ7LploDS8Y6Dq95CRvOjJjSf8b5EvdpnUx9ivGxOCTLqqvg?=
 =?us-ascii?Q?bJiBR/nzLRYExAzwkqIk6ndjJAEksFySqaBaUn/NZ0ayp8g7EPyaN8naFDNo?=
 =?us-ascii?Q?Khn9jQ6jifWuoK8NpssyTtCHalkzdJsAbstYzEFXWNQSeWZRbXx/Jn7DtMBw?=
 =?us-ascii?Q?k62hdH6T2D5mPXKHOnkpfFQfsuG9RfskyO6Aeld0UF7G9ic9PnwM1+H5rV1y?=
 =?us-ascii?Q?Wljcdb0Rg0pVOuId5NYJtej28RRhWOWOZLXgWMu+K//VzRDwL0SI3CwAml8K?=
 =?us-ascii?Q?M8Kv/J4xtDCKeQo6YOExNDhJV1PTQeftT3JWvgGZQa8vIU0Dtcz9NrcRR4VN?=
 =?us-ascii?Q?IPLJOJuskbP/w/szjTGqyc7XUQibQCz1IMxnqR60Yqq9c33OYPhVrlXZ4jHU?=
 =?us-ascii?Q?KX1unfHuJBkT9gvUaGhyMkiAeISAwlKyQSY8hniBLX+3Y5oenRX7Quqtga27?=
 =?us-ascii?Q?s41sIt90erR7uIbuCrfph+FmBLlUjCuo551L8xl3FOZrBqeVcKBHrbmfK6Yp?=
 =?us-ascii?Q?hM13jlB8pWjFeKC9F6o+BUhmz3Jj3fCeTT3SVGt99bytLIqlFkWBHOzDy/BQ?=
 =?us-ascii?Q?JaLOA1Kdu+XCWx/SK4NUz+kJDxYfRjYFPjPaKDSbcH96xRyy9GVmjJLBSAgX?=
 =?us-ascii?Q?KUYxtKwmFjLB2d9Dou3xs1ldChk8GPraXBIQ1VPqvk5kQwJEGoAgbN74GCya?=
 =?us-ascii?Q?EVZ+FoHHq7BCF6+q1e8IqMp8xFEB5z1PsFsvIvCHWwDKpVikqHcCF1VnxesN?=
 =?us-ascii?Q?X52R4m0iDuBTwHLTLYYpNarKcWpyMWrPf7gQTU8mhz5NCtKXKlyaXNLXpAZQ?=
 =?us-ascii?Q?yLn8xNJ8l0gvnrd+4GVlRStQgtQtxGvYyS+ioKRLZx9wsT2+9nsuhxdrfSed?=
 =?us-ascii?Q?HgLwUqFEdO4N+rrhIRc9RnpRm/ubnc0nE4Q8ytmhVbxmngZM6PYCnO5IBZl3?=
 =?us-ascii?Q?k++bM8hPGi4rg5EEy4wgWBLiLLhSsvYEXQpi0yZtcYn6HabkQksI7X/n8JBr?=
 =?us-ascii?Q?DOQSmdHOgh9FrdXXJeKT5SCIBECHEBhnGiJfCqWd2lD953YKsscy+bR1NDim?=
 =?us-ascii?Q?R6Obf8/0Hpzj6ywGVt4M4vsVifgYQW5huv14w3MpDQiBWrT7E+8Q8Xx14loM?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4957a6c7-5f2b-4470-695f-08daa5f32de4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:28:29.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOr3krMsY8cQYjgeDiKeSQVn36hp4JkrYz22j3aNElqk71Nc2+Jc5hel4PRza0I4PJN47iOlDEHr/yiF7pnEUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: KhvL2H87GuLAfjDaFjQBEUHbLkIq9pvA
X-Proofpoint-GUID: KhvL2H87GuLAfjDaFjQBEUHbLkIq9pvA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

This 5.4.y backport series contains fixes from v5.6 release.

This patchset has been tested by executing fstests (via kdevops) using
the following XFS configurations,

1. No CRC (with 512 and 4k block size).
2. Reflink/Rmapbt (1k and 4k block size).
3. Reflink without Rmapbt.
4. External log device.

The following lists patches which required other dependency patches to
be included,
1. 4bbb04abb4ee2e1f7d65e52557ba1c4038ea43ed
   xfs: truncate should remove all blocks, not just to the end of the page cache
   - a5084865524dee1fe8ea1fee17c60b4369ad4f5e
     xfs: introduce XFS_MAX_FILEOFF
2. e8db2aafcedb7d88320ab83f1000f1606b26d4d7
   xfs: fix memory corruption during remote attr value buffer invalidation
   - 8edbb26b06023de31ad7d4c9b984d99f66577929
     xfs: refactor remote attr value buffer invalidation
3. 54027a49938bbee1af62fad191139b14d4ee5cd2
   xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
   - a39f089a25e75c3d17b955d8eb8bc781f23364f3
     xfs: move incore structures out of xfs_da_format.h
   - 0bb9d159bd018b271e783d3b2d3bc82fa0727321
     xfs: streamline xfs_attr3_leaf_inactive

Christoph Hellwig (3):
  xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
  xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
  xfs: move incore structures out of xfs_da_format.h

Darrick J. Wong (7):
  xfs: introduce XFS_MAX_FILEOFF
  xfs: truncate should remove all blocks, not just to the end of the
    page cache
  xfs: fix s_maxbytes computation on 32-bit kernels
  xfs: refactor remote attr value buffer invalidation
  xfs: fix memory corruption during remote attr value buffer
    invalidation
  xfs: streamline xfs_attr3_leaf_inactive
  xfs: fix uninitialized variable in xfs_attr3_leaf_inactive

YueHaibing (1):
  xfs: remove unused variable 'done'

 fs/xfs/libxfs/xfs_attr.c        |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
 fs/xfs/libxfs/xfs_attr_leaf.h   |  26 ++++--
 fs/xfs/libxfs/xfs_attr_remote.c |  85 +++++++++++++------
 fs/xfs/libxfs/xfs_attr_remote.h |   2 +
 fs/xfs/libxfs/xfs_da_btree.h    |  17 +++-
 fs/xfs/libxfs/xfs_da_format.c   |   1 +
 fs/xfs/libxfs/xfs_da_format.h   |  59 -------------
 fs/xfs/libxfs/xfs_dir2.h        |   2 +
 fs/xfs/libxfs/xfs_dir2_priv.h   |  19 +++++
 fs/xfs/libxfs/xfs_format.h      |   7 ++
 fs/xfs/xfs_attr_inactive.c      | 146 +++++++++-----------------------
 fs/xfs/xfs_file.c               |   7 +-
 fs/xfs/xfs_inode.c              |  25 +++---
 fs/xfs/xfs_reflink.c            |   3 +-
 fs/xfs/xfs_super.c              |  48 +++++------
 16 files changed, 212 insertions(+), 241 deletions(-)

-- 
2.35.1

