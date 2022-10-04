Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B50C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiJDK3u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiJDK3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 06:29:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8A212765
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 03:29:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2949KNO7032693;
        Tue, 4 Oct 2022 10:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=p61Wf+tALLi2ASmAeCCXqApbVCqb+Oysm27MBMg+WUY=;
 b=021IR6EmRRNe2eAll+xYx5EWLbwRWPn97I0Ap8pXNGBqYeX6RCrohdpl2ZE5PWhDlA8+
 nI797pXFKcUSFpMF1pGjpxn7KBsfUauwtUa7UsiEzKbHYPJR3uNDWiNqysQRQ1Nva8+o
 kq/1+AtwmS1ZPzyx2pOzadq/FB/W/WA91dpiMR2lacAalyISx1rKsi0sabORUzVCf0ML
 W+1W+GNSmYjG8S8YPqKuD2+vY3ayJOspu9RmoWUBA/Mo/0adb4nipaxz08ojeEdvvBdL
 Cnnpo/gQr+XZiV0kqbgecFQaQBrCXZLbxKuqr2i8e13i59xXtZWxZ0fuBxKiBzv6u1H6 5Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxe3tp87v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2948AWnV028277;
        Tue, 4 Oct 2022 10:29:43 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0a3h8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 10:29:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0IMws4o3PRApFXX9wfCNljUxFM/ACoIPGWbrDkQLNIVNLA5tkezIFCIwL2HEqzPMmGVh34nG1yb5dfq0PkGMn34yCu4Cr/5WhnP6/2xt9UaWA7xOeVTeHoco2HEcWvaUObvJ9UlTR5OZRpr8Q2q8RcbOTs9zS3/dodMhUdcPnpFDHZ7j6yX/OlwrRXG/FP+gEZeFmRTqrkH+ZQ9fN0uO+cjc2o7Xmbtny+Y1wcqc46Mlh/Nhhv/EYWiKjRc4DhLpsnqwKtqIqOIGFYZ2zuwk0vAAJLclqhs/Q/i16qRPWvbdV4JJXbGKe1lWDQ8xWtYA+6uBg/vQkUGV9saGZup7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p61Wf+tALLi2ASmAeCCXqApbVCqb+Oysm27MBMg+WUY=;
 b=f3u1EfEv5UUcQEe54ByQ4cmC8ZytOs3kNJBP8hWdiZcHcnFIGmkPlnmGsEjZ7t52sWafdATgQUC3TCxFtD71jTdy6eFc0Die03K4L5LrE2JGLX1EiRiOF7Lq0af/25RwiS8ErXrpozOwxny257t6W3QbHZVy5alJy9Oo9W4xjPuCtmZpShHl2eYpC+mzdFZrdNTUYdFQ4lOboa0GD7mZ2GM1uJ4gpUpqwaoxOq5EVLkpLcgaZG5LkpUBriz1PdWfsL9voGVIjTeF4EeaVot4RzxAHeJXjDmiHIe38UZ2wyD6MjQsU19AMFVdeRCJHe9562rm6hiiIlxSQKC6yGtZhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p61Wf+tALLi2ASmAeCCXqApbVCqb+Oysm27MBMg+WUY=;
 b=gI1J2+n8bWSkhTfv4m/2yGOwOCNcYdSGpdgSjc27U7A2L46kTCLoh2IvlksUjQE5/o58nXfFSQuf/DA7mZ2qsjTGxJ4+oxeZpFnKOWb8DAeQ4SsDRG0BIn8dkFh1PbzTnqgBIhcJOfj1legAHEOxSJ99zg68TlGO56NULICet7M=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5184.namprd10.prod.outlook.com (2603:10b6:5:38e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 10:29:41 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 10:29:41 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 11/11] xfs: remove unused variable 'done'
