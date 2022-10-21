Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FC7FA3740
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJUWaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJUWaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:30:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4483188597
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:30:06 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDerK019113
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=02liA0DcMJkW1MA6MIejOYiG2l7yxVNZwErzdgLqLBs=;
 b=Yaf9sHMUi+wWv452b+k62fL+BvqRt8oUv27Fv4am5/Raft0Ch9JuHBkYXBf30n3S6Z9+
 WnoVN+iydc6kyXddQ1Tv/bc5rQIZk50Vxi9z5zRXvzwvrnTgA1PzoZEeh9vzeCyTddXy
 p1Yk5sRbZFp6SAAC4wuiwj7NvFZVIR/Ch1qacrkIBGbsTbbp0ekWj5iBLWbYYsMJ7gFY
 fzHO/CMJYHPvvDQrF7tkF5zlFJE2Z2QjNqkeq3jGOfdLFOWdvTk2VQLd4bNolzJbzxAk
 fAX0e8aHApXGLqfr0nJ6zl2hn4FSQyq/J8T8Cv6aBI8EjveGk+CGZhooLsAzmsJdKJro zQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9b7swa1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLUmG9018333
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0uc7wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:30:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCnfIde1NoI7RlK7h1sQx8iQ9/vNMAXi/U0epXZSgvNLvy46/BD7AuVP33L757UVPC77fv/E6wseJwXB1v+XNz6niD5GgAha6BG5xW4uXKo3qs5QB0a5+7nCPmvRG7ibgJWOJDCLif4jt2v6tCaQ29ptgnPK8+7n5hHq5cpUgteqgF2OvYp5bHyfr22SR8plZ8/4Qah5ob69PTXXgX92sMbygWY/tYGupxFct9TFvjdfZ24mzhGsXoIrrNJis1vNVm/tZ6lfjKIWAmYWdYcEHTGMTbJDG3qT4cMxW+MsWXCAAEQj1frfIyI3Nu00G+NNxSIzXhZNAfymfO1EkCJ4/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02liA0DcMJkW1MA6MIejOYiG2l7yxVNZwErzdgLqLBs=;
 b=HsgCgNWLsmT5EQD7eoufBGcIYBMebwDp7dcMSElymN14/DsGV+SRWd/4U00LbigrEXhgJ3cZZjAR3iPQUSMJkDG4xqtXGYUAx4m7QI60zWPrq9bVO6TjWA+5ewXwOF+Gkfvj/SXFcV5GsoIsGAnHPlcvmjUVzVY78GUIQU5L+BhBh2fzwT7ry+UT6EIcRvv+JkWMbVJFoxkjWFRZEYoBSH08ELqpxfWkpV1bAIC34amqOcp8BqTN1Qdv7zGn9Whd4fKqLKr2w+jX/+JAJU4ZjQx0sPtenCm0gzx6piamPtqkAEPN8WR7oSHpY/XzxHeC13IxO/TgWH/rwjlZ4xisng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02liA0DcMJkW1MA6MIejOYiG2l7yxVNZwErzdgLqLBs=;
 b=OuKB0SHRzJxksxdj+tIhuP82Ujc6Ro8+TpHesPeVQuss0Zhfnhx9tXaXO6qjPYTks8K1GMnSvwohRGgDLugMpLLZlbJ0erjjjJDEsejJqxxpeA0Kzuur4bdAXTGz5Kf6052OTO43yPpFHYkivMjZetz3vcKhx+3rjDtnRjAl0RU=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DS7PR10MB5213.namprd10.prod.outlook.com (2603:10b6:5:3aa::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Fri, 21 Oct
 2022 22:30:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:30:03 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 16/27] xfs: add parent attributes to link
