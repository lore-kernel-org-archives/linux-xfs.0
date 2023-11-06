Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEB3C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjKFNL3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjKFNL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4593A9
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:24 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx41m005748;
        Mon, 6 Nov 2023 13:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=l9Z+i7jfqNvyF5V81lTi1vV25xPaaE/z6jOlkFwlpGJvizv1bmERjqYiA00jmXwVm0EV
 pTeMu4GaR25If5dtq/uGI1EDmK0jZH8PCJzIf3V6OB8kZh99iR/JxQfWesW3sTIdN9Yo
 bnoTTZiYBJmLH85REgu4FROh/4QN8zkDWB3JLFe70zxbjO1TAlcbPGY5aYgDH+LBwbvn
 OGMsrJM+ff/jQVpMVQnBtxPlN3FJmBCy1FaI/0ox84OJWiV/InlhHrChWs9i3xXenqwW
 xEF66yAPN6QL9bTA71/HUxjaigss2N9HJlSEgQZlxyd09e5dWiLsVLSSJfV0lq6ARY3S Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dtw85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D10Ut030483;
        Mon, 6 Nov 2023 13:11:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4t6kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1gsosgMJkHzULd83yp+k9LgsAVzXMi9Oki9+HePIopDCTlH0bDiSMgL/x/qxDKTqdqgYtOhxxGXsPjM7x6zaYR2DTat//ShT7lu4wOpFzW94JlylH7syqvs29EsAIWKhivhFpjDpnb93gR+HgJnt6GEv0/TFQsjZ7BKLhYHG/6IYgXNPjczVm7PCktUY6Kxgyi4GgftHMedeRbRFE/1Tql6neFxepgabqWP5cX85Y8YiGH0td9Hu/Zb03UFYS4S0YLQOl5yevxGxjX5rCUxMsnNWKHWthbgsydnw6veFPd40XGzy3VqsXZQ5Y/TlWXBTr2x9jP0Tn0pb2UquWuipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=V3L20PSgbaTlh6P+BbXLVlsTFhGOedl+67NO2IQq/PjofAqukzHX6TpleQkhtc+2RbKBv//4vFV8Da2PqY9pWUlH7xSp8nOOQOJ4CZWkTjiKz3TUIq+ZgxwzR++qLSphocMKrALIkW2MAGTjvX174A4rP+O3AE6O307ryj5nur3CmXpa3526VtTrGhksiSv+rVrPUbS78+/8gy1/Nz0vSCVraxeL8dmSoq4uUlXqUcAi5QUeklyYKdrU0VfwHS9MnG2SURskO84Fa0HkM3VzKJrgwOsyPbq8m1fJF4oLRlRNkhd9JuzBjEF1dDUVkm4hA/1PkIHWHBgW5di2pso6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ud9rOBOyVZiNwlO+3c+yXzXarz0C350WA136+GBmmNk=;
 b=qv6TJCeZm0zbdmHdasimxjNgxMuuCaxCiqdYa4sEPOfI0uL/DksAOjwU7drFbC6zlMtUABWafXHPkvWFizA5hPbHMyJYOnzZ60qDyGbkgBxSuFSPTkre8o7Nb1miNKm1MgLlEvhqsqRJLDs2F0SZ87kLdzErZ91GKxWJ4EorNzc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 01/21] metadump: Use boolean values true/false instead of 1/0
