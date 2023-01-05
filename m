Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252A1C46467
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 00:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbjAEAh0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 19:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241153AbjAEAgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 19:36:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2465BDA
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 16:36:29 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304MEK4O028225
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=g5n20lLei3gi13IsHSaiEYRm99YZm72cRB3tNurPjbU=;
 b=hnYJDHBQjPV9O2HPF+MAI0J9AvzRIbmI/u7QqTYewI5dj/+VTek8h5l+GW9gdAxcW0sd
 wJedIClVhO1ROCI/rbaIHCteXcLeMMsHSvOz3Ls0lhzyyGdQo9kO9rbux9ra3b1ip/vm
 hEq08jpKDhbNbG+FyBeIOI3S5HQJ1BsOcUXv4Ab0tdUh1q4Lz3VDu45aFZo9CIwp046v
 miIh+dNCltzf5TqQupbG7k3thATbBLfD8rScGFI0vGjb6VS7ZPNPwM8NsyatyjWf1gyv
 QHtJ1tVzdlBQVGYuj/n6KV0oqFl8Awy4F5GsLwVA6kBsRQFTeqGXctdlnvh7Ey4gnrsA tQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtdmtqs05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 304MxYw0022760
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwevhty62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpDk+7y4N/zWsY+uVK5JuyTzy3yF7Bfi6HhOfOjXZYDM1CJd4RS3+8M7TasHpwx9o51HbbKQxbT4vG2B0G9JQpBrAqgREPvS84+DpYeJXzqjLWHdSL9KBnrTHoaFV9r5zkkZTSmXEQYXQHZnfv0jZgssccsHm4LC7QYMx9lu0FtnbGKwXzN2miVQ5ToBpiVs1nbOiaGNhnbh4/ZLH6w0eWDOIPbomF3++T9jFS2E4+4zMjCHZLGWe1bN57vcN3gZzma7i01sx88aS/HIX5CFvqAkthAQ+S4ygrhW5NmD3NH8tg4j3v0zXmXJcKDBu0KEsJrDQlKafCABAz9qfZ04oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5n20lLei3gi13IsHSaiEYRm99YZm72cRB3tNurPjbU=;
 b=WiildiKcfHdWtTG8c5TF5MLVXdnDdlSopduEmNUowwiYvblSsdyGIzjWNLtGW4ReevDxfCOsYk/uVEAi1u/TVH4SNBvHiysoIwv3Z11HrUUhZur8tJmuFF/uSvjwUtIXL4fva3Gi5N8/TNNXlBlKN5bKHPuH42pCD1rWcEneVqqKvw65QYeKVjhhO61Y6DPbZbQ4k+tlyQFPdntSXqcnCUOqq5lHnEZdViwA29ISb7rJE8oxdhAkkWQTH8RfWSy7gqBapcnZ3UKvCTlc6ErFDRauPOBPnHQPLfmbJD+CJxvTKyoAQBhdJB4AQm4M3aiZDyA2Ol7+I33yf9m9ycFk0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5n20lLei3gi13IsHSaiEYRm99YZm72cRB3tNurPjbU=;
 b=xAfqaehKdAf3PK01T1Xo+E4bb9wEhOwdv5SwyNFLB7wn0VKnaOEdsH86Btx1X+Zjmxdktc03SdPpZl7yPMmltEITodr2Ai22kAlt/Bh61Gj2obphp18gF/y0ZSMNHGRCrQlQSQkMCOOoVq0v/Fcm8PvzMBGm4oXY1oLlICjICT4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 00:36:25 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 00:36:25 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/2] xfs_admin: get UUID of mounted filesystem
