Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37476C38A2D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 04:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJXEzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 00:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJXEzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 00:55:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31003580B9
        for <linux-xfs@vger.kernel.org>; Sun, 23 Oct 2022 21:55:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29O2WKqO031538;
        Mon, 24 Oct 2022 04:55:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gj9tCY4Y25cCXdTdSNsN09ENyJnw9ka8ECrbFFoD4OE=;
 b=aHDyjRVBPJ7EFM0hYThq+5KRspgd3JO9lhkFsF5qPhOxDrDa7aet5dCNs7XNWlKzAjmk
 F0KHPtHzGDScKghAH/xwIWWcmgpiJlHrW3upy6FAvMCSHGr8M3olzI1MvHcXSSKhkNZz
 GgbSpxkSAu2Ktn5j+8zKDsKBEqdqwsCccLb13/JMT7ng9J7en5OKIislvhXOH82Nu1Y4
 A1GOI7HrQqIUxUVFfn5k6p0ZlR+AomaE4ROQclvv1VsbBOw0jHjnjSpnK1fXtOwZ3ukW
 fNd5cSwtIPG0gNfAgIId1vu/7OblKXt5E5S9i2v25397dZYsOO++lzJ4aL/zYjqraCu8 uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbasak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:55:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29O00LKk003625;
        Mon, 24 Oct 2022 04:54:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y9bp8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 04:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtxswejG+ZdGLKSEs4SxuEXvn/TrjqhONOJBeu7fs3R52miUf/8p5YyKQ0RYtEodqfGjDNHlJ8R5h/kDEEnCaZmR4xPzQqWXDsbwMTj6D78FoJ35Csm0PQ2EdE11XnFyNCGFQ0OcHY8sJFrPfFDV/ruFLVVN8hWbJrxpv5vTnQVmAGO93rLKYLOxIZOPRkP5HJgCaLdevlCkY9ioLZDtov/zGUjmJAfFkNkdqQH5K1G2frNwbzWIoyF8HxP3F2NPsz0oCD0y29xF5h5nPQ16JAb6Vf8tbXPBlBDQk4QqunEYd/w12mb1RtZpbOrOu4EqLax8hq5t6cPZZ1goRRXWQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj9tCY4Y25cCXdTdSNsN09ENyJnw9ka8ECrbFFoD4OE=;
 b=VL9LAL+lwVt576tVZY2bjYxUz9T2GLqf2AIce1xXx7MLeBr05n0rLNAl4nmTGX+T5VNoRIUCuV1aGTeGez5OF+ybEVALLpABvSKMqmRRk6xItKf5X5LJWWw6vFfHdIPD2k3/icKVrDw9tU+42flcxvax2BI4SLG7TQM36jfVp+k41b+gltMIjpwyneAcMUIoZdx7lt+H2DtNFIDgP6YIdiK5sGcYtBEdqo2LGlefVlTfCeCzgb4lia1PPpXWI+/QLK+OV0EUIiIeRl9a0FGM3XtPGbE7VY8Yhm+yYb8jNf48N8SYmwUQFakBLcIquNUWEMHHr3FTKRfb4EVoQZowaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj9tCY4Y25cCXdTdSNsN09ENyJnw9ka8ECrbFFoD4OE=;
 b=az1bf03FB028WFMQEfI0ifLpxJ8/FXv78XP/s4AO+GqQj9aHGYFzB7d9oA7S1Uf8DWqfKloDHR4G3yVFZkHPvCTMAl2HJPScQ8JmChHivbB3MFv4GQLY9WANvEY+waT74GvlfgKkw32/4RkQkZc2U0NPvc78Ax9u7U5u3IpnDkU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5374.namprd10.prod.outlook.com (2603:10b6:5:3aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 04:54:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 04:54:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 11/26] xfs: remove the xfs_dq_logitem_t typedef
