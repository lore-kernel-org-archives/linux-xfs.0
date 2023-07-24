Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8283BC0015E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjGXEi7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjGXEi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:38:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F15C1A4
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:38:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMjSaQ007321;
        Mon, 24 Jul 2023 04:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=yQxULfrRxSmXLfCyDb3ENcNXj0vjxoG0LvVRvtM315u6j9bVB6v5R/8N/StPZ6hosanM
 SmP6tO98xzUl2E1GRdPPAzOPTEcKGw+bBRb9BCNlJQlax/Y1eT52Vfg9BxBF645NBZ/0
 KPpLe2rrZW5T8uLmbC5BaQdphKdT3Tnc7klO+JsvlIKPscJ0PnA5cdXFDt3mJg2QbmRv
 Q949TJ5pvIzcNyiJ7PN9UT6xL8WdAGSvkvbSGWUOpxh4GoNTPSmNkcum0Zc5G3RqQ5ow
 e8h42G/dFQZAzJLh+oAqg4/9IvUH/P5FgsTipfmKQuHblRPhdkDGn9CXuAzStSKX0elm tA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s05q1sv8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O1G8gM035357;
        Mon, 24 Jul 2023 04:38:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2x8v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENZDojxP+k4A+F+Q8uZRvAgmFFOuNoCWSAeRrOXQe73Pfb2seE8XuLv/OnQmol8tYoYY+v+nYsrr8YBQF2oRKzv75eqt7BV6q6ukXeqCgMnA0AufYv73A98bHbKO81eH4hfKEzYGN/KU/EyMfKQQJ7epCiA8xfFNwPtIc99u91wYTqQ+m05CNMFzi8ZWooVL+YN0uFAqaGy4wzjus1ueG45bR+OXc9hxnR4R5T15OrgSqC8hEvoPoBp5R8esHsFgmzY/utlvuAvYH9zm714AhwWDeUyQ06+/u7Mmd6XkbTqUSRnP8UNulkgDtFIFDBjTW0cS5jWm6SwGHkRVo0LSFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=kVoJ6AIzPLjf8BfAm4eUteblFkvEURYn2vEFjjDAb7v4W/iB/1XUDUPaYwLXImp9TvUw0FJBYRNLBpL6GmycKMWkgzUjdWpQ+RM/xCv0XYdWqQ/7hH4I7WDiUZO/SP1Zv0FpEyzWzHlzQ/RRj/7dCeONMAEtQWWapBu3eiZhW4+xuawFostgUqI/1kySPUldpAkTM5lwO75M6kDaGkG0rmcd49q3vvzlyEahSKDThD8FWjaWZO2i0Lwf5pczSvTMtgtDrW+TMKij6DRTulfSmntDAtI61aOt6wOg0uwwSB+oKhnLCyYrPme9b5nPa9XloLPnX29kkF2NRW5E2dXWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=n/gAlWVbPu9uesOh6BzD1mbS/uWjTWJ4KZDh36f0/F9DkeMVN1EaCYTjoyBldl5lkE/ExtENtkWc3l3yBoZpgyw0MJmHvRgYLhDFVTbgePpzMkMFSFvcuCkFqkqm0T7ArkUxkbXpRLNBdpkYzeotAnFVvDbj0FCKWnNbyPoISa8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:38:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:38:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 21/23] mdrestore: Extract target device size verification into a function
