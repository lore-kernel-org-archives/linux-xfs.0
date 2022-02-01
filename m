Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D078C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 17:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbiBAROm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 12:14:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7680 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbiBAROl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 12:14:41 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211HEDj6003008
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=yOnuytAqyRTuSOqIp7EtNjI7ldRudKVGb1Uk8yevtWw=;
 b=0uZXUOnXA3ShwQoWCY3UuMtoT9wHh9jr+JDHFs0YWv0raIjWcSALO1dKikvhf+lyClGT
 lqrLEFEFyuxUiOIT309aLnxrSwnB90DlROVlv8XIy1Dap8ZIpLqfw7uA34/RkPB2sAgO
 A0Gic/aZmqXPnnEmVGj0q8jFQKy+5hMyewRaIkX75wDlFDH+OUg2n66SJ9LYVqoh1p56
 2/MHeN2lo/77qGFNqxu0hcFohdr8pD3vIkwGI+x2sfe+hRlVXRFjTPhtjtKpmMldzobq
 jQRc+U2mSl9RnHhjIEjpdpUIVqbjcwoIyN9HeT/yXWVAdtIMoAiNGrUQ1r9aa2Bwc3g0 jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjatunmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211HBSu9156543
        for <linux-xfs@vger.kernel.org>; Tue, 1 Feb 2022 17:14:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3020.oracle.com with ESMTP id 3dvwd6k4tu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Feb 2022 17:14:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9nZC7eiLlaK9lpHEga22pqih5X5tjdVJlyiMWLqMkVx/9vXNa6FR3tb5RJBcLWKfJ8ljjYz+tbj7XHziGjHIpdiZAUVrUOFizvN1SrsmcQroQkYkvEjFprLwG6vEcNEuWZ49zKPZOnVh/4PAMqaP6llMkU74H+xPBs1ZmRJ233BruNWsZIOzTyGfJ0ItIxa4SAbxqmh6dYFZGPvDeAAav8Z760KMzTgqrhLK88bLFTTrfjPefUvVd1GBncDJdxuRw//lmaQ/8NS7EOq076ZIWKaDYAPuqcKN/OzCo3DiJVMzk8GzMtpveB1u6xZj9qKFJhh4JsjNfxTlIRmCwS5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOnuytAqyRTuSOqIp7EtNjI7ldRudKVGb1Uk8yevtWw=;
 b=V+e4pums4skJV/M7ALKoGwvckWizn7DKoZXxTArVq8gbckpNgInSOBkwpI7MmMIVLV4oUJa4kDnwmkKOHDyu9dZu89GrAU49G23tDWz0PhcIepcRRjmoVd2kaYJOvUHax9JnoXobxiSxCT+PsHuZkcjdlhCdXdK8xyZxIqgXgeMji4w5gymnkaAahdCC26wLj06HVd8+sPguX6RUsFpXJAGu3h2d6krYgQSn3PEKax56mmoQFb+DKQBgoHCxi1qj9LhB2WPWSuzpXqWGVB73XTRavpH9TgOk2I+5oEaoNsnCPShPXs7b34GAhio0FZHTZEU9ic12TK7vWy8GvG2X/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOnuytAqyRTuSOqIp7EtNjI7ldRudKVGb1Uk8yevtWw=;
 b=vuVTr6AzdycfthKjmlm9r2MIcB7bhRDXnvLkKbHn06b1hRQySvXl9SKsH7q7QfVuR7VUVCb3rnogR/iRqTyltdxIW/zEk7Y5KcmXanxEQiVsdTc87EdF4S/nHnh93N2NVP6SPvLdm5KmEoXBbpJqOg593PFDV31nf10gusR/6Ko=
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 SJ0PR10MB4735.namprd10.prod.outlook.com (2603:10b6:a03:2d1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Tue, 1 Feb 2022 17:14:38 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::2927:5d4f:3a19:5f0b%3]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 17:14:37 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH v3 1/2] xfs: add leaf split error tag
Date:   Tue,  1 Feb 2022 17:14:29 +0000
Message-Id: <20220201171430.22586-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201171430.22586-1-catherine.hoang@oracle.com>
References: <20220201171430.22586-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a953d1f-80a9-4ffb-81f6-08d9e5a652de
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4735:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB473578DDB8A02D2C25DB2EFA89269@SJ0PR10MB4735.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjNexgWMJus93rQcuOXpWfFrL0rISctNHAm7x9oaNhhZlHe5RFZWPZGLqkho1p3OMvacTY8LDSK6qmxLGhjGI9ovNcxZwdm++svvEcQnJ5oMS0tF/8tcR8C3cK+SShliKLzTVkn6mKVtnlICbdLFTVVroYkEfliUnVP8XIJMzUM1mHr/kTnSMWBABPLjmtb9HY6qy2QlfIeOGXeaCeAFL+BdogEJbOssLelNH79VklU6tXUREpZ/5jQNbgEaSUB1qHY4LOgDWYGdV8sdj8j1J96tU7au0v1qFa653sgDLYJKsUuQn4U435YCgcxgIX+4w0kq2XZJgVH/77L9W4I244rVdp3Jr8kCj2+Fu1HjPti2waUaiPleoJmPsWEAkLGw8V5eaem1pZSJOjnIHRALKDXj3pTmscWYNKg1m2SBgT1lMBzVQ1HT6JuLX8hlOd5l//1oIre68o0Q+4d9OrjB3m058XNwZSG5InNxMwojW3uiJlzi+GP3Ka+PBO+3f+TmZtsx13TdtNSBusP/ugjhGGcAasgDUD9RtvHW4/wNKXfU6ezmej1epAyg/cjcwHFgHNaedrgP1cYwvJtQre9qpHVR6sPMxb1zRjVnWKBU9lZRdN2zvzPBNPx79nr5RjIl5cgcp/kydmx7x8Jfo2IHy71x4xxcRb+grngPs7psQkWxkqMBtA9CD2uZZiPwfW17VFOk/yBRws2tM7R1DhkFBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(66556008)(38350700002)(38100700002)(186003)(508600001)(36756003)(316002)(6916009)(83380400001)(26005)(2616005)(1076003)(86362001)(8676002)(8936002)(5660300002)(44832011)(6512007)(6666004)(6486002)(52116002)(6506007)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kg4wz8eJ0z91uBQKFb/izO6qJZ8BcXUKoe/W6x30n1w+t/JuhNU2zwkuCqad?=
 =?us-ascii?Q?G92o+4vkWq6GFYFBH1xEQu+F998TkOzDv8SaxiHNuD+HpltgO5k2N3WNTWd1?=
 =?us-ascii?Q?BaLTXITWfTAraFqPfJdn1rRs0eSKdgOAuDvRQ8n2oQqVgW6zyQYvmvLaRRhN?=
 =?us-ascii?Q?/E5hHaHnunPyencTEjl2BJJUsnCh5kDrugQ2uktCeM/MFnzHxYOeyVtDzJ0T?=
 =?us-ascii?Q?94KK36ilZoO3FdoKCZRTBpQcHlJq5mCvZG0cxeO+A6wPTHCjnayIFIVXyKX8?=
 =?us-ascii?Q?AIolieXF7VtO9Pq+KdkaAktbT9fKIjGUxt8DbhHGZBGqxovgwms+Be3QFvVS?=
 =?us-ascii?Q?6+0c+sFp9zguBm1ZfAN+QdJjaA2xNKsb8+Sl8E2KwfQF8sUuQhRATqii1JNo?=
 =?us-ascii?Q?Vi+d1W23iAfxLGz4MLwPj7ypbz60bK4v3r5FXZuaS2gITbqqsoxX/6Auodek?=
 =?us-ascii?Q?Rbjwf5xxXzVMh4RFcBuD0Z6zgMs0kdeoqpLoRkM9TJ4erZfVhDPI/qeeyfhw?=
 =?us-ascii?Q?FRAgeBNKbVNMHDlijPwfM1QB9BepCV6xeAKoeD8ByrAnnoS27rGZ62COzcBW?=
 =?us-ascii?Q?C/P1wT+21olL/mz7gkucRg+w14PJ5zuW+8Mh5scqsmyEK6CHJZayu5vsvhlA?=
 =?us-ascii?Q?jZO8PgI2i7PBUUmFc5HRjz6NaVLl7gb6zAiChtpnSHWVETwu21edRsjWG+JR?=
 =?us-ascii?Q?H0sdviVXejowSB3/yrxA91fR4V3eoWCRXB8Or817uMGSzj/tB3dWSH1xZZf6?=
 =?us-ascii?Q?Dn3oSLHz31UPdgu6Q2cdVhtVnFhlruQ1+d2Vy7qgj8sY2o9CJUe6uyJ+M6Jj?=
 =?us-ascii?Q?hVwb0d/lpw6dWMvSfRIG/DJ8bbwnYAv9EKTocZgDWLcz16RnEstDE1DJ3TbW?=
 =?us-ascii?Q?EXzwn1Id90QbcKc7LkP6NdNlCAlSDtOXoTiyzSsjJFHAZuebAv3ZaoxVkKwk?=
 =?us-ascii?Q?Lz+LA1nzl/0kAi/fLY47j4SrHuvcCoWxAiTWjcpKB8pTIjA7bl/CFouZT5da?=
 =?us-ascii?Q?bX/9x2+suMuK1Ipi+/VfYORT8S2jiQB/4esnmPPJItCFHBfiEGqJJ7zzurkf?=
 =?us-ascii?Q?J01sv4zsQ5WVmJ2ilKtbQZs1eoa6OCeD3mBozXQSYWt5cps88pH3mgXzVqgd?=
 =?us-ascii?Q?Y/toFjh2Uhz7plQ8dPMGJN0BzUxXtgWtNqTf/mUnVzK8r0Ps7BOv9igs9fzu?=
 =?us-ascii?Q?Fx/G2CqZ51bV7UNyunciGshsbXEFjJbdfy44WtHZussBOucSid/RnYsPPD1D?=
 =?us-ascii?Q?vzWUxzAKDXRnseMBB/XAyQdZJ/75gXLQMXgEcPytypNgIK3dY4G6ld6+IZ4A?=
 =?us-ascii?Q?iCLibMfmPifPT5A1wx4w4bv0mhfpddmYKt0oEV6wGYF3Pg9LQaDTbBCjpxXj?=
 =?us-ascii?Q?i+F4Apyp/W5ejMWfpaYOri344CN+x4mfNvINZzvThnQZumnsvjq+EE0drmoZ?=
 =?us-ascii?Q?KHzM2+8ZyZdDQlolTPGtT+6RaBQWquEw/lYGv1rajEtYZIjVnig83V6MbEXN?=
 =?us-ascii?Q?EAABdKTV0hrW4apDOYaggbb2AnEeH4qxO4dH/79EoW0LidJxRzh7iS2/epWD?=
 =?us-ascii?Q?44p+QerqMEkev2FrovsA9XTmPxUq3ye2oPLgOZZt8RtMx5gbuMlEBlbCPrtB?=
 =?us-ascii?Q?le40VMGtAuecbX8Hcp5gmr1rOdzGinojY2D/r28KrirytJJbjHrrNG8g3Kpe?=
 =?us-ascii?Q?5H0XVw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a953d1f-80a9-4ffb-81f6-08d9e5a652de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 17:14:36.8062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfA6vLrZ/sAdttijzvU1LcFZ6/3gZusdWyzKmK0M6LF55V8m2A6l3TZ47tLwrzCyCrdXD5DCvx4fgrTqthikJuItT5HJQYi5M6rMjNQbqv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4735
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010096
X-Proofpoint-GUID: ADblnm5la56gJ1lnBN1U_6WNd3WGTqrs
X-Proofpoint-ORIG-GUID: ADblnm5la56gJ1lnBN1U_6WNd3WGTqrs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an error tag on xfs_da3_split to test log attribute recovery
and replay.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 4 ++++
 fs/xfs/libxfs/xfs_errortag.h | 4 +++-
 fs/xfs/xfs_error.c           | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9dc1ecb9713d..aa74f3fdb571 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_errortag.h"
 
 /*
  * xfs_da_btree.c
@@ -482,6 +483,9 @@ xfs_da3_split(
 
 	trace_xfs_da_split(state->args);
 
+	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_DA_LEAF_SPLIT))
+		return -EIO;
+
 	/*
 	 * Walk back up the tree splitting/inserting/adjusting as necessary.
 	 * If we need to insert and there isn't room, split the node, then
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index c15d2340220c..6d06a502bbdf 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -60,7 +60,8 @@
 #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
 #define XFS_ERRTAG_AG_RESV_FAIL				38
 #define XFS_ERRTAG_LARP					39
-#define XFS_ERRTAG_MAX					40
+#define XFS_ERRTAG_DA_LEAF_SPLIT			40
+#define XFS_ERRTAG_MAX					41
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -105,5 +106,6 @@
 #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 #define XFS_RANDOM_AG_RESV_FAIL				1
 #define XFS_RANDOM_LARP					1
+#define XFS_RANDOM_DA_LEAF_SPLIT			1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 666f4837b1e1..2aa5d4d2b30a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 	XFS_RANDOM_AG_RESV_FAIL,
 	XFS_RANDOM_LARP,
+	XFS_RANDOM_DA_LEAF_SPLIT,
 };
 
 struct xfs_errortag_attr {
@@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
 XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
 XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
+XFS_ERRORTAG_ATTR_RW(da_leaf_split,	XFS_ERRTAG_DA_LEAF_SPLIT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
 	XFS_ERRORTAG_ATTR_LIST(larp),
+	XFS_ERRORTAG_ATTR_LIST(da_leaf_split),
 	NULL,
 };
 ATTRIBUTE_GROUPS(xfs_errortag);
-- 
2.25.1

