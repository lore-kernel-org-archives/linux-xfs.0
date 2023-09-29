Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C678CE732D0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjI2Jy3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjI2Jy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ACC199
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK9Qj6019170;
        Fri, 29 Sep 2023 09:54:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=uRezmoaW9M7/tdtG2MUFn3a20ZX+t0e4gPV172Savjw=;
 b=Q21iWWLfSSALa1F50GwbcHXBP7tznyVE/yKyqZNiGfkPzM3djzgUODgZsq0aXJZhJJeO
 PLMqtzFfJ5meV1q9DiPKii/j0eC8NdKYcj0J+ccDIs1bxUcqIsgIiktNcdBAmLpJYT2/
 Xbm6nLsXlr0xEJ28lgUNxIilXFBic+yySwpiujBTXIck8kr+obpiJqnKot+dZY8+hFNz
 5EzrHMfm5tClgHz4DRhKHf4xt+AObJJmnRCEVDM0ft4D8FBp8bPlDz73kollTtucngpZ
 Z1Q6khvNK29DeLX5+NjjPRZqoEOuIwbYIt+wesK+LncqTTTJFVbjd5F3YUAZgwjZ0NUx CQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9rjupd9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T81nsg013858;
        Fri, 29 Sep 2023 09:54:18 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfbkk6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEHwdsYJJcZB5pu5Zlr76j++scs5aaZ5uaaW/RAwYqkzDsl8HayyIlNUStbXTRxD+H7pOrtT20HaztuZCdn8LOXxT7z5XFYM+zjG2pYHPZLeyZWD/PWyRgvLPL9cm1bdhEelhDqaQKiCv4NdWdxnJeL3attDIfPgIibw2aibdjk+HExTvRbKGfVaZEcUv1XStiPSFp0fxeW4uqM0LILfdNt6OQ+FPOo55BidOLleoGvckZPcCKGiHJedXtUz2GueLEPAFFB7r0O663I4+XdHH4uCk+S0JfS7ZmjLYkUGEk1Nlsm96B/2qniyEOFzd4QcSmTKJSVvDcjgF+UZkFk+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uRezmoaW9M7/tdtG2MUFn3a20ZX+t0e4gPV172Savjw=;
 b=keP9AMsMcman51rTRkstwvfgdA8dQ6wobVu0tLS18ir30wBC/riHaQTUAOzYvjr2mNIwMcAf0EKv4jJtmdhuZajTiAUs5RJ6joDUftyH6LaEaX54HLyCt2YbJRl77LmgrHl0TdWZ6dUA+vDCjb7M2ex3hCeikVZkXwnRILByAzIfbBxToNjuUf2jE4c50P/sy+IPASjTFDQq99gCnthp6WmwNazCfkmYtLp+wQ2kTrvpD8xKZ6Ov8P73UMqyK+RpXROvAOeV3CWEsr84CIvE7nU/XAXfVbGeK6aZ83oMqLdooshsF80lYCjrYR8IRYyHdZAhVWbPf65OlI6cdI2zCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRezmoaW9M7/tdtG2MUFn3a20ZX+t0e4gPV172Savjw=;
 b=Og52bSqUPheMNaHCuvXWJgt/NTquIulKdAInwfzbO4o3gIdKekEO4CCrOyj+OmDdxHP0gpuhDrJMXgUO66mX5nL3VEKm5D3AdKC8oIAzU1qpewXvbGXAw85RnP7rYFP9us1NIhdhSTNrDPmON298lhJIzztqUGjEEP4OrW1VlkM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:16 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:16 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 4/7] xfs_io: implement lsattr and chattr support for forcealign
