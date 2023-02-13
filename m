Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F40C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBMEIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBMEH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:07:59 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3560B76A4
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:07:58 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1i8Cj005947;
        Mon, 13 Feb 2023 04:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+d2OEA5D8zzmQqTHndTXtQxQyBee+IWOB6KdQmz/buk=;
 b=VZQQT7+dwioyfds54HpZL+rybNUHu8yl3PXBUrgl71TjWsKIBnA0tghjUwUxPB4/2qaC
 3n2XjQ8k2eyQVwF8NYb622Ec+TS4lhaPydA5ANlcXS4FWw6R2bnMSXIOSCVYhiM2Ci5z
 Qi3PqC2o40jnzYby6P0NFwVzcRp6icC7LDmX5Bt7Fw7rEJSlllc6O6pbpZtUBdiqf7xC
 Ps/07ix+waaW5Fx+S4q55Br1cApFeBfxglC3s6OwFpu/TGI3KR2T3KqJmikOPPpexoaH
 FEqI775MP8ZrWC2lu1+KJlXZnJxwVGCOgz114TaAPi0ypoj8eY9CFg3FR9AIo/uwGSo5 Qg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mt9udc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D38RIN028887;
        Mon, 13 Feb 2023 04:07:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3aajq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:07:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz+huMCXj4xOXYjZh6I1EzDA+50RQ/8zYwnp9x9LVUbLU/XpoDPfMRdcOBIVtVfWTsIBZLMbB3gug6ZBMCsSnTSgKn9B6ezJcoAaeBu44/TEeJkDqlmvSNXmOgy0KLYFoPfjgJIdDakBoTjZBLBImEl/v3CCpsB8eFeTzUTeFiOrA1rV9dz5Kql1ny0CYyJv+QGcwe1Gj0plctSCtbYrRtsEVthsvp3Oqa9ihijjHkUl+V8Y8EoGbvAcT558lLM5lF0Rh2FWYMxQsS1YyTHggRsXEpmTL/71zgR3NfMP3CyRmez/o62bWSaWTdWEJosbkP5/SR6MyrKpn0gLbc5tUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+d2OEA5D8zzmQqTHndTXtQxQyBee+IWOB6KdQmz/buk=;
 b=LoxP4DRnJaEdvqD7uU51esKBkuvMhVHchBcbXkWtrRvQq4EBSh/jVmyvFWosw2AO51kAw5T1PBfCNauEnRQdCim66BR3EBgclXXCygDCJ1QfAnRMVaivtBU6U5XSvEwtjvb9V0sVDrso0AxalOxtBSYHOvGFP5+ot3PgefI50mP5COnMqVkYlXRyPdifNad/nL/2C8eDz/8MNbdHoX2Z9cyC1x2/HiTrE8zp/LRDSH412B4Iu2E4JDTrSzAmuoWB8mbUEXxfRmaKYsItEVnEo63MH683O6V042ggqxLotvyZrFrPsAd3n0cHd5QiiBY+FLbr+dbgE6PsDHj9mdKEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+d2OEA5D8zzmQqTHndTXtQxQyBee+IWOB6KdQmz/buk=;
 b=D5GW4vqtXV2zMTtvfHAanNYL4VQboH09OLH4/U/Pxq3lwqWLYeio4/9TjODYBRYzRZjJqenCWJzqC6qsYpZxzSIsRxKRVGs9bePDGvIneCq+XhhvjudqhGDJSoYdhzy6SEaX2l1HeDcLcQKfnIjLB7fu3dQMXRmQiRyo3SFv/K0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:07:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:07:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 20/25] xfs: only relog deferred intent items if free space in the log gets low
