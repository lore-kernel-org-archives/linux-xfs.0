Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E96C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJXEzB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJXEzA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B3E252B9
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:54:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2eWiV025813;
        Mon, 24 Oct 2022 04:54:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BtL41UmmCbrKmstpTEYree2rE0fQJeZUcCqIRo47RXI=;
 b=EOgMDVv/By+kTaNN2CUt0WGF6/SMNLl8qmQDK0rvfNsh/kUq90VZ1N9ksPah1zcW8Agk
 zw1arBh6dwxRT4oXQuRobBhM7WuwUdHMZFCHPOSFDxPxwKoQIzHVw0jiN7O21iSdMRZ9
 2R5ZVX0BgvgI0+lHutRJYjt/QSEauG8hEdeMQuEbdAoXLAOrnavbl9+EHOs/zayB53aq
 NpE1FVINA9YHQz9kLtUoy10oyxco2rUDxzicc1B2xZ5zFc+HYEGMQS2TYZ62f71sCee+
 bFi/Q0azkoY3daw5oDOsykZs/NB5G8xWia2v97pdxuECOOsJ47hd+3NawBWpXi1BHvEy HQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc6xdtn4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O0mhI0040497;
        Mon, 24 Oct 2022 04:54:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y944yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ9T0TeKB2tp41Cu4M4H9vOrFNaFTyq/F9t+oC0wseMhU+pF3MjnYraOlhT8Yl5u3uWf7YPmqivBqgcdnFt3OwbYxx3XCqgFk10hoslZpXuu+t03uuGxASWR0Iqhg/UCEoPdhqhoS880GlQfGtLpyzMA28j4ilvfzAG01gOOJY+JtgfEliQTpTZY7n2z+Iaog4erZDt1GOJaMJsErjbmakctSsWHTz4lALux11wNEBsg+Wh5ICmq829mjkkojPwEMOmoy/pPlEhczgAh3D6YvgmnwjR4G/jP+b8l2b0idUiMdJfcDvPMhrTBSSgVgiCpuZZEm5SuPyXqCIGWDNmYNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtL41UmmCbrKmstpTEYree2rE0fQJeZUcCqIRo47RXI=;
 b=VYMWJ/iMM3DE2E6Ng2MOYRqL/bZFntcE5zE0+9MI2Fi1gYI8EXkLqALATnPsdih7/KF9WjH+GXSIHJ4xsrGrbuc71eaPbO+0z7zeqS7Dm3fueTjdX2zlgYjdinAu9I1OtzqW5g7ODGUWOWDYWME6yKqR/h3O0nLceHBw7fAZeynL1qgIOXvpdb4/IK21lh/zbOl4c5Ald7bfef6t69mfWnaGEJ6FKyaqCWhM1BUBgtKZRy+kRwHd1CS2V09RFy4JebmIdFg6ipCs1uwG1d3kw8SKj/yUNINeneEhWCgn4uCgvdSnugnv774XPjUF6Ma7EKbIIWahTV5sU2EGbQPBsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtL41UmmCbrKmstpTEYree2rE0fQJeZUcCqIRo47RXI=;
 b=Q5qBKwiPqcc0NHLJ7tpDJX0MeioDq5RjZukDZ3O7L6LPyeh1gXjtnzFCI5I4UhVAdn4SXFAwnyCq3HVHkaDGFg0efTqA/iQlqvbY9SHWQHaHVtsXeJnERi7YB/PjDfu9p+AFgK1y8Y6L4dfw2d2bNtkrAhIvcKievyZSn1k82Fg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:47 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:47 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 12/26] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Mon, 24 Oct 2022 10:23:00 +0530