Date:   Wed,  4 Jan 2023 16:36:13 -0800
Message-Id: <20230105003613.29394-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230105003613.29394-1-catherine.hoang@oracle.com>
References: <20230105003613.29394-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::20) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SJ0PR10MB4622:EE_
X-MS-Office365-Filtering-Correlation-Id: 9036145a-ddaa-40dc-3498-08daeeb4e075
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sBZ7DEYjWALLNyh7epugMqqCthe9IZkTj45cd4REBe97RZXK82BK1QxYHM/5egW6buMRU5gvoofe1hWY3qGou9E1OnbcLJY2/8el8oz+48r+xQyaA6eyvYN84mIpl/RE7poZF4+LymrNun8e39QlnMgyCW4iRxmrt7+DJvBDn2wBGymSxwRkT6T0b1kiWVLYB2GQA8CeMuPZtMNDQOG9XupTGHgdfyZfDYz3wa4ruEtgTLuD/Br4LMHAIgVQ4nLKVkIHlRhavPmEmgkV5VXMYtYAbVxxyIW2/Ws15A/ACIbKwVGwDs828VydERYCwW9U3mK2KtV5HFORUWVQWcx5u5B9CmjxtIJnzE4RzL1yw9UikMAXmnm3ew1ajXzlXAvRROjuKvOxztord3YOlAMAeeA35+tI2SwlYh9HNT6QmZ5xYqhK8V5DB6Ix+7JjzM2L4f84rFpMxL9V1By8wbuwwe6U5gsGa1G+zxzfEmO2Hdk6ZLMJmqkK/1an0CSXP/aq5ilj2p+FtsbB4kQO9LAd75i4f90ydTVyQY5+et1MiQTB+hLr2/60/5GwBU23cwxXTtvHDRtfdvdvV77Lb99bCSiqef0kvNVDDYwdHSEULRyAirmMVeP+mCnFqphEUOlgwBQFeG5bgwPxEO3MEEK9hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199015)(6916009)(86362001)(6486002)(6506007)(316002)(36756003)(186003)(6512007)(83380400001)(2616005)(1076003)(6666004)(8936002)(478600001)(66556008)(38100700002)(2906002)(44832011)(5660300002)(41300700001)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4k6vOM74C0awPDMd5WMauio0ajvaXu14vxOwSLd37+evY5cuEnU38use+zwF?=
 =?us-ascii?Q?Vr2y98pSme6737IBTFmWzNLfkVCOU7Yg/hI30CfbHuXyEQ0nFzcq1v7H51no?=
 =?us-ascii?Q?dh475ooTsPZ16LBRt+8sgKGLyQyZPcsEX3dXvNCGK+Lbc3axXDf/g6Ah/9G5?=
 =?us-ascii?Q?bpCPyi9bk+Q+uVx57hUIS3U4x/vdFCjyLUxwHBeuRVDtcGlEidzgv17MFLdD?=
 =?us-ascii?Q?E98a4W7OzO5QzWVG4LnDiWsMW/B1UgSTsS0pfwz7wRdlnz9y/rq3QtCcE4Dk?=
 =?us-ascii?Q?B6k2UJkcLmfb8tngUnnReL1PSKZ5UunYcLglXWyncKDZor7yrDkruMVT+1Ar?=
 =?us-ascii?Q?1/1l6iJ3G1DnmHONr5bB/y36Dn0WXSJccsPoEFDC9xRWZGyTMBCs117Cy7RB?=
 =?us-ascii?Q?RjVxrDD/w68bGp19Nk4HeUH2PnF5F8LQgy1ur9EOd+/amI/3Yux2RXBaYklG?=
 =?us-ascii?Q?ktXww+/ccY5rWwwdnlQ7c56DyAXWrJUzOZCKzOqrLMUQ1QT5Vnz2maIvAYqm?=
 =?us-ascii?Q?uNp/CzCMu3J+nBTmpozMRCmVUYmqVoDy0kP7cE0c1XTaHl8U72pL8kHT2orV?=
 =?us-ascii?Q?kF/q6jCQZAMZQBJBrb6wdUdC9WIgAE/+dvhRMgjsOHUWFUlyHfTtw3Tq2KnL?=
 =?us-ascii?Q?Z1q3fwPsZNRqapo6SzMID3tcqYg5X2ObAQC1MugFS7P1umuHpdR9OsbsErNj?=
 =?us-ascii?Q?sAutDm/ojmUIqmE1k9FoQ9Gdl1IXGCae9rGblRrXx+GW58XSVHBqM5TJ5J0e?=
 =?us-ascii?Q?uv0kJ9UpidFjk/pBarRNrNEgJMgGaVDn8smAy9aamPkCtOX4Sk7UGxY42+pJ?=
 =?us-ascii?Q?QDVGH1U0L+92oSmjbxfj45/xWLl8CkfMXp4KQQhbdjpwvuqYmyl4m4z60j6N?=
 =?us-ascii?Q?CtbpXppCJuloND4ZZu98lbDOYEGXOzYfpwMX7gXP78TwqKTxuNTxuw4wgc0r?=
 =?us-ascii?Q?z0cpj9tU3uxdAL/8gDAC8KLUsrKNkmjxBqcou9RGMF3xbmZdKrxZhkL1XCe4?=
 =?us-ascii?Q?dyBfLh5JrOQT+Xs2rA7+udeD0f9AX7RNooprNIUsAP43ISf7al+cA/zjxSLR?=
 =?us-ascii?Q?wevTZu5GrV/o0V4yOSKFfvpSDzg/JiZII9qqMHQz/eNqzHzdlem+O4cOcg8W?=
 =?us-ascii?Q?UjwszSsolEulrmL9HyXTJA/OODDt9OfDnscSSh/zgiTpeljh6scp4SQLoXkR?=
 =?us-ascii?Q?AXTPBObla7mEoOu2RsW01D//fsYVXjnXJTxBIyapny/vZCZ6CVrhngX05KR6?=
 =?us-ascii?Q?hFW4qmg8i6anRtTT3yUCxuDLdFabEv6586Bc/twj1IYr/PE/MnrN22fy7/kh?=
 =?us-ascii?Q?VCgwtBVhApjxx+7f/gHB8jQaDGMA16xR2SVBlZHcGwgtTng3pq2VSQgobnOI?=
 =?us-ascii?Q?WjRjOaTYeNqqIhv9Px8HqmKvPxwYR/AyxRtC3BjJ2WPN2Y9FelgC5NGH0nKa?=
 =?us-ascii?Q?hL2LnyHrlTrpZJaTnRD0L+KFX7qYLMywYNXH5XN2TSEgEpPZLDLC4wztAfyX?=
 =?us-ascii?Q?ncyXjv05GE+mfhHcXUl76BTHSS7/9KI2qBwugmA1tdyzwP07B5bLe3ui0DKQ?=
 =?us-ascii?Q?DmZcvB4WBnElCUYj82IazUBB1eY3LwudJD/nnHLSBTuWCX9UzSQw86ZB6Edk?=
 =?us-ascii?Q?/02OPuepfbDx1MS67hAPK7vCXpx+9lO5aYv9gKMa8myF+TZnEXupr89WRjNR?=
 =?us-ascii?Q?ux9e+Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mYxuHCx7aV5A9dXvfSHVqlc+AhJDsidxbD6Yf7O8lPdcL6QIIfOamnHx8ggU1w3gArfWOiiIUaFXyM2ba9GpMC+wCnoaqjfzqsB3OgW8a70hiRoJMBJgAcOqfpy+n5bpP93x3x7EZSQzJ9u3CxE69zHswAh3xlCLBDOojO5czsl2LJfP46dxyFcURW4+Fl6Rn2ZLYs6bZmpE96ElAQRXgWHbZV2IxENOvPkNghfIeWRUapZwe6DrPSA+ZfSLe1p3b+JUu85kzHdVNtwRNz3HwmeiZaH24BixNBL7XMhf+WIC6XwAXK562Wwiu8xFJW/Lb7j98NMzZzGzezb/77pgVi+Vi06JSaCUiAvmKEf5ySOoLMBIPGknclDZ/ST1XSpbPoBKGNAVxcr1DWBQmFblRfNTnZBelmEo/uC/OgEJBjJ5zIT3PgzfWVBH34glr6si5B+sipWZ12nlkmAQnudIS01HAYMKQegRfGzNrDuaCNVqsR847ck73QWeJcEKwVGoMP19E63l2+WzXV3ubhJwVo1TQFpQca+64SHXla9xsRHjiVBM084qrMchS21hwOKxNU7NZ2Njhi9A4HA1ylMUjKZ7v8qxgmI1CNMBmUn3WPdYQjrn87rZpuyy8cWU2METNQWKmcnK9s6nSWRMWejoCiPvgUS1Sz/WbbHmbe1nD0QLn2YnRmTnftV5ktO0nyZ9jqe6hjeFDY8DVApSI+jGijNvSqgPoXA83/VyA31juMNMO9msm0xM4wtPxPf2fPXWsrLe88PqdzxMBSHJ/emssg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9036145a-ddaa-40dc-3498-08daeeb4e075
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 00:36:25.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmaktWV3G7rFQ17VSBFLBuN9jDYd7GRJuZRI+U7vs0AWIERtdPl87T2NbKby4EnUzXWhR/kxGwA2T2tyksE9gSTE/r2l9mckjTd/gxNFjk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050002
X-Proofpoint-GUID: 50tZ3983kk2vLXO3zZK6rnAg8QDp_hdr
X-Proofpoint-ORIG-GUID: 50tZ3983kk2vLXO3zZK6rnAg8QDp_hdr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
This is a precursor to enabling xfs_admin to set the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/xfs_admin.sh | 61 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 409975b2..b73fb3ad 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -5,8 +5,11 @@
 #
 
 status=0
