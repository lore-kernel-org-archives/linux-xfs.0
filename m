Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D30C00528
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjGUJs1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjGUJsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:48:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B73C13
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:47:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMWdD002011;
        Fri, 21 Jul 2023 09:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=F9bcRnnYU8yaPYEiqKZFs+JdSWr047uKbVf3vSIhc71hFOjZsYh81W+CR5k4j2EW2TB9
 Xs6/8uIooNifV+o5drviEJ0ffdb2NZF+7ZXiYGjwDlGrVs5Ks8FRRIPUT4Yk8aVzMQ5A
 7duSTvR6GlFQz93YCAnB5e9/GyQ/6clhI3tSpihYhGboGF0XH5Yo43Q4hn6HQXvkuR2k
 sUQRyHGX5pUy8DhHCWe3BIAxu0bUJlWWgCZ7CMyuzIx+C5kfsrYbmfRwt/2SaMiitg8s
 Aaxcwyub6rVzwXmnLWBGtbc1ngdx8hlmOHzbxWnrZuvkt1eorBcYtqd4+Vc+U21HMO3D Nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run773knk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L807nt007843;
        Fri, 21 Jul 2023 09:47:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw9jx34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:47:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMLrfi84IIl0eZFul8uUciXmrZxeJz+UZubG4uiiYKOTt3IZwcPP1wL33TAdBQO3abTjA7l+esAbOLZU5iW8r21GrRVvBc4eSpND3PISXDj27HRC3ggV5t658C53KNzdNhROyCnsYvMjOEXfTM0jQGn9bGPOObPqAJu/pRDJtNnAPfX1LEyuR8du7ouPJTDuhMVArWh4l+Vx35OmPz6Ch0IDSUT0RyU6DA6PLK/9/ov7IB7MUK194OBWmeMDoDog1BiAh+iyYrFYfFyZIAQrdNMbcw22UjZ2XZh30yn6/cHBOQvth3wZV49Ej1lhLvq/v8PqmuJpBQeuh0FA0c/W6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=Zha4ZLArmyJxCxY9j9nwZcePGF8N/8zbPLpPAAkD1dFap7gnHWfzLvE52QNn6E/zZvBUvML5Whv3I47A206DIlygbZU5kdacHs56gh2fbO0i4a2BRcJsF4H0472E+AlBIFdYSoPoitrHfR7Cj6HV/8eLNZOmt9kfjPSBuzkRdedioDCDvSw9N4KColxsUfxVVMRhu9OC1+J/yoFndHKVEXyN5tfApJ8Xa7vav9hlZkwjuI4UHRG8jn+Ql+MZsq/E2cBXcDpAzDHJd2Bt8po8aUo9zcKLl53iSYRmmLL/msjMwObGFOxxgvnfKWMHXwuQYlgzYMhTcmuddDt5IiAoOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H66qGbjV70ou8FWBBgOpLIkBPi9qfcwQl+qUFzfsv6Q=;
 b=xk1jTrMn013Bn9k8xkzEXzsIdbgN2tVfPJ5DxnqxvZSTW4L1SmcOq3KEG/91GQnD3JR1MKTbABb1LgKfs7e9DIC3QNL4SA4loMVxIOvdMeuaccbk639/85WPFUy84UT4C8VUyurS8w3krMhOKUZDtFKYKfHj2ANeK+YERXiduT4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH7PR10MB6602.namprd10.prod.outlook.com (2603:10b6:510:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Fri, 21 Jul
 2023 09:47:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:47:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 13/23] metadump: Add support for passing version option
