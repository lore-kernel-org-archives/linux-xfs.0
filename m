Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B260C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 02:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiLGCX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiLGCXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 21:23:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168154B755
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 18:23:55 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKX5Y001109
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:23:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=s3rxKsxfUgP+ZDvUVZ9KGKNVdQ/umnwZyTX5Fg2kSBs=;
 b=YeLmrmZvRtupq6Pq2ZIFRzrqj5BshFuHdOsX0bkflG9jAMG8L1AM4PJT0RF1jyvW7naY
 Nj2XF43Kuz9+8+jdeXir9huhf1q/NKJ9YrHXBaaBHGqQf+gUHFDbC1t2k1RvXxgma6Z7
 a4v9a+2mOdfneyUZDig1zqDIhrIMVzLwBXG3KvqJhuDpkyD6BQOSUF85j01Wo+T/ysRw
 UNsSx22/Wulel7yuctTKL8DUS5NSDbRB/K21GHReUQilzgWB1BRuzCWzc8ZazBF7tKWc
 Dl351CuhQ2/MOr1UMW1szAF2VfbYPtAvSvUlBtPC4uqp62OmFIUqnjsQ4J2wpUQ9WgoB 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya49h5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:23:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B70359P026084
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:23:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8etx5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:23:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZXEJ7enOndoqXkjt0J0Vjo7DR2HYppjp0viS5WKxeXPYyzwx8FRyLMoYqNcFTf3263KJBfV3d/Nt0DmKhaQqfrCUbG9ZONSLr5n/ZOZ0eiCjw56m0i6Ubo42Lb7Kn4faROcaeNct+zEX6b3VpmlAv0FdEl0D5fTjMTDqJKD6zbW33WnMoquHNGUa895UCPghp3kuTn05h/nzoBh3I+4u/MtgnLJUYOxcFOH+n9v/gdNdfk1xczOUTtGaTD7WaIMkA40UHcRyDahPYoKn8lTz6F7VJgjjGjGvrJWH8o1KMy1sQ+/AfJqg3VPaUXyIxqD/OOecTqDzFhsl2+NmX5d0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3rxKsxfUgP+ZDvUVZ9KGKNVdQ/umnwZyTX5Fg2kSBs=;
 b=L4I+mU10+rK0VI4OcTMGJ/5yBDoTcn+kQe4SdB83TE2bL6MAeHLIVTL8ddkpwzN0ODIK119OnoKUM2HCoc5qhgv3Tm9hqibYMMw3XwC1rQxkyoLW4JwRInc/0fW9Hlb6Z1NXFl+k3WDgyzmN2JhHzXMvdxF63wG3y2s4IvdbzBmbrgRX+mi792eWsc8q5wy0d6OltEpWwEocob8CKeHzN0uRa+lc7GfmlpJllaG7vOgRFYEMbphSipZKZPnyGhvUFE+MpwkeOgwaSm9H6pS4QVy4RSowaFU2Vuhlp7I0IGgvRsqjkP/ZInc6oocYP4dTDbAgBt92GaFyhyA9IRo4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3rxKsxfUgP+ZDvUVZ9KGKNVdQ/umnwZyTX5Fg2kSBs=;
 b=IgSN+liqWetqGenv1zpTaWmlnwoGtI1xnZDK/6oy7BtJgRodOu5r1BCMvWJ1o4IEjYnF2IppYB24/ZqgCMHRYyI5IiFonAnKfTMaKU54gqusWy9q7itf1gbzZIuiM2T4i8pYc2DgAD6j0isChIaadLq0zGgRQj4/uvjPzGIRxjw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6983.namprd10.prod.outlook.com (2603:10b6:510:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 02:23:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 02:23:51 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/2] xfs_io: add fsuuid command