Date:   Mon, 13 Feb 2023 09:34:40 +0530
Message-Id: <20230213040445.192946-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0197.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: f022f377-3297-41df-93fc-08db0d77de43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nhe7ZS7udMJ+gMIBsHLcNnoDjNUAXDIaGYgPpuhzRmKHMQ4UXa0s1KuPRr8JcR0V6QW2s0rkQoGXCqLkkXCFlJEUI0xdhYY5p8cv7DuXkVksGopUa6VfQX/BI6czFjIJ1+XT85c87m2hVuHaSZtqfilpsEM/ZXmOQ7cxHHKhVtIrYPIduMRbCDMa8B5ZXyj/r3Y8Vjpw+lK/RZixPIdPbhL1k006vVQIvXWg0tEMoqpcbfZV9m7YhrdTY0DX8g8UDJxV60JMYolo1NAV/UbufpnSN+/lSJj5XfO9UiEc6GVnU+/el4mfxDuYhf2gEROlQQVUnLSZJ0gHKjIY9xWNf1DCLgxva71Wtk/goi6FgFce+7V/A8jNEXpqYjgBXsiyGliJ5vdoLwq4JVyYsKqIf1JPn4wdR5+yzIsMw7MLdvSvUiYPVb34w887Ft3/mQoDuSh09Sshmy0Ola7mZkAUS3XtDoP1rE/8R18YC4HLWPudw2LNCfTnd8D/qxYNz3jDOo9neBzi09SOsXiLAZZqkYHqpOSKUqrEnNas8yWs3Jc8n6h8yesc56Yf5gtDL/TE26KdHOdV3D5FRwRN2sbM+QK2NhF1WbeIBC8e3+vLuxUkMQF/DCUQyn+rcCi5xm4OM4tukrcO+1QVc8dL7iiO6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3bKPB+u7+repZGoGMaPlIY7tMnWKpO1ag/O3yRjWzN3P5qLwMnTXCwbEtAFC?=
 =?us-ascii?Q?3NzXZd/qe+8DkIrovAISvmnl7pjU5WtkwVvL+nJsBOyPzm+FZ31djMkEE9Rb?=
 =?us-ascii?Q?fuei3plYZWIM3XYKu3292mFHpNbr4otzZ+5nG7SOUXNaELFWKcsNPn7o+dS7?=
 =?us-ascii?Q?CL7CWQRH31wy0Mu90yrWCHmXy7JOnodoXosGML0NJpwDRRG9LAPvkBl5zQWW?=
 =?us-ascii?Q?oFzdj6KMQUTCUZO5nI1w2YSOdzfhNB+dbk8b2D2/gITiuc3A4ePN6ObEv9L6?=
 =?us-ascii?Q?EZSatMpXUinaRiN+0A9yaT84RGqsgDm7ONuOiX2rxYZywDzYFg0d+IWedgb5?=
 =?us-ascii?Q?0ncfogd1pYUrhLtygVaTMSvhFnxIiQAe3U0rObVpnXsafjDzspHPzlNKATHb?=
 =?us-ascii?Q?ZXupPpvbD/F+P2Beb1Reu25xkrHMkWKzqUsM1Tq66q4v8/FrIyMWu7r0M8mp?=
 =?us-ascii?Q?5bY3IFceX7Fq7Wf5ORa2fMSr763mTVhUVCHHBnJfKOpw7jbWN4PEeCoebW3j?=
 =?us-ascii?Q?QxClDtEPHNcd9SSRXqaOycDqXZ08WVT+ftp00h3SRsBfGFH7mFG0TTkgX9+1?=
 =?us-ascii?Q?rRBtDhU8Yq4YuFEWxaDzhSzPuwfNOJHNxxLcnv4PfwTqYeA6LL0EJG4saOFl?=
 =?us-ascii?Q?+0PjSoyPNbvPKQ4HZX2iQcxjhFWe2fuNQepOfKLJPXTwvuIzKZOaUSro0M8/?=
 =?us-ascii?Q?7OTO2bN45vLEyaMiOO4TqLXe1ygBjRM+HKC6LoFdkPT50TCQOjC2d/XPN1cf?=
 =?us-ascii?Q?T+WNFZuhmvaiNAHMgPlOG9kkWWcE4M3jdiO2haFokL2+jrdK2CEgTB63ZHIM?=
 =?us-ascii?Q?wcIrCmRUcZ74/38GaDkDYXodfTgHVrcu59zv0UxXF+O/bAxeOKAOxuEuLK9E?=
 =?us-ascii?Q?QhZiWnvs3c5tKqfNVws8V35FDs0qF0lp2rUGuXkwbRm1kxq8rLtxZM2w7bmo?=
 =?us-ascii?Q?6UvRexxAXuqUyrTDCV+BC18bxl8GloJiZ4XZxra6J1mSHdSgJgdw0eY+V2Vy?=
 =?us-ascii?Q?qWdpyOUN2A8Trx6zRBCCsmD+JKrcmElZ6Rcx93wIxCaCmAL4ROlZyFRqc6Hu?=
 =?us-ascii?Q?MKqmCuJBtU8dGtSaZFxgQDSBl4fCuwRaoBbT9cgSuXCfosymSrrnKpvka1Hx?=
 =?us-ascii?Q?FlZJXAHjKRg2KupsziwTV9m8N7T/s0yzkpN64pAu5zQGxqnUW1MpqtVXJaOL?=
 =?us-ascii?Q?q3q7oeKfqa83gASlhn0qw2FXSgTiqeTfXTwJ+Yc4VI7BP6g1BxRJymiOPjxE?=
 =?us-ascii?Q?L7oMGMihZfKl+thCg5OVyS62fG/7pLYvvmIkgBJgE8VRuw5DGqX6sUt1JK5h?=
 =?us-ascii?Q?arzqhCaoUrEhD70PQQF8e2v3HIvpxLR075EgI3gObJ5Gny4pzreSq6iN/4+n?=
 =?us-ascii?Q?P+ibQmyTZi5Z7Ah8HCfeXMzLEa8Wc5w+noDNwnWnn0JuD00+jDNXAUYNDmrc?=
 =?us-ascii?Q?E3GcMjP2FfPxO50mqzGgRYACYeErMUz7g2taa1pCEYwaMUpDnrCNw7n8d0fY?=
 =?us-ascii?Q?Z8oOl0PRdTOKAIqFCo0kZC6144APq8qU4kL9sADpaq+wTJo2ZXUIxxZl9HZj?=
 =?us-ascii?Q?H1asqjK0o1pptY7tlbK8ZytUjie0AcTrW9Nr5G5naBZj3lOYS13seGkh8Ich?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: BhSQZ3eYCymMtQMZUCN4KIiLRePbJyLtyLuNYhrxadenaMny68eU3CUqQTWBazSLkO++ku9CkdvGXptY3/eyOuLn25IyPPww8IvnUgDa1BcV2nIZntajRVkrTCSwQsFeJMH2K0awT8K3unC3CsJ7maafky7YJXaRCm+jYIs6u+d1HuOVpaI2WjgivS8nMyhQhWgZubUHTlSbluV12wiaB30kR2/VKIEmiVHhUucSco89cfs7eItZt90/2m0sjmagRJL5dQVilOasYfeQPyC3JylmoqDcuC21RdFnUuerpG78BEg56Eg8pqNC+gbW5B1v6vxqVBOkQ2Ma6LHG7fgibJfyuOVJ207WW1+ktMSZML8Goj7EpQCli144SCb0XfMMKsuz8HIFniYp2N46tVA87qweMEqcjcrPZMODYMaPw5tLjM6K8YkkQGRXtz74HcQKNtSHpa/ks/VXlj5X38V59RBidWlKSOGZ5gH5OpPqNLR+oNH3hCRqQH2aN3UEFon5NeOr9bHzsVZrs8ctJNLtP3FbGqNMPLDhgv27tYXKxHVbWer2B5X4dQUYr48HwXVr6K3gXc93zefvOn+uQekndCv81bkstsH8NZWwH95PmMqbhvafM+CJGxUkQ4XxvGq9DJmfh0Py0mDRx7Y97BxTFvKGONukbDM9vdp3Gu3hVs0SIF3Ii35PzUF8MckHMAy4aSmrN4aN8HUZohR4Tru8baWKD+t2zFQDql3FW6smdrn7XfO2Mo0eayZmd5ssUvTUktdN1CWNDk8o2xebnIZGoinde1SUYPdkPYLMhTi5fkB1t/nuFIezYCHjJ5h4Jug0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f022f377-3297-41df-93fc-08db0d77de43
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:07:48.7265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Haw+l820NH0/LzcugKSiJSe+BSgx65WOCPYdMS68a/HAjC7PBUt+SeyW2qw9rAYiujlmhYp9AaDlABdRNVmYjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130037
X-Proofpoint-GUID: q0CPvNpjGcQMzfmq5ZHAaqu_1OixyGib
X-Proofpoint-ORIG-GUID: q0CPvNpjGcQMzfmq5ZHAaqu_1OixyGib
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 74f4d6a1e065c92428c5b588099e307a582d79d9 upstream.

Now that we have the ability to ask the log how far the tail needs to be
pushed to maintain its free space targets, augment the decision to relog
an intent item so that we only do it if the log has hit the 75% full
threshold.  There's no point in relogging an intent into the same
checkpoint, and there's no need to relog if there's plenty of free space
in the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index b0b382323413..3a78a189ea01 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -372,7 +372,10 @@ xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
 {
+	struct xlog			*log = (*tpp)->t_mountp->m_log;
 	struct xfs_defer_pending	*dfp;
+	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
+
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -388,6 +391,19 @@ xfs_defer_relog(
 		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
 			continue;
 
+		/*
+		 * Figure out where we need the tail to be in order to maintain
+		 * the minimum required free space in the log.  Only sample
+		 * the log threshold once per call.
+		 */
+		if (threshold_lsn == NULLCOMMITLSN) {
+			threshold_lsn = xlog_grant_push_threshold(log, 0);
+			if (threshold_lsn == NULLCOMMITLSN)
+				break;
+		}
+		if (XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
+			continue;
+
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
-- 
2.35.1

