Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B73C6FA83
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiILN3h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiILN3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:29:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14392D5F
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:29:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDEGCb020724;
        Mon, 12 Sep 2022 13:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=U02S+jtDaAptlpF4jCsW7jAhf72KbcnFnpz0TlhayNU=;
 b=JLJPSVoGckvwGV4Mq8qi5v2MYd4l6RgGKWasvF6wnp1t+PvckcZHLeCpsDZL9EAqfFdf
 3HRiiprgTLrY046IlcAYCzKInFVEFFoD5AR9JoXurMbm96TAw1PJhJ3HOQHE8nak2UlX
 Wp93IEJ9SyVAHx/7iTHOHel/yM3cPGfaqi8uL1g2DRXG4buRbpXs+2aPeDbnXVl9UcMG
 HFPMgH3qi39Ic7srGBxIh9jfpfnLFVOB/HI9LVU+mO1sa93MLXidCsBf9rMclkAo+IlS
 NGEfBM1cezvETOc9+MA5HmsVvoSK8WLxEvp2+/D/Xy2eWwtJlgFoqVwhAx9gg6xKsVN7 tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skfb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEgkt025108;
        Mon, 12 Sep 2022 13:29:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12a80e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:29:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7i+oaNGca2Ljc4ygLyBLh9GLpU9umwqhCEsfyqqcUR8dYHiyWyJ7/82WuP+UhwVMRXXrDCtoUga0VDL7xQRcBTgJkq0Yn6RlrHm4Rp8DvxrBN6yqgu6h2cyQee049v0HUEWHbkaSz71uXsgZ/SPTgVy9R05T1AOaUaIkpGorSz90Vy0FO2/vHhALYP+iOKqM9i7/7bMxg1kbIy1S8dJlOzCPdrjkCAV6uqcK7K2MlvWWpVJgG7KR38DITpON7EmByRfHTY05wIg+xxVXH492xNpjHzIxYIWNZ3bC0qma2FYjRf4H2slVFU5rJLKTTlFqGg6dWqkTqnq01IB2s/AxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U02S+jtDaAptlpF4jCsW7jAhf72KbcnFnpz0TlhayNU=;
 b=F6jzTEzl7YAkEGykP9c+SLLbZEDshJs0wERpAZ3CcGDEBtvTrhmfrITutFr0CWyODM6uEPJO+h0W2sArTPXywj6bWvg6CGc21aM/wCZ9nlfu0f+PDgM4/mKUD3HVW0kwyeSWT120fizW8EUQqE/EJjsAu65pgGFgoDFAFDyAllK09Bwc2queidpjKqRHMZry3vTrVH23Bvc9gsXpfgRht102TLWGZ/sCNZLcFjIbJ9ZK37X8/lcHkJYFuKRZWB//II1XMGwkIpNGdtxyaWkzXy2U8CVH+zBq9Wct36VA7nqcqZ87ZQk8aGiOaMceXElYwqWBkfiqXBrskNDJePuwQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U02S+jtDaAptlpF4jCsW7jAhf72KbcnFnpz0TlhayNU=;
 b=UNbl4O2z+Xs8pQyluBkw5lFOUfjtgh0sMTZwP/Am4ppNjxML3GiPFoKKWCByG1XYA85S95lYi9SPoLk/RkHcJipPz84Yf0AEFu9uFfZPui7C9XPOzDqlk6saMayrbbcWapEOtcU9R1IL0L1vL1NvcLcGAXt+zRSBw7kGvKyRC6Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MN2PR10MB4318.namprd10.prod.outlook.com (2603:10b6:208:1d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 13:29:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:29:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 13/18] xfs: fix some memory leaks in log recovery
