Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C125C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBMEF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBMEF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:05:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286DFEC59
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:05:55 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iDvX009542;
        Mon, 13 Feb 2023 04:05:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TM+8mDqTJxnVOiWeER1ckheUMBC4W5kb+tu41Ake6/8=;
 b=vBIkTtiJ13tiOA+wIAp+xoNTmg+Bcitb5Urb97AfO8n2K1if9OHt1un6rtRPAdWTH1u8
 3h0rkNUjsxgpegCz3F6bQyS32l4OFGPYMCLSRFpJ4gYxTr8Vc+bQx849IRmQCuy3BF3Z
 BSClFHW6yb3H0XNUIBMTCSo+KgK8ZLh0+/txWnnuvaxYaG7zE+w5HzPV6PnAQrvvXFtU
 i9LJ/ozzc+wfh8YKh6fGUgFKSKRQlcAw39QUAMO3iqCa+xjdG8kkFkfmoIwDuaqZ51am
 C0bitJMjRLxdQk7TlpOToHx0arItd0AcPlyKWlNJcw6gpfkQM9UVTixN5JcEAglgFKUX Wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb1wrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D37K2Z028870;
        Mon, 13 Feb 2023 04:05:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jxh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:05:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMIq0e/m/5X3mmZWn97XnYFv6QbxZ9wkOLR2MsqneR6xVzmDqWvYtEtGB9h0sxUtSZFSY3K7+LiiGwx/MK1275VjpwBsBx3lFZMFzv+V1Tu8+DS6t+I8FzfUi3/bmxnCT99IwFA1qdH1XaP4k2btNW2gz6oxAIX+kmqsVP4FunzabeA2IljsTf+5VWpo1BhDbOvourloRu7Vn2nmMvlnfn+vyT/SlNOPLF6VBFXTh2mowlLqECFEDliq9IMYAX5Wcqgba590F6TRLYxBXhfzzvLQ0BIzUPPRTXhfdfY3s289umrkM4RiZQ+VOfsRa0Hud/ZTHpooQjJsXJbo8tUCHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TM+8mDqTJxnVOiWeER1ckheUMBC4W5kb+tu41Ake6/8=;
 b=kEQu5Mxk0IjFUdp0c8Ii7WDi8xLViOao8z3MQUtmNaVl3TDO7Dw1nPoud3qJCOR2HTufjPLf/jhAmkEdYTk9zAXqL9k23u4vNFvJJ8gU8HS9i/I/5kGKtdGarcmIlY6StRRShYE844ZVMDjAKKBfU1qQJSHYQz5UTWshtB9SPxpIVVVoRcfHatTYrihxGbimCaOHBTBofPNYOvplSDHLAd5fa3sBiw+4LCd5jF97lhp3qq9CBOsMB0BRwczhy0GBk0fdKps6BeiQoMIngb347jx8+ozMReEJjye6V7j7z7q6y9DygvY2wo0MElV+46n3589ikSAUGOovOD+wua1Bvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM+8mDqTJxnVOiWeER1ckheUMBC4W5kb+tu41Ake6/8=;
 b=Lf1HAg6Rj1pSOwQ3zpDXcPMe5ZXV5g9PvYhDhRkF+sXbIOiy1WXMIu3GC4mZUOOjpLPsgxXy7r9difAcpQH8nXTj5p93WhaDO1xmTh+Tt6GwPOiukNMUVJDGAEuX/HOn361wt4NAhtdRsMoMvu35t5BKA+DiPKdbct91JBCnzTU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:05:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:05:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 07/25] xfs: turn dfp_intent into a xfs_log_item
