Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FB3C4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjKGHJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjKGHJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417BC11D
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:23 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72OWIu021822
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=c05fgVMCQoylVBeVtWWeYbYsfxH3/LIZPvaVS1pW23I6UBSAJj/5+1XO3r1C1Nxc41t9
 6f9Z+aDDbmp0kVcWrEgtRn1dLB8t3jV/sXDVnZkufIiEZosTrZZdo2InLjhKEt4pSXjR
 p/NP1sSkRPK8BvRuVyGhsDc1yBTD0MYt5e0xjZJ0prxx+9e4qS+l5RC/Ru2pIH9e686i
 vw/raWEtOMjhxC7/9DLI2vqoOBroe1Oj/9RJhEDQj5/fwnatqqzpSyTaEw+ZtFsq0yAc
 E24r3ErSoZTPG7PX5qmy/x+zM2yUuTgcq+bSmhSL3BH0SpvR9XhgCrXeWDu2mpTtCXBU AA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5egvd8ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76AfEx020819
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdd1x3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLi6TJX03ewzxjLCnYhceh/BIuVsUNagizzNsaE2Ag3X9m3ojr7pp4eoSpLT24islGvu6Nfq6dXWjl6BJHcPoZZDE1HPffyELAwS/EdmgvGUp7cZ71TqzPJCdSs6xiHYoNg8XFzejs92Kq6UavYkTHrMbEs3w0EZCHVQbqv/28o0beqLThhKvx+OcAPsNE8FZTx6g8vFHV/O9ZnuF5ckOJhMjBD9z4TCnR75OIfobHZSmf9+QZ9xZ59iaaXHL5zsjUN24qVmrSJM0ZFAyEMsy+OWV6sik48H3tujPLmftkgYNMx/QRoMoIxItAgcAjGVGFwZ49+AeMilIP8fO7kCAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=AG+U9i1TkncdLuIUieq4Vum9wrB2pvL9gxaHY1Q84+QgY65mY/cns5V8BbrSPVpejhoJmt0AA7seQREsqFqFhjZx2QLOFq3hnJzqThR23s9yMmMoeVWblcQo/KaeDiluoVvQ0x6k97JtJjhO6OCz8O6ZeO+M0GY9AQf5UFvGOyYVCnja04VPZAWSvyQ67it7JXXGG54+NZ36t0CG6y9FjvCxazyKPOAGuj9IbRRAw7NuNLxq2ieNiDDfSuZeV69jJEFaqnzsRa/kWYdzdEPtahzQupsHeOk0yeBbrDRYYGyu6qyvFs5wKCMTuI+0O7s1epTRv+nG9bO36+hVSzsoWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Utm5Lvcd+DgY9K4VopJp4jyGdtSR30ppD5dN5Gzx6HY=;
 b=TbWPd05Xhd37lYAFYkUZEQyzKo3pnvSwEaxPK8CwkB+dHyXNOrnkX1VAu0EeqLR8HtNan0lsJP00yFT3smHyWi1v0JEfMUhZ8kM3PhIn0OlvUN9zfloR3UX2vwwvbxn7ooqVoABLnekgjnzQYjvwpCUOS1Tmp14XWDKVu8rFcMI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 07:09:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:09:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 19/21] mdrestore: Extract target device size verification into a function