Date:   Mon, 24 Jul 2023 10:05:25 +0530
Message-Id: <20230724043527.238600-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:404:e2::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ac094ee-db82-4230-0e76-08db8bffe1f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhhPYm7MjezgMnIH0RFh/BcWgTRCBhqinmyrX1htXbDx91qyP0xdTnAfdfNOHt6lrZHIN7EyPE3tJwEJIE8xHoLzYFMvwydOFJoH+u/qSDoZ86b/wqXZHPv8ODb122kSvTo61V6GZEy+ykg1IV/TQJdSX4brwjZKDF9o9T5LJj3MfHC9odriljaVCXZAvNxgqM91cQnhiGf9Lnl3l4ajMUAdXx/u6ZVJM9UBu+8gbjxFu1fGZwGrSDsMSnT/HkQEo8LdI6puZ4lz5W/tIyOmVDxzAWNIhNiaew6+pH2g8VhyIFuXoj8fUFYVxxPlg/0D9TdgbrwZkm9Gl8DE6gb1FONHC0IiyuxGf0QHTWgk+s8EPV6Zdhl5gjO/ab7t2zQHBrp8Ni3BCdxFM5jlrlSX/GFMR4KZ+hIN3ja/TIPAuhpRfr0rKb+YoGVLrbctrCc5Kc1GpGUErs3j2RwF/tAdjd/KStCaOkBPe6Qo2NauzlYIMdb85dTZ5zpXqXy56bgDw3N+cmtG1Rsd92YCMpRC6WJvfbJKGxetffMDHOU/MWy+83xYbMLO+ayR5rk9qOtF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(15650500001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FacIFTOIOLUw34h5MG4y1Xeoy6YYszq2XBlhI2Jit8NjzIqTSwj/lfaKZ8CQ?=
 =?us-ascii?Q?DmIvOMQXHUmEoWE4yXYx6HC12titIGd+5YYJMZf4YoEVhhRGb45Oz19lxWsf?=
 =?us-ascii?Q?U1JYNHNmVru+IiTZxhcUgcIn2tiTHwpKBKqoduze1c5mbQ5Ilk4XLhRvvTMX?=
 =?us-ascii?Q?vcj2nO4Xibe2iO4xHopdm36x0zjfOh7p0LSxk4e5OFqNrCnEV2O3llkWEl7a?=
 =?us-ascii?Q?l4/W7B7+P70D5G8PpFcTuDO1MRnWdZs+XurIgIJJ5kudl9HbrHr6IMMx6wAR?=
 =?us-ascii?Q?I+kTFjQHsbfbz9Il8eRU/e/gz32c/4MavJ5RQAACZ1ghX/xfLLhB2avMxxfI?=
 =?us-ascii?Q?g0FXB8yupL1BvUw3zxrHN8MAX2Iye5hz/vGYYBCpEjQvGHn61JHGK/bZ9JVz?=
 =?us-ascii?Q?or8g1Nssm5MIyuFVxbZsgY/U/BCg3VXKbP8tMJK0fML9aHOrDuZ5dm3PSXbF?=
 =?us-ascii?Q?jCkFLPFgPMvYN9PzrhpSwkY4xTPch/sZvjx2yDZ4iIsyyvar6fjMHzLErOgU?=
 =?us-ascii?Q?TZt/tqGTpkDCUy7n1//2sYMU58eUp7g8StxgW6NuKOcaJ73L8DpuGJW9IxxW?=
 =?us-ascii?Q?boPzzAU3EGvD09487m94DVNczSvFbkJ8bYD/y8TIgmiJ2aaJkxtFIXsIwJau?=
 =?us-ascii?Q?FV7mj2AOYyOsCIf4QX/SlIPY/Jys8eoP0GsHAiP6qpvOUkzciZwOpieL3UQ2?=
 =?us-ascii?Q?NAaj4dlFW8NNvuJWJO1V1C7rCBQjRCNUjbhBRSeOgrZ0J6wUJfLlVSOm9hvq?=
 =?us-ascii?Q?ih5jkLIvyUhrSc70xZBOzFZfOvAEX1zqSEwnP6rU7rSPpEIBN6K+Q9q3Rard?=
 =?us-ascii?Q?OJDMqFI5EE5jYUQVPTk6+TUJgnX6kF2U3FGHs0n64iqpXTuoT1XTiTMavI6o?=
 =?us-ascii?Q?+Fm5pzNp9VyCP6i2hcuDzNzB3dR7OgEWLizdXbLwMoP9nikRQauwufezhmSV?=
 =?us-ascii?Q?ys1f24CeNY56vghp1ozl1tg7VIqUHZsMTf4vkKXVpkOyvhq8jdqzF8Vfg3WW?=
 =?us-ascii?Q?y6ULElGnvcyXyOWgBE8K1YI/WMlpobJ4u9Kv5ti4ums5jlp+knTp8HIlE9CU?=
 =?us-ascii?Q?xky5ZI6OjGnZidSrLnF0AVG/XJEV2YuNZuVzBUX5vSf9kx56jrxZy5c+jReO?=
 =?us-ascii?Q?qdRCdmV+jpVxSehPBFS33AVFUKSQr24EGRBgi3IVahHYdlebARWIWCqZN2hS?=
 =?us-ascii?Q?AM6KoxwyZMYrC1FKwgAZjaaHWH628zMgUa5qIJvTYw29CLQLgRpN8HlLt/YK?=
 =?us-ascii?Q?RVpAVG6J5mcbZ78kiAgsVWUw0X6PTcr0NaSjW0PZmy4Sn1Ci7cpj422iyHZg?=
 =?us-ascii?Q?VvrgFc8rla90BdNee9ceYvTS31sIVhtyna9Aqih/7iTBLZNhz+dFrSRK6vQ6?=
 =?us-ascii?Q?XowKrEGxC+A5TyvfiUmXmSxt0+u7+YfX33EU6a0E2sTOPrmOWHPhAUxV8Rc6?=
 =?us-ascii?Q?RRhdcEjJiCwOeQrFWTcU11YthfSqAWeWrZsiYq5oGvskykd/ZdGXnuqUQlAU?=
 =?us-ascii?Q?eRYM1DakuDME/FdnHBLXPcuWzcMY2geQ5FX2BS+w5TatASurC1DFnQarhQdY?=
 =?us-ascii?Q?Q5hTxj78ug/5Se+W/QO1dlIbL54UFgFlENI5QmH5o4F5vxNzRApBZHp+pAH8?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GgMRSBHFcTvJ2/Hfkr53WkahxlmQKq8633JBb33eU8XUPk8QCozDFFei6zsbgp8pXNwtaQd8VcTZhYDslWwZS+DUHSSPnj+KY0Xra4X/TQEZMCx3T202DUA4dChYDcDsRRgma2aKgtzVwd+D0RclrPvePs/vht9tzii97iUw6qUU+WTAepbCmSqmIF+8rRz1tKD0Z+DS0I3CUMKe/Lvbd8y+mxQORc+2BfQZ9/oRdAfu6gT8LKel4oVaqegYhWXgV43Gd+w2vE/R+sOjrCY3CZ21mEgt3NzGG0ZHqfEgZX6iF9Bc73ddqPgpVexxtAxEYmuQkK3/B5PRFgRom9KPwDI8KV4YE4O4JicteVEFh3tYvydFbAsUp0AhlwLTaGAzdr+Rekwr7oadI66/haZx1k1HylLhIpp/eCtq6RYuVW7umIgzH1dzrJQYEQecVI5r24yOGfD/cE+943uuQLuEFaw1KzjlsIj+yf3ZEI4G2LP07rhHyjx1EP0bqQFUC9W/MMAi8aXhjL5K5Xbqx9Utnq40ajrdmN2QX/hhoi+bShHNW2gHNEbCft/3zkKOksKk/duBVAoBBJiqzqWG7kZByZnT28rUrDYoRYBApzI5fWAvA6WO8I3YZ/S2b5YoMekBXh2VT8P3Nn6vMPdMSv0Pu/pmjQSBNKx+hDOySamoQ0WBPMhQu7Ioq+5mQQcM6/Os2JdCsmtEbIbmuf7Ir3sLFvkqLY/QJQEKB/SbhUjSjxaHvGv8gjRflK6Ci4NUflHEt9jgQzppSRPJZyNuyiua3LJTDIkV+Dn9NQx1V65XeM0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac094ee-db82-4230-0e76-08db8bffe1f5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:38:52.9142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7fiqDamGmKHV7zuh/dJ/uvsTLRU6i75wyhSLd7JrD1dxLOgD++CEmuQ+c7mM0O4s7J7hasowduUyPlKsNZgog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307240042
X-Proofpoint-GUID: 8CZi64IXusEudZPNzDgajGPAWZ5p-VdX
X-Proofpoint-ORIG-GUID: 8CZi64IXusEudZPNzDgajGPAWZ5p-VdX
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will need to perform the device size verification on an
external log device. In preparation for this, this commit extracts the
relevant portions into a new function. No functional changes have been
introduced.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b247a4bf..0fdbfce7 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -89,6 +89,30 @@ open_device(
 	return fd;
 }
 
+static void
+verify_device_size(
+	int		dev_fd,
+	bool		is_file,
+	xfs_rfsblock_t	nr_blocks,
+	uint32_t	blocksize)
+{
+	if (is_file) {
+		/* ensure regular files are correctly sized */
+		if (ftruncate(dev_fd, nr_blocks * blocksize))
+			fatal("cannot set filesystem image size: %s\n",
+				strerror(errno));
+	} else {
+		/* ensure device is sufficiently large enough */
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
+		off64_t		off;
+
+		off = nr_blocks * blocksize - sizeof(lb);
+		if (pwrite(dev_fd, lb, sizeof(lb), off) < 0)
+			fatal("failed to write last block, is target too "
+				"small? (error: %s)\n", strerror(errno));
+	}
+}
+
 static void
 read_header_v1(
 	union mdrestore_headers	*h,
@@ -173,23 +197,8 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	if (is_target_file)  {
-		/* ensure regular files are correctly sized */
-
-		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
-			fatal("cannot set filesystem image size: %s\n",
-				strerror(errno));
-	} else  {
-		/* ensure device is sufficiently large enough */
-
-		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
-		off64_t		off;
-
-		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
-			fatal("failed to write last block, is target too "
-				"small? (error: %s)\n", strerror(errno));
-	}
+	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
 
 	bytes_read = 0;
 
-- 
2.39.1