Date:   Fri, 21 Oct 2022 15:29:25 -0700
Message-Id: <20221021222936.934426-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|DS7PR10MB5213:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f04278-8f85-40a9-2fb6-08dab3b3cbd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PGSYbDF+NJuZ/Flejxa0tP9Tf2ehq9hp3mAl5rZg6GMi8IbpEGLvWoJOIz+N8UmoK7PqJzZk/48U5gh52HKHUlGQOuQTsKUQyCoKpsnoEsO04ZzyNaC0qnB7KHhP3m91V7rCbF3GFCic9crEwsjpLbKJfAITfJqppU60XRRe5Lb15qs31r+q6zR0oIo4MSB4BgGQ87BcpoDRYKHjCgN7LOijzSY//cBHWkJge9JhwSvEtY6fUDvfVbkfQSZRiSZ48XWWH2ZVQ+N8NbV9sh8ZPA0YxDMeq8IY8q4ssmxFJOOrh4SWaNXwXraRg6q7/R3yeqGp7Lbn3yjNMECH/Yd5yX3Mijg66Bjmidx4ZwCrlGTy6YhTd/JcvXRYeui/5CiakJJdpC3rEKNt4KxGtEHDPm+nqly0CUjIIDK8e2MRKSjxSMfivDNBCRzPaBlv5yQKP9xB7nwNqdpIouKdBnwzSSzSw2k72wp4cgcjfjzCNqCupDvfpUxB7lt5VrCwLpvxI2c9wWJIHG3b4u/Iw3ZOaHQIsRGLxcZlC3tPrdsyPYGt69JCvyEhGcqMID2CAUtwz3LtmpulIKr0kQ7Y+MDnj7eqK1PRqy6LpbTnaFNEXHn4PO4ot8yx/xwkSFy++Zz/1UjonkhsSjN6xJFGmymjsR3Z+w1DIfajb87IonFGmjbii/coQRW7YCJtMiJRnRGhvs0TLA70tzHa3gRXtWicBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(8676002)(6916009)(66946007)(316002)(2906002)(66476007)(8936002)(36756003)(41300700001)(6506007)(6666004)(6486002)(38100700002)(1076003)(186003)(9686003)(6512007)(26005)(2616005)(83380400001)(86362001)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?te5UEWr65G85GSfEV+IZ+i/7OUXh624iJmBf3RN/jvsXnCluq2dy8Sjif3Ha?=
 =?us-ascii?Q?Qax+aiGnxa2C0JnyMoU3iiPOzXY6f7VXPRAHcdljCs6vlaOAZInU2cswpo4h?=
 =?us-ascii?Q?IykFDrCsS2o2BGQI2j1HfNfzxizGmpgbDBvv4tS4jdH4eSlE9AbHrPLeikqO?=
 =?us-ascii?Q?OJYnfCAdtqgn7T5RIYUmyfzPXa9id+uhdnSvjN13G7BTlrZLn+D47kP3VZAu?=
 =?us-ascii?Q?LOiblEs8iYTLwJyZkZl49UTAC8B6wxqVwJ1lAoT2p1SW2Af2ML30CQw2G24B?=
 =?us-ascii?Q?Oho7gFHQWHaJHdLqC7KqgVl28AxLNXwak6zdiP2FHtXo5jKCrk6RFya/BwMm?=
 =?us-ascii?Q?jwIrDNtbFRNNeinRk196l9TtzZlyhodH/+/l8S6OR1/K0trIxtnXxpCz1JZZ?=
 =?us-ascii?Q?PsIGdchMSveyy4SgHmPkHVKQvxpmgzZvoFuF04BOjhrCzrClQzV6IDexx5lm?=
 =?us-ascii?Q?er4fWB8JrSMnwOrbDEzoL6v1QC8Hh7xAwpikFnB87Bwza50WoKI1XXJveUEX?=
 =?us-ascii?Q?1+decXFWatdxSk1MO6KLPbDpljC0m4wRAz0kpwgDDHzG2cXqPyVtecX0xgd/?=
 =?us-ascii?Q?M4RakmTQwuCJYo2Bv2wn7Du29rIHqyK/mUuQKCRVqPCWRQ/zef4wJmiblTD+?=
 =?us-ascii?Q?Mfhsi1bfu0bensbFEItmR6mWWViAJgGo/oUQg6710m5+sHj1bd9hAFu7iGFc?=
 =?us-ascii?Q?UZ02Bh4+9CsFM7V5ENQ180uVhV14ZJICYgct15wnftfJfRV70odHl5TtdsOS?=
 =?us-ascii?Q?hkuaYhhGHWTiBe24E6vU8SKLxF4RZ97ENXu1+VUmIq1ffO61SMwLCdVbZhoC?=
 =?us-ascii?Q?LuLJNXosBib6bM82a5rRvD7ImnMdhdrh5vuuqA+BDCMhaxlQlNjzyzJC30lv?=
 =?us-ascii?Q?9E2KNI2K363c8q1IO6kihCV8megCc+lUagQxypzUom6E7gLi32EybUjwcOuS?=
 =?us-ascii?Q?6s5aRV8ADt9rt/GHJIgkiT8SIX3npuqdN8Aj+6BUdydC+NDveQZIb5nj5WPX?=
 =?us-ascii?Q?5dasxX1X9tkh1isnSbNpy/7JvLO8dBAd4+FmtK8kkJmxPjrDkLMKQgMppSwd?=
 =?us-ascii?Q?d1h9nrXotwaWzON5H7pt/OKKCNDDjhxFkBug1OmmwOqOpJzfPl23iWq9VJGj?=
 =?us-ascii?Q?7/c4ZhCVonui4WWxM+RAXPV2YuSEBKdK5pgBIqGdDf3kVXgEQBN+/4z5uMt4?=
 =?us-ascii?Q?MnFpzVqzFhrplxRGhoukOkula6wHI2VfNzpFLEQNtFxackZDBBEn8YuYlQOi?=
 =?us-ascii?Q?aVYa2MUn6MQQ+MUNBxkDt/zijUOelpkDUHxmNp8n4is7uiEDyWalzNtHi5QI?=
 =?us-ascii?Q?3Y3wDXLmdB0c/TIesEgOpLtwJlhPVklQ7gqCUqoNZQUDb8umXOpfLyolu45T?=
 =?us-ascii?Q?h1vNjSlmMwXEGrCfger8qrsodxxdyo0BbSIed+o/+5jP7A10yBY4sRmWY+8W?=
 =?us-ascii?Q?wZ0K8cPbk6iWR40fQjL1A+JMRrygaK/lZEzfa7DvdLk+d6r7fNZbgkH9DeME?=
 =?us-ascii?Q?xiO5GxReo4hiSbbQxe/gTwW4K61pirxj3YwdFcFYzNdqQn+Bz0Qh2YT7VNb1?=
 =?us-ascii?Q?gybsWQU4HAh7eVyBsLSZ86IexYDPioUGW3ugvq1QCXRe9eHCJrjfhS8WWm7r?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f04278-8f85-40a9-2fb6-08dab3b3cbd2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:30:02.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltRH3gFbPZ2uAV+fseBYjw2XtS2ryO0bFAbKA4i5M24f9UDecgJXmjpXAICNldCAC5usXn7Gw19d78mcRTFkrsTrsUMPPiqPSMJVzZHgwug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: 6JoKf-L1WLGursRuzndw-IGujvbqeVjr
