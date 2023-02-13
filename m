Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4505EC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBMEFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjBMEFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C85DEC59
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:16 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iGSc018536;
        Mon, 13 Feb 2023 04:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=AOn59TvjkfXdWSD87bZHEcFddRAMA0hJ+srFR3L9UzY=;
 b=YWeHP6A6qG12PABj5MF1pn8q97lS7PEAQs6I5rCavjd032LHrTZLTGAl4V2m8zSoLevW
 5w104Rp24fRMS3K74s/2SJcshxLAgoa+6JV+kYHwmwjoJvAfc4P0tKj/SdEUgE5MesSr
 Eo4w4Hbz57l2z92Pp0v8uBgHsKmPvRu+1nfZp7dbi4xMS5Hxxej0uMghN/bjcOXQVDMO
 8+fxzlzhZ8bp3smrFv1akhVBEhnvo2IBSeU9GsOfnIwmaVetnNTddO4IBFpT8qXBjUnp
 Nvd4rvdMU9Yscs1NW1o2kb4yyrkMlg95Cu9HMRctfrPzACyySPKlqjNd3qXFt2Dad0FK xg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D35gkr028859;
        Mon, 13 Feb 2023 04:05:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3a90u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQj9WXmyeTnZBoHCgDRymkVvfxrfW+c+O4CR3gomyqs+qnpvQx/S7neLRPp/iNdt8wT+Nx2aVHsKFUdwXK9MYjSigJGR6NK96m8WpfRJs3CHkAY61de+sMSi4ZvRdCr2BORCZzLG6YcLAH81kmylN2mZx9zY3rN9vKjYWSgD4WE0H5M4CoRoWLlmz4YbARXIZpKlsmMv6HHJIB05MV38yoOk5oS7+qdZ3BTO5PCJC3mZl2Ry/b+DKxB+Dmi2GPZAzDPoYqj0/ekeHkhQJHMCo/DFhpeq9rqrIqRWICx7A4whBRe1OwghRypDRpmCATCAfo3R+Jdl154HjvE5LFckzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOn59TvjkfXdWSD87bZHEcFddRAMA0hJ+srFR3L9UzY=;
 b=AO+SjsD8t7b7okkhU3mzKt7Js71qjG02Zww1pkQ/HmAP8EbFD2Ehl6Wcn6Nr37ioRSFIhvF7ITdXaszwIxQP7WbIM1sbQZ95m1c5QvR1g2i5o4A8m3WJoVKImyteL4Pvl0j/a9jjxpO4b5pSCnDF3ur87DhqdjguJws/btRH3OxrcQD8+QhmXq8AVCmcYoPnBWCOxXu5lpfIAC2eLYOeBlKKVz9oXxY29S8gheNqSXJzwYiSIwFAvxUT7RQnSzWMkqCDwRTzmaey3nyqIokuJqhbu5jha9ndoWvclLcuoYLn6KYf44jY8/UbP6sPYiDahAZaUEc5rivbzvKbvXtLxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOn59TvjkfXdWSD87bZHEcFddRAMA0hJ+srFR3L9UzY=;
 b=jmwpGuKv6w4h5JsmH4HdmWEYfPjsyVlJVxu6F8nQNxkwvbojvanxCLexphOA0Che6mHljFAmv+S/8neL+H6PA50BLDcF/pgkUm+WZcyZh6cpEcx0JMkXM3piiqrZWMlXKo2GTU9O4Fdx0Y14wEKYJN/lg7xsYCR2D5vGqPGnFmg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4492.namprd10.prod.outlook.com (2603:10b6:806:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Mon, 13 Feb
 2023 04:05:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 02/25] xfs: remove the xfs_efd_log_item_t typedef