+require_offline=""
+require_online=""
 DB_OPTS=""
 REPAIR_OPTS=""
+IO_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
@@ -14,17 +17,37 @@ USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev
 while getopts "c:efjlL:O:pr:uU:V" c
 do
 	case $c in
-	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
-	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
-	f)	DB_OPTS=$DB_OPTS" -f";;
-	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
+	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
+		require_offline=1
+		;;
+	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'"
+		require_offline=1
+		;;
+	f)	DB_OPTS=$DB_OPTS" -f"
+		require_offline=1
+		;;
+	j)	DB_OPTS=$DB_OPTS" -c 'version log2'"
+		require_offline=1
+		;;
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
-	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
-	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
-	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
-	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
-	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
+	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
+		require_offline=1
+		;;
+	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG"
+		require_offline=1
+		;;
+	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'"
+		require_offline=1
+		;;
+	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"
+		require_offline=1
+		;;
+	u)	DB_OPTS=$DB_OPTS" -r -c uuid"
+		IO_OPTS=$IO_OPTS" -r -c fsuuid"
+		;;
+	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'"
+		require_offline=1
+		;;
 	V)	xfs_db -p xfs_admin -V
 		status=$?
 		exit $status
@@ -38,6 +61,24 @@ set -- extra $@
 shift $OPTIND
 case $# in
 	1|2)
+		if mntpt="$(findmnt -t xfs -f -n -o TARGET "$1" 2>/dev/null)"; then
+			# filesystem is mounted
+			if [ -n "$require_offline" ]; then
+				echo "$1: filesystem is mounted."
+				exit 2
+			fi
+
+			if [ -n "$IO_OPTS" ]; then
+				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
+			fi
+		fi
+
+		# filesystem is not mounted
+		if [ -n "$require_online" ]; then
+			echo "$1: filesystem is not mounted"
+			exit 2
+		fi
+
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
 			LOG_OPTS=" -l '$2'"
-- 
2.25.1

