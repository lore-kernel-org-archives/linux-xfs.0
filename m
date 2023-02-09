Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C06BC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBIICN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBIICM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAB8265AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:09 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197ProA016215
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=fNKnQ6ZYZZiMCtDEqPiGdbURkoj1co/cnKLJ4Deslr+zmPwqz7e+RriinKA8mW44eh6Q
 8utSpWVe6GEz2CXSL+MXTxYqSoUD/4j9AADtd9NVlGETfqiY49iNC+2e3GD30g2QC13Y
 Rj1x6mG497s/5ufUJJb0m+s+EHvrq1WDiOdKA8hojQW7L/3AeX9k2QOtlBVSHTslRzbD
 ORQGEl4aXFfTpyxKWb8r35Iyb8j76n8m4lhgk2REcYsjl1O/QW5yAFcohcvqoOIaWrxL
 co+d6Zevk/yOHwvMpGvWsztI2xvyEXCCpLXHClU44QwlYhLPWxr7bb38UA/+w1x4km4c LQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nj4dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31981xCs030986
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbcxuh8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXF0ixpX6GA61DEB88udPNsCZo2jZ2QFG0HuDDVOBW8Gtl+nTbPZKYmykotGRdVux+Ev5XWQmT7Jd6EGwOSV4VKz/F7Jh1dfNVSactaWwoYTOO9wh2hMQnKCDZmT98GVnDzVJCq5Xz9QW4PJe0dGiU5/Z8RAwY6tmTbg5m7KB7JHtA73KV0NB5qgLjLYcgK4iHKQa0kQh9oI4Dl26KOY4rapJD3cZQYffqL/7MmXkuc2HlNKakIyZl3Hqr01HbN5WslvGA0vXSnaCrE5bhrUJ9ALxpjvp/YBH6O0cYApZnzjWS1xGSPf0PaT9Jym4LujfNwwjfNatqZ9bYDhyxzRQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=AkRaJH6o1HNvmUAobJBlE+pCVmNFkrPP+QuuPCQT1pcyP4lhuE8/IxDUq2tCJEVQc85QJLWEUas+qRv6gMAE3gdbJ9LlojwcKiFq5QyN+hjqj3dDfhtVmrtVhzvDUXan2esfrvoSnrnS54nSQ3s+BR3JFxKwjuBKe4+ZUkmFbWWYJ/pMMzpwK3q8OZWbwHIZkTei8loiwNY8cbOnSU/86eHqpkFV1p1i8l7bVJbzAxjORHXaatb9dax32muRorliM6Qr3sHGvIxEEMVtYXGLxZI+KNLUdTbP9PWTwiHjC/saMgCMGPB4Nmas71vl0LQAuN3ktFzW2HuKreUnIBlYMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7c/ag05lDcclOjw/wtyCnf4/2HW5521laIEYPVOD18=;
 b=lrmTB6kuxQHdGWsAiMI0RiOMq/F3RjXEG5jFkYHveseJwd2NshJNDkJRcgfBAy0OCwhE68IunXBvwMFmWPq1Z5PYwdG9Qop7a3X6x4Lt6O1g9TUAsX1ypZr6lB8Z8QTxB9gw5aBDXnH250Bapet1czQHO8qIERm+AMHzObLclh8=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:06 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 10/28] xfs: get directory offset when replacing a directory name
