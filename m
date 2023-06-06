Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77124C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjFFJ2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbjFFJ2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:28:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675EE126
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:28:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3562qVQQ013978;
        Tue, 6 Jun 2023 09:28:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=TJUeNc7CXMpsd+WQUG8PSOUrgRNu8bhCIU0os6UdGgLXKtIUAfMbNGWatW82XCQ8wIJF
 4fI/stvsEVIhP6teHLEfNuct+fxtUWAJKwqMFCiSwkR0r/t7lT0q21wmsIYYQOVpm/7o
 jtQUx8/jEY0jMPPpxamVAS2ZPdz8cVnb39DZCOCgz9xkI7VycNh2+BggcFJnJwHpr2a7
 2a/YHTXP2Q99AK2YFYtkyfSUVzvJN32UbEDu/obpft4gVZqg0Slq30aSEmxFb+rUiY3h
 Fgfitjr7PFz3nQn1pOR0t2FHdqM0e/WU/mLaTKD5cUxjMlZ2sCLZyexbz+Xo57g06gJU rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2n4vmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569DBXO024065;
        Tue, 6 Jun 2023 09:28:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tkgvbu2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:28:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9sDA0pg/K5xPC+GswmpKpd54yrIH08u5XEP60T3bxtVrihmOJCzbixHhBxSpxATxuiRQCdRaLKnm3xaFFI2LHUchtiLuYh2gXcplTmANFVhZ6y2LL6PBt6gmJoIY18BTwmhRKOOHiL2CZ1FZKXgW34yUDMXXeDcgIVI4jJ/bvm1FiLyKZ6DXu600kx6V17SvibQ7JmkkDR3RCqGVSWZa7wPrTBJ5fFaNqLSuNEwNxujWBO73TlaSuJ/g1kJ/tn4sQ32CfyUjYkkBDo/icHfLehMegGpYpblHoW1VoV6fc5Gr+XzyKtgmHo/1CjDO1UKYzObc1oJiLW4TV9GT0z0Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=bSSfAMl3B+oXTk4Cv+2aQ02bv2ARGwZXpfxr9yKaSHCGySIKmSnjKh+6svMjfcfy3uI1dSM3bHUpu5CseJvsAUybc+qGq1bU26kwazRadMxd8GS+UiAv1rHRLZ/BbD6ZMYSs/1BCfchiqTqDkGrrs+e9qYplxIodql8Tq5Z08N2HIgD9D35gqB3fcBZp8b1T9f7ezKWkQQHwOiHbY23m3tjQmuayToGJ8U77tTIULmw3cnW+fi965fiHQJGlEFwxiX8SqYIp7jt03jNfH58O4Pfnjv8dZXLGr8AaK89nn6tHWOTqTL/xqhxZ7Q/EsguUCEP4gbJ50SH71ZBues04Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ONOo55tdf3ee+BxrYEgkRmZAzZhTN+QPS0HdmE5hsw=;
 b=ZLRMyUppdp3ooCAord31lRanat/0Y4nBjHZubRHlo1DKdkj8uhJd5B1HqqInq1zsJ6V0cfJe134SNneodDIBy3UvG+fRLjCbXCpU7xzilKISQ4aIpegnXabVgh+HMfvQXTZ2QJLKQvW+TyUBxEJQ+ucggEf9/XYzn0SNZ6t/5a4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4781.namprd10.prod.outlook.com (2603:10b6:a03:2d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:28:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:28:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 01/23] metadump: Use boolean values true/false instead of 1/0