Date:   Mon, 12 Sep 2022 18:57:37 +0530
Message-Id: <20220912132742.1793276-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0010.apcprd04.prod.outlook.com
 (2603:1096:4:197::11) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MN2PR10MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: b0f3821c-9735-4a97-b675-08da94c2cde7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1gl8eZy3GUtgn9KatjXRefupPIPGkdqoW0pGvVPlumWEtdRRpGnytsQli0CJuso5nMuhrIPpxHF7FkikA7BGbKCVCzgg648UK9+C01kFAZRvKZFMWsoaYQHQNF5SktU0xk1wACImG5ja9fwTchyMsHwFY5o8yoz2Lv6VXSVMTGboY/6lFqRvqV0b7KxYh+4HDQNctI9kaoAHL5idpIoG1lchr7T6Mcz0/vVnkwXcqrsl9eR74j1GfAAF43QDbmlCsdk3ldGVggMav4Ep2Y66iwjNMV2URK6T1BU7HLoJNrsx+TB5zcm04omErXKPAqy/PcmDMh2Ofjzh4eNF8yWWerGgG4tIIvTMUj4X4eQoWQwYisZAawcBz9Oflpaq0Euke2XGFYi0h5IziU75JOirKBOWqwq7i3p5sKCaRZIzwDuCG//OMj1ar5C9gPzVbdt6h3bD24q2zSk0JHL/+GMRsUrnKsKMvZCn5fN2fNU/+WOrwfXz6IHetooCff0KWyzAmt1VagXx1+GXGR1UxRPpVz7XiSNk7xzn7Am1t7ri7pLEZdcI3iMDEZq6KrZVcYBOGf5KKIOM3K4w0QRV785klWPyO9SKXFXq3uwN6PXP8nYnj70yZn5ghKm/afj8wLfh4gm/TiMUvhTyMZCYV2TUvW5N7cLw4lFZWq/1QOsMrDAYp4mv6x5YTEZFNNz9PinlW7O6r+CrGjPnWtYIG48kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(396003)(39860400002)(366004)(1076003)(6506007)(26005)(478600001)(6486002)(6512007)(6666004)(186003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(6916009)(316002)(41300700001)(36756003)(66556008)(66946007)(66476007)(38100700002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PPMysArBYftWyup5hraY+GubwDLZ4CGYoTs/MB9s3Lp5GXMH/dESnX5aysE?=
 =?us-ascii?Q?NEYJQFxHKpHjcn2QmNGNDhvG5ZSjJo8f5pENYysuSqnTHYdw2cduAZAvnxTN?=
 =?us-ascii?Q?D0JGX3UNduTPRMzcQsYah+PTzSw28xC+858XRiZxDzeLdgyJOi9cps1NA3vU?=
 =?us-ascii?Q?QXDOEYeZygmWHhCVX/4lHBXdib9Hkj5BhZQmEVirVOA5Ld6hzUgTjQddETDr?=
 =?us-ascii?Q?VDi8m2CmR+Ft70stGaEqn2FMBwQS3tZmnrp5LreSUvGIvr1r6heI96gwxi03?=
 =?us-ascii?Q?bf5Q5WOcfmt6iCX1dkb0Z6xadbbsxcrrcY+TusWmzP+isCqcSwXik3OCdIWN?=
 =?us-ascii?Q?8phS5gLiWa6cEdjX3VLEoEdD3LdIrxjl1xN4hShAvl7RX9Ak4FYy66wfw6tF?=
 =?us-ascii?Q?r3QLDJdyJTYjJvSSD2FNjH0P6N5ZgkoUSNHwbeAl60xukhrkbAC84/M4at61?=
 =?us-ascii?Q?YlcWemNVeDqugfIzYtC1z43QudWNakJE6+q5x4JBmDKni3pzTGTMh4Te30EK?=
 =?us-ascii?Q?Jgbw80sOGv6+q16NGLIhotw8AGQBiwRP9TTEJXKR7vxlg59RXOVt2FMBHii9?=
 =?us-ascii?Q?Z8Hh++mFVhWzOsFa2yCqJDff3gFk3JU2Dbs8h49grL71UerpZpuABL30P4lB?=
 =?us-ascii?Q?7b+uLtD7rIniw3ikypHNdtGgkmZO9CUggOYG0izA3Ae77JzhgWUFK/B7chSJ?=
 =?us-ascii?Q?8ue+H2QWbeSuAk9myNraqDoVfUSl5ugQ/mzUs54ATgsbVrlxoJzsQCI95XW9?=
 =?us-ascii?Q?9BYxPXjp73fza21LbMg5HN2dpCOJtShWRKu8tOg36lr6TiDJaxE1dqvRVWQE?=
 =?us-ascii?Q?Vi+wCjs0y1RBgI2Tl8o2xAoVyDYPl4lQ528XeUJpwgwaYzGZ4Mur76FhuEe0?=
 =?us-ascii?Q?+DSJz04Wyw3mQLtS/FxfTwRSBK+FrUx7XKolhXamOiWfu/A8eaHBoG8ocXGL?=
 =?us-ascii?Q?AxBUv7qKsbNEmBgOn70NbIn74wb0Wi+RmgcuhBmaMouwfxU2C6zveDNWOGmF?=
 =?us-ascii?Q?S7aguujdytuF4P6RJ7YYeJfaxz2gDzpK1p8UpppLBda+9yhF11FTzQStBJTs?=
 =?us-ascii?Q?PjKUMo2f92u2dZnJZGT+MWew94NqeS45i5kofM034eiOcgjsbLNwK7YE/9BE?=
 =?us-ascii?Q?1+lGzF4eQFWZw7cmXp7VZjDoQIbn+pBzzGsh1CHMkUyduD9j+8M/FIh0UiP5?=
 =?us-ascii?Q?y1UtMKG+TL17a4TrQcebthzLKR9LN5U6ajTB49UkuU5kzJH3e3jm+p1L+N2T?=
 =?us-ascii?Q?I97vL2RKA5x01g2bvdu34Gw42qVSBL/a7kqdvQWlD5u0kaX1eYiEmA4DGpzs?=
 =?us-ascii?Q?n4dOwDqNNzlAmqGvffKDW2jZ90wxwR579aTMV7tSt05JnL3a3E1AJYDjR2lO?=
 =?us-ascii?Q?xPO9lBbnS5VZM39cnMiVzeP496IzptJsmVpC/tHCNYfrkawxnFGHGCmIopbT?=
 =?us-ascii?Q?XHAKF2acDErAtOEOXCXN1RsLvlWZSFIuIEH6Gh9oEFBFQaYihH7Jox4CHo81?=
 =?us-ascii?Q?Xj2S+EmTgcuYUKPUWHO/epKJvE/hwRXaHVP6X3RSc+jyTGINxqCbWk2314lh?=
 =?us-ascii?Q?gQq5hPhsZOkEuO36prFCCj9/rZCOT5x/pIMWBAa5j/hpzyBsOlJEu4tiprd5?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f3821c-9735-4a97-b675-08da94c2cde7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:29:22.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vC/cvm/as7bJPBOcupyD8ZwE5toS0JJwU27XPXeu2O6x3buZxlSAPHDuEPEq6Sb4AfDSpLQIwxr6pAHQ3Q17RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_08,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120045
X-Proofpoint-GUID: lZ09RDwMIHSSu1Zong-MNnqEWV0RSrmL
X-Proofpoint-ORIG-GUID: lZ09RDwMIHSSu1Zong-MNnqEWV0RSrmL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5 upstream.

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02f2147952b3..248101876e1e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,10 +1347,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5318,7 +5319,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 
-- 
2.35.1