Date:   Mon, 24 Oct 2022 10:22:59 +0530
Message-Id: <20221024045314.110453-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221024045314.110453-1-chandan.babu@oracle.com>
References: <20221024045314.110453-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5374:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d366b98-150b-4a1d-2bb9-08dab57bdbfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ytaUD3QF6lfVwtMyAUAzYhVmNnrZHebFwGHtYnN2uow85OH6S8tPNLvGJ9ugKhYUL3pOEHap+sVr+aezhy4/jpVYhazuYW3/usQWJyyiBKMYzcOhXrUwgszpJUIBlGffa3MEcOL1HG8YJFnMSdcIKmO24yHdZAMaKVcQk4jDQ3HGxuKSyZcAIDyhRV/WEVN9H27iMQeDQjxQEOF6KvPtpA8twuaN/R1mVrceJl/Coz1rDeLjgxp5ZmpMs8+NBwd9rFxXREz5q2URZ+oCjc3OxarKA4kQ/ku9cEPli95t+nygaU1BZ6iOdo4JQCMFWUCU4STx4HarYtt2rMh0XJt41XCEPrbtLl7nQv02U3m2ER9bO+Mgx4O/hgfD6jbWnK9mJHs0h2621epfMHIUSZkgK1qrY7natMcQNV2dw9zo04RzqjFGwT+gHO3pjtqYaBOnGvptrLBLSl5R0Tn8KIurQ+6U537XVw/Ryo/BEyv7Boq0k+Fj18PywExX62wEiYKPT15g8YvpiuWCiArEpRFCyz5T/Nt7tWt6QwximXJeKzXJ76XUgdgSGJUg+Hbwylv8KZWANTaCn07jJL9PhhgtPB7na73w8XwCY8+Ufir16Tt72yPv1q88wwmH5tLKf7UiC5CdNWSpvPKyhFhz35ZrzwTVd86rH+cSiQ7yuV4q/xx8gs9lmEsnuHosyy/UqBaWVVvbNOOs/H81jm9i9NtDeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6916009)(83380400001)(2906002)(5660300002)(6512007)(26005)(6486002)(4326008)(8676002)(8936002)(86362001)(66556008)(66946007)(36756003)(66476007)(2616005)(316002)(1076003)(186003)(478600001)(38100700002)(6506007)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hw3k/nRKoUke+xGjSs8bpuC5rALAqvzIuTkqJkywxeLxfZkUfsAtZQRpurbl?=
 =?us-ascii?Q?JHO0X6FbfvCyR41SY6lKlkJ+VCA+JEGFnO1ExljF4D7lJDXUSsgFXdmPlCBc?=
 =?us-ascii?Q?8k7W21IoI0fNoSkL6diTLN5aEVRm+F5TeJFe2VwGPxtNXOjCh5Ul2ajfrhXR?=
 =?us-ascii?Q?8Fl/8rQjQ0wGwaKpYYMoauwd67Nr1PqROPmt0rqppnwock1j5Vufiys52Spd?=
 =?us-ascii?Q?RJBZAqsHvEglBlsv329AFhznex7cywgPqj3rR3+GPMqksEYdrU6MsQ0IoXNK?=
 =?us-ascii?Q?gIzADmgxbpyvkwbEwcunlmjoUWJ1spXj0k6ucBJ0XMbndBmOL9C9phZeW9ru?=
 =?us-ascii?Q?QIRWx8YDIfW9h/zEd/bBT0Bf2rBGmILGcd2KxuAvqPX3W/nXdQt9vzGU+ICw?=
 =?us-ascii?Q?WlyCHHUqAyGbozdOsaTBBgRK/uxN39loFUpFCrVVAymjvQuuGqAOq/+2v2fI?=
 =?us-ascii?Q?FKOABpVvPC6+mUPeSM6/KnC/mDc/j23xMN8jee7/li/wsCnBQV1rUH3yOHYj?=
 =?us-ascii?Q?387MD44P+enHatGeJ37MnhCS0jAl51JY8WrjxwUVT2UsE5dxi5MRoXG2x//t?=
 =?us-ascii?Q?9URQtFFQATAkdJ3MEKhKf1W0vIOYsUndawEXhZWhElrgRXXhueOPWcBM5Qks?=
 =?us-ascii?Q?ix9CKa3A/PdqPCpol1agG2ZWyBfZ8zZrnLPJGQz7vsR0hGoklid+vv4FCtIH?=
 =?us-ascii?Q?uY/Rz+wEIJ2mWJCvjFvmKvThmfLJ81LE5hBpsvxddMegVcHnFyQB3F6LPxxX?=
 =?us-ascii?Q?wz6GAfw8OZR6iS1+IZidHtZ/jia9oY3Tg5ZVxE4nBjsErXegl5AU+3U0nuJF?=
 =?us-ascii?Q?Q+eE0g1G6rYOQkCuh65ggBvNrtc4oBbj0xN0KxGbUvNFfHhyuccUJlarPuUC?=
 =?us-ascii?Q?MLk4bNlRbybYWxdM1li5yAQkd9txAkU0Td0KVXQiB7NMfaePEe199YyvdsR6?=
 =?us-ascii?Q?l1BtB0/d4z8Rt2jZxW/yODdSLg6banfOgOdxMN+/SD0y6hyx7T/qwU91DMdr?=
 =?us-ascii?Q?iqQPvF/SV/+Ko3aUZ4ghMes5IsxPTgbqS6154cVYxEcZLQkPWjhrezzZL+Jb?=
 =?us-ascii?Q?SlI6ItESqBajHpUNyImM7SDAGvIV9C/aFP6irmgYCbe7hBYyJwcLkLNs/HnG?=
 =?us-ascii?Q?xA5JlZa5TrXVcbXJSWQsC7SMtA4tuZC/eaVLV8GX8fSs30EPeHxMvveo014l?=
 =?us-ascii?Q?3WVxfKg3gSpzwdEFqJnKNdSVzsUTbA1hevRpSj7CexORQmbAR6nRRQR0rvuK?=
 =?us-ascii?Q?nTQ/M77WaMDdNiKeRzv7UGvb2VaeZsEk0dN0ErG29pAz6Gy6Ca+sX0oPNjX6?=
 =?us-ascii?Q?7ZcWUj6dNEtRC5cbciFt8bRm8ZPlzHDme7KwrrftgzPIhPONZZF4qgVuPzxW?=
 =?us-ascii?Q?X+OoJRN+Qes8Av/yLiofDqt/Szs48fQygahrdr+7cMc3iQmIvo9QqAMHkPlp?=
 =?us-ascii?Q?9DYq2LyAB/Z1xEiuofXEmA87sxX25XdL4z6nZO8eCmNeGCkbYsskNn08PKyZ?=
 =?us-ascii?Q?QA2lEK5rmUKRr0CznzFlzpXI0piPfb2PRLP7VGzz4t8JSPJ04ZnX6WQX0mTQ?=
 =?us-ascii?Q?ukNvr5l1eqlaZDSoxElgI7nddFN6wUbpQR6rr+hVedLvyY8DQOrEsT8lnYOe?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d366b98-150b-4a1d-2bb9-08dab57bdbfc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 04:54:40.5343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TljFprDO/wsd697eHhXptrUhtb7mQIu39t3V71eyC8l+E5LJDGBCiSBS5IuSe7fUbr4iwNqB55J6u5b5lPsF3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5374
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-23_02,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210240031
X-Proofpoint-ORIG-GUID: mm6kkvuLP7LbxKG6uOQuLBnOr3QSYWI4
X-Proofpoint-GUID: mm6kkvuLP7LbxKG6uOQuLBnOr3QSYWI4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit fd8b81dbbb23d4a3508cfac83256b4f5e770941c upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot.h      |  2 +-
 fs/xfs/xfs_dquot_item.h | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 193a7d3353f4..55c73f012762 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1018,7 +1018,7 @@ xfs_qm_dqflush_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
+	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 831e4270cf65..fe3e46df604b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -40,7 +40,7 @@ struct xfs_dquot {
 	xfs_fileoff_t		q_fileoffset;
 
 	struct xfs_disk_dquot	q_core;
-	xfs_dq_logitem_t	q_logitem;
+	struct xfs_dq_logitem	q_logitem;
 	/* total regular nblks used+reserved */
 	xfs_qcnt_t		q_res_bcount;
 	/* total inos allocd+reserved */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 1aed34ccdabc..3a64a7fd3b8a 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -11,11 +11,11 @@ struct xfs_trans;
 struct xfs_mount;
 struct xfs_qoff_logitem;
 
-typedef struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	   /* common portion */
-	struct xfs_dquot	*qli_dquot;	   /* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	   /* lsn at last flush */
-} xfs_dq_logitem_t;
+struct xfs_dq_logitem {
+	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
+	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+};
 
 typedef struct xfs_qoff_logitem {
 	struct xfs_log_item	 qql_item;	/* common portion */
-- 
2.35.1

