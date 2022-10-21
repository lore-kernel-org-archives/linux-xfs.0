Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB97CC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Oct 2022 22:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJUWaB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Oct 2022 18:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiJUW34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2022 18:29:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B045073C
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 15:29:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDrSQ001722
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=jKpkrJ9Ypdfryg5+772K/UtRosEZLXjzEljOs+wNL+4=;
 b=OFRa9TqT382NquGFlxgDJ8poNgta61h6nAiAdsuQeZCx6IMg0Io/OVsI+2z/J9YtLiOH
 1Ti1dBWGqXIKpuCXFcGRAIqDAKYMnR+NHO3zE9UQEmaBzOLn3bwctcHOJ7Fp/RyjpHE+
 vl+tcHAjujK2gK51QOlwrxi+KsZSVEDNWauoKN/YB8kknhBAr+g8jcKT8z1/xsPc0Vwi
 RKGedrDaQEWDcdB03zr6MX/c1l2bjmuuTbQ930oAwoWwGMFyHxdQRIGe2VpmApFxJvUF
 DJvio+8ePla04Yps6Cx+WlZe6F8kpwYE1vqsOd5ldv+/1HXKW16nRdURRjT6coJdYT9X vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9awwdjnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLPxnj016974
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hub8j97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2022 22:29:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkgqPNLfPD6YvfcVHxDN6iG0eUgg+QRIY0qDOYX3T2Syb3iYplvw+crYzvHjNs5lT8dbwhwOYhuGdNZKOoJ60xsJ2NanF3a+mgh7gqu5GvRww9YAxRI5UcaTRMvRhsOJv5a3NqczAjS04DrbBJqsb/7L4fuRGak4K9sZrFnsLbl60Ntgptj36qx9i3dk3yjiGX3CSVxYFG18++v+VDgDQl74iGHV6nXqQeQ49gZdU/HAxzQr8EUFd+aYl+WMmB3PhyBWe9oV5Y/RDFa8+eyF3hYyQ6b5TikNDiJz2D+vWvLkTzRPYgOPx5RjXeQ4ZKj2hmnb5EEhcLdvgtYcropfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKpkrJ9Ypdfryg5+772K/UtRosEZLXjzEljOs+wNL+4=;
 b=m+RlLQLBYQDVwUJH8EPoctC5w18Soxtm37r2hrOq+QuLsvYNliRFaI89EshE7yPoV7NGs31kADxAZCOLwytvWD/4WFjC+2EwjjdC449auRhCEsh/ut0cN+YHQUt7Ak2NA34xZ7hw4s5K+IIMsLhcTwPYuYPVCQWtRd7xEgUlMIsxYCUZIZYNrTfQ830KJ/+TKcTXvVKIH62p1lrst/eiI6UkECkHpY5swkiWQKU7m+ySFCw2tFIFWDSZosTSSij+JFeZ63B8okc9cqQ1OH0BWkIm3sH70tkciurBV6Q+fFL/+F1JNVWN9Hmv1WwXOwAyFmbOwjrg82reD6I11bcFIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKpkrJ9Ypdfryg5+772K/UtRosEZLXjzEljOs+wNL+4=;
 b=KjyOdSrp+ktoSaikjD3Ap/5L7w29HOkmLTMtZ6bJ5wZBbzN+MFpu6Bbkr/HkDkdrMDWB728gxcfPMuG4tRbXQhMQa7v1aMlqUZdKJM88gVy0iBDMg8m+3El1HWO6f2o3Bea5AZfihhxIdXhGCDahsrmpBPhZj+4M2VD6T0Gk2sg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CO1PR10MB4433.namprd10.prod.outlook.com (2603:10b6:303:6e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Fri, 21 Oct
 2022 22:29:45 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%3]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 22:29:45 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 05/27] xfs: Hold inode locks in xfs_rename
