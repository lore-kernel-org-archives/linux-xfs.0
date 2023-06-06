Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B11C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbjFFJbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbjFFJbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:31:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A55610C9
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:31:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3565qooc009177;
        Tue, 6 Jun 2023 09:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=v1ut+JtTuUrN4YY2A4fXuv3POhNx3S2nZ/HBKbyEXRI=;
 b=CEkHPXE1q5mDD9sOObGliFPiWlELFtw2Nv9w5UuBdmIOISRm6J5hQ+JYwlZ/Ba03Gec1
 imNCHpURe9e9EGMS6x+FXedir6SeVZCBWS5xH+bJil+dRH37D362wPORnw1mMlYuciap
 TKMPPTnqZgKXndQKr3RcRDUdCgajzjDPDVbfUWLzz9yHoRW89nrlbsfHRJFd8Lo7wQvr
 NjkvicuJQ26JNF3AwdwWxJnMPnb8g3uFiYG1VYmhLFnBTXLI0Qsrk8It6n7oT3hFUi8e
 aIqT5jufzOq3UwQeOamGXoJ4VFX9cJRmmT9o7ln1BMVUtXX0zevbgTRK+ynJZ7+Kcsc2 Ag== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx1nvx92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:31:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35680X9d020039;
        Tue, 6 Jun 2023 09:31:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tsxcy1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:31:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBLYK2Dtv3qiZXzB82QVAw45y6XeetDJNwKz6Viq6EzyM6aerXya7r7ni7WfnMvfOnZu4yThPIjL/8rRxNT0KBT1lmQC1FJecOXF0ZfarWpvGSkxKQARtGFBgyQRUi91HQ7vSm//LTehSWAeQ07/T/fZcC6YUfZCnwxZ2osU9GG2WcgxC87u6fdqi07DhQu91IQqFbShAlsUS9Rjg/qjwqlUFOesXg0g1tIyNZm8z3M4fSKDTwSYNH9zqaGIlxPhZzjCwpNh5DIRLAgBZVPsG9g0cOUYmMyefjNtiNywN9HDOWWi6bCtiErz/OqxQgv3DjF2IzzLsQ1us5glYmovOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1ut+JtTuUrN4YY2A4fXuv3POhNx3S2nZ/HBKbyEXRI=;
 b=KB5uEGKEx0Q8Y8bOBtPW2fN3nSxmK8ayXgmGBOuXT9LYcOIBy8J4lfLJgAk8S7xs/fb9PG4GqqfGpPR7aVTYdnVIFfUPZuZraqyMfevwmPEpwWcszjCXJx1P7USSbTpvcTLA7HQ2S8rTfiM839W/ZdTzItlBhuAMHnTMIzXlmehM4PJCvpJ+05UsdcZsQPMecFupfrH4HvBKW9GUwNL7HJv52ij+CQJTPeykrCW7OphWgVmkBIQBmZ7irMsNZiYoqnPJs4+wN9YYb19SIhCbmNo6hiwhD0lzZIWHLsZPrBUfqpNr3zA6LxD0prZmJF0dhkB5T6rUvVZB2Vuf56s59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1ut+JtTuUrN4YY2A4fXuv3POhNx3S2nZ/HBKbyEXRI=;
 b=oZGOI/0Agn9AiXMLOvNMDN42MXbib4wfejk05Y06PC+IuXyeNEgQpjcqS+Kcg1TeEUzjKTf6Qe4XAMSOb2exhrpWxu9/+RX2u7as6rjvwgrSEjg1LgKYwrqOoqWNxz2xob0RZ7a0MMYqkN+Z+TUmyfLPtD2UQh7iFsIGcqIf080=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:30:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:58 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 22/23] mdrestore: Define mdrestore ops for v2 format