Date:   Fri, 29 Sep 2023 09:53:39 +0000
Message-Id: <20230929095342.2976587-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0138.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: 6efffb03-721a-4d27-bcc6-08dbc0d20ad7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJ8KFm5NzhSzs5GzDtYYScMD4B9R6JZHQUwq4H/YcY4TBIRDj26fYaZt96g1/9fTRIUPSECmV15ito0d6MBFzVX2aY/6+Bm+4+C3Bvs/CG06zL0SNT0hwAsvxx6X/lNsptknsuBLlW35Y6z/FmM8hURIUjGZkmvJbvIaaVS+gxmIhzKdB7GElNPN7mNdb/tLRcbGx+DP6ug8K/lEJUc40JPorsK5v8Tq/wmmr2bvkxV+ww5TvqPZh+4RX2lf1ZUq8wp4/9qvY4ln/6S1PIIbvc9pl3FfIr36ZdiMMTcZUeASq/Z4xGAzqm1EZnaBrparjITTNyBzfGqNRlPRlFBCQ3Ta9jZ0sSpsmUMAnWBGaJ5WZklsBdRNel12srrlzxArp7qoBgiGtiw6/LcEG7BDnWVDP0ysD2dGixQKMDcl9UDHpNQcK2ypEFmnOhHLfCuNIdaiZk8Meny7FMWw0MjpfU8mqEPDO5VtMy+w2r4QvgfMzQDqTP+/YP7L7iLE7EZzeuh9zwUxsr4/IBF1Sve/phP2mxtJFIuyuLcQmiq2dLyaggyQq2jo+CIwV+GJOwIq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gi2SNmYdU3hvN2O9Kt2KWrQrIDz9oMPTK3SvbcKiwRCJaiOKn3Lf/fyR042W?=
 =?us-ascii?Q?F2qd37Ntje+UZ8dgdq/q1UOpBrJkhHgo9mYG91bHNtseCTr19k6ld0ThAW8u?=
 =?us-ascii?Q?5c80ucOR9hIveG1oedOwyknTC/V4CheeYzla4IpMoglgIu60i96V3lr147uk?=
 =?us-ascii?Q?qsw7z5z8/dDflIIN98FS97fkYG9UzbedVml5Ghjy+F80Z5/SD2W+85AKaCe9?=
 =?us-ascii?Q?auO/LnjGGUcrsXhg9+wvOcsy8hYxnSw9TBibuVcI7bDxZbEJKvlCqshqGxrr?=
 =?us-ascii?Q?My50MSo0P6CWUbkA8KzIT/6iXwXHQveiyiB5fJX6DgLH7tRz4E72WxBSR7Mq?=
 =?us-ascii?Q?9Mel+z+E1HpaY7MMH87uHhgrxNgBwSQGRMAW5u08MWXRNGmw80hnBnwkEpKW?=
 =?us-ascii?Q?QU/V/U9SGKoo6H5kQRvVBbVDIhDl2Am9G9YCaj7Tx1mQ4vxwds0xWrLjHcEe?=
 =?us-ascii?Q?QyOWiD8gbrgvJxjVyhpb+eVpODc3Hoa4diOT98bAdueJfomM37gy4VQcU6Yj?=
 =?us-ascii?Q?hNxP7CTJoNFFxET8lGw9pwHLa82mveJIgalQA/tsmx8CyBTVkDyDk+rK3VrM?=
 =?us-ascii?Q?ysUgP2lxLXSpfQ/1DGThc727zoChevxerEIuMN62Slz/4DVZ0ssg3Q/vqk/f?=
 =?us-ascii?Q?j3Uy25uW1HkdIccHerV50BZ8YtUi9gNb/11qOaRH2R8ZaF++RR3qJqjkILb+?=
 =?us-ascii?Q?xcOzJmomWvZkh5JLx8ce4OpU1+XCQpTtkdgC6hjAReECMX5BI5DKd85JvkmT?=
 =?us-ascii?Q?7HoLePYkRMEMeW5jDhvKOHJD7tlAVavk2w4B7cubGFLcVDDXpKXBBIbiHWzQ?=
 =?us-ascii?Q?Xh1sl/xwicP0HTT9kH5ijNRkTjDQL79gBm8RjmoVIU9Wp6UeD05ZijMdlXwY?=
 =?us-ascii?Q?Bs4VFjZk7FuFU1V+dF2I2WIZQ3Jm3FDulAyvefhW9H+Mm0iBe6e6nfXj+f8N?=
 =?us-ascii?Q?W8Z7BoMwEcxATOhmmC3gi7ZoRZt/b6fzx/Fd19Zoc7qjpWFAtayDWATy9qHh?=
 =?us-ascii?Q?wekiq63heqwhzlXYiXDIxnW6M66hoYv1HO8K5ZLcaWvqEpQYzFBwk4fKLY6S?=
 =?us-ascii?Q?bImgg0oMPY5zkKHGZbA/HpsggQTA3yxIgEoUU/maMAKhC/QXtGNhXCB4isFV?=
 =?us-ascii?Q?U6Vzl/ryUEhu2piz4247P+FyepUviW3d9iiZPJcI2zouIG7mFR1t1/ay9o9g?=
 =?us-ascii?Q?tEdkg7LqkqM2rNC0nxH6RQc0mhiVwa7jom+KmfJ+7+zIS1JWlGiZ9iOIajmH?=
 =?us-ascii?Q?b+oLdESCfKuXA6dLSzoIOnJkuP/bOVJl+EkiB0qQs5gvQAe2Sw4+4REnp4h9?=
 =?us-ascii?Q?YBwOf6ml2cSznLfyis2Bj0I3KkkYfWUKEaNxaw3uncYzXMNM8VCXnWm/IOpn?=
 =?us-ascii?Q?KACSa/O/Jr4qkqxQJhypUHTXaJW3+aPW8AS+n1ZfuECXJySLmuqdVxncLuX4?=
 =?us-ascii?Q?WN1X5mhUrpV5DIrCDjk1XDqUIoNXNrro3MmapWG6J9OeAsFHEHk3b0h5fldx?=
 =?us-ascii?Q?s3QKObQxJh8wig4yokXVaM51CNv3OuwF1zc26/7CIo/aWPRc+lrxyYEm7z1W?=
 =?us-ascii?Q?ip+Yw20NZxZI6nov2A/CgMEsdsE9QhnX0euKFjlRGrSHCxhsC7GVmH6qzFAh?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AvXIIOB5nIFLX1sNr+tfLnUlziFnbseKqJbzoxrQDvJDJ3zgsNXkl36olUqNYDua0bcA0+OfTyS0GQKAmXT5MGyAXkn+sj8FERHZiHK4SWCIqPPjJzD2V8Ws/nfCdzvlfNYiCjaoPg9UQML0qti3WLgUl8/XDhY6ikf1nB/kwFWKYHXdI+IklWIaK/QFSntJNJh0n2XDGTJ0lqlq2i0aAbFT1pPg8AeFfnzsyxW8zV8b+MS5Xjxohr21oeudGS//5cEeRHMC9RQlry3KrcDS3AVMAAQIFIerS+L8rEmZ6eUdc7zuaT0ggD2U7XLxIrN96cZBv8fj3Vno+wjNuNVeCOOaJfYzWPMAJSV9f0sDts7d1fBe1n5hsNWDPvOfs/cCraKltYITX12a9LazX8HaFOFCleT0Me7nj5gYGpTS6QEgtvIC1aKvERppbPoHWuiqyVDCFt635wpSEq88QdCJrb3ZQfL+4DrFK5zxmdfGLV5tJqlsLe/FaEebi4xM176uVWT1gn6bcDVGTM5sdHC1PutPN13+d4HPLZH5FjuY3aMsYHIxHVXv9M08XngGZw3xGnSNOn1PvT1YXWcNlWh/wbtdI0vkWohUWyCIr/EE9imDCGAJPlAg8mUiGmOEMCu2HTdvSRsPuhSTiK0m3LRRKDZWO/+OsaH8gAD3FzduRivJBXl+OQ1p4CFXfwgVrjw0JAbSTQQwsJbBdTiVi3YS5uMTVFZL0nXQrJdn8w1mp6lZVKlnQpsI0ll7NyXzcVYy+CFfKSaX9G354iqiVlnqjhhJ8umA4FvyUhnv/MOAke9hxE0wMJVzo/Br2XLqHu5ufbJmqnQ9haCTcghCeoRcvQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efffb03-721a-4d27-bcc6-08dbc0d20ad7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:16.1567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUclPpavIxYOZ9QBpCAzIzPszyEGx6MTeLo0graJVMQeYCDWtZnVqeWv4XMpTgZPcJaHwCuDtlSKqd+S9mcFmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290085