Message-Id: <20221024045314.110453-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: d87c43d7-d9b0-4c76-d314-08dab57bdff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cf5qJY7lKGN9OHqrBErfNg/PeXC+M09C619jGZu5MTLpmWpYZnXuXILuveC9gpCDaAr+4taEO6fkplCIKbImMgAr5gVA7DZ9qyzhj7xBPubqZFrBaD9MTJUf//GVFAerzxulcJQKfRtWvbPwHI4pb27BAs88VQ75dLybgSHv9UJ9+fuYRST6TLNpx6759cnht0EtmeSEtrmrvW5YZ3jxplmRQ8X3LwQiCLbtvkyMPiFTjFUIKZgKJrQ+ECY++GwNYwEPuwfkyQf1HX4GMdjiZy9r0Vs5o6Guf0LBzUpAOAWAIFEcSoQmb3o6mRkEO82zG4EnCyb1u/SNHWnyOwjv37p8PcwpNXFk21n8JIpU98ZoQ8KV7JT9Fp+XmEemqW+cgZXv9xbN1G4II93/zvBqBxdLUIKgY7CaKrSUOEryJjiQJ19XBXH9M9mtxf2EMMbcV1El6npSmD+VU6y6rjdO2O8tuerqeaNv8vVfPPNTooiITIRoHZ+/ZvB6swb1wB5eAO7yS4Hkvtf8b6yjpeS6mjUTrR7D2qHtTNpcB0HmEZ60OX+mSk+2V6+LZgo7y7UPHveccq+d8LBDgUrjVJpyXld+MW2xwlBVFKiBiIiAcMmTW8f2y0ExF0EFv0A65GbNZfWSR/K/wu1PeEZNhgsjxSf8TZnEbdR04ztJe7Ix4twZ652/G23+5TqYq7/kRnsbe6McXA/XRPynXWPxKgmDYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9JY2vkiqH/tS8ypbZfhY/v3hnCBzh/cN4vfepbWyGzJVq2Q0jcd2ICLN9Vs2?=
 =?us-ascii?Q?GRkDP2jXU2J/84TtBdzSdbiB+D23Tt9E/jDbgVPDKLZm7XD1/ifRT7OCQ0PE?=
 =?us-ascii?Q?hZ+KNctlOSwH1XQkS8Y57VxpBd0DogJUFuC0tgEUpW9gEDx6AA1PggLKFNOQ?=
 =?us-ascii?Q?fVKvibtvw+lgFPuhyEd48jE2tILKNS6Up4QphiwPO+yPxZrcCqYMOZpZgZhS?=
 =?us-ascii?Q?xHMOtj9y54uQhRWr51ms+veUW/RrNxYuCsh2+DJiuqyhSTI+jkx4enzIzbDD?=
 =?us-ascii?Q?UUgLduJcGDfwAeKImKa0cObQk8P83hqnc17jrZZ31iuOcWmH09iktoh45q1E?=
 =?us-ascii?Q?yoBIqNN9Oo8IwGlMVxJ9G9Kuah9yNGHnXA1DmRss1gYbqegY12J2FHrbsB5B?=
 =?us-ascii?Q?jR/CWEZFAKg8yyIMBEcQKaJUydPjGvt5CfljpRcXSnsY/dKGbVxTe5IqekYa?=
 =?us-ascii?Q?bpxatlEOiwYvCsnXnHHH1pEW5avTZ7wcuTWKOVX3wQ8iaSdlirq54RBytU1Q?=
 =?us-ascii?Q?U0sxkuBJZq7M8uuTaQhmfw4T8cHxsynDIEZfjq+TDXOUK+CCU/m3ViBKYQBq?=
 =?us-ascii?Q?0ADZtMs02HNYKmJ4YHIrisu8JDdYoAJqbW3oLZvIM/9mV0SlcFLMG+fx9m4S?=
 =?us-ascii?Q?qIjYXCYiObRgCK3ZEFISHGjAZlgMPACyPkXZQKlmboma5VskMem657JH/9Pq?=
 =?us-ascii?Q?mm+bAMg3PUtDEWEfu7DAbf24BCpgPrvwlwQBwXUUrvrxguw8T1DHQ9jso2Rw?=
 =?us-ascii?Q?EQywzTZ7nn7hyhknhJF4TYgAJ+Sq9HyK1FL0Kibtyi7+2KV1sCPOcNjN+0jT?=
 =?us-ascii?Q?VQxOP0PXZfCLoG4jb+srvF7XNYq5CBKaQrILwQg7vmIv49SC4GNwI1ZBZYXw?=
 =?us-ascii?Q?irTuzgxfIWGpgjaHmPHqzGJ+nscMpqFzXFjEXSdu/Vb9iX67CeuMM9ljy5fu?=
 =?us-ascii?Q?rI9JiYPY8GSTxHkln57ey8QtZYQik+OIU3mDWZ0cOlYsKKc93tR8mJR4aTaP?=
 =?us-ascii?Q?T10DygIh3dJSEvRObnjvfcfywKo9bWmBq3oyyK9rm9ZTfZ7KwGFxm0nywcFc?=
 =?us-ascii?Q?2fFMR1DB+hNx8b/FUmyDWyfheawD2NWphahzf4c4lK9z/toYz3EV8xSG+xsT?=
 =?us-ascii?Q?UG5sgot70apDIO5tAdM7B1nHfpjd3ySqwgCE8YLERS/1G+mN4+WYsnAsyqUF?=
 =?us-ascii?Q?DgdlZpbPVzObVE78+9rhb5kfRlLCD/Sqc6EwTEIgCfpeZJC9t69BAcgDWPJH?=
 =?us-ascii?Q?0OEz/SFRrU9jrtfuDgOxuCv3ELaZiP09UJUUKv06bOdXwPLwPuMKwKNdCDQw?=
 =?us-ascii?Q?wRomjK8XwstWZhDLf7R7SOcnlrFvsUIjE0slspiWsBvku3UkEvTk1acYc62Q?=
 =?us-ascii?Q?2Ydei1P9bRtSuNJ5XNvToqLRBb2Ii3yIzKIBqvdJnl6Fo0+uIkYQMxD5oPmb?=
 =?us-ascii?Q?jgofagK82KhmpqQkdCUBnT1x68eSayrsYv50Mse2RWupsuysEteOD4QwVfwB?=
 =?us-ascii?Q?dJrpsuDhCmLgZVn6EqrcnouW63HKZFu4dXSOZzt/WJq6T3E+3/LF1sFmYpdV?=
 =?us-ascii?Q?RCSyS4sbz7dfX1hHTzXN05J9fGVMXu65+M5kQ5a1GCRzUQJJzDHUvIkYWUU5?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87c43d7-d9b0-4c76-d314-08dab57bdff3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:47.0186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hWGaFAJdmNz+BvmaG7jSKFzB5xB1NiLmO6aweQFwnzPa7dTh+PtehUm2PYAxJHf6BWdUgPT/FmC8QHnS4g2eig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-GUID: fsEVBYcuxLYV0_LYfZoZy9nyfH1ktG0q