Date:   Mon, 13 Feb 2023 09:34:27 +0530
Message-Id: <20230213040445.192946-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 198844ff-31e7-49d6-65d2-08db0d7796aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjbZIsUajvm1MkD1kXzJYb73XN5ERdRnYSb++ODIaOuEBuYPq0cF45hAppzMyWs3Hv6lg1Ae3CauV7WEk2bRUqwcdFy2oI+ocrfq2pjetGvf7/zt30ogp47HQS9JSkl6YrimEbLtiET4aVk4h1Tbns9hVnKd43JIExfEDi/wionf4OoO8DvoDctj8uu7FCXUss0+aBVmy3PGUOA9Wje9Fhjpg7SWZMX4Zjh8b05hznQeDuJ4ATUlMoboNRynI68Esrstc8O1KWcel64N7tE2x+oAJglEw8S4Sw9JqDO5V2vbqVv/ZAVDnzCVSFZ2jh+8FBxtG9mZqBv/FPXBulstgErDVYd9S8z83tRfcPMB/DcKQaHV0OUr1ymFdLFZdlsuTv/Us3Ohsrtj8rrwLZfwu/L6EMBg1mKiOiutLfIgqJYgKnmEFgu9Z9XS2DjLNhVQMBZSk+nR5KQEvMrZ5BV4YAxbUl5D0R1PaPYjQ3HtHmUYV34OAV+xpQIVBDGVFMp2jTEf8gZAlO4oaQ3FeVq5aPyKIFGUkqs6DoDdTMK33nkwSgBNxI9zVxDXyqwbCAsS8GYhyo1KvYUnpObusbBOiQgVblnCH65fJAIhUzP0wv17JkZUINUaQArW3a/DC3mflFGoJ3y2WOOU2QOwh/1a/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/HTaCginnSgCb7qo2uk9+/cJSOOtmX+4Wc5zGlBowdaOlQN4KV5m1gvUVLQ/?=
 =?us-ascii?Q?6fv1mclPObpq0IND4eyFUjmDrI93JoFqhw2U1/E0b+J2NBj8bPBjq0TnJN4g?=
 =?us-ascii?Q?F/yuJgNJnZscL1TvV/1upjuySyoWhFSboduldxYwfT3dn8CIPhNw6/ohfdDt?=
 =?us-ascii?Q?1GTUrhtWQ4L9KhTlwJQTpZUp/M10vtQIJCRn1UJI9XbMw3GsmnB76yO/9CYt?=
 =?us-ascii?Q?bB0GDonGg4bQLA94A/Lyast1YQi8ddHO7ZAsTCuudTWO1DcRIFO17xyD+hrm?=
 =?us-ascii?Q?FKDzKM4DLOHITG6nOi/YgOuQ5cAtqudgIs3NX2cDxYBGP28KyvtaVGVAMPv1?=
 =?us-ascii?Q?ATiK6rZmrE0joNli0rMWlZId2V1Z7BgaYuPh4Aq0STLbwJopMSBFndM294JM?=
 =?us-ascii?Q?n5SnRc+IGZKa/i0yP9+LBle+qlMbyTA0+2+DT/BXRbRZRIp8PQhVAFXcp+PP?=
 =?us-ascii?Q?+izuNWw2/ECVp7cj1x8R8ve/DMLjcCeUSrjNiNp9CA6L4Gj10lIwB+sTT7nt?=
 =?us-ascii?Q?YKZ+Fkj8pwEClFZWpsnPbyGrObwhsT/xURA9BnDKJkbydNwQfLzec+pT2x2r?=
 =?us-ascii?Q?gD3Y0Ou2csfRYTz/nSdnUuULhVvnF+aDdktbNTgwuU+nIwbAAwZvw86gJAe+?=
 =?us-ascii?Q?HuR/VoK1fNOLRIKNGdYQVTmYtuSQWjwf87/ss3x96N5xVDNfwmA19n1cBcnA?=
 =?us-ascii?Q?L/rrgj29IKWNy0fWqD2YEVMdPPFWPsSeLSV+8Ygd70uL4jfvhPSdXblFP9yO?=
 =?us-ascii?Q?z4OTS2FbnMUAG17OmASGGbMsiNrEJKNZgWodymqmkFlZsERDa1UbEjtZxeBy?=
 =?us-ascii?Q?mlpaaZNAkqSD0oGNT8pI4Liv2nUh0VAXbi/GnU/oijGexW7jGvWq9szADP/Z?=
 =?us-ascii?Q?+zIKySCiW7nralmaI18jm5dtkQMG5Rkm/A5Z4gJHuyO6xFOsCdlQnQF3MSVy?=
 =?us-ascii?Q?1olPyLyr9WJF0Z4KFbBLYMiospSZ69kbq4OAxJ7GLTtwO8mPiyV7dLdy6dU5?=
 =?us-ascii?Q?OfIyVnLM0YC2sErjvs6tT8kRbpGMPslGdzU6qUdm62htUipKnjzB+3AyPe0z?=
 =?us-ascii?Q?A/hwTqpRXGhMvBWr24l8OLWNE3e7cosprEwVmCzTnvyaHaMmi0kjii5nyjLd?=
 =?us-ascii?Q?3vkAL9ukb7mfPamaQzsCILScZuJeguGmMYLwgsFAEv37XJVHfaxZ4IFYkmBh?=
 =?us-ascii?Q?6IppwSu3bpzlYu9xkv/Uf9sHKfY5+C6m0YvqqbklKNyudF3HD8BsMqW7TWRa?=
 =?us-ascii?Q?KVrbvO998piIIQ7IXdla8AipJib6g6upvnV69eh8kngzcYhbRFq1xHaf+dxQ?=
 =?us-ascii?Q?eansgcnG/NcrYGErHBh3d2qvfadISdxZkWqPxbrIo/CQqhVgtMraQMwh5jKn?=
 =?us-ascii?Q?RaO4RVBUoc/kvCawiWPGdHnoja1hKvDYo7Lf+kdGqj8/F0JIIjW91Jr1fxyK?=
 =?us-ascii?Q?HaYIP/25D9jJC2+igfY6YZ07WXE4xdOP9r02ArzeE2CrTzNO31LWYVYnDhKE?=
 =?us-ascii?Q?8BbWiYe/IcNo66Mb/Pt1RAIpo6kHkSO2JgxoStdV+0M5dB1wW0sa1JnWOTrY?=
 =?us-ascii?Q?roFBL1PeBbgakvFneuENJ6T+Vkug8Cqz2G0NMhqd3JPO07AKMtAmyd4rCI0A?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QXSeWXR1CZu7FEb52AKDuPaA0IYUjYbB9irXlZHSXJ2xKvq8sTsDeW9J7K/zfRjHNP+pea1Yw3PipUjEzFpgs7BcX0Xu9YoImbf234dJC40lc5bqJtxeH9Rz5/cOb1ta0/6OWDVYF5G2f+KuRY+XHGnvIJ4hyanIo7q116MKyhfwLlcLLbXFFaAr8vfCECIHWSUoE17FL2J4QhOczewpqVqPdB+lf3426PvRTNGHwfNrdv6yMx4OSjA2RpaJwQrPu6+h3bujRP0OyDqVau9tdmUTm1rNuM+AnXgKn1ABnemvCLsIKwXJLZLYk7A4Cai+qPXe70hOjZTOkyNy08dUkgw80LeqGp6+zxnSeUa2VQLSFCQJJrECtOiSVj+q8WqZVbFnM7lm4eGFpUHJNaKLURL8ZAMYMp0yBIBJlrik4xEhxGHGYXb65ff2xg4TKkGkmZsNOMaRJMqfXx4+q8MvktYS0Qj9v0EN7TxMEbqj/aZ6vkMY1Ux1fHTy1z8hNBtZZiGf0xFARUya4a6XH3VUjMf0EdfhV8vWd+0sxcsBRkhbrueK6e453K0ITr766nAIaFTPpbc5w+8E+q8asS3Ruy5g8Hxi0Wg+PGlnKdROW7MhR3mqGHUliKilMXGAIzj1IsddZgBc96bT0YBpSsl6PBmQEtInnCYK07mwCJQgMjTQdoPLAKqhXuefwqHJx5etkGXCLDaGJb+R186K1DyeiZTgtWYGL64Cm7XdxbF5oFY6oXTwbr/rl+nj7h1DBztVBsLIOLh7uFjmFjptABFLBTCJmcdUPdU/F9QtKuXk8LQTSE/4Ytp0QJdurhvqwUFH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198844ff-31e7-49d6-65d2-08db0d7796aa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:05:48.6024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/W6sGnKVShh5tNpFmM6j3tjjnHOUvqyZ/STjEudCOfLilbtxg/vuSJMZ2zH6suPMBqCTrY2FpAcd+4GOPIkAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-ORIG-GUID: VU0dDex3RkFcmT1uokS4-exdWvk9GQqC