X-Proofpoint-ORIG-GUID: 0kvPKb2ozQUcgijd5nUItxWl8zrTDJTQ
X-Proofpoint-GUID: 0kvPKb2ozQUcgijd5nUItxWl8zrTDJTQ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Make it so that we can adjust the forcealign flag at runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Co-developed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 io/attr.c                       | 5 ++++-
 man/man2/ioctl_xfs_fsgetxattr.2 | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/io/attr.c b/io/attr.c
index fd82a2e73801..248a9c28eae1 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -38,9 +38,10 @@ static struct xflags {
 	{ FS_XFLAG_DAX,			"x", "dax"		},
 	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
 	{ FS_XFLAG_HASATTR,		"X", "has-xattr"	},
+	{ FS_XFLAG_FORCEALIGN,		"F", "force-align"	},
 	{ 0, NULL, NULL }
 };
-#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxC"/*X*/
+#define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxC"/*X*/"F"
 
 static void
 lsattr_help(void)
@@ -67,6 +68,7 @@ lsattr_help(void)
 " x -- Use direct access (DAX) for data in this file\n"
 " C -- for files with shared blocks, observe the inode CoW extent size value\n"
 " X -- file has extended attributes (cannot be changed using chattr)\n"
+" F -- data extent mappings must be aligned to extent size hint\n"
 "\n"
 " Options:\n"
 " -R -- recursively descend (useful when current file is a directory)\n"
@@ -104,6 +106,7 @@ chattr_help(void)
 " +/-S -- set/clear the filestreams allocator flag\n"
 " +/-x -- set/clear the direct access (DAX) flag\n"
 " +/-C -- set/clear the CoW extent-size flag\n"
+" +/-F -- set/clear the forcealign flag\n"
 " Note1: user must have certain capabilities to modify immutable/append-only.\n"
 " Note2: immutable/append-only files cannot be deleted; removing these files\n"
 "        requires the immutable/append-only flag to be cleared first.\n"
diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
index 2c626a7e3742..d97fb1b508aa 100644
--- a/man/man2/ioctl_xfs_fsgetxattr.2
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -200,6 +200,12 @@ below).
 If set on a directory, new files and subdirectories created in the directory
 will have both the flag and the CoW extent size value set.
 .TP
+.B XFS_XFLAG_FORCEALIGN
+Force Alignment bit - requires that all file data extents must be aligned
+to the extent size hint value.
+If set on a directory, new files and subdirectories created in the directory
+will have the flag set.
+.TP
 .B XFS_XFLAG_HASATTR
 The file has extended attributes associated with it.
 
-- 
2.34.1

