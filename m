Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D96C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 06:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKJGhB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 01:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKJGhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 01:37:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6B92CCAE
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 22:36:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA6ZB38025345;
        Thu, 10 Nov 2022 06:36:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PGSljkWk5KhR4qn4AbR00NWjIqcF3jfSpGc8q2/5lUA=;
 b=tflBl41f+3SLH4PA5Fccq/BbXPeuseTSEIVaQijsFQOe+cJG5AwU0EorYmyS67/mrD77
 e1rBzqqwIIdxLUhnEPVv2IqVelOPrpU6qWhUlrYQqAELhfcCzHmwkxgNo/tz6pObbqfG
 rYNTkXzueVEqxkhh3fvMHEzCeEJORZp6UNQG5t9hvMZtOoNAQQjH0R6G7AHWefL3JEC1
 hIJIpmpqAR20rUcKs9sn++loFxU5zIN1ETEYgEKsrlLSE9FUxKR4FC6fpNVkL2zwjTOr
 FMWuYMHHPXGfr4f99YritCbjh01nCVx76mnue3bWBPtWMjaZq6mpNnudWkBjOJ7lOnsr Xg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krv5f806j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AA5M7Ko004289;
        Thu, 10 Nov 2022 06:36:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq4fvn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 06:36:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTYaSrAsDX634NjCV8Po2+qcYHTVU+F3T1lN/cjlJTm/6oNeLvOubqnrRpEVtkzVS4p1QUVat2QJZdWcz4UVhth5yw+JiXrUGnepDgPBohnA/7rlq2X6FzBjapzOHW+HR/WFTP5t9k9Wv9ziLUHgXic75kjyk6CCns+G5qlOtJc6Z4UFnnaMk5j/zSbE1gzYmcH52lSPDpA0KBS0jsUSC7DPBFFq+BH4EYS37doNQeALRj3wMNNqz7CVreMJyCB87m4vD7m2EeLluHpjmsPBscLi+7Z2A3d8bZ06EYhk9RckAX9XpdaQ5yP9tlBBuYFcVaXiR+W3ywpasbRg+LE/UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGSljkWk5KhR4qn4AbR00NWjIqcF3jfSpGc8q2/5lUA=;
 b=WAcwa65hGs87pXjFKShwdMqNLkAEHfayk4Ja+lK2SKENUB79af0ox6ajHjokbAhayizNQYGKhtLAkVGUwdyXLf4hBctve5dIwmce0+mFfvLIJWrymYzFoCsZasZrIT1uOG94f467hlF0/Ug9p4tAWBWrmtODIU8suWWr/FXM84y0ZarNtqMScVr1RtR9pWxmma16vNs8LFOgwbzKxFWXczK5/PC39aAkAin4idQw06Exjj9sInP+mGL55SURrQfLBzdkRiJJLmo+yQM1JeTUo8LbVWT9TVESXiYdhSqe40ScEQ3kmlZkAthWuMVXG5JW9I7+SB9RMGD6enaZPISMuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGSljkWk5KhR4qn4AbR00NWjIqcF3jfSpGc8q2/5lUA=;
 b=clJaHKjLOrZvJMfUPHKrFDVk+q0madi/CurfRAkZf8FDRrZpEczQTvGRlRGs4tj0ww3FI7joHdJKDUZ6Wv39LPp6kaMvgmIQR86XnYWxTCPfKIQQERSuY6OlYC1nFPQF0lVOEjf6Ry6JfjTrKG88B3PfKvyNU6IQKzdFOIdMawk=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 06:36:46 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 06:36:45 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 4/6] xfs: use MMAPLOCK around filemap_map_pages()
