Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A589C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbjFFJaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbjFFJat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:30:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0582E76
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:30:45 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566I1uj023432;
        Tue, 6 Jun 2023 09:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=ZJdBaXmqIOv9kW/ReOI9djwlqPDft8L4lTUbQ1cH64E=;
 b=r1FrrQTXywLbRu7H7tQhPuudZewRxTYruDKrdtUVuKnb4Cx37r/Xn9cHu93GUBMQtDhG
 L4NXMtkQMe3/eYK8qzViKhHriuAmlo0SgKSLrFhMk34X8YhErQbJdqAQ8ZWV355f22jJ
 w5s2BM2ph41ijOy/QBE4AzZszxnAEeQwbuWtBuNekXhH8HmUv/CLPz/Yoi0sNhVxsY78
 D5j2+9pN1tD80khA/n8PIbg3LJ+l30M6qjQanBU9YdA5nxhG38Ld5D2TrELS+tQjbTO4
 8/Na6jvc3MPKo4QnK9DGESs4wU/Dpd2P8+rRQGj9aWIXHC1wDF/+zSdAAreIvp7ei8Ro Pw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx2wmxr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3569NvcV010306;
        Tue, 6 Jun 2023 09:30:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tqcnyqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:30:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htuENhMoBVvRVHdWjXB9M68zJ2/29GuFXPtcR4ThBhO/PH4lCSZyxZsDYbEQP9ru+4ZwOyyBRYf7RUFHJCkK7Hx8fidhxM/IDQkTVg5bgOIOfha6OfwNGnUGveEqbwoIuxnl1hBSXKwomj+doODvr7/ZkwC40FD3l+4hCbpafyMXXKaljh9CN6FFqRcq9VrgybCRYuqYcNRzUfXIvh4FKh98eU441TeKgjTf+rVcrcxQeFBKXBe/fdQfuZJcj8gF9fGSX9ok1CCKgfyX4odirvO5qZFFYWUozAAnZBEotSY6GwtcnSiTQb882qgrFhQD5PqeEmenkfAtrm1iy0Feyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJdBaXmqIOv9kW/ReOI9djwlqPDft8L4lTUbQ1cH64E=;
 b=dWkyjxtxmTUzjN0g2ri0gTOWLfzOtc1sgCMUElg5/JR4ckD87WxMgYVnK9+E3VB2Jmry52zsb2QkeZWt88MWjSqes0uaYzutSUqMJIl73NzTfi/EvCX9055lTUdZDR5gdpknji6zi2gcVWQjZOBToRchW3e8uvaoGJBUCAB5Ejbrt9c2bh8U7gL+CcVF/2wI6b0BVhaCHnWeuxs+2Az4BVr+EuDiHbC3UYCxWAkQKfdYyDypB67gyEectrbHRfg8JaITXAGWrS548H9frEuUz0/TGwZ9uAtXzRMVBrPfDR2tbORBXP8qLwEm30K9xA9ysHMPCU0g23woEYmwv2L48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJdBaXmqIOv9kW/ReOI9djwlqPDft8L4lTUbQ1cH64E=;
 b=XasCL05Wmn5QmQNuqlUnN0F2gKs1dlhGEVwvKLRQjmpkM47veJvWC0zh650szO1K1eYzfZ0P+ukd47FTt8INGpufP+XPfraEniC+XRvkqFK6Ctopz5piUe0QZ+2cdq8sIJwqLjHBA9NPTYA7OEHpR4akZ/Iy613BZ1c+49VlKqY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:30:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 19/23] mdrestore: Replace metadump header pointer argument with generic pointer type