X-Proofpoint-ORIG-GUID: 6JoKf-L1WLGursRuzndw-IGujvbqeVjr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_inode.c | 60 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae6604f51ce8..f2e7da1befa4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1248,16 +1248,32 @@ xfs_create_tmpfile(
 	return error;
 }
 
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
 int
 xfs_link(
-	xfs_inode_t		*tdp,
-	xfs_inode_t		*sip,
+	struct xfs_inode	*tdp,
+	struct xfs_inode	*sip,
 	struct xfs_name		*target_name)
 {
-	xfs_mount_t		*mp = tdp->i_mount;
-	xfs_trans_t		*tp;
+	struct xfs_mount	*mp = tdp->i_mount;
+	struct xfs_trans	*tp;
 	int			error, nospace_error = 0;
 	int			resblks;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent = NULL;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1274,11 +1290,17 @@ xfs_link(
 	if (error)
 		goto std_return;
 
-	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
+	if (xfs_has_parent(mp)) {
+		error = xfs_parent_init(mp, &parent);
+		if (error)
+			goto std_return;
+	}
+
+	resblks = xfs_link_space_res(mp, target_name->len);
 	error = xfs_trans_alloc_dir(tdp, &M_RES(mp)->tr_link, sip, &resblks,
 			&tp, &nospace_error);
 	if (error)
-		goto std_return;
+		goto drop_incompat;
 
 	/*
 	 * If we are using project inheritance, we only allow hard link
@@ -1311,14 +1333,27 @@ xfs_link(
 	}
 
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   resblks, NULL);
+				   resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
 
+	/*
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * attribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, tdp, target_name,
+					     diroffset, sip);
+		if (error)
+			goto out_defer_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -1332,11 +1367,16 @@ xfs_link(
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
 	return error;
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(tp);
+error_return:
 	xfs_trans_cancel(tp);
 	xfs_iunlock(tdp, XFS_ILOCK_EXCL);
 	xfs_iunlock(sip, XFS_ILOCK_EXCL);
- std_return:
+drop_incompat:
+	if (parent)
+		xfs_parent_cancel(mp, parent);
+std_return:
 	if (error == -ENOSPC && nospace_error)
 		error = nospace_error;
 	return error;
-- 
2.25.1