X-Proofpoint-ORIG-GUID: fsEVBYcuxLYV0_LYfZoZy9nyfH1ktG0q
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit d0bdfb106907e4a3ef4f25f6d27e392abf41f3a0 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix a comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
 fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
 4 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f7e87b90c7e5..824073a839ac 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -800,7 +800,7 @@ xfs_calc_qm_dqalloc_reservation(
 
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  *    the superblock for the quota flags: sector size
  */
 STATIC uint
@@ -813,7 +813,7 @@ xfs_calc_qm_quotaoff_reservation(
 
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3a64a7fd3b8a..3bb19e556ade 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -12,24 +12,26 @@ struct xfs_mount;
 struct xfs_qoff_logitem;
 
 struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_log_item	qli_item;	/* common portion */
 	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
 };
 
-typedef struct xfs_qoff_logitem {
-	struct xfs_log_item	 qql_item;	/* common portion */
-	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
+struct xfs_qoff_logitem {
+	struct xfs_log_item	qql_item;	/* common portion */
+	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
 	unsigned int		qql_flags;
-} xfs_qoff_logitem_t;
+};
 
 
-extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
-extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
-					struct xfs_qoff_logitem *, uint);
-extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *, uint);
-extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *);
+void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
+struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+		struct xfs_qoff_logitem *start,
+		uint flags);
+struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *startqoff,
+		uint flags);
+void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *qlp);
 
 #endif	/* __XFS_DQUOT_ITEM_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..e685b9ae90b9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,12 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
+					struct xfs_qoff_logitem **qoffstartp,
+					uint flags);
+STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
+					struct xfs_qoff_logitem *startqoff,
+					uint flags);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
 {
-	xfs_trans_t	       *tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	*qoffstartp = NULL;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b6c8ee0dd39f..2a85c393cb71 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_qoff_logitem_t	*q;
+	struct xfs_qoff_logitem	*q;
 
 	ASSERT(tp != NULL);
 
@@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
  */
 void
 xfs_trans_log_quotaoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*qlp)
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*qlp)
 {
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
-- 
2.35.1