Date:   Tue,  6 Jun 2023 14:57:44 +0530
Message-Id: <20230606092806.1604491-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4781:EE_
X-MS-Office365-Filtering-Correlation-Id: 061a5f94-3b94-4c57-4be9-08db66706397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXmKYkDViqARVd27jJdWwOjQHqni7NrCdeNXfnmiBnX4SXpADV69qEc2xhsUrDMj2141zSV3r1YvKNJlDizi8jNz5F5sOF6WlWlS5p0cA/iv6AG+UVUSwZp2Z04UD1rOHeJQofVeBfaHWJwDf3Lz7dFvBFTFHA+qm/QwmMRlwO+wpq7nS2gZqoYDoKNuYdVFlXEOMRhQAbKwVaWX2FYp7cdVzZ22jyf8oXzXCapWWE6uEezCdRa9YIQ9MAtnhp910lDQNBUJmqE4wYtVgHJSPWgYr8gk4W2BOLNfjJMuALcBqcr4BbfWJBiX577VUBeYf+U9aQnr7nBO6s/nkeOySvFZAVs1WwyUCaI0X5JSYwI6VXEN+iqn8Om67yenVgoQvDTbCXit9WB273gXFtTIZMfw25J/fgMcC24FaajcKDrTn98dy8Xn7WpksHydaZbpDrho+tsHMvc7X39toBzFBgIJXCM9ejovEeG0A4JrO6B9Jsk+o9cHYE/PEt7WkunopvULbRJnjGVlMf+ylWR+iK97FMTl0+BIUDXHaaa3TPWPitxwBgq8K/s7gg7HT5PZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(5660300002)(8676002)(8936002)(66556008)(66476007)(66946007)(4326008)(6916009)(316002)(41300700001)(2906002)(478600001)(38100700002)(6506007)(1076003)(26005)(6512007)(86362001)(36756003)(6486002)(2616005)(186003)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vePtjTm1fVzb8mpl9akwNa7ZwcOq8Efz3zhof4bB+biXkfyzG1+XYllFxIoY?=
 =?us-ascii?Q?UJ5hL8Rt6EY87oy4ndk5Mu1URBAWCQ33LfTNbsjrfxSRyxEoh1R7/JuJI/as?=
 =?us-ascii?Q?Ry7wtbUHsOtMZFsGbJvLIEl/6ITRJ/9EaIJC9BEcT/8lix8tr9LEMfnqzgMg?=
 =?us-ascii?Q?A/rhVW4VqZX1Pj/zIQeDc+1HttRueMsmAY7xUZAkRrRinOQVTfGODLrNOnTx?=
 =?us-ascii?Q?HkUPLO7do6kQGm2FbBxjZUbvJ4AkCc65a+fJyXaGEeX01s/NBtqzPhBy49W/?=
 =?us-ascii?Q?lXPwTbJ1ZcDvseS5il/qWlV+oy5cC0yjbyZrFmo+GNTmyvnCz8HCb4J+SyXG?=
 =?us-ascii?Q?/7BZNouaB3Sw2buPd7jlRBq3UGYMBMuBGoblEZbFFX5he2D6koHEM1Nb7l85?=
 =?us-ascii?Q?VYfNI82pT4RH7WdpkxxHNxWPONrKrODaj0f5F2tdkE4iZo9iRIKcQD9XHyla?=
 =?us-ascii?Q?xZCiE1TeEEO0l+rSqs/wuX+rSQthiXE0ptvOEg4iOP0SvKvW9Au1UxB+c6a2?=
 =?us-ascii?Q?BrAURG7RhKm4EsyqNEPGSvlBKYHyxi6DRwYJlG0RCfqRobJ1dJ06tcla7vRZ?=
 =?us-ascii?Q?BstjzJFnnSsL2A8rCUlsmeELbJ26GiqaHs0gp93mKE0UO0mZXNhdWvclR7gV?=
 =?us-ascii?Q?B30h6Pk8XjAc8zgHMzHv5+yycGdnm2cXGrbWc3E4QdbR4YNm/+QCp8Tiibbs?=
 =?us-ascii?Q?/SQfrFNXOlP67xWABxfX5lgrkMAXWINqLCCXM5zu7SfoqAdXHn+ZbhegJBfc?=
 =?us-ascii?Q?/vX+F/AmlRnNwHlpC3oqbQaCaAPaxb5/NVWsAWTaFkWTOsN0JSlQiZne2sQe?=
 =?us-ascii?Q?y/BQ7AjWA4vVI+fNbIHmai/tT3st26map3ecMAq+J6d7YHKos13KuetvagG1?=
 =?us-ascii?Q?NdDxRn2RgZVfdl7BfGyzh4PYGI1mSxvTJiUg61+qYZ8PATKAzkoFwoF2ILO4?=
 =?us-ascii?Q?3Jk5o94EgyJnMK8URoC26wSkUjKkuGeE6nMstn2PgFQQmfQXhcnLcFzLPJ8b?=
 =?us-ascii?Q?bHnHLgbvrJwU0pX1dcCT09Xc1gunkJXrSZ7kZPZBvP5MGrrYmwJ2qjUqUgpm?=
 =?us-ascii?Q?IDUTT9pSleUC4W8vLPs6VECk5hfWuQsJVfgWeCjarsJ/s+V6twcQVgWfa3NQ?=
 =?us-ascii?Q?EAZWMfUCrzBn30k8JSHb9Ey7No9wTcx4wKzSWMw4ZtHJNYPoI5azOWTB2Jff?=
 =?us-ascii?Q?76yePLxjkeTkSGhISRxo6qiTWu8Zcv0W9uqoZJx5PCr7ko1iu35MIEPD/4Wc?=
 =?us-ascii?Q?Y87B6ciey9dk9Mg680ALsqMtk8tdcJDkg2jo+uROT1yczlJMwZWhbDvRCWvL?=
 =?us-ascii?Q?jQxH0g5VzWNkLpj+ilMoOZYo+kg5HcMlRoehJyYICGiRrgO+gM16A1O+ge6y?=
 =?us-ascii?Q?ONbUJfLRoaqJVKORZu9LcWiufIMydCkT+2i5F/g2xXW+vskleFdpenVvvDKx?=
 =?us-ascii?Q?I3R4XyzJiIviHD0XvqvefVav92VQChY4LvWDz6wNE0s+hTlkGdabhdjWD4xT?=
 =?us-ascii?Q?sVra3NUKr5JSJszH4uu8PZzSR5TICcLlYi9hSZctAYUtWyNNNO2NHiRbhdbC?=
 =?us-ascii?Q?H92O80GHxphdoeVaDqoULeLAbN5hqg3MLM/to/1q?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Te8Ne0zmOPnKyqqP4dQCXdncMWoA0h1dBgBqB7JJHFR15qnXhEw/3POq/B94WCQwy5GGgHpJd052QFDp8vVY1E0X6zTQLK5sR3M8nTrzLPHJyHGQlEL+kROCS23Q3Uvuz7GZv7yQQwXmm3M65dIvGNrZ23D9vERenGcw/vRsYyULKYU2bbTpKDgtjs6Z0dgyTX3t9XKcuc9L7Q9MBmNE1QuwpDzfjDZnXYxz7SCtQ9UeX4GvdkqEpDSTn54jKHTIO3pHaSNlt1aNOdsuNCRFTC2YAi/FhvcS3G8VmwexgwaL5pni2YyHFRdZBKZXY5A9fHVoY6VCpuIQujgszt9k9Ywt6xPq8awA9l2d2d0JqB3ym5UljABz8qMDEc8T9uSHkd6Fs2P1AS2QWgEbIXcGAPGtTCGmcjJArBRQMtwn0cxhC7i4oEqiOygXlWvfs2/KEsJBzjdcE+gNIM9y/CI+pKNXJT59vd74Z3vXF6W6v4bPZa4uur+lAm9tV23U/3QbKFwD9c0MEm/O+dHmyYjdOGeXDO6fbLS/5215avC0S6yO0A1chJ8yBpmCrvSY+3950+8ydaKNQhorcXTaQDXVJ+/lTVuBFUXHK3nJiopCrYxAye2wmXPp/xMHX/flStwCSBT3A7FtwAmDVfvnE4brhlDM2+7b0uHMvTQ5A1cHK2dNF5eamgDbCG8OOJOEvgKvYL26hEAivOE14HbieG362Izn3SKIVzmwA6MiPpZvkV8tDonU3J9RKL16tbMRt7/u5f1Srlkt8YAMedybGFJZEZS7EyebE4YuL/w2p/2eMsM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061a5f94-3b94-4c57-4be9-08db66706397
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:28:29.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUWopSdlQdT14iouF1t4h2ZLxi9Ve15M0Chkh83AEn+BY+5gMPbNOK3mutHtyLzYv1mgwFI1dZlHfln2sZqE1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-GUID: KqfMqnUeNmOD291pdJdM1MPiQG58jwp2
X-Proofpoint-ORIG-GUID: KqfMqnUeNmOD291pdJdM1MPiQG58jwp2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43..6bcfd5bb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2421,12 +2421,12 @@ process_inode(
 		case S_IFDIR:
 			rval = process_inode_data(dip, TYP_DIR2);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFLNK:
 			rval = process_inode_data(dip, TYP_SYMLINK);
 			if (dip->di_format == XFS_DINODE_FMT_LOCAL)
-				need_new_crc = 1;
+				need_new_crc = true;
 			break;
 		case S_IFREG:
 			rval = process_inode_data(dip, TYP_DATA);
@@ -2436,7 +2436,7 @@ process_inode(
 		case S_IFBLK:
 		case S_IFSOCK:
 			process_dev_inode(dip);
-			need_new_crc = 1;
+			need_new_crc = true;
 			break;
 		default:
 			break;
@@ -2450,7 +2450,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = 1;
+				need_new_crc = true;
 				if (obfuscate || zero_stale_data)
 					process_sf_attr(dip);
 				break;
@@ -2469,7 +2469,7 @@ process_inode(
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
 	if (zero_stale_data)
-		need_new_crc = 1;
+		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-- 
2.39.1