Date:   Tue,  6 Dec 2022 18:23:45 -0800
Message-Id: <20221207022346.56671-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221207022346.56671-1-catherine.hoang@oracle.com>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:a03:117::25) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: cb57a7ea-c380-401c-9bc4-08dad7fa14ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LiCj4IYO/nOiM69+QfBHjUoeP+H6FN6hZITqn0bm7NRqaR8Dm1CWt8zsaWTR39xNK94LJcRKS627wS1sCxgsbzTDx11WpnxIvrg1DdjAkVfPFXZTmaS/HmROifN36pBUdGo/eQE2OxqTfpNnN2sRY7vbHFhubc7ZoSErTm90xStAkawFHn25Xt5DgJs9mm/jBVSPrDuG8oI4D+L/N6OzfdsU++ifBWPDikTUKV7pz26HLXBKxpGz+Vbe6/6G7o0Z8lq4VpTeUOG6CbtQ3HM/F8HfR96+6/u/+1MrlMFxTws+EZUyRIDYgGhlDnp435J0E1glZcuDrKuF/IWaXKSAcGqnaTcLDJLVHXOXpfOYVte95kD15d8m5UV6u9VlfGd/tm4+GJmXKTqyiXOsmkww+GaU1aubzi285pZIvM7yJrqcZJHGH194iHxRowgICP9XRBYTiwtQe8rXOHHhCpKjqx54NoNwMNXMO1vV8NAfX28oGVbJFSdojCDRANbmM7goPK4NKdQFDhzOCkDYr5eOiJ5F265sRnUNSf5ZTMsxM6HxUKmmhMfBSn+4SG8uiIe3ql0Jfr7wxHQiUSsoTaE88Uavc6oqLkkYFSapBWsTzmb8RlUBWmvlL/GVrmTtux9Px+rFy3Ycu4g6OEI9+Bw0Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(2906002)(44832011)(478600001)(6486002)(66476007)(41300700001)(8676002)(66556008)(86362001)(8936002)(5660300002)(66946007)(36756003)(6512007)(1076003)(186003)(2616005)(6916009)(38100700002)(6666004)(83380400001)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ni34Vfyt3BxHIwdDddOp0BOg1Q14TQADC2Ch4kZgjIvf+3DZrdUipVC54LUv?=
 =?us-ascii?Q?xr4Vakb+bjD3pj/PM0ts/VjNA+ta88//3cjGyck7iDU4E73RqTpm5WsBwqG3?=
 =?us-ascii?Q?v/0k90Kg0WxdpzlcyHIlg+zPqwtBsY5PQfSrXQY+lpE1EnxOFHhJJsjoM5VH?=
 =?us-ascii?Q?RNbb8kZD0uUW/qc81g9vm8wyRV882f9vddwhyXfW9q65pEFH4jTS+zIkZ1lz?=
 =?us-ascii?Q?88dPZ+icAv1moC2bn0pksOlIQXCvpcN3o6Qu8n+G9S/Fkfl09U70vPi8BGst?=
 =?us-ascii?Q?rvksMkbWfjbWMel/ao//j/1hCfkIMKelsXYH/371zlX4nlW0ZB/vEV8CWwSp?=
 =?us-ascii?Q?QYrBCE70IWrzQ1Mw9Hv5ngEElGhJqpPrEX5BjIm54fAhBAr6zoVMgua3inHO?=
 =?us-ascii?Q?zy3cq54n9jvg8sn7tc1+r+jNY5o9vb9z5LlsxSEXTUfMoBZ0YWD2oA5yiiOH?=
 =?us-ascii?Q?IfVCPGuyOmQkgLVBjw3adGfKZn7mBsIGE6B052pDDlvTVtAr4EwB3bYO29tM?=
 =?us-ascii?Q?FafMMp2sTL6BW8v+c0QczuX+SOrPn5CoLNgR1WRsEG1u8HONFI5485RhYj/f?=
 =?us-ascii?Q?xTr5JzN3hNodutiAgbHpgMYPiyZOohKWLKWx5kZNQc9no83CgglDm//vWBgQ?=
 =?us-ascii?Q?Vs39NDEsEveanD3ZIGS1Ia0LXEjgkds3t8W5SbQFUuRvG9OroIGashNgY9lu?=
 =?us-ascii?Q?8xP6gyuXS0ABMf5TI5KqkRl/8zasTS+BHzU5R+1wzujPFWahaQp28Wn7k81Z?=
 =?us-ascii?Q?e3Ir45JplwGhXzFQT5SwRelNRM9MUEK3Br81BAugtsqtnbKYz+hvtBG9JyEb?=
 =?us-ascii?Q?18ynkia3bfYStCDds3o6wpHmozLxhnMDvLi7Vef6yS6p8tRLQRKRL4WkVcJE?=
 =?us-ascii?Q?eODQ6klmJCVaFp1GEnXcyJp4gy9V0QsxqbUjG8l1YJsl/8UsMnnsM3sElR6b?=
 =?us-ascii?Q?BRQlRZlKsYjygU/1Czrmr4M/FaNNn5fDVtBHTnzkA52robtERBaMeFP87e/7?=
 =?us-ascii?Q?rbOXBLwlpZho2NgCzQY7qKzVZ/BlljuaVUlVbcfo/6mNzWdls+aTCaWc5DXh?=
 =?us-ascii?Q?k8KEc0NnGwQxFkp40QXIW19k5Zf48wDBM3L1vQy30JmUjxdE75a8HqPWuY4q?=
 =?us-ascii?Q?BvCvhWrl7ANSMLmPm+lsSnd08AN0gGRlEXV8bUSydqmscgnVtvVTaViKJpcp?=
 =?us-ascii?Q?gJHUqF7d50zTTBJuQh1S7nCfFUPUYvGdVt41CfE8+nMuKoM1U4YoatNPX28F?=
 =?us-ascii?Q?FGLJ9kXpz4g0bxLljNTFBZFYoebhV05L4h9Z0dIwgMl+DGpcqXwkEXdWFIXF?=
 =?us-ascii?Q?Kthi2GcfoHkRDC4jZXZp1fAi+ED6Vb1nhU6fVBlHOsixsyL66Z0IwPWEQvKk?=
 =?us-ascii?Q?TknLHRcROSzm5QDI1KEeWx3alP6BcVAv89OH06+CFGbVlfwJudJhVmgHSKF9?=
 =?us-ascii?Q?dxKs3m77xJZWsWqy6gkw9gM45D54E/spcMIH/vbgfkX5yKdNylmcXCB+PuGN?=
 =?us-ascii?Q?aRdjHVw+/Qep0nQ+MFh4Az04xomuKnwmFdGNUG+baazUsmq8saCybsYxALnA?=
 =?us-ascii?Q?PhcwAIOprLytoCPmyC4+aZ1lOQXsKCqUKd5A1fl3vGuf7lO3WzPiAyjrZKAy?=
 =?us-ascii?Q?AwZl/YjJpGgDyrK/wtegFlNIyNrGUwx+g3ftQkNJxaILcQuCizZbeyrZGfYM?=
 =?us-ascii?Q?/ZUA0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tY/XTZkIkYO9IKDTffdDso1Tx5PXhorJe+nEZtx9ceRbi4SQjrM6E94cyj7xFLc+QQIWT/NS3+abv+t86RcoS8bqJKOYI7S7H6t38xAu2HB+IF6cTbj4CWXWdu2lvqEdOVS2TZL200ZylkP73QEoVdYBPjjqWko0MjbBB3LdEVvW9o5rQf6XKQXaUZv4b/p2Q3B05KkG559w5mLXWXbdhwLKwt8yUFBK80P9FRMRqy447iKURU622BM4x8WygSpe5j6IR1ciEaqjblJwIJqLWur2kLSeXsnk00wIY/7DYvzHXpwvjTF9RHtvgq9EUOLEP/y3HDMZ1gYXGPTuBMwdNWSG8VuuIGaw0LnH36u+so5g/yIo5jrdyWQDSg5DedI/qXuvQRymi/98iQXf/27h1i3lkyezLYIK+Fssnkq8i+vcIQEORpCZ07pNIfHMnRyYr3tBp5dhRvbBArr+iXx6vZ1bQhWSV+a8QjB1wGwe8slnY5ObbxRaiTnpESpkPx80NdsiTnbmswWBei68wE0AkjmxE3DPnBbFqNO5M6z5n5dltQdt8V8dFA6ot4QSI0bPy8sdghEnBxBRRjqZK2oAMReDu/fcQuuDqctGvgsiF1+hsOhHBuA6BkJlP8uZ/ErQksFqJS5fay55J3BvTCEKEaF0P2GZrXSGFn1P8JUyUneIC3k0exL1L1r7mj0yzMxB0ZIRWNysX1CMP5k1WT/SZqw52Etqq9R4iOgMHDGI+mHnepV1UGwRfKHl5my+7qeHZBn6aCDpvv2BLBmgnR/4AQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb57a7ea-c380-401c-9bc4-08dad7fa14ba
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:23:51.8103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rFIN26BT24QsD5dG9QMnp3+csQdl3/2telpQlN3bB0r7dZhllwxiyqq7igMCvfo8LmDxrQLdqpzPfUZVNND3x+HxU/36+LI179Ma/u1hEQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070014
X-Proofpoint-GUID: m6d6r1g-DFxIyjCwo0p8hgZQdUTNLP0a
X-Proofpoint-ORIG-GUID: m6d6r1g-DFxIyjCwo0p8hgZQdUTNLP0a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for the fsuuid command to retrieve the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 io/Makefile |  6 +++---
 io/fsuuid.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c   |  1 +
 io/io.h     |  1 +
 4 files changed, 54 insertions(+), 3 deletions(-)
 create mode 100644 io/fsuuid.c