Date:   Tue,  6 Jun 2023 14:58:02 +0530
Message-Id: <20230606092806.1604491-20-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0143.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 17d48cec-5ab9-4f6b-3f31-08db6670b0c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qseyx5OkfoN0LgXe0TQOM+Yzg6axl/t1gZtTD908/tcY7Ol6yRxvOlhGtTlyrAjdIOrIce0JVDlPqrsqBlt8Lw740h8TY/7cF7VQSDPnl7rqyN7059hZyaWPlubqXlRsJF65MHTnyZWgL8lJb6ET89gGcNvY6z1gg93ZquySyfndzGn2TaDAe6W0QGYc0Yc3vOEB0UrwYeD2lSKbXu8PjVvL0c5s3VZTCtmtqeTiYAz27S49YmcYUE2g2slFZ6hHzCxaK8clMsHwSxh+ZO2X0fidGyDMckRBmPSiN+pHD4ImSug7q4WGZZBwUXSqvdfoHDLgamneSwh5sdE5ZiRo3HeAjSAs9CHgYQV7Uz8HZhdjKTfWZIuNsGyKslYWs/K341PEHbWAZpaNivE1JGoyCioC2dnGJVhtFbTIYEPvOvZlFgL+OOXQ2WRKapm3kKdR7l7P7EpnLPjg+ZI/EWsRAWOepLa8tND9jBOEqx+x/TLkooc4qk+ARgyVvOC63HIQWWLtJf7Sj2cWFnzn7EfM96mfyQmMko/IwuxSCSLnBq0aNYj2jmPqy8QnwcaHVUeJmhvtAfF/VTPsDI7BN8EHFjz7QE2IeYqrFMkQs+Zekjc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(6666004)(1076003)(26005)(6512007)(6506007)(86362001)(5660300002)(2906002)(36756003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yMCitP199eLOQU45SvMnx82VshSMsEh/JZDMJiSTdzK35aAp+j5xwFT2eL2X?=
 =?us-ascii?Q?gKmwJHCgOxRoqZEf84m09eqOLRZY6FMBWPSgyKpOKj5AB0jTvamAeZVZibTG?=
 =?us-ascii?Q?NCm9bTXEBiBnEoBC5EjmsI3WjrUVQIl8WmYYvE9B4VEZh5M1Z9xVZeTJdXkG?=
 =?us-ascii?Q?s0o81dWk22nHwqYImA71wTJF7pV9VPJa/3XtKX0CyXOoNoBgilxyhGMS4A+b?=
 =?us-ascii?Q?a1jV4H1AgHWa2/kIW/lsIBLsThvrOFNuPLkSrYTZ18P5DkljsxMT0pd/NSNV?=
 =?us-ascii?Q?fnNy5PahSDQczsXD70vzkWaqgRdja5JR/SVhcTyCyei1DI2mqc9axoRZoN26?=
 =?us-ascii?Q?CzXbKKJqHbp1WYXAhdy9U16bMiEGhokwwTjAda+MmSYDNz+gQ4YYFk9+2Blq?=
 =?us-ascii?Q?Okjr8QKPpJSmatWwUe6vuHuMxl4OFmXbOSBr/nXEDNaNg1zM+8s0WXtVjMLy?=
 =?us-ascii?Q?hz/pMEIWzap1W7MpB9HLkDeEyA0oUFKKxKixQC0JtuoLweRx6mPXqpzEIuaG?=
 =?us-ascii?Q?ymxb/zQDrNhYdMhXkvTRmWANlGX6hAhPeDsbotIWT70tzMMVIFc0VnsZY1v5?=
 =?us-ascii?Q?cO+0bllLXEhBlS0HFkmknTn2ZMRu6/5C86o3LfK8KWdRsev2QGIYv0qvSvFY?=
 =?us-ascii?Q?ZHaoOAt2JDglpFS/rsTxaczLH13w7ceKgmaCnxU2qAKETLC64QnTlqsAgXUl?=
 =?us-ascii?Q?Sd+JCQXA0jyya6KqNN/oKESUmZKZmS3wVSf7NMyeSiLISd36+Op+NABvUGrP?=
 =?us-ascii?Q?9q8K3ChY0uwhUAoVfXFAqF98VAthVhLgUxpOi57z13d3/1QXaKHj+aa5uawA?=
 =?us-ascii?Q?CpPnMH/+Mba2NG2CACQVYRgEhsm+0V5ngLYs89LZM1ggnnnP7KrnESHugtPO?=
 =?us-ascii?Q?RXCO8xUy5IEbkSV2HRrYCCiJvMu3GwIgUbP1Oy5K4W45+XUXUrRB33gQfaR1?=
 =?us-ascii?Q?yglglteApWIhwTQbP+eVRr8brAZf0KvaN/yR2kQ3ooHG4bB1CCFQwqwsvQ2M?=
 =?us-ascii?Q?IkGZ5jmzp3feQwwcDYKn6ij0O1ZYE2BteKrRfw5yuDHyWdspLg1Z5u2Vw8la?=
 =?us-ascii?Q?fdfNhcIve24e/ya9Gchve1PpQHk7tpU0TXp2s7z1sbe705BXdWajirN3tjlL?=
 =?us-ascii?Q?r2Jt+CSQ+1Q+MjojzNlzYFOJFpBNELODsnlRuBn3oI528Y+PtO8dUNkiHyiN?=
 =?us-ascii?Q?xmdj22lDEbogqxO9QAbFhxGmY+p7alwEG5bH2d5+Nfgh6+tgVK3TWO/IHTnN?=
 =?us-ascii?Q?r2b/xZoEqFyHBApanmh350BrC/dVvY0jvcfyHLhwrIazu/zBPsEvgBPYdV81?=
 =?us-ascii?Q?PdTpX7gO4XEod26yjIY2qrVa7o3nJk+4zxgix0fNYjkTplwhoJ9MmkgwOkCU?=
 =?us-ascii?Q?1zYdCTfDP7hnol4rOsC3ULPY3Z82aZFShf4F6cAr83UsIxSGIv2UHBqj9Pe1?=
 =?us-ascii?Q?HSvW2GZRvpFfnXDMK7JSXKbKp8zD4B4+vp4zvGi3thxavgorhLV5ed4Rjk9o?=
 =?us-ascii?Q?BQIt1CvlifZen1CcEGZspsUZvr0lJO6lxlNR8X08ZIwUKWOymMnLVO56X8Dd?=
 =?us-ascii?Q?XOmJzB9BTlESF0nmbTsTful7sbpBM/fgkWDbgwABwlR7Ta4q3fmNRBctCF4A?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Qx0AFzCW73ymu09xtaYMOyi2nrliuiVzgjZW6LB3bc3w7G9Nn/BMx2b6Q8ZjS9whoD3ovOkTCPxgMGyEDyYeSBhaUaNSD4W+D90RVMmYureo7nKpeOGJqjIkAt3h/6hybwn4tZ2yvwql+c13djkud/z36QB0H7HoKmLbbAbDBkR5Vl6JalhVrLGy3CM9jOAke9H3R61Lsiy4xyULV9Gx9Y+Q1PqusK+/FSCvUK3QmW4DIJGaotZwk4cPbQbakLQuAyMRxsDaeNNCm1QVwnpkMoE8I4ZNf6DSbP49v5RpGfIdX2x6nb9ZOxBtR/BAQJiHjiuU7+uG7yACI0F+4UceI0BbdD0+2PfyKK5ZRYHCOvqt9dalGvykoFCdCKFkDvOnoVJW00vTZ5MpkhdoPbGYKhoZdSU35i6C60BTMjcXsTTFb9PaoLMTaWYtMGR04oms2EAfwtUTMutU80RPkOBidOvLbx2MwnbSEBD6szPiKRKAPb9RDO94xykl8eBpNsSlstpSwuzeKRH1aBh+cP5oMEFnKZv7v/fDUKoibvLOZHR/5KKZBXq4GwY2PhJ91nON1Yn26VZ9KWcQ2xM1rsK8gbIrlcs1HOs119fcTMdHp5qRVQIRFvTTsJ2Ai8TC/5TVMebIBVgGvxo9iQV9douuZfi7xNYWIQOAZFPWQ2cvbvc1QdjltxNOC/iqkynNylyNXIIx2eDNDKblpYCLulSxBEbj0osdQBma4+ktKeKDRRPwtk0TQidki4CVjrc/auTOleWOWkdrTTPrICBKPZrbkvm4EtP2EW4Pjd9fCOso7JM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d48cec-5ab9-4f6b-3f31-08db6670b0c6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:39.1873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXGpeD/z2ePTCPEy0oABuHDruc5IZH8AV22gC0tVksxBx0+WOVxW5tEr5zhrFr+CquYPjmUaQ4Nl6Bs33G5XSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: e9SlGNIUpEUKt0CPzQ40WIP8CEjIYy6W
X-Proofpoint-ORIG-GUID: e9SlGNIUpEUKt0CPzQ40WIP8CEjIYy6W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two variants of read_header(), show_info() and restore() helper
functions to support two versions of metadump formats. To this end, A future
commit will introduce a vector of function pointers to work with the two
metadump formats. To have a common function signature for the function
pointers, this commit replaces the first argument of the previously listed
function pointers from "struct xfs_metablock *" with "void *".

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 08f52527..5451a58b 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -87,9 +87,11 @@ open_device(
 
 static void
 read_header(
-	struct xfs_metablock	*mb,
+	void			*header,
 	FILE			*md_fp)
 {
+	struct xfs_metablock	*mb = header;
+
 	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
 
 	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
@@ -99,9 +101,11 @@ read_header(
 
 static void
 show_info(
-	struct xfs_metablock	*mb,
+	void			*header,
 	const char		*md_file)
 {
+	struct xfs_metablock	*mb = header;
+
 	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
 		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
 			md_file,
@@ -125,12 +129,13 @@ show_info(
  */
 static void
 restore(
+	void			*header,
 	FILE			*md_fp,
 	int			ddev_fd,
-	int			is_target_file,
-	const struct xfs_metablock	*mbp)
+	int			is_target_file)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
+	struct xfs_metablock	*mbp;
 	__be64			*block_index;
 	char			*block_buffer;
 	int			block_size;
@@ -140,6 +145,8 @@ restore(
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
 
+	mbp = header;
+
 	block_size = 1 << mbp->mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
 
@@ -269,6 +276,7 @@ main(
 	int		c;
 	bool		is_target_file;
 	uint32_t	magic;
+	void		*header;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = false;
@@ -321,15 +329,17 @@ main(
 
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
-		read_header(&mb, src_f);
+		header = &mb;
 		break;
 	default:
 		fatal("specified file is not a metadata dump\n");
 		break;
 	}
 
+	read_header(header, src_f);
+
 	if (mdrestore.show_info) {
-		show_info(&mb, argv[optind]);
+		show_info(header, argv[optind]);
 
 		if (argc - optind == 1)
 			exit(0);
@@ -340,7 +350,7 @@ main(
 	/* check and open target */
 	dst_fd = open_device(argv[optind], &is_target_file);
 
-	restore(src_f, dst_fd, is_target_file, &mb);
+	restore(header, src_f, dst_fd, is_target_file);
 
 	close(dst_fd);
 	if (src_f != stdin)
-- 
2.39.1