X-Proofpoint-GUID: VU0dDex3RkFcmT1uokS4-exdWvk9GQqC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 13a8333339072b8654c1d2c75550ee9f41ee15de upstream.

All defer op instance place their own extension of the log item into
the dfp_intent field.  Replace that with a xfs_log_item to improve type
safety and make the code easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.h  | 11 ++++++-----
 fs/xfs/xfs_bmap_item.c     | 12 ++++++------
 fs/xfs/xfs_extfree_item.c  | 12 ++++++------
 fs/xfs/xfs_refcount_item.c | 12 ++++++------
 fs/xfs/xfs_rmap_item.c     | 12 ++++++------
 5 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 660f5c3821d6..7b6cc3808a91 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -28,7 +28,7 @@ enum xfs_defer_ops_type {
 struct xfs_defer_pending {
 	struct list_head		dfp_list;	/* pending items */
 	struct list_head		dfp_work;	/* work items */
-	void				*dfp_intent;	/* log intent item */
+	struct xfs_log_item		*dfp_intent;	/* log intent item */
 	void				*dfp_done;	/* log done item */
 	unsigned int			dfp_count;	/* # extent items */
 	enum xfs_defer_ops_type		dfp_type;
@@ -43,14 +43,15 @@ void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
 /* Description of a deferred type. */
 struct xfs_defer_op_type {
-	void (*abort_intent)(void *);
-	void *(*create_done)(struct xfs_trans *, void *, unsigned int);
+	struct xfs_log_item *(*create_intent)(struct xfs_trans *tp,
+			struct list_head *items, unsigned int count, bool sort);
+	void (*abort_intent)(struct xfs_log_item *intent);
+	void *(*create_done)(struct xfs_trans *tp, struct xfs_log_item *intent,
+			unsigned int count);
 	int (*finish_item)(struct xfs_trans *, struct list_head *, void *,
 			void **);
 	void (*finish_cleanup)(struct xfs_trans *, void *, int);
 	void (*cancel_item)(struct list_head *);
-	void *(*create_intent)(struct xfs_trans *tp, struct list_head *items,
-			unsigned int count, bool sort);
 	unsigned int		max_items;
 };
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index f1d1fee01198..f4d5c5d661ea 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -330,7 +330,7 @@ xfs_bmap_update_log_item(
 			bmap->bi_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_bmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -348,17 +348,17 @@ xfs_bmap_update_create_intent(
 		list_sort(mp, items, xfs_bmap_update_diff_items);
 	list_for_each_entry(bmap, items, bi_list)
 		xfs_bmap_update_log_item(tp, buip, bmap);
-	return buip;
+	return &buip->bui_item;
 }
 
 /* Get an BUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_bmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_bud(tp, intent);
+	return xfs_trans_get_bud(tp, BUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -394,9 +394,9 @@ xfs_bmap_update_finish_item(
 /* Abort all pending BUIs. */
 STATIC void
 xfs_bmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_bui_release(intent);
+	xfs_bui_release(BUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6667344eda9d..a9316fdb3bb4 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -437,7 +437,7 @@ xfs_extent_free_log_item(
 	extp->ext_len = free->xefi_blockcount;
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_extent_free_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -455,17 +455,17 @@ xfs_extent_free_create_intent(
 		list_sort(mp, items, xfs_extent_free_diff_items);
 	list_for_each_entry(free, items, xefi_list)
 		xfs_extent_free_log_item(tp, efip, free);
-	return efip;
+	return &efip->efi_item;
 }
 
 /* Get an EFD so we can process all the free extents. */
 STATIC void *
 xfs_extent_free_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_efd(tp, intent, count);
+	return xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 }
 
 /* Process a free extent. */
@@ -491,9 +491,9 @@ xfs_extent_free_finish_item(
 /* Abort all pending EFIs. */
 STATIC void
 xfs_extent_free_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_efi_release(intent);
+	xfs_efi_release(EFI_ITEM(intent));
 }
 
 /* Cancel a free extent. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2941b9379843..a8d6864d58e6 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -329,7 +329,7 @@ xfs_refcount_update_log_item(
 	xfs_trans_set_refcount_flags(ext, refc->ri_type);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_refcount_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -347,17 +347,17 @@ xfs_refcount_update_create_intent(
 		list_sort(mp, items, xfs_refcount_update_diff_items);
 	list_for_each_entry(refc, items, ri_list)
 		xfs_refcount_update_log_item(tp, cuip, refc);
-	return cuip;
+	return &cuip->cui_item;
 }
 
 /* Get an CUD so we can process all the deferred refcount updates. */
 STATIC void *
 xfs_refcount_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_cud(tp, intent);
+	return xfs_trans_get_cud(tp, CUI_ITEM(intent));
 }
 
 /* Process a deferred refcount update. */
@@ -407,9 +407,9 @@ xfs_refcount_update_finish_cleanup(
 /* Abort all pending CUIs. */
 STATIC void
 xfs_refcount_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item		*intent)
 {
-	xfs_cui_release(intent);
+	xfs_cui_release(CUI_ITEM(intent));
 }
 
 /* Cancel a deferred refcount update. */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 2867bb6d17be..70d58557d779 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -381,7 +381,7 @@ xfs_rmap_update_log_item(
 			rmap->ri_bmap.br_state);
 }
 
-STATIC void *
+static struct xfs_log_item *
 xfs_rmap_update_create_intent(
 	struct xfs_trans		*tp,
 	struct list_head		*items,
@@ -399,17 +399,17 @@ xfs_rmap_update_create_intent(
 		list_sort(mp, items, xfs_rmap_update_diff_items);
 	list_for_each_entry(rmap, items, ri_list)
 		xfs_rmap_update_log_item(tp, ruip, rmap);
-	return ruip;
+	return &ruip->rui_item;
 }
 
 /* Get an RUD so we can process all the deferred rmap updates. */
 STATIC void *
 xfs_rmap_update_create_done(
 	struct xfs_trans		*tp,
-	void				*intent,
+	struct xfs_log_item		*intent,
 	unsigned int			count)
 {
-	return xfs_trans_get_rud(tp, intent);
+	return xfs_trans_get_rud(tp, RUI_ITEM(intent));
 }
 
 /* Process a deferred rmap update. */
@@ -451,9 +451,9 @@ xfs_rmap_update_finish_cleanup(
 /* Abort all pending RUIs. */
 STATIC void
 xfs_rmap_update_abort_intent(
-	void				*intent)
+	struct xfs_log_item	*intent)
 {
-	xfs_rui_release(intent);
+	xfs_rui_release(RUI_ITEM(intent));
 }
 
 /* Cancel a deferred rmap update. */
-- 
2.35.1