diff --git a/io/Makefile b/io/Makefile
index 498174cf..53fef09e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,12 +10,12 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
-	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
-	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
+	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
+	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
 	truncate.c utimes.c
 
-LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/io/fsuuid.c b/io/fsuuid.c
new file mode 100644
index 00000000..7e14a95d
--- /dev/null
+++ b/io/fsuuid.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/logging.h"
+
+static cmdinfo_t fsuuid_cmd;
+
+static int
+fsuuid_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fsop_geom	fsgeo;
+	int			ret;
+	char			bp[40];
+
+	ret = -xfrog_geometry(file->fd, &fsgeo);
+
+	if (ret) {
+		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
+		exitcode = 1;
+	} else {
+		platform_uuid_unparse((uuid_t *)fsgeo.uuid, bp);
+		printf("UUID = %s\n", bp);
+	}
+
+	return 0;
+}
+
+void
+fsuuid_init(void)
+{
+	fsuuid_cmd.name = "fsuuid";
+	fsuuid_cmd.cfunc = fsuuid_f;
+	fsuuid_cmd.argmin = 0;
+	fsuuid_cmd.argmax = 0;
+	fsuuid_cmd.flags = CMD_FLAG_ONESHOT | CMD_NOMAP_OK;
+	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
+
+	add_command(&fsuuid_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 033ed67d..104cd2c1 100644
--- a/io/init.c
+++ b/io/init.c
@@ -56,6 +56,7 @@ init_commands(void)
 	flink_init();
 	freeze_init();
 	fsmap_init();
+	fsuuid_init();
 	fsync_init();
 	getrusage_init();
 	help_init();
diff --git a/io/io.h b/io/io.h
index 64b7a663..fe474faf 100644
--- a/io/io.h
+++ b/io/io.h
@@ -94,6 +94,7 @@ extern void		encrypt_init(void);
 extern void		file_init(void);
 extern void		flink_init(void);
 extern void		freeze_init(void);
+extern void		fsuuid_init(void);
 extern void		fsync_init(void);
 extern void		getrusage_init(void);
 extern void		help_init(void);
-- 
2.25.1