Date:   Tue,  6 Jun 2023 14:58:05 +0530
Message-Id: <20230606092806.1604491-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:405:1::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c730d49-7b4c-4b13-1e98-08db6670bc14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2I3XIfBoolCNA2JB3Jeyi2z6KqpfIlap/OYN+1OeKwW7ERfMCXDebbT8Q2wEopCvTATT+Mv19RRY0hr00L5Ddm089gd5+THAFODhH8hT1aJGuGEzcdM34h//ieV1wmpZWYHWCmsQ0EammqYYaJejmQogBkZ6nQjlx+Up2V5FJjuJ53qrLVBSDmXyzaZ0f74B8dEzZFYz1PatlwskDQFSK9frFxSCIBpq1OTRx4TugGfHeEi07MjxENa7e6zNM20zocEidRoeGBl0h/KrteBumVMIz3PE78M9WkP0ZwOTEn/Tznzg+Qwwfekxlrp5WgkE19rbyRoqM9ISSGNT42ZhtYON4Turh8+MlvDbiVpQW1MfZor8Kpw8Zktr+rIHbUxj7t/M3Zxkt7cgQ3zLyzhphk1nuUXucW7L9HIoV852x52vs6SWU49y5/pleGofQgg0T1FIzP0gCadzY4QXa561qAhspoBbu+H96QnDvnAufI9ZBcRcRynsTjHrE1D/DaA9oLhQs8st/j2NMD3wsGKXFwlBbcQyyDsSSQIsH5RXRS6GMtrLGHRV1Q2G8mdSiEi6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(6666004)(1076003)(26005)(6512007)(6506007)(86362001)(5660300002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p3hE32QwQQXk1tvBMMmT7gxkLujTkgdx+0V4eILYYqyo1ZBMy1niSem4kfNQ?=
 =?us-ascii?Q?ugxl0+6Q3c6aFkkTd5s2RrRj6JURPy9oZRVcmXSAD5OVmu6aBa0P8e55hpQX?=
 =?us-ascii?Q?IXZLWDxIX6xEsq4OW5NFDueNzQEiA3peVX973cNA6dHpbGQrYdQs65o7nvaa?=
 =?us-ascii?Q?C2kBr5V8gkwQNIpc6+XtHKEaLDuxZ36kooi/dO69VgF2QeZ2RknrllR/hipE?=
 =?us-ascii?Q?weErl2q5ZMPJTKKSdeURgoMSuko5TlewAq70cnml+A34qFDGDbu6uK21svCj?=
 =?us-ascii?Q?w8X/A3pJVg4ablc1KX63B4bDeIaCJcBJcz9X78ynbsDIAMIjVXpWjpdc2AiN?=
 =?us-ascii?Q?iJrmkTKN74B53Jl18Iz/eyOqae6a3i4A9AaMOiAOcuNa4WzXGKy1Jh6ILJZY?=
 =?us-ascii?Q?ukWhpKpIqKT8V8RCa1gz5kW6WIukuyGLp14o90wQOkRRtoyCt6DhQULKGP//?=
 =?us-ascii?Q?7D/5VlQDe+F4vdLvhKixqeSG2DyZ81kQDj+3yoX+K4OWkRX7tsHVAIwuhGR2?=
 =?us-ascii?Q?gIcxpJv/hoQxxrYXddEeLE0TEZzRjSI+9vk/g45YdmVgp3cz3a/OLYRKs3jU?=
 =?us-ascii?Q?RSWH0sZukmV1yQ2ipzZpzayA3BzxEu9YZtFd2jvHGEZlkLloyjxCek3o4117?=
 =?us-ascii?Q?VSERzEEB/l8NlD3DyZBVGhSIhoPpb5LEjxLsiEdTYvj1ayQVhtYEgHfcu8Zj?=
 =?us-ascii?Q?UP57hs0n/wB5TToqU0YHB6x+BqGVaZOY4Yez4OhPXzoVbtGJoOJsCxJLobnE?=
 =?us-ascii?Q?mr7pYZ80atvZqvFkMzsiLvlclUh2O/xuuD0oOj+j+C/5GNnBzz3RjbHTISyV?=
 =?us-ascii?Q?JhUiyR47iP8kzA6Z4f1C75oL++3w7Mkco7lP0Xf3HH/MIhZ8WflwmeY25WUq?=
 =?us-ascii?Q?gu5SUkGzN5CLdnEsoD58aEM6PGkLgMdeqOg9jLNc7T2arCPjMWoDDdct5QLF?=
 =?us-ascii?Q?V0rDnlfkPxeE43UQDZIuYmgAgJEbqVV+AZO/P4IKqJ+Bn5bP//ZNoJUzFh1c?=
 =?us-ascii?Q?6V6gitfNzEVXPiN5e7NY4pOG0jhe3aod+72gHYp7f+zCM04+lwkg9jyNtAgV?=
 =?us-ascii?Q?0jE3eUjGW7gx9NBIuDObqCSYcATValG3zrVKjuzMPMSpPH//huNgyJoJq9Im?=
 =?us-ascii?Q?NqJWCCVScX/gzMeYakm85AqeohW+pykR3p/LC/RYpmduZ/0zmQZE2Mdi3y5l?=
 =?us-ascii?Q?DDH1EwqwFX+5gQSmc/aQYg7A94Ms5dIirBvcNnUEl8dvLleyqIAFLJS2WTRK?=
 =?us-ascii?Q?o87Xqwq5Z3YsQZ+biCsctZlR/B5tIiaecxjjYkwT0cw4cSCIh3XPzQ/2eI01?=
 =?us-ascii?Q?muxnlMYBLJzWkAuZFi9FTKCWxpSAnkRNWAky7jpaSytiIj8LleVAIv1OtUQA?=
 =?us-ascii?Q?JZmlNpGzE7PnA3qgNBhaHJRo0OM3RCwH5M+oW9TW7LmItyJxb47M+vZ1cOl/?=
 =?us-ascii?Q?GBLTBeSZsPCJ2nDE1F4ZU/rN9C5hBfOtKvDnszB5y+lJOJ01tDrOW1ciZK5D?=
 =?us-ascii?Q?XWuVgZ261btnqGGl3Y0UGqKOeyuJrmu29UhVyoQzgjZWofnYH/mDvTQYne9f?=
 =?us-ascii?Q?syK4HULLyOR1kYtutLTcTzR9UEEgOZprsXhe6L4anM3A/TybR0hSPhU+srwa?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TYJcsUigMUOg+HitY5NXOja+EDnq/Uxh4pxQKp7CquMqaN9ZefPn8HaVIHrDtblFBs9zr3Zuagk2b54uaNWBfhAgoH3zo9oju+Ig0odu8SLto2oCKYb0jNLtaWSXy5XeE7doqpQBQlCHsVvaETk5joTASCWlKytu+BCu4qk60S8LaJgQaV9qtoanmZTwF0x7qCM5yWH7gvogIEyotf/OkpGpwshMGXYeAnaHhKOg/XYnIvB6lQRS82HP2msv/e/LK0EYgrovVT6nvkOEkga2n60MkHky5q9eoHMB5128Nq5LQdmPTOYdl1ygpqmutw2169uxHGaC+gIe3rAJW+zLwPC+6MG9jWMG1XVLGcAYm4AfAU8/yHBKrk0wedWT408TBVo4iwZP2fIV6AreBpxKL3C1QLc8cu4MX7ZOw1F5Odo3g2vbKYIuUuc8UIdEmOG9SaZDbYT2MQXjeukYL6Z7khDT0t6+lHOeE7S70eCxkFesaxCu4cxMLcK/BG/USgAwDEOnOe+JQ3pNd0RXuifkmwlOgkD0cDMOBzzblYlxgYMPMwezXgZvR/VOKjmIQNIZvVrUdQEdU++9LLFyiyKL+OsWmsdm7dHzL8CMz9xFJUIUBImqMyPhuaAcOTnD9HA5wQZwBwQ9tApo7iAmFimRT1W9LutcHc/VlpRXLYesamraOIWjOVAVITKIeEGf2JnJJi+qpnT3Zb5ozgYdXYuc6qxXMVa1E5JiPBw6wpNlSYvPOebXHdbRRul7k8MMc5Ec4X1AicY8sNZWe99/2djlKHI2rnupRFp40Rt0VNNvn3w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c730d49-7b4c-4b13-1e98-08db6670bc14
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:58.2876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vKDB2jXuX0WCG0BLtB8a6GMZfcw75Z2zjfsPg4KUMR2LY4TRJYE2SoPJkO+sfkR/2A5SNRzGcYwkwMW2XvMQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306060080
X-Proofpoint-GUID: 74VeqHj3gtA3FMtyb9jE8rVB04ZlTyW7
X-Proofpoint-ORIG-GUID: 74VeqHj3gtA3FMtyb9jE8rVB04ZlTyW7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to restore metadump stored in v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 251 +++++++++++++++++++++++++++++++++++---
 1 file changed, 233 insertions(+), 18 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c395ae90..7b484071 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -12,7 +12,8 @@ struct mdrestore_ops {
 	void (*read_header)(void *header, FILE *md_fp);
 	void (*show_info)(void *header, const char *md_file);
 	void (*restore)(void *header, FILE *md_fp, int ddev_fd,
-			bool is_target_file);
+			bool is_data_target_file, int logdev_fd,
+			bool is_log_target_file);
 };
 
 static struct mdrestore {
@@ -20,6 +21,7 @@ static struct mdrestore {
 	bool			show_progress;
 	bool			show_info;
 	bool			progress_since_warning;
+	bool			external_log;
 } mdrestore;
 
 static void
@@ -143,10 +145,12 @@ show_info_v1(
 
 static void
 restore_v1(
-	void			*header,
-	FILE			*md_fp,
-	int			ddev_fd,
-	bool			is_target_file)
+	void		*header,
+	FILE		*md_fp,
+	int		ddev_fd,
+	bool		is_data_target_file,
+	int		logdev_fd,
+	bool		is_log_target_file)
 {
 	struct xfs_metablock	*metablock;
 	struct xfs_metablock	*mbp;
@@ -203,7 +207,7 @@ restore_v1(
 
 	((struct xfs_dsb*)block_buffer)->sb_inprogress = 1;
 
-	verify_device_size(ddev_fd, is_target_file, sb.sb_dblocks,
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
 			sb.sb_blocksize);
 
 	bytes_read = 0;
@@ -264,6 +268,195 @@ static struct mdrestore_ops mdrestore_ops_v1 = {
 	.restore	= restore_v1,
 };
 
+static void
+read_header_v2(
+	void				*header,
+	FILE				*md_fp)
+{
+	struct xfs_metadump_header	*xmh = header;
+	bool				want_external_log;
+
+	xmh->xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+
+	if (fread((uint8_t *)xmh + sizeof(xmh->xmh_magic),
+			sizeof(*xmh) - sizeof(xmh->xmh_magic), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	want_external_log = !!(be32_to_cpu(xmh->xmh_incompat_flags) &
+			XFS_MD2_INCOMPAT_EXTERNALLOG);
+
+	if (want_external_log && !mdrestore.external_log)
+		fatal("External Log device is required\n");
+}
+
+static void
+show_info_v2(
+	void				*header,
+	const char			*md_file)
+{
+	struct xfs_metadump_header	*xmh;
+	uint32_t			incompat_flags;
+
+	xmh = header;
+	incompat_flags = be32_to_cpu(xmh->xmh_incompat_flags);
+
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+		md_file,
+		incompat_flags & XFS_MD2_INCOMPAT_OBFUSCATED ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_DIRTYLOG ? "dirty":"clean",
+		incompat_flags & XFS_MD2_INCOMPAT_EXTERNALLOG ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_FULLBLOCKS ? "full":"zeroed");
+}
+
+#define MDR_IO_BUF_SIZE (8 * 1024 * 1024)
+
+static void
+dump_meta_extent(
+	FILE		*md_fp,
+	int		dev_fd,
+	char		*device,
+	void		*buf,
+	uint64_t	offset,
+	int		len)
+{
+	int		io_size;
+
+	io_size = min(len, MDR_IO_BUF_SIZE);
+
+	do {
+		if (fread(buf, io_size, 1, md_fp) != 1)
+			fatal("error reading from metadump file\n");
+		if (pwrite(dev_fd, buf, io_size, offset) < 0)
+			fatal("error writing to %s device at offset %llu: %s\n",
+				device, offset, strerror(errno));
+		len -= io_size;
+		offset += io_size;
+
+		io_size = min(len, io_size);
+	} while (len);
+}
+
+static void
+restore_v2(
+	void			*header,
+	FILE			*md_fp,
+	int			ddev_fd,
+	bool			is_data_target_file,
+	int			logdev_fd,
+	bool			is_log_target_file)
+{
+	struct xfs_sb		sb;
+	struct xfs_meta_extent	xme;
+	char			*block_buffer;
+	int64_t			bytes_read;
+	uint64_t		offset;
+	int			len;
+
+	block_buffer = malloc(MDR_IO_BUF_SIZE);
+	if (block_buffer == NULL)
+		fatal("Unable to allocate input buffer memory\n");
+
+	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	if (xme.xme_addr != 0 || xme.xme_len == 1)
+		fatal("Invalid superblock disk address/length\n");
+
+	len = BBTOB(be32_to_cpu(xme.xme_len));
+
+	if (fread(block_buffer, len, 1, md_fp) != 1)
+		fatal("error reading from metadump file\n");
+
+	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
+
+	if (sb.sb_magicnum != XFS_SB_MAGIC)
+		fatal("bad magic number for primary superblock\n");
+
+	((struct xfs_dsb *)block_buffer)->sb_inprogress = 1;
+
+	verify_device_size(ddev_fd, is_data_target_file, sb.sb_dblocks,
+			sb.sb_blocksize);
+
+	if (sb.sb_logstart == 0) {
+		ASSERT(mdrestore.external_log == true);
+		verify_device_size(logdev_fd, is_log_target_file, sb.sb_logblocks,
+				sb.sb_blocksize);
+	}
+
+	if (pwrite(ddev_fd, block_buffer, len, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	bytes_read = len;
+
+	do {
+		char *device;
+		int fd;
+
+		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
+			if (feof(md_fp))
+				break;
+			fatal("error reading from metadump file\n");
+		}
+
+		offset = BBTOB(be64_to_cpu(xme.xme_addr) & XME_ADDR_DADDR_MASK);
+		switch (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) {
+		case XME_ADDR_DATA_DEVICE:
+			device = "data";
+			fd = ddev_fd;
+			break;
+		case XME_ADDR_LOG_DEVICE:
+			device = "log";
+			fd = logdev_fd;
+			break;
+		default:
+			fatal("Invalid device found in metadump\n");
+			break;
+		}
+
+		len = BBTOB(be32_to_cpu(xme.xme_len));
+
+		dump_meta_extent(md_fp, fd, device, block_buffer, offset, len);
+
+		bytes_read += len;
+
+		if (mdrestore.show_progress) {
+			static int64_t mb_read;
+			int64_t mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
+	} while (1);
+
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+
+	memset(block_buffer, 0, sb.sb_sectsize);
+	sb.sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n",
+			strerror(errno));
+
+	free(block_buffer);
+
+	return;
+}
+
+static struct mdrestore_ops mdrestore_ops_v2 = {
+	.read_header	= read_header_v2,
+	.show_info	= show_info_v2,
+	.restore	= restore_v2,
+};
+
 static void
 usage(void)
 {
@@ -276,17 +469,24 @@ main(
 	int 		argc,
 	char 		**argv)
 {
-	FILE		*src_f;
-	int		dst_fd;
-	int		c;
-	bool		is_target_file;
-	uint32_t	magic;
-	void		*header;
-	struct xfs_metablock	mb;
+	union {
+		struct xfs_metadump_header	xmh;
+		struct xfs_metablock		mb;
+	} md;
+	FILE				*src_f;
+	char				*logdev = NULL;
+	void				*header;
+	uint32_t			magic;
+	int				data_dev_fd;
+	int				log_dev_fd;
+	int				c;
+	bool				is_data_dev_file;
+	bool				is_log_dev_file;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
+	mdrestore.external_log = false;
 
 	progname = basename(argv[0]);
 
@@ -332,11 +532,17 @@ main(
 	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
 		fatal("Unable to read metadump magic from metadump file\n");
 
+	header = &md;
+
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
-		header = &mb;
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
+
+	case XFS_MD_MAGIC_V2:
+		mdrestore.mdrops = &mdrestore_ops_v2;
+		break;
+
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
@@ -353,12 +559,21 @@ main(
 
 	optind++;
 
-	/* check and open target */
-	dst_fd = open_device(argv[optind], &is_target_file);
+	/* check and open data device */
+	data_dev_fd = open_device(argv[optind], &is_data_dev_file);
+
+	log_dev_fd = -1;
+	if (mdrestore.external_log)
+		/* check and open log device */
+		log_dev_fd = open_device(logdev, &is_log_dev_file);
+
+	mdrestore.mdrops->restore(header, src_f, data_dev_fd, is_data_dev_file,
+				log_dev_fd, is_log_dev_file);
 
-	mdrestore.mdrops->restore(header, src_f, dst_fd, is_target_file);
+	close(data_dev_fd);
+	if (mdrestore.external_log)
+		close(log_dev_fd);
 
-	close(dst_fd);
 	if (src_f != stdin)
 		fclose(src_f);
 
-- 
2.39.1