Date:   Mon,  6 Nov 2023 18:40:34 +0530
Message-Id: <20231106131054.143419-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: e0625a2d-1e07-4a9c-d907-08dbdec9dc82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03qPL+o35y0InlSyoMblRf0Sabt9v+302bej7szBMWErdmzienJYETTqtJqtz9X3MXJpscxqSCbJ8We+sYZ1gou5Ao/YuJJk1DBa1yx7/7uM+gubUAOAQz7YIaZ7H4HXkpb6Nw4r4tdvaY9lrdbNTgUFt4DEK4JKgYL3vLL3fXa2ZwOWOyKUJBQ8w4P2rdeEipkULXfEUtMJLDir8cqT/SbuSbRv0gC5vAdprnRdapDPgajAKE6nfieDuMzZLvR9OavzcSyb2M43ZqdKygS5deTyXn+ZS79HQlEG3lPPRnJLXs5B7wxJvOCG8QSi8WT7q1jAggzCQe7ogUUCtmd+cTiV8qBsNwHVhODbflgyOOrAPyDNg9wFlT8KLv9wCPH+oTGRKttyBJWj0OHcrb8BeZuw0lcVSzeYMuUrtLIp5lZrRjz+Fo2Zx+334fIzpPKMG6G9/+EC6K5TiZd8D0sxc7LmI4JAwFgCM+z4devIbuik4rGJAWihAjhFNRKaAZGLkLuZgjxBFBdG+ANtbsYr+XtlrdAuveJ5FcP7k+6UPGPDgyIbk5Q0zqSW7qapFXd2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mgbJ85gCnDFny3WY78FBfQnQ8eWzEQw7wYDykyLAri0cmetnezPRzoC9z626?=
 =?us-ascii?Q?xN9clWR6sGOqDCMSmSc5K4ZNZMagPUc7JdZ47qWhiGX+9rpYNYRKaQpU0KcO?=
 =?us-ascii?Q?aV4i4LSJoF0kqeoCnmU7O+yllHRMH1JIJMGK8EMk7oIvkS9ZlMUPMV/1DtCM?=
 =?us-ascii?Q?K7dVQ3ptflIqcq+2ZhyFyoOPJOfE3eFQhBG0rLX3NCUDj/DP/72O+NPVuznq?=
 =?us-ascii?Q?igq8u7GAuDGIlKgRSvAqHJfl3ELrvYsJ2jVnmXJNnM5njbyQe+v7DUS3Hmzo?=
 =?us-ascii?Q?FmLrX4A5Q861zCs7B8xWO5sBPc6BFEGblSrDoMOK5YSim2n0TUaDUwD18Kx8?=
 =?us-ascii?Q?28z6JyobysCp1xrqfiIuC4yvGOmmgro6cHZQs5i0CIqXmE2AYXcuEqI7RQZt?=
 =?us-ascii?Q?z4CdCLAr3N85N9451CEyPyKLiBYhNlP3/bvKurcCpjPMhYPGjpzhVclTUKMa?=
 =?us-ascii?Q?XhYAfjhATbmHbDvvaWM0Ltje5qrGUddkZjnU4rUwSqu/z/5NNSo6SwM8BAdF?=
 =?us-ascii?Q?09MQzd6D39m3bpzKpW9mSWfhCyLRtXFC0uBAU+aPDyqF07v/ls4mu9PzyRAb?=
 =?us-ascii?Q?qKCvU1lbp687ZTUu+Ynv6lRPWPHWnd/hny1/SXAgc1OR80leHLDbLeo/Pe6S?=
 =?us-ascii?Q?WH/wgSAbPeb9Y4TFEjChNZlo18WaQ44Ihsod5tNk2hARKq2kh6k6vdofyyAF?=
 =?us-ascii?Q?5w1C0mBgnLz4gTbw+ohMDS3yC0Ka9MKi5Dl9JWH8qIUsFEpinSQD5W/1+Yxe?=
 =?us-ascii?Q?dcNmwLCDQ/OxfSqgVSK/tIk8nU7N//3zutVmlUJWCp/aUz5T7m1IKJJNSQPX?=
 =?us-ascii?Q?Aw5YLxeIxwVrRikSqzv2cmhAKFvu2d9SlXJ0kc0dqI1E4B6VJfrvNud1z1tQ?=
 =?us-ascii?Q?GI6PPgdSnNXp3pDZfKebN/j2umjaGBs+DLF4/aJnk93XEaKB7BP02T7SKete?=
 =?us-ascii?Q?2W/s+a9s6QAChQrQcHnWETXrH7sLqNBvKPUvFekqHnlfGL/hLEzSFO8JrFtE?=
 =?us-ascii?Q?D0IDrpnnFciyGhlnBsS3VY2i7hiRW/K8No6woQW7N4ARBYI00baeLKgGA4FF?=
 =?us-ascii?Q?czt/HoVwD8RJ3Q1VZ+ck9O/vn1xkifMMVNoKG9SU6Avw1uSRgyekO7z5nmAk?=
 =?us-ascii?Q?EispscsMLB6oIlWcPW0kLFzz2Ef6BzBkTX+wxVVrQHQPjp81yMzMvwANmY1d?=
 =?us-ascii?Q?tGp3xi4mxZ9DBitCNkr4xfvK8rlxm+NPgrsyyJ+fXvyZCsXqXMxu3k+q5KnJ?=
 =?us-ascii?Q?qOeTh0u+obybhKozPg6BMz1hxsnVZXhMm+d+wzCJOSSe5y6wf4J9Ynzg4eBD?=
 =?us-ascii?Q?4PH9TXr6Efkpc9IKEbxIx9UYUhsBL3xrFoAEIUAQ3pYpgAWDQSPJC3Qo/9lR?=
 =?us-ascii?Q?pI+a4MusqZlh1ysn8uUn0klBre6KchVg4VLe5DsH5VkpVzBA2xWa5Agkcaaa?=
 =?us-ascii?Q?nH11Tzv+6SdY9G3HPxMUV3pTvzGmQRFfR5C1phno11xlukP3dre9NpfYCQ9x?=
 =?us-ascii?Q?89oFOSxwoIPf1ra5Buqk4BKVGopDGlCWh6aFvAbEuDL67gHHBc523oAJ58I9?=
 =?us-ascii?Q?wD8l3ipMpC9ZwTIG+Px+7Re8BLJal96nj9NS9jhd1C8qLjiYxOJ04HLZs5ym?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1IpHjh9y3xNhuc5SglHWzO+nqxBoTVoUfcnOlzjVV0e+Th9+ZK3DeRNa0QAb8V3R43+XIPQfQHYef7yOtpC3c/P80Ws74ktYe/4eVqumGj0cZelDccy+Rd8VWie4KfutaOXWg0XamBSH5fHx6kv9ElA6jPxsbrUhPMwxPizkROCXFEHiUEpCj4IkLazKg+CkPUWdTh5JzA0myZIHqsFzeNeewYW2bzWD9tCrmGJshg1NIJOrwDkWRzyEY8NAsT7eYVtLiRPiW6XBaQqbk4Kl7dYgqMtGn7oj+ycbzva02Xl82LsAA11FiJj+FKUwdlV6WNfrkezlwQobZSdZ2UE3yQLM+un80hHIEkLbhpdNsRndEvAD5SW5bZS4NTELjy/+BPAOeplP63Xq+teYx6h1qWyXta42Q9KQZGEggiFgyLrHlm9jEH5SZ0ARKacUGXcegdeiPdXA/qEScgjgeXexu0eg0/gNz4HIav3vpLHTxVa4lhche+3uuf42Qy+eXVWq+0FkNhG+O66AXbbxGfgq9LN4hLQp2Q0pNAi5+yA6jkN/nifXflF2D68ljVOTzLxe3WkdoCdfBWSS6uUgclsAKAv0AyYijp9VzINSDii/khAGeUOfHvRTCP+ceVCfC/3thYKMhJ6f598ZGZwsqnADKB+SXY7r1Zj/atShESGaNxmREqaV6Y29jsJ/FUUQuEcTwh49tbaMioduTjEJA7Wh21YcA/JRXeyJqdNx7nhLeI1EcZLnz5IX+C/DMF+ZLqR5I5wTdRZ9wbzn2DOdwVbNj6uZg4Pl87Uz1ZS3pQEeVKw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0625a2d-1e07-4a9c-d907-08dbdec9dc82
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:17.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcBkzdpF5oU5fhTAXnVgc47X+VuYdRxTH+oGxc7DWBH2eDCuVxtsRIp+wjweFSSFsRAG9gI6mnZu5teyXcecuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-GUID: BpNRIB2EfBt7jI6Avqv7ZTdVePR-Zlxz
X-Proofpoint-ORIG-GUID: BpNRIB2EfBt7jI6Avqv7ZTdVePR-Zlxz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 3545124f..dab14e59 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2101,12 +2101,12 @@ process_inode(
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
@@ -2116,7 +2116,7 @@ process_inode(
 		case S_IFBLK:
 		case S_IFSOCK:
 			process_dev_inode(dip);
-			need_new_crc = 1;
+			need_new_crc = true;
 			break;
 		default:
 			break;
@@ -2130,7 +2130,7 @@ process_inode(
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-				need_new_crc = 1;
+				need_new_crc = true;
 				if (obfuscate || zero_stale_data)
 					process_sf_attr(dip);
 				break;
@@ -2149,7 +2149,7 @@ process_inode(
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
 	if (zero_stale_data)
-		need_new_crc = 1;
+		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
 		libxfs_dinode_calc_crc(mp, dip);
-- 
2.39.1