Date:   Tue,  4 Oct 2022 15:58:23 +0530
Message-Id: <20221004102823.1486946-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0041.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5184:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a241a38-444a-40a4-b290-08daa5f358fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZMd2AK3d7/nkNzWN/lyevyTMNTY2eYP0mVlNy2ytH+QUSnzCX0syBh6NrYFRADlmedOEr9yKTDbHHP2ss5F3Imb8r2kU1jiC+IXwbxWbt3wFOxwfijlbUMjB8DDJM7L6SldmVbg+qNbWZGUpahQO9EoEnGKWEKZYWsuyVbsdZCiQxVAOmm9rhP4bKQN7rsd2F/FsKUl+BvyDLoDUuWNrrqSM5zW6rpMhz2rjHoxdui2UKMxgv7YSvB5Q3YQHu0M+7lvcGJCE4Z7ZXWWRoB+H8ObqsvyOuPebIGe9IMqGFveT3iiDL14D5BIWvmsQlWeItMpBQGqDGuOL9WL0pokzj9a97s6TTLL4n8Pba0HIbqKB8pLnTyXXsn/WayQhuxAZ7nu2vlT5x97D9sek3JbQ8ljRQnNyFNZMMCFPkWQ7uxdvrDKP0/2Vd9/qB+4fSwJmX6J9vLW5/Hn6ve9lwCZwHjbtvmq/WG/oyIH6wXwYTnuzRFVLPN/ecNqavL/1Z2jMcELsS72oUrN9JVRoyGELGVLpQqdZ7dimaf9qWt90qQX40wHYRw9LT9DOp3Q7Fb3beWGxwRBR0SSWdsCj2JMOYxTjAwdLyPlCZmc0kHpWNwfVkU76OKHGHiykXoZ78g3T6DiC2yhq/IdVafq1/yP+uREP3EMsrRLo6leySSlU617vBWYUVdK2pIBV4DcFS0pG8h+f/Goaafvml+b3E+xsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199015)(83380400001)(38100700002)(86362001)(186003)(41300700001)(8936002)(5660300002)(316002)(6916009)(8676002)(66946007)(66556008)(66476007)(4326008)(26005)(6512007)(6506007)(6666004)(2616005)(1076003)(2906002)(6486002)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UnA1erYwdgiMN6kuv0F4P907VsoB0lWXusmcIDjIuehIPeGonVA2LecbkLdw?=
 =?us-ascii?Q?HKRP6hXPQlvhBEqkFoaNgozLXdky20A6soZdS0006apcYmYHUm1yFjaxEAE5?=
 =?us-ascii?Q?GWibXhz9Shui+qaIOHOrSzmdFQdBNL9qdSPJ7sok7GFcOSUPZbWNr1MeweYy?=
 =?us-ascii?Q?XKGV3Py+x3Q0s3x0v/wZow887wAf/wwd/z12bCS5C4zISlv/lQ4l1TGyScOP?=
 =?us-ascii?Q?CNmljoPTdqJpzn5vhdUnfRkuBkTciN0oLrhCVv349P1OOBPbijnbDAWdNUSK?=
 =?us-ascii?Q?1pjPO24/Yc6EDwwoRVeehWThQD8WZQc0VKJSOS0CxH059gV/2jA7RXByZvTg?=
 =?us-ascii?Q?M2Jj+hSb58r10sZAyBg/2XaG2txpT1ldUHtvjhdXEuMG0hGdg31eRzbgnocn?=
 =?us-ascii?Q?Djq0VXhM0VdK9vk4gZWMRlAppRnZlSS3kwN0KdzP+0c0QcYxGbkqXtDC+goA?=
 =?us-ascii?Q?X3xNJVJ4S+U7D174hp5IO2MI8BcJZUn6pABrbN8CGNE3siXtR3RVmov9Gt5J?=
 =?us-ascii?Q?nJISrty8QWDercPU45Xg5JC0Rd4U6bnKVwIxuY3WoBqGCp6CwiiEbrBXsKXj?=
 =?us-ascii?Q?NisvtmF9aVEF5g4zgh+HLJi4I0X+I994Is6esKLfcnLpXrA1Xqoq5iO/s9TG?=
 =?us-ascii?Q?2aR7bzyjFFl1xa0d3ijqA+qYCHrHYGcxtTXyDOKHomNTXIS+NCCSj0la6GQw?=
 =?us-ascii?Q?V9ebruuwzKYd+iBLnn6G8KKAcJ0zPoL7jJypZzDm18VQmQuWazYdFthEEfj+?=
 =?us-ascii?Q?cw83C5Tq4bWIZskr7mOKwaywTFSvo04HsOcNQMuOo3opQYHph9BvdNdYu8Kh?=
 =?us-ascii?Q?X+8LHboq8WSAC1DvtSUsCAAvJKdIhuiAzE1t/3JQ9VXDriByRufugN2b7P/T?=
 =?us-ascii?Q?7ywK2zTpK/VsxBQKateSrja3BmqKQUtHzFjZWKN1bas4SDyfhCvfGNoTkskN?=
 =?us-ascii?Q?gl/UHXtvpXfSOZXnRm4uKO1uo0CdRfd9E9IzDce2BMCINfxIM6vsdZiMDN6h?=
 =?us-ascii?Q?jK9tc8+T5raakiTLnrYqn0CN7mrlHEHk201P0kaFQ0ufcAdf1+hAZS8VnIFA?=
 =?us-ascii?Q?U4WS+3uBlNPIH6zskVG0pprmj49hX9zqzQTGLqTuY5I/BkdYOVfKKpQM8EDw?=
 =?us-ascii?Q?G/xHkCacAhvOx60W5h7hlMymCYG1EmSej9jIx+x3xiIIoLjtvP9QlBuT0OPv?=
 =?us-ascii?Q?j763CGA3CySUHqianOwViJBGLlXcCDsJrS2bsa995++32emikkJYkmk/0bMt?=
 =?us-ascii?Q?83UVEjOkS/la/ihKRHrRQGdfBgmKN0M9SO/sG2A+Gm62v9kpfgR0UxoDyFhs?=
 =?us-ascii?Q?WKEtoNs/mDKhHiYTwbqgdjSZWfMIVs9UxVwmInCNSlMfSgTqkl+TijKp7cRE?=
 =?us-ascii?Q?Nzh+CouigcNgxYq+x4T65d1lWNhWv3IlH7GCGZ37WmO14+w5eg1XIxVjMh27?=
 =?us-ascii?Q?itWpwVogg3Z7e/GNako4Adq3CBxKZd3daDJf6pxafmv72MidHbLPurXuEer7?=
 =?us-ascii?Q?Zi63EjAwo5i2eqYModO2QUst6GrDZEguY9r1Cpjq/r43Jfbc1eegtntLGL/6?=
 =?us-ascii?Q?47OIviQGs7Qy3zNuQXsYMhZfwDHk5VXo0CK2QfggAZigtjvicfGoGKJZ8vnA?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a241a38-444a-40a4-b290-08daa5f358fe
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 10:29:41.7099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZeD0WtB/P2bjuLGD4EpM925vWR+OtbEK2x3CcQ+Ouuz4QOUlCyY6LjlLrR6qAG1f98YiwAi0UsrxRIyCj5XxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_03,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040068
X-Proofpoint-ORIG-GUID: rw77jrWvphvuo1lBFenc5lF64Zh7Zdez
X-Proofpoint-GUID: rw77jrWvphvuo1lBFenc5lF64Zh7Zdez
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit b3531f5fc16d4df2b12567bce48cd9f3ab5f9131 upstream.

fs/xfs/xfs_inode.c: In function 'xfs_itruncate_extents_flags':
fs/xfs/xfs_inode.c:1523:8: warning: unused variable 'done' [-Wunused-variable]

commit 4bbb04abb4ee ("xfs: truncate should remove
all blocks, not just to the end of the page cache")
left behind this, so remove it.

Fixes: 4bbb04abb4ee ("xfs: truncate should remove all blocks, not just to the end of the page cache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d4af6e44dd6f..30202d8c25e4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1515,7 +1515,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
-- 
2.35.1