Date:   Mon, 13 Feb 2023 09:34:22 +0530
Message-Id: <20230213040445.192946-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:4:195::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a23c9fe-d29b-495d-eadd-08db0d777fb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I73+EFkbx2hZbg9LQjI98CZG9GuPwrvuDzVE19agwMz97Unevh7gUtXykqD6Hsip3MIgm3TPIu/t/KJkF6OBHLLICUMpEPV2lA01C7NHGjYrLgkPH6A1n4C/zUBBbGPecJdO8rhD2B2ifXu9ZM6kW7bZ0YxJ4+gktRqpCKB+2QtVIfSJtsYbjGlV3EEckj8RKv4SrKT92S0DrBtgINSUp7lBqzBcKPndEHxwWQy1DqnrJkzPvt01LpIOJpmxhGsqiJxx8FZFT+L3VgSr2OjuDV1/VxQL2XsUbB68aOXuc/TgqGKXOo0zjQyf7Xmkw80WYz6lO8ov4kmwalYa6pWOtEAGrsPF4AqH6jaTR0zd7kYidpqbIKPPRx/fzwUbtiyHfWwdSlx0ez8Q5/g109oA6YMhowVjdQIAPxo/v4wV/0di7/9z+Xranmaw74OKMQVE1MAEclJKYdNb0IStUyngkpG1hALXyRGTO9V71x0Uza5PUBxqHBFmKsnmPsAwVMYo5n5H5BotGP9ajyF7J1ibYeGA1Xz+2f0IEjBLUgZLgJllmNIdBLzyirPNtWEA9NwkPcUOQ8gPLY3BEfoq+sUrDpjD8lbt/lK/0KpDSTPkYU85ej9IgjcmhzQb3HoGuKqs/zH8ZqEdXOnKESv+wupRiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199018)(26005)(1076003)(6512007)(5660300002)(8936002)(6506007)(186003)(83380400001)(36756003)(86362001)(38100700002)(2616005)(2906002)(316002)(478600001)(6486002)(6916009)(8676002)(66556008)(66476007)(41300700001)(6666004)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4t8W0HrQY/0D3CPZF492541xEpljpOWadyKC721QyYiDC5WeLlClK5i9e5Yq?=
 =?us-ascii?Q?gqCC7yLu83umMSkHcFzQFp/wud/ONuRRF8JUV9TUa9xe67UHYkzgi/lz0qGC?=
 =?us-ascii?Q?xnzg72WBc/HlSFRtNsmdTP2SYnVJ4HTUA693vXA61os+Hl1v3iYMiEyRrcoR?=
 =?us-ascii?Q?VOIE0VxbRO5jFOciJ7RAh0hAYjVOqTeefj2JqGpD/kHE6L8OPJmKXLK+CRD0?=
 =?us-ascii?Q?TmAyX1hgk6WhP7t0bPqAZtTUezsErJwuaiqHtMRo81CNlxiDIoFoTO97ip6m?=
 =?us-ascii?Q?0FZC5rx8OMjHKv0Ilv2YHVrFE2U7iX+Zg1wFpK6GQNpVPwCV17XqiTLmTVLA?=
 =?us-ascii?Q?jsVPYy3c5vP+GTlfUMpzZUjkUDq/LNyamuWjvc7e2/Gqj7YaN4hWB2P3rxWj?=
 =?us-ascii?Q?xnVGPku6SNy1eT17FUL8XQkX6kD4eXIF2ZfCkRcNq1rW2DSvMV2Ak+iIGEZE?=
 =?us-ascii?Q?aHLC2Jc0/o1njsDxObEpwBue9dLQhARyPX4AgWgvC5kgu508/9JhpLQNcJP1?=
 =?us-ascii?Q?oQeh4QNqoMyfhQDoC+gcm4h1lh6X7QruJuyISEmftfxfDabX59lEs0D8nRaD?=
 =?us-ascii?Q?1yNq2ZzK+Xz2GUPBcpglkxSreZT+1eiQ32PSYsSGhN3hyTehmppvGmhcJvzS?=
 =?us-ascii?Q?99QNyhREUZWV0v6OL62uUreOomYhXhBioeoq5DDiv7xiNoqiH8FtKEGitdf9?=
 =?us-ascii?Q?y7s8+Td6m7cBstTfPSitQKKwQmNsIyRU6RF2YJPNUm6HJ8GboFvC98SsooQB?=
 =?us-ascii?Q?Io1mJcu3sCWPtZQ1CIm1rp32f7bdXgk+NRcxdZRZguR8fovKGovIcY2OPbFM?=
 =?us-ascii?Q?c5zkzxQZNXYCgA7+n0cv+kDUZqPVnhhuq5VjEwENs3fVCJoMYClOvdug4nX+?=
 =?us-ascii?Q?Nmlc4+siYW4ocrzXhWHqzwCMRmFNP0gv3Yb7B17g3QjDNtQ/Obp1uK4ptVO8?=
 =?us-ascii?Q?39OI96lGdHafLosPjmt5L8kACgudGKBiPU9CHNxznRF1TRldMj0dWm1E8aeL?=
 =?us-ascii?Q?IsneeqsCxIB+hzwmL/fZevadQHq2PCi7OJKSWX8A2oOgojX2t7fwl6ImdjUx?=
 =?us-ascii?Q?ONLEFc3+IKVEerQGZdLWm+49Z63mFZUClTMwfCuPbCdJn5WPLaQjiCqedK2S?=
 =?us-ascii?Q?OzgUakPdz1p3G6XRnvGjkvuLDTmWUbRyCbRALAPnIfj8Lo6SMr/yiM+y4D4x?=
 =?us-ascii?Q?FaPj8TIhJZ+8pPDzm63cIHCzuNQdiqlbQigOQg0VpOTqzaGV4yWgmYTtqNde?=
 =?us-ascii?Q?Xg3NCVqqzDURykbMxW79g5xlU0ADcuC43ovEiwt6hXsgoDHbXX1QdSBAuO21?=
 =?us-ascii?Q?Z1Lrclb9O44weQYyOiXZqXICeJi+/P6wsC4WyBpamcXE/KowFQ5Tek81c5zr?=
 =?us-ascii?Q?4ZsOaqMQPnTj42VqWICa2dH2S6kN0oGD8UvVN9dbUcskm6/HiMgIefeMHX6G?=
 =?us-ascii?Q?VUg24NNiG6Yp04V4q8KkJda3hzQKe/rczH1hlAnxpcvJooFXd49KcM6EKbqF?=
 =?us-ascii?Q?2fXw9wrkeRG2OW+4To43uwqWqR787ieZkMDKtM95PeCN5G1PCi8ih/IzIn+Q?=
 =?us-ascii?Q?w+Aqps/ZVrCdcUR+PyULHBpLZ1sPvW9hYrH8c34sUq9NFcHfCi0l6uEUfCBz?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /Q2Rp+Gq/vmW2MrLi8Q+EZmLn7SwDN2jAua0NHMbxoypPk1ts8LE/JVnS1vrT9388cfDNPQT7M1IZeq69ZqfFQRaFfdaYdwwT3B++YREV4HREIafwkPzMcwtWeiYCOCf0wGYKHl9zgM8MXlTFzuXqkCf8Prutl0LeZL0PUZ1dqKwrJWpMN8Lq1ObqAVwX6zRsbZiKWuPuH5tRzhhMLK2PiXcO+WTlfzcm4AazQ3RQbmSK22/oKGJeiWzGmW+9fKpQU3+ZzRaQG5M95UEjWAOOYQrw3ZuBrJHVqvRx0jgJNN4jFH65CniV7WZ4cuqltL0v0Jk3WXLr5OvdQDCgRE2/pT13Tabpt0cc2xqp/tjsm78KO/DPs84TDagc5yPnoagIZEC1E74MeTKO50bzG91OGVkXp/z6pS408qlYJZztPWfk5H3l1p+SC9TWi+oxp6tApOGbPTyyIj+pW3OE04uNNSdt8UPxKTK8wmNDkwD5r28G6Va9uMk+IMQ6EX2ZIAIWrzqaXA/GD/33nCx3YteyGjvpvh17pSuBLs9AZ7uN4g+g7b+vxxXrhgXPgRRXxCvO+zRmUfWEW4SWIzQWVQfPmi02/qzXZC2OfHoYqWv4z9ep/ykiuGBYSa1Ji9ahW4oBc1Iv5iN2m9og2PAsyar3JDeJttRushAj7zve8ZXUpRtWxi+j7QrbnqJSZqaHEOf2mrw7sqwrzpFLKXUtJ8KPH6SbFaGPVmpUYu6qirnD0qbJ30IyVJkAdfXCGG8EphnlNRL6s/L8RHMFFcAzkyR8ErVHvFPlFYhifq8fY1zpgZsuh3D18NwEOqZbG4bFFnP
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a23c9fe-d29b-495d-eadd-08db0d777fb8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:10.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/25wfjs06Ldg1zeLYxhRoPSZlvvbYrJz3i325pkupwV5pDeUghvAfT0iHy+oDDpu5bP11rUGplWyHrT7PyeqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4492
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: EUmlwmh7xQa64xVaXqz2CikhXMvb6xuB
X-Proofpoint-ORIG-GUID: EUmlwmh7xQa64xVaXqz2CikhXMvb6xuB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit c84e819090f39e96e4d432c9047a50d2424f99e0 upstream.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_extfree_item.h | 4 ++--
 fs/xfs/xfs_super.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index b9b567f35575..a2a736a77fa9 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -63,12 +63,12 @@ struct xfs_efi_log_item {
  * the fact that some extents earlier mentioned in an efi item
  * have been freed.
  */
-typedef struct xfs_efd_log_item {
+struct xfs_efd_log_item {
 	struct xfs_log_item	efd_item;
 	struct xfs_efi_log_item *efd_efip;
 	uint			efd_next_extent;
 	xfs_efd_log_format_t	efd_format;
-} xfs_efd_log_item_t;
+};
 
 /*
  * Max number of extents in fast allocation path.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b86612699a15..9b2d7e4e263e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1914,7 +1914,7 @@ xfs_init_zones(void)
 	if (!xfs_buf_item_zone)
 		goto out_destroy_trans_zone;
 
-	xfs_efd_zone = kmem_zone_init((sizeof(xfs_efd_log_item_t) +
+	xfs_efd_zone = kmem_zone_init((sizeof(struct xfs_efd_log_item) +
 			((XFS_EFD_MAX_FAST_EXTENTS - 1) *
 				 sizeof(xfs_extent_t))), "xfs_efd_item");
 	if (!xfs_efd_zone)
-- 
2.35.1