Date:   Thu,  9 Feb 2023 01:01:28 -0700
Message-Id: <20230209080146.378973-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbd06e3-2285-446a-ab0b-08db0a73efef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcLUjaY1WLmj+pepYoCDfCTf19Pr9bT8owFtktW5SiI8/yBkM/UvBGaWm79MCmOlgL9So7exuWM8+99SQsXFfn7ZIsT2hLlKymQkFgQ9NIT2R2IGO4cWtj5Vl04vUdpV2iE8GgkYjIksuESgAaytT9nhsYddIiIHeIqcJKZUKKCAss5g+4+rzNRjT0tUGBs8VlWhoFNltm9JGYm7tjw9d19UxqGclXAeQLoVAm5bgqexuU00ZWFvtWR2DJAFChLZPUeqVUrGoW7phB5xLgdg0mrdTBNrwrehpGQ1Ze+LgYFwCy2zMSzHC1e30QVCBWhyi9S0IX6peUacjenPwOfCdihrY9ZKYrVpQLMb+LVhIWw+LXFVC5Nj7uDwgWEneO7TBWr8pZ9sUM5yw4TngT7dV/0rzFgezId9APNBBmF6O/6Kjug/7ne3ARvYtYSvEbJAjnyN6dR53XA9F0dKPbu1EwtSeQHupHJjDqi22fuVBOoeQYm7w4GIn1Jw3B/H1RRveNJhMAStmrA77gWyDJqXK53aI0qSWNpJZia2EehVE3zHK0AfAuAKa75H++wXB/uPMx3A/Qp9y40driP3iueI0jrwcJVJ29pYPB91KWTRuJ7V/waOAc7hhXZ4Xjsz1aaiZrFUyu7dlw67wsm4AXK9HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IgbG21jS1LF8TzzLj+05swkQ68IoXX9YK4LOBxmi9aqL7R8WAKL5ECkcpIlJ?=
 =?us-ascii?Q?GTMe8PG+xCvo672n4oVYPn0gysDHL7v90BtBDts9PrfM5gsyFZ28uUqd0OMX?=
 =?us-ascii?Q?mP/Ww5NIAn3HyJTbTCKDenXkmsyexuJE94h4M7EBPJuLz4QHNDIiSsHSV6c4?=
 =?us-ascii?Q?l4/IKJPRknN813pC6Ce1Gff9StY1QXlwVXV3QqNFZmhsj36N6sMrJqX3YhfW?=
 =?us-ascii?Q?F/uIQUF7jX4VGK+79w9vVnbVxcGJE3rvvx/Iy9lzoUArtC3sEXyfn4K/Muog?=
 =?us-ascii?Q?JivEiuuR2dK2yxPdxKtWFzCvMBdzXf8aaMOXDJDevLfqi1Op8HN9iKqZNaW/?=
 =?us-ascii?Q?Xl2MxPglNXu0ht4aoAu+asheIJ0TqT4IvmjdwCRiIIixLXzMjFar8uG7h7NJ?=
 =?us-ascii?Q?GGMGxK7HZDVlIoNCyP5bXBVOc2EdKnuVPuiOYvO05rQ5jv2aQVanNwFHYcIn?=
 =?us-ascii?Q?LrHTEhllZChqkTkqFgj/blfRmhZYBhxx5BSAgRdw78mQ9OcNVVyrk7tZc5NY?=
 =?us-ascii?Q?jvbupKm4kLvYw5WWwv98O9AP810QVzbDoZONggNjp/kjo+vY9QRTHw2+j1Le?=
 =?us-ascii?Q?V3DQbdFqdtoGfZUDGkk0YA+zQrqDRr4Kx+JG2E+TqtB5ORO5rS3X2xQNZ6LH?=
 =?us-ascii?Q?cXsrGXOhHXlKaIk5iGS5mQjCCti8aGny0axai2/815DYrA3NCgrrw2PJB7vK?=
 =?us-ascii?Q?9fvkThIFUBAXMXYyOI9WILcpNuRIP3H4CxrGUY2gi84Gz3AgLf6JPGWfWPh+?=
 =?us-ascii?Q?oTTE2ZwDV5xhkVFK3HoRvIncC82mmWoeC42Ir9SZUYdudlGT24zG4rSWfFDs?=
 =?us-ascii?Q?Vd7iCJg2Ea6QTqmLj9fb6lO/o5h/pCBoB0pu3+yYczuBmm5hn7dLiS5f1VQx?=
 =?us-ascii?Q?6owZoqIc5w9HfCeupgyNGn38G7cXt8kio6AgdUwA16ZH7UzAFViGZVw/lCb1?=
 =?us-ascii?Q?VxjOk+yInw1RcajATUgSq+R6bw4IqQvmmcsCnadnIvOa/hCPJKTe5m1s8unA?=
 =?us-ascii?Q?2UagHpqnmM7qaSeoaLDjWnwYdjcoyzUguXxQKxr+UfMSJ/KknoD4VRN1lx87?=
 =?us-ascii?Q?caQ/9oU4ABSgg7hDOC/Xd2FY4MmkMDQGzTYW5nuqf6LlO5js1Bc2HbZ8LQkS?=
 =?us-ascii?Q?kPP0ErXkaMqD3oQwsoesKikXe+xpIDOjeYR/duttg46dWGFUt89cgvicG9EH?=
 =?us-ascii?Q?eCmSFeigorWC9S0mRK//6Jj/WZPwaq4VS3K3MGUdQojV3pFpFqkUtpd+ElKE?=
 =?us-ascii?Q?KgxjXJOwltj6VogcPxZLsgC95ZY7gCzQlThmbrKlzgCLjb6svopi2Sqs9Cyj?=
 =?us-ascii?Q?ZL9BrRretJiqAXGvjCHL1nTwi2Pg+r7yjQf53XTZ0m0N63UH6LzzDY5w1L4o?=
 =?us-ascii?Q?NZbOV97EcpZdRtl1qaAVJYEzK4TUdh5S3r6u3JG8uJnXKU9BTEsTNG9HU4m7?=
 =?us-ascii?Q?iwMwoTrEzM9+Nr5gku72LDH2KaruJFIq5t/p1pFx/h1djUFgnhX9yZyrilPa?=
 =?us-ascii?Q?vvXgz0cCnxAMxfX++7+SbwAC9CItOj3jYzD+LOyixY/X+mjyQ5QngXSSApzX?=
 =?us-ascii?Q?38XfThuKt3k4/rZP52BD6a//3swbIIRoeTfmY/RDLTD2VeP4gq7grVpycWuG?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WG0yDsPXZPiMGR0VuIT5b85F3P85sqRN0tiN9N0n8dnpeJyDvERMM4LgQURc4B3rbf1Ft7GkNQMtZXpAb8fScYONaGzpp0037KluA07EYNaBZOnZ5/1/SSh3TmqUuFet0N8/UuiiFNc+gzdTZ0MbU/2Ry7pnFVwFTIIezR14GIA+SXj9qAE0SZglM/X4sVqXZVctOjoj6ccvYjLn6kq+mLDJ1kr1LPMzTkCL5hzcvGKd1iKGJuUY2PX8+ueVL+MhOgVROjgCCEAs4SVy3Y44Tpv8r0Tln5rhEODW40HNxUXI4vKnRaFwttXcSxnXN4V1o1N+FtQnOUXNbq9QJ1jVHjjmrTsZCPYJmfXc55Hr2IM9kTV+ng5T3MdzAFRznXEqSytLCWkwOj/lZ7yoijMb2rgeVqPs3ghyjI6GKJWqIpQsw5fFvnDNWQvpzKOZeoiukhS9It4tKdlHqn29L7bWvZDuY4WxtI8yjOSk6n3SBzdwH6iF6Xy4Aj9BDp1v5OHbdfc0ewrl4E6drKaV6viMZbz1iADqhwt50SBKUknT40H/5g7CtqOVfSPxEOgCyRv9t4e048Vyb7KmUQKqAC9p4mgtWJJVHqy3HpN8lFggy/7pjZ1+T9kPO3CoPnqwQb0NBix5os28136gSVIJTh6kC63kjXRMJSixvR77J6L9wduH1mcVlUM/lLQQ2bNQHOlMVVWYJF7oasndLoPCe4RSzcCl23kF6aDgY43aiLs03zhJnQG4t81jdJYe1LiyMIPR
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbd06e3-2285-446a-ab0b-08db0a73efef
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:06.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwExKGtSuuiKpbOh+VWvas7FgVC0s3uRbdq0LsuQPhsXL4Y8/LeWbmUM1+Yu9iogM80vyRLcQAKtc4128gH7FD/OzF46yuL+D7fEimH4Z50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=968 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: ZlAgGKonkj7blFtUKPO23R_tD3tQrADe
X-Proofpoint-GUID: ZlAgGKonkj7blFtUKPO23R_tD3tQrADe
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Return the directory offset information when replacing an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_rename.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
 fs/xfs/libxfs/xfs_dir2.h       |  2 +-
 fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
 fs/xfs/xfs_inode.c             | 16 ++++++++--------
 7 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 891c1f701f53..c1a9394d7478 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -482,7 +482,7 @@ xfs_dir_removename(
 	else
 		rval = xfs_dir2_node_removename(args);
 out_free:
-	if (offset)
+	if (!rval && offset)
 		*offset = args->offset;
 
 	kmem_free(args);
@@ -498,7 +498,8 @@ xfs_dir_replace(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -546,6 +547,9 @@ xfs_dir_replace(
 	else
 		rval = xfs_dir2_node_replace(args);
 out_free:
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0c2d7c0af78f..ff59f009d1fd 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index d36f3f1491da..0f3a03e87278 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -885,9 +885,9 @@ xfs_dir2_block_replace(
 	/*
 	 * Point to the data entry we need to change.
 	 */
+	args->offset = be32_to_cpu(blp[ent].address);
 	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
-			xfs_dir2_dataptr_to_off(args->geo,
-						be32_to_cpu(blp[ent].address)));
+			xfs_dir2_dataptr_to_off(args->geo, args->offset));
 	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
 	/*
 	 * Change the inode number to the new value.
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b4a066259d97..fe75ffadace9 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1523,6 +1523,7 @@ xfs_dir2_leaf_replace(
 	/*
 	 * Point to the data entry.
 	 */
+	args->offset = be32_to_cpu(lep->address);
 	dep = (xfs_dir2_data_entry_t *)
 	      ((char *)dbp->b_addr +
 	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 39cbdeafa0f6..53cd0d5d94f7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
 		hdr = state->extrablk.bp->b_addr;
 		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
 		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
 		dep = (xfs_dir2_data_entry_t *)
 		      ((char *)hdr +
 		       xfs_dir2_dataptr_to_off(args->geo,
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index b49578a547b3..032c65804610 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -1107,6 +1107,8 @@ xfs_dir2_sf_replace(
 				xfs_dir2_sf_put_ino(mp, sfp, sfep,
 						args->inumber);
 				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+				args->offset = xfs_dir2_byte_to_dataptr(
+						  xfs_dir2_sf_get_offset(sfep));
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5ed8bdef9fe..a896ee4c9680 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2489,7 +2489,7 @@ xfs_remove(
 		 */
 		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
-					tp->t_mountp->m_sb.sb_rootino, 0);
+					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
 			if (error)
 				goto out_trans_cancel;
 		}
@@ -2644,12 +2644,12 @@ xfs_cross_rename(
 	int		dp2_flags = 0;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
 	if (error)
 		goto out_trans_abort;
 
@@ -2663,7 +2663,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						dp1->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -2687,7 +2687,7 @@ xfs_cross_rename(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						dp2->i_ino, spaceres, NULL);
 			if (error)
 				goto out_trans_abort;
 
@@ -3022,7 +3022,7 @@ xfs_rename(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					src_ip->i_ino, spaceres, NULL);
 		if (error)
 			goto out_trans_cancel;
 
@@ -3056,7 +3056,7 @@ xfs_rename(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					target_dp->i_ino, spaceres, NULL);
 		ASSERT(error != -EEXIST);
 		if (error)
 			goto out_trans_cancel;
@@ -3095,7 +3095,7 @@ xfs_rename(
 	 */
 	if (wip)
 		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
-					spaceres);
+					spaceres, NULL);
 	else
 		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
 					   spaceres, NULL);
-- 
2.25.1