Date:   Thu, 10 Nov 2022 12:06:06 +0530
Message-Id: <20221110063608.629732-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|SA2PR10MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 5294fd22-e746-4722-1214-08dac2e5f008
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwGsL1uo8lwpgodvHX23PKXpSfupDHI5kwvukHMGnaI6mL5lcl3C6wrrBG/SM4FtbycAbxrP3Q1QgP/6Xyk0k6AQw1GGOPrq8srQTqvSH7KvxHh9k4UuTuanXmRz5q1rSEofPVvQ3gjaGBBf37jmldoe3hCSTtcjPLuRd773aCA1EO4Oo+kfJzxs8BEYHnZ4qm8b3Ke5ZwD7GV+hzqIshU/JvL73z/Uknun/S/twP43dh+kE4QOPbL2cFn34tRrVvFqrZIEDc5g7oQgK0QPwIEw1XAIEFFGpF0fys24O3wCydh/kTtbnJLdb2fOaDYDOZwzOYWtJr3vtSstelMoWK3LiFBJIsEBKOt6pvloSN1xL++AR7GeR5Q/VKS1op3eciVG4dGrMiDOGvXzLMe55/L7JCUeeVnxUZ2U0Yn2nsyk0diVKT/BxNkaoICGiuQuyqGHyeLezRqukiEZxXEd39EEts6z8iEsdVm6v4zx3k/TzydgQhH65ciBJBuhzz/Vq2ZOFJ6KgL/UlkIo/7OxK1hoRg8/3JFHddJcZmfcAGn++U2xb9WfMHzP9R/48tteCwE7pFBa7xh0GiuL+/2ErlMPvNneRFmmA/cQDGaGHH6T1gK+5aaRWFmD8sKzA+i9GwS29ySKgzGVG6cu/qVcN5OJs+xJD1wYDooHAEGFJWerK644/+PS3/h9kb3npRtdhnPxacAc8oXrshk38onpbwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199015)(38100700002)(86362001)(66556008)(8676002)(4326008)(66476007)(66946007)(41300700001)(2616005)(5660300002)(316002)(6486002)(478600001)(6666004)(6916009)(8936002)(1076003)(186003)(83380400001)(2906002)(6506007)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XU7W/Xr70/Ze3mHatgSWCC8VDsFvgdtW10puDrodnYgjcQMIApmG8sjiKEwv?=
 =?us-ascii?Q?RCf+VOf6chXo9rdZypvFjJ2Bg0KajOD2Z8n+lAKpEjV7vQkGmC8p6Ukq1+p2?=
 =?us-ascii?Q?ADb3B8VQ2umfWc8+AEzdp8Zok8o7I1TjKnJ8IYs7MKlWd+v8WqnrkehBVFvU?=
 =?us-ascii?Q?Hao+rwQOJCFhIUZKSN9WhSPA17/0q95hPo7qubD+P2MAj0jd5QDTXoQsbG9U?=
 =?us-ascii?Q?0pNbfvhyvYv8++csp4fOnvxquW3z6R+Z6HXdh/gcRCON/l6edLmlCsBW5BGK?=
 =?us-ascii?Q?L4rd0BYseR6DNPqnbu062hof1Q9RGFtdvWK9u3w3MfL+huqJSpsuOlF7o5AK?=
 =?us-ascii?Q?svcM6mNkS3iXGjYZyQ4VECu7+bbswq1b1RhN6PSoEbY0eKUcIu/uQe5bUugJ?=
 =?us-ascii?Q?tgcwSmdh+AaZlI4VoAU+6SBMPymijjnAS7gTbPAE5PBXIgW4+4WnkYYHVH6G?=
 =?us-ascii?Q?nUHh8gJXkoTty1RAAPfrL8Pr/IgW30vEmMn1TcxOOongFrLU6F2N0jJklDy7?=
 =?us-ascii?Q?Wi0vrsRnl6sGZvaG1uqdFEJ67+MnfAQUhq6XXFucA5cUyc2dtrLHXtivTHkf?=
 =?us-ascii?Q?MyJfcKf6lIQ9kTdkqkEMeXLRo+kSMdvy9ZY7+HUqdV6SFv1QsqrAcpZLq2Kt?=
 =?us-ascii?Q?/OOAneg1tXsmOUughYFjOJbQyyN9aJS40rECxwJZvazItxc4XqdHDxNemttk?=
 =?us-ascii?Q?cF2HgH1/KlWdAcN4XrS0ZuySmUs5N6wYJoVF2fdlhtZ7U/6Ylkgsmp5E5wyM?=
 =?us-ascii?Q?eL7ebvTmIXgorp6KoNy+rq5ftAjpPeTyrGv51TiSybqXYKAPlcvrp1G+wPuT?=
 =?us-ascii?Q?YFoLxG0GqrjZi1yY0rj0rijfPAQ2jmmXaIn+WVKqqvuBzWyLlIMJ1BySTPCJ?=
 =?us-ascii?Q?WUqYOfkGJ2qdynY/zFm0D/blHuqa8XReKSlh4ITCS71WmfhGvqb8UNqhad6i?=
 =?us-ascii?Q?q9S9lEp1v+GPIYcJwjFWpWa8/2jFKzf+UrVI5GOBWqKKh3UeAdhfieyFzBuF?=
 =?us-ascii?Q?85m6rcrIFvPqAby3Mzf4mVdhqScQmD10YPCp+mCz6tpetSYsXQr7rrB98/h8?=
 =?us-ascii?Q?ak8Quj8Q1p7ojDXWPurlvyB38GkCQCLqTb+J0uaEpwmw4Vblohw8k+bWpEKG?=
 =?us-ascii?Q?btYI8eZ/ZXF15AiqAi1QFnH3blQXHgtWNDYglTSJh6Zw7lathoy4G9jrwpvh?=
 =?us-ascii?Q?rHLx6cRz1XrLlS99+A8CoS0wM2k6WERGwirSahcD/bgvNDV5yHsqcyp9cc03?=
 =?us-ascii?Q?Kla8CqDgt89QZIElY6KGkQKU8CnX60cfbgqRZ6e6KHyOsuMr7kklYFqfxpu/?=
 =?us-ascii?Q?OwxrpcNPc/QQeYRUIUdJDUGHT++jxvjQHop8UNrZ4tP16IxKy+Khi5tp6Qe/?=
 =?us-ascii?Q?bs8zOyF1I9W1BFFjHhe+PJEPIYEJh0z1/y8/6tcC6WKHcOqVl6ZqN4WB9+rO?=
 =?us-ascii?Q?ZpSynNmclSwPvIuYcVqt3yiM9QaXbgFF6pcuvM5nRtfUcH+fzg0TOLwNuLHi?=
 =?us-ascii?Q?5rJZ+mKeQcSirUdwi0XxmpnldMy843p7HwemXKm+eRpFPg5xfXcL77w953ps?=
 =?us-ascii?Q?5peGJu0xTSDczE/ODd9BGrloMJBZlgabq+bjKJ4g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5294fd22-e746-4722-1214-08dac2e5f008
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 06:36:45.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gowqySGMeCBo/zI44aX5QJ3hhVTfWt0e3SXGesAabsasi6AD6ucR5j6Le7Kw5WtJGkaEnZsFw7b1r5zB9iaNFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100048
X-Proofpoint-GUID: PD0u-81u-V0O3Y631ga5jTmMAD3GfWfT
X-Proofpoint-ORIG-GUID: PD0u-81u-V0O3Y631ga5jTmMAD3GfWfT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit cd647d5651c0b0deaa26c1acb9e1789437ba9bc7 upstream.

The page faultround path ->map_pages is implemented in XFS via
filemap_map_pages(). This function checks that pages found in page
cache lookups have not raced with truncate based invalidation by
checking page->mapping is correct and page->index is within EOF.

However, we've known for a long time that this is not sufficient to
protect against races with invalidations done by operations that do
not change EOF. e.g. hole punching and other fallocate() based
direct extent manipulations. The way we protect against these
races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
lock so they serialise against fallocate and truncate before calling
into the filemap function that processes the fault.

Do the same for XFS's ->map_pages implementation to close this
potential data corruption issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c67fab2c37c5..b651715da8c6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1267,10 +1267,23 @@ xfs_filemap_pfn_mkwrite(
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
+static void
+xfs_filemap_map_pages(
+	struct vm_fault		*vmf,
+	pgoff_t			start_pgoff,
+	pgoff_t			end_pgoff)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.huge_fault	= xfs_filemap_huge_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= xfs_filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
-- 
2.35.1