Date:   Fri, 21 Oct 2022 15:29:14 -0700
Message-Id: <20221021222936.934426-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021222936.934426-1-allison.henderson@oracle.com>
References: <20221021222936.934426-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|CO1PR10MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e60c570-0267-4067-6c24-08dab3b3c176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cecj3Ur9/GA4V5jf7DUGe7G2mbaxd1NHRBYEp27lJzfw9P5SVfM7nfwfK/iitm8L5IV4XTEGNfRvZ8TrpUzpDULfqP4ReziSwL2ugH3r4Jte5BdzjVPaZRM/enAsGl4bBjEnnHSzIdqDup6RKaV+OYtNyzTHAfC9jueVis42sbhf+RbaXOnueIDpI3A/iE3/+SmYHXx3riAdG7NkIF2ua+KRJREzHBbvSdG4rsCaDSaubzTejg/9TbJn6fnHuTnCXg6i9ZM8A+CG1atAB5y6g3gKcAde35k1UFAJj8VdNPuKC1C4ptpt06QzX5RWpeTCCvkoGDAyXERRpFfBKkmh00Qd5rP5F4kSzZOzIKES+MPgAcaKm8gurGb0GMxZkwnk9WdZZrCxIxQ/zQdbuf9MO73eYV7OvAfqD04uvCzAYqUII9pk66jaQ6oL/FtblJoftbaussHJ0pngwumYwrVujFejCxlOGPFWHQmtvp7fdz1pjB+KaMQ0sxrQIA6S3VHnKQ7rpJNaFNBY9+qy8w16+thJDgctFbnvgXNmQqgJ0OXva7e1RWgIIoAdliFRRWjyvyk5mC4gHlnrk10V0azd/iFj7BT1JIEC2egvUZw8TwMy6TgCyJMF4T320sk8rwP+/aZ+MfTbab296E6NgI4zzKEzZ0JPt495ojEKpSzPF8M7gQlZmo5q+TP55fvQdHqU26SA/QmJs0NQ3IfU7/Fujw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199015)(36756003)(38100700002)(5660300002)(86362001)(6666004)(8936002)(83380400001)(6916009)(2616005)(6512007)(316002)(8676002)(6506007)(66946007)(478600001)(6486002)(66556008)(2906002)(1076003)(9686003)(41300700001)(66476007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w0FiuIMLT0RMrc2gATqRsuHmWOB9nDsmS6ZjgTnMj4Cfdw8TwFzh5JByA4SR?=
 =?us-ascii?Q?ZInkSDJtcPLkWBrl18+e2OEeD/kVmMF3sOhLcbBilsshZloGwv5aEoD7Z2lH?=
 =?us-ascii?Q?YsRjyIxAiLlHJ80fSKEBWMCT75+I3zZPMrOWapkGgTs86dtPRrBMkB7LCcpb?=
 =?us-ascii?Q?YIOfLmgA+ODEXFdGtKvURbjAyRiQvMtkLw7fIfftTNaNk98uwwLhEtB921jf?=
 =?us-ascii?Q?7QbcBEM7ZtgcmAkqo2wv3WezNHBbf7ibQ0NToeY0q3c7tpVKZdONIZ1pIGk8?=
 =?us-ascii?Q?cPxYG+aPzW5vKGOj3ZkMY/uin7GECN2qif0pcgJ3ILC56Fphok6fWbEPfOY3?=
 =?us-ascii?Q?s4kQujWQYFpmmodoaQ9Qsth8cfrFf7wVkTFfhPSPPVEPOuNI8k7MQDYDcY/i?=
 =?us-ascii?Q?DB1kuIOaeyOVfHLIPASagsFqki6ITb8K/VPwECZCxvhLkJoTN4n9V7gMNPmH?=
 =?us-ascii?Q?M4/3r36lsMngU7nI3K05ks1eCzMlfqbhuO68ZfGzgC/Ir3GGXMWjdjOA+Hj0?=
 =?us-ascii?Q?Sd+1rbAlMoVZvHfpXU4NJq/27hxlxDf8uYLvzjuqO8euD7AoKH491HsJnYBX?=
 =?us-ascii?Q?AOqfjWYQVu3g8FPmdzGbBVYMJbc0i1ypHdDuAL5AT2+c37Iq5+xRBH5rIM6H?=
 =?us-ascii?Q?HwCNHXsdvrHrCoAru1nGPc0Q9B+wg9MpBXhyVIss9eTRKBzlTxeO6oQq9ECO?=
 =?us-ascii?Q?oPg6q7LUQ1ngqIKr+MhBanTnZEN/kIBd0hd1MQx9ATKZ7sHJ0wZYJKX9WIj/?=
 =?us-ascii?Q?JPS2IY6hdrzap6eW6H35BxVZg6nGESpitTcFSJ+nsDZctZ5TGghuDGwNHEKD?=
 =?us-ascii?Q?q40TCSeB5rLSQZMqEQB6HEvhEcDGGfd4xL6q9DICkGzG3y+SJl8DrUufeOyP?=
 =?us-ascii?Q?4qcbdTOS59HB90Il5kC+zJFYQX9Gn1W5Q9h9DieqRYDIPqrANYVe2hmGMjnv?=
 =?us-ascii?Q?XKdlZ+RjYf/eyfSvb0ZRBH+tFqgFYpJJrwVLt9rWhYlHpjvjgWcVPWS5SA3y?=
 =?us-ascii?Q?w8vdkhx7wKxjnzFBFDY60YzCnCn1q3XYRWk4hGM/s3XN3O34HOnwB92PQIPs?=
 =?us-ascii?Q?1JVi0srv1CMyo6a4L7bqv1u2PfzXmS71CtbMjnhUstv96HrDk96c9OMIhXFh?=
 =?us-ascii?Q?roVmF1rL3znsUyz7Oj5P6mXowUF2FPAntYWxtEDQqLdFR0re/92G+3qZiuEf?=
 =?us-ascii?Q?AGBBdu2E9PYEt55xpYmrsKLsNv0MTnigwr7LNNfW6+iUFoLW6VXhe6bOzIp8?=
 =?us-ascii?Q?1y9rClPRfd9CW+MbjqMMm6CKzfotuiwB+Gz9C4JC70RPrh16ByzwJYaFlOvX?=
 =?us-ascii?Q?SXEJtGp/x0t5RYtyk28rTAB8/pNjlVRIPDGT2l4zvt/W56V5jOyGfAZoZ41o?=
 =?us-ascii?Q?VacG4zQALVTwX+lnjOH9fLIMBYDcsnMNkDYIybWM81Pft8frEZe1Epd5Kx00?=
 =?us-ascii?Q?n4uhZrcCE1tou1lQGcMuUFfmaXbRHD/Y2qBnXdevRJ4fkndSClRcK3xqKpZ9?=
 =?us-ascii?Q?t+mlMRFj1D3hxgeOclczg1Vn7bwKsy6DbVTbrXkIqXyOwiYdH/6S7l/+/LFr?=
 =?us-ascii?Q?gWtSYwcvqYR41KB2XE6IlgkGSNZYcV0HdwqXuOAa5TlByz/Vea1nAqRa2MKB?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e60c570-0267-4067-6c24-08dab3b3c176
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 22:29:45.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFjNtItZzc8DHJPmvc7IQnl1+WfsjYI+yWKNMws7v/oHr72HqCz29PLQgYBNpcjqpscYjrsC9w9H24A18ixL3IOh7HHfJOHCy6/ZgElNypI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4433
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210131
X-Proofpoint-GUID: fDsA-svV5xOCTrhaBc4PN5uDmI_tYs4R
X-Proofpoint-ORIG-GUID: fDsA-svV5xOCTrhaBc4PN5uDmI_tYs4R
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Modify xfs_rename to hold all inode locks across a rename operation
We will need this later when we add parent pointers

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9a3174a8f895..44b68fa53a72 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2539,6 +2539,21 @@ xfs_remove(
 	return error;
 }
 
+static inline void
+xfs_iunlock_after_rename(
+	struct xfs_inode	**i_tab,
+	int			num_inodes)
+{
+	int			i;
+
+	for (i = num_inodes - 1; i >= 0; i--) {
+		/* Skip duplicate inodes if src and target dps are the same */
+		if (!i_tab[i] || (i > 0 && i_tab[i] == i_tab[i - 1]))
+			continue;
+		xfs_iunlock(i_tab[i], XFS_ILOCK_EXCL);
+	}
+}
+
 /*
  * Enter all inodes for a rename transaction into a sorted array.
  */
@@ -2837,18 +2852,16 @@ xfs_rename(
 	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
 
 	/*
-	 * Join all the inodes to the transaction. From this point on,
-	 * we can rely on either trans_commit or trans_cancel to unlock
-	 * them.
+	 * Join all the inodes to the transaction.
 	 */
-	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, src_dp, 0);
 	if (new_parent)
-		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_dp, 0);
+	xfs_trans_ijoin(tp, src_ip, 0);
 	if (target_ip)
-		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, target_ip, 0);
 	if (wip)
-		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, wip, 0);
 
 	/*
 	 * If we are using project inheritance, we only allow renames
@@ -2862,10 +2875,12 @@ xfs_rename(
 	}
 
 	/* RENAME_EXCHANGE is unique from here on. */
-	if (flags & RENAME_EXCHANGE)
-		return xfs_cross_rename(tp, src_dp, src_name, src_ip,
+	if (flags & RENAME_EXCHANGE) {
+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
 					target_dp, target_name, target_ip,
 					spaceres);
+		goto out_unlock;
+	}
 
 	/*
 	 * Try to reserve quota to handle an expansion of the target directory.
@@ -3090,12 +3105,13 @@ xfs_rename(
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
 	error = xfs_finish_rename(tp);
-	if (wip)
-		xfs_irele(wip);
-	return error;
+
+	goto out_unlock;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
+	xfs_iunlock_after_rename(inodes, num_inodes);
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
-- 
2.25.1