Date:   Fri, 21 Jul 2023 15:15:23 +0530
Message-Id: <20230721094533.1351868-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6602:EE_
X-MS-Office365-Filtering-Correlation-Id: cca85cb1-686c-46ff-dbe9-08db89cf7c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I6ZxLwVWHzWIahhly0ftlg/xeva4YEyGnutRIr9iGcFtedApoAzoFYoiM6BtxgfMCGcXCjOi81ZbDO0B6VGCUpDk+wAZ/y7ASkbtxtM0w808UmJQtcvxzrMyiXIm5Z5V1USyAfwM5txJq0bVXqtq0F8MyAm/Th0UgeP7wkP7IDRFOUS7NSyc/ZqIrDAe9PIcp+GpU73TbwLG3zmA10sJF+MY74nrZNpuYyeg1o1W6lan4pY0/DjlvDEBkFmMob6sqFh0kMtJ718cW4FLSNZjFnFYobR/OcZEWSb0bjW3OW1VHWSHrcpeJBBatfp5Nz/hfq0A+w54shESQA0yDed3do5qPziSYfe/uMQc+Y5VQIlnCBsDVNtK5ybIz+qgQybVsfqFFRps9N1JcqTiNty7oVboNs2C0vDo5ykbB29bhuSp0KaBlIzL5NECXelaT0dBTy8PFdjem/q6n9r5PBuzDu0eKuYY2hMFOz/bo0z+wcOPR5koBJruCcRzLZz9iOCIT4xhv0nNDRarirxqV8W9cuZCjkDM2KM5Hu/yvDef67WGMFVgeTCeo5tCVR1II8FG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199021)(2906002)(83380400001)(2616005)(36756003)(86362001)(38100700002)(1076003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(26005)(186003)(41300700001)(6506007)(478600001)(6486002)(6512007)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RjqOeWqQG/c8w1JoLIhliv+9AvO/BeYBxSftNPZemD5wQwDU0gzXtwX54WA8?=
 =?us-ascii?Q?AmHreEBfV0wp2S8vlpqO1mDeMzyYEJjY7UBFudHdGJMnhFFW+44B4JLRYs86?=
 =?us-ascii?Q?D8MtVBfnogeQdA2JCsZ+bD6W+R/qh4bSO0gIgZ5LT5zrTK7mtthMFmBfEN5u?=
 =?us-ascii?Q?GMmRPEj9bpyvyM/J3fbI1Pmey9DyKEtC4cK+uOu3Q+UuSlRiIWMT3iQ00zce?=
 =?us-ascii?Q?RPU9OFmppzV5Rgr7dT/Y+dAfRzKkQc255aFgZ+7vIj9p29SIZUnsCOyvvPC+?=
 =?us-ascii?Q?bIsv+oXpNCOtWMifvW1+cc3kbE774JvPoPP1yblmTvQD8puEns+QHioPgjKS?=
 =?us-ascii?Q?m2D5qmVWxmjxZLF7qUoPokQp0nrHHaMoQTLplIw8Y+AmVYmTu23+zEZhzTF3?=
 =?us-ascii?Q?yMbL8rpGOhWxyJEo9PvAIOSMAuT2RY891xzqhwo8rXYqOlQjJusY3GkGOpGR?=
 =?us-ascii?Q?2bZZQBoZh01HDKhDJNBxg9Q72M5GXm2N8dYbrXqvVyy0jS3LtedWvft4B+xU?=
 =?us-ascii?Q?icSquR1XWjfG/DE9CIdEEWPnhVe1t0ivTqeCR0SJTfEmx6WY6d++56WzxKfu?=
 =?us-ascii?Q?gIv4Noxsp0J6IcvCH/JeiqUU89h74nTlD4WePoZh2Z8RD3tdrSfcOGBTn8/4?=
 =?us-ascii?Q?LoRQ8uWP6UXKLUR6ls4txew6CJN1oeaWYg/AKEk4G7tsI7dSCjX9tjh7Gxzs?=
 =?us-ascii?Q?1EQHSxKnVtnImeV1jmtYeIPrZ+y+7oYzFUUJW6/LaxIsTPuWVwp7mPGzAEth?=
 =?us-ascii?Q?hDqC3SzR1sKrSl1yt272lvK7QX3XankBrRFmE8pQEZ/V0C7Dzg5eEa1mK9QX?=
 =?us-ascii?Q?2v6XtaURNSi2Ufz+EtoFsCppjpcjwhRxJYvcU06wtHJ4KdabM4+ZbyX4hk1H?=
 =?us-ascii?Q?dDqINQRL3om0m52se2l6bKUycPZ6/buWQFL949vasDkfT3PHoFfqLIb68Tur?=
 =?us-ascii?Q?LjO17suw5huiJ+wfEblcEbp8+tC4MGiKdziZ8t9d3I2o70jlhAO/0qfIBhKm?=
 =?us-ascii?Q?u080moErw/+R51pwL7f1tIt4u9bxp0oDvbZTGflq7nNuRIkW9e+aim7wyxfs?=
 =?us-ascii?Q?jN85ejIAWQ90sZY0j7CUabSm+Mg49hdS6riV2gLmPo64R9JyyZItTXugPwCV?=
 =?us-ascii?Q?YnzDhKVy47N6zXdm2aBExmogq9U0f5ZE1/QawM6utwroUqDml2jWPwhqXtkB?=
 =?us-ascii?Q?TQia5gAWQ6IHpuzH1bvQcxDnqhgZtWFngpyHB61cz6C1c/Cmmdga9W7ff16I?=
 =?us-ascii?Q?jpBEHh0nVjvhSkfJuA6UnxGcDd/KHltv/KuSFNL8X5ui3X9O+gGIi/tAQO4g?=
 =?us-ascii?Q?ohmTJd5/pB1QednqDqDNDXrkdjmkNODaXTQ7wAnqhz8L7URW/wLhAek+a7jQ?=
 =?us-ascii?Q?ivOPviZDZZl1kLQ/HU5PLcliO6M1G70QnAqdkvCH5acr2Z5SueIorwHUnlyk?=
 =?us-ascii?Q?5sbC5acfjs0XX7mUL89w9X3u2QqPPtGXDQ7CMCg/pMKbXgtaY1gNpjdU6l/R?=
 =?us-ascii?Q?4AidF4lrLYu1Hm7GedBYiZDF0hbS4lVFCenxmdDxbYOyxZMCaxZNs1PhjLea?=
 =?us-ascii?Q?Hbp9I49sH0y6b6Yjo/0viQ25jCVKrc4odeo9K6IRZ1sT6SsrfRVT63eccJXc?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xe0E0IXvGyWEIizxgsbLodESBZF8awOrSvuZALjRUsFLa8G3W4iCJgN7WCX+6JZYz5ElJzRmtTnynp1CjHNC8F0FAzzjogk+u7ir2r5EgIUrxb3yKbxGsiMlWwMZIk+6NM9NZ0oxIprEGB20Re4RcdpTSdZIv49QCeRaY822B6SnbC+4ssFRES0DzM5HE+AS1r8TYeNHBoNyK0lGsgyt/7L2kPg14Ta5GR03QHnWeFVYgqxGvMXWMI6Q/NLgGgyUxT8P5DFbMIUqP+qWrXf3rItgOSf/IiHXiaz19GUyL+k7Jy/J1p3TOoeKL7EoL9Tp70OUE+WT5uioJZ5OwZDqp6ENW1J5gPEBOa/Psx3Sja+Fbr63nVFWb9OviCOF5fZio7D+pRSWD0aM/QeFks6f1qORdaIjP/ARYnyrHi0UOJSZ+lQghTps25UnKnNewXRSePMeHHzbwWtfSoXx9U4ogO69jf3FWAdFHm0RhFWIJOQ2x35wJVGkhNtxH3Pr0WaNtmDmYtWSnOl7MgzFLNq3PaRMSm3CxNLogyNQyKceO0QS53eJRTBxlCB7lNFXw8OwpBKBqwqV+fGI8E9VYnpUV1TKQ2R6+ufzZJ8wIBRQMKs5uwz/UOR6rWrAHk+JjCqXZAB+UVDTNooJOPEVaOvUkeXO0j094xtuiuaeYaalZ8IWjX7xmORBPvyjZdxqhHoCwGsn2Tg/5cfp0TFRzA5mkZBMDW3oRqOQXNSDRO9nGPcK6Qriq+Pt4l16Tk4BCNR1IFK615dfmERhrdqXdO8C0Rn3PBcHN8qoXxbAfyHEGqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca85cb1-686c-46ff-dbe9-08db89cf7c09
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:47:23.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ronyVvD1Ssgawj+WAPvodWjOGIjVTaVCJ0UBM0X054F+37nspW+PZwrmX3J61Vjvv3kg0a2aS5bVum9u25Hr9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: YI8exbB85HriFxF4IA3eC6G3zL-00bLk
X-Proofpoint-ORIG-GUID: YI8exbB85HriFxF4IA3eC6G3zL-00bLk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The new option allows the user to explicitly specify the version of metadump
to use. However, we will default to using the v1 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c           | 81 +++++++++++++++++++++++++++++++++++------
 db/xfs_metadump.sh      |  3 +-
 man/man8/xfs_metadump.8 | 14 +++++++
 3 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 9b4ed70d..9fe9fe65 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -37,7 +37,7 @@ static void	metadump_help(void);
 
 static const cmdinfo_t	metadump_cmd =
 	{ "metadump", NULL, metadump_f, 0, -1, 0,
-		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
+		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] [-v 1|2] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
 struct metadump_ops {
@@ -74,6 +74,7 @@ static struct metadump {
 	bool			zero_stale_data;
 	bool			progress_since_warning;
 	bool			dirty_log;
+	bool			external_log;
 	bool			stdout_metadump;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
@@ -107,6 +108,7 @@ metadump_help(void)
 "   -g -- Display dump progress\n"
 "   -m -- Specify max extent size in blocks to copy (default = %d blocks)\n"
 "   -o -- Don't obfuscate names and extended attributes\n"
+"   -v -- Metadump version to be used\n"
 "   -w -- Show warnings of bad metadata information\n"
 "\n"), DEFAULT_MAX_EXT_SIZE);
 }