Date:   Tue,  7 Nov 2023 12:37:20 +0530
Message-Id: <20231107070722.748636-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0042.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 43a49e1d-119d-4504-7280-08dbdf60711c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYCcaUQwibljWfkEd9us5twYa27Ih/WHLd47G4WY7Bglhf1pfFjbQWiwy/MVMJCBRYCd5U3cw09lHa0YF5q0oNXkN1s1VK7Kri9Dr0Fi6M0MVctu2H2O21VUxM18RJivPCGMbUyhNFeMfGulHIzgAUD82N4Iw1FWmvZouL/LkoI3Ishu1KIsjiguzza+cXDRRlBIyUBG5Zjv/j7hmHIBmVTG9DmDYChb0nfLqrEErJHsBMJpSr9snTxRIhdV7ruPQeNwCANf7Kv38r0wcVglOpJpoYRs0ACtFPZQbfRX3uv7+/z2l/ayQezbdlBqN118fF60KjUPIheLuPmTqNXDn5c9FjWftMRf6GW//LWhS/STl3/f2iWoM/PkOZm48nqtQ8LTvpq80iOoXyrEOu2taDGe83Q4Vpd69yM0thZkrRD0fWNirsoftdml+majwItJZ+hstCUSNMsGc7TKdd2y9DuiVanjwuFIPNvY6cXmq/fLOmWwj6dJIttEhsys1cwxQ4F4wV2p/T6z/ezgbi0msOn6AKIPpFfFOrcCUk2OseS6ja7plDqHMVTqfsijbi9Crff8PZ3pUm9W/KDi8w09SqDPXcQ+GWCH/3XLRUi3sg3D8kozUQI2+5PMiVfzEQml
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(2616005)(41300700001)(6512007)(1076003)(8676002)(26005)(478600001)(6486002)(8936002)(5660300002)(36756003)(86362001)(2906002)(15650500001)(66946007)(66556008)(6916009)(316002)(66476007)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8S3ZgsXxfffAK6lAYlWDodyVESdqu3IkJjPy9CNDRiWCefZWm2t31OFlK0Pg?=
 =?us-ascii?Q?U4frX+mcFKp7AeikwX/kxsVu4Kpcr1k+f0q3MODylwXaH2hT5C73MeSrU2/i?=
 =?us-ascii?Q?Kjq2QbrkaTbD7ZiJFGhmR/si89jwt3Xogyn48AXo9jAUkDeee6qcRlsg4v9z?=
 =?us-ascii?Q?zW295EJYl7Wfsg9DuQ8brbiMFCoCHFi4d/CfrFblHzPR1CbOlJZL2gJyWEwl?=
 =?us-ascii?Q?fR/u6Ux95Hqa+QzL8A+RDu81IyfOFK9XXvXsEUmoW6vsBte4p1W2I+8ZlcV2?=
 =?us-ascii?Q?yXLfGLsgq/vPt+dLISoBq+wOdMJt2U5RMdS9q2DRh1F8owyIAjbuLLCGg9Uk?=
 =?us-ascii?Q?tzvKW4GeHnKwd7D7kxpbs0BcJDvzuyr2KwUCxG8Bd2W/06c93AMwFxaaYtXo?=
 =?us-ascii?Q?qqJfSMcioNgGnFCFZPn4ELa94RiknFEXG69DBx4KpcUdkyWJkTbz+6H3kmDx?=
 =?us-ascii?Q?EI8DkVp/OYhNoisE3iFNoMXKRy9XE+QaHQIfmIggdUW/CxauE2oaB8TGa6Er?=
 =?us-ascii?Q?peVv6M1q/X3YztHDVxQX6Vl3QcUL3noi5/zZjTUqBrWCsirSxzwbR/cRRrpz?=
 =?us-ascii?Q?49kgeE9mekrrWrUsZZTeonFXfstPJWKM7m62fBHHxzMGhIAtKe449y0XWwWz?=
 =?us-ascii?Q?L7Ooa7jzR+TXvYyNIvm68rtnudOjC5kX/wk3QFaaypLb8xZ6jCC2vrHDt9hK?=
 =?us-ascii?Q?KRPp/RBi+x/xtR1eEp8QrJQf3SzlBHaO+vLF88wcB2bJoF0GFq2rHVVqV8DH?=
 =?us-ascii?Q?jms4z6kIfwlyV4X70bLmyhLixJBeBkD4ib1uBcAaXG9QfvI3Q4IDGGHPaENk?=
 =?us-ascii?Q?mU80i7fKsWy9VAVqj+xqfL48hsas9PMWyVfLi6STOHtCQYzhMsp2OxXuvgjy?=
 =?us-ascii?Q?neo/tKQMoM9SalJKRlpYGJLs8y8fW9E6OH3vx1p2/kWuwgRA8uG8J6DagZem?=
 =?us-ascii?Q?YVqptTIT21u+sGJ8pVMyqd03jo9UpkLZ0mN/AHNWnhHlTiiMwPjgnvQSWVXz?=
 =?us-ascii?Q?PsbUejM6Px4uiJqCmX3WH4cpseqCBtXLuyAjaQhSFtJ6xHHae3LUg3EdVB7m?=
 =?us-ascii?Q?SSJp4u1GqAynDNgDfnb9iRfuCXk5xA2D/yzcKJRZAg/iQ3tB6ZQodRdUC9F/?=
 =?us-ascii?Q?WaNUsiXoQthXDPIA9f960pNvQd8DAxe/3xvhhVdliT9bRmWUFvcOWg6XZUxN?=
 =?us-ascii?Q?fijv90WG71z7O7c3u9z4RlulgCwC0uClXteO+LS1FswQofGKp9il0A7ywQX3?=
 =?us-ascii?Q?xeAgv2AyCxx0btOLen1TDwPlJj+EVaeFEPIZUtkEiD9mTy4ZKo6eEEjgyWAO?=
 =?us-ascii?Q?KVfNX32adOJtppqI1yWR/qQZt0748ZjKcxCbU2LJocI7tpt7FlGgybaOIfzK?=
 =?us-ascii?Q?N1NXxRJ5BOQnp5zlngwZE5qK+U6vcRgQ6htlXS/zW/5YOCuRGjzQU3chK43p?=
 =?us-ascii?Q?SUa3IwdTbb+mcPQt+Z8uQboxgRiOaLqbj5f6z3XOeoDBsYKvO6TVdidGKjht?=
 =?us-ascii?Q?HU9DDToqfe33tgvrgeCyPfF8UbSsiznWVZV73p3/ehNaHzmAZ6m5PUD8T1xi?=
 =?us-ascii?Q?MzR77KZac0Vt2OrnvER3IgoEKj7DpHXTSyF4rwUavXPQ/e8HlnR/uTnIsaD+?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: eOfFALusItRTftdBnOA+xZycsik+jJ5fXxrTchzRh5h+ybvDjwzQScV2+S8HPD2EyMuciGGGr4s9NAFF0UhV0CYExEi7NBOhfw4ZhLbyF02L4bVmSvrPVV0X/KoILSeQ4kXKToCqzJH1Jmk5vCXDQ1tFk6deLAzzUHdJCTlE6N+H9AZZL7BajhRckrbhTu36ggDY/DjOM42j3BiX+h8vcfMjT5gF6i4bK/VgJJphjT+jEdCdjD5B4aooUz2xbSdr0B5HFLbINOKhyYlLN4witDnVrUiODfg9pKP4rthYnUfo7WQd9H3Kqxkuh7Mvx8/brM4MiCjD4PtwF7DAfbNnc2dh3zOe/Ok1HlZ/GhwxFyV3ZgBZEABC37CeCCsL2wM3kHhBbiunmEESdLxtp0z/yj946Wvo/Yw4LNpRnJa7yKX1dFhc6yOkwltv+CZkSN5A+Xnp+SS4T50HM/k5rCoRLuOBTIa8G+O5xF90kLuOdCvi+V5l/H8Cj3ZhzjocLwWOCgguSg2Y6WBxaF1+oA3qqdGsQniTAezWcAKH7i5465mwbCMtL6DH5UYGv0fpaAHuZe/PzXZZKQ/csZER3MN9O9yU/7rXxC50ANH+RJ7fW1yKZuFqgZKWvW0eBaoP/9Yl17xYTM7u+cCCX9MmAgVLC5ZYmh8YQU2vpINWucoyMscQ8kxO8yMMFIL4e4jHlCf25Z+fVf0UiM4CjCYNtarbYABQin04OJcTiIIrw4uP6ausXin1vPazvNfDYWaCjbZQXX9qBrbJjwXa43bDYJ7BxA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a49e1d-119d-4504-7280-08dbdf60711c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:09:11.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gGH7rf2rudpST8AHNnIcu35rpLi8q47QAugNUjXO3yqm0Kqi9KUECzQ6EPuVtpqTSl6NHfvRzIiWlcSmCt1+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070058
X-Proofpoint-GUID: 7XQV6db35m4XxiZgNlQs2wQf_cvQxYky
X-Proofpoint-ORIG-GUID: 7XQV6db35m4XxiZgNlQs2wQf_cvQxYky
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