@@ -2909,8 +2911,20 @@ copy_log(void)
 		print_progress("Copying log");
 
 	push_cur();
-	set_cur(&typtab[TYP_LOG], XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+	if (metadump.external_log) {
+		ASSERT(mp->m_sb.sb_logstart == 0);
+		set_log_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	} else {
+		ASSERT(mp->m_sb.sb_logstart != 0);
+		set_cur(&typtab[TYP_LOG],
+				XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
+				mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN,
+				NULL);
+	}
+
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
@@ -3071,6 +3085,8 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
 	if (metadump.dirty_log)
 		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+	if (metadump.external_log)
+		compat_flags |= XFS_MD2_INCOMPAT_EXTERNALLOG;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
 
@@ -3131,6 +3147,7 @@ metadump_f(
 	int		outfd = -1;
 	int		ret;
 	char		*p;
+	bool		version_opt_set = false;
 
 	exitcode = 1;
 
@@ -3142,6 +3159,7 @@ metadump_f(
 	metadump.obfuscate = true;
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
+	metadump.external_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3159,7 +3177,7 @@ metadump_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
+	while ((c = getopt(argc, argv, "aegm:ov:w")) != EOF) {
 		switch (c) {
 			case 'a':
 				metadump.zero_stale_data = false;
@@ -3183,6 +3201,17 @@ metadump_f(
 			case 'o':
 				metadump.obfuscate = false;
 				break;
+			case 'v':
+				metadump.version = (int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+				    (metadump.version != 1 &&
+						metadump.version != 2)) {
+					print_warning("bad metadump version: %s",
+						optarg);
+					return 0;
+				}
+				version_opt_set = true;
+				break;
 			case 'w':
 				metadump.show_warnings = true;
 				break;
@@ -3197,12 +3226,42 @@ metadump_f(
 		return 0;
 	}
 
-	/* If we'll copy the log, see if the log is dirty */
-	if (mp->m_sb.sb_logstart) {
+	if (mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		metadump.external_log = true;
+
+	if (metadump.external_log && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && mp->m_sb.sb_logstart == 0 &&
+	    !metadump.external_log) {
+		print_warning("external log device not loaded, use -l");
+		return -ENODEV;
+	}
+
+	/*
+	 * If we'll copy the log, see if the log is dirty.
+	 *
+	 * Metadump v1 does not support dumping the contents of an external
+	 * log. Hence we skip the dirty log check.
+	 */
+	if (!(metadump.version == 1 && metadump.external_log)) {
 		push_cur();
-		set_cur(&typtab[TYP_LOG],
-			XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart),
-			mp->m_sb.sb_logblocks * blkbb, DB_RING_IGN, NULL);
+		if (metadump.external_log) {
+			ASSERT(mp->m_sb.sb_logstart == 0);
+			set_log_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		} else {
+			ASSERT(mp->m_sb.sb_logstart != 0);
+			set_cur(&typtab[TYP_LOG],
+					XFS_FSB_TO_DADDR(mp,
+							mp->m_sb.sb_logstart),
+					mp->m_sb.sb_logblocks * blkbb,
+					DB_RING_IGN, NULL);
+		}
+
 		if (iocur_top->data) {	/* best effort */
 			struct xlog	log;
 
@@ -3278,8 +3337,8 @@ metadump_f(
 	if (!exitcode)
 		exitcode = !copy_sb_inodes();
 
-	/* copy log if it's internal */
-	if ((mp->m_sb.sb_logstart != 0) && !exitcode)
+	/* copy log */
+	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
 	/* write the remaining index */
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9852a5bc..9e8f86e5 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -8,7 +8,7 @@ OPTS=" "
 DBOPTS=" "
 USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
 
-while getopts "aefgl:m:owFV" c
+while getopts "aefgl:m:owFv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -20,6 +20,7 @@ do
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
 	F)	DBOPTS=$DBOPTS" -F";;
+	v)	OPTS=$OPTS"-v "$OPTARG" ";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index c0e79d77..1732012c 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -11,6 +11,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 ] [
 .B \-l
 .I logdev
+] [
+.B \-v
+.I version
 ]
 .I source
 .I target
@@ -74,6 +77,12 @@ metadata such as filenames is not considered sensitive.  If obfuscation
 is required on a metadump with a dirty log, please inform the recipient
 of the metadump image about this situation.
 .PP
+The contents of an external log device can be dumped only when using the v2
+format.
+Metadump in v2 format can be generated by passing the "-v 2" option.
+Metadump in v2 format is generated by default if the filesystem has an
+external log and the metadump version to use is not explicitly mentioned.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
@@ -134,6 +143,11 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.B \-v
+The format of the metadump file to be produced.
+Valid values are 1 and 2.
+The default metadump format is 1.
+.TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
-- 
2.39.1

