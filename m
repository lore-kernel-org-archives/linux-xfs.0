Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4BAEB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjGXEj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGXEjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:39:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DB3122
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:39:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NMan1J018630;
        Mon, 24 Jul 2023 04:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=SIU9hbnyPKO4rmv2bFc88tWCvlQ563t9f31OOptKbTQ=;
 b=GWgkis5XrjfsXezZFabaSfzqTYA4qqKuT10Wpqwib+nv07uQ0MBo2o6QpcNuhurZc7HH
 +pyXi2LZYmIU7ofuMRNaFYYDTuAqydWSlXALFocCus4EOJUf3FvF/utShT+jyi3hP441
 tHFiY8exnLdsnjc7jfnDtU5qEszp7Hf+hCa8m8iRIMYkHcMTNXPtOrlSz2pnx2+UtifL
 9tBSNtBRX77Wvg4M7sIgQIWxma15iTQoCK6QNWGHy3rzL0m/byGpTAqpbssePZ06eQ+8
 41wGkgG/W6XvZAcIm1byp0c8Ie36lOSlGO2tucZSngt3oStLJgI74amQe8/ZJgUDx6id Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nuhsp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:39:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O0r7T6000494;
        Mon, 24 Jul 2023 04:39:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j3eaym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:39:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJXessMCLMVA+s19MWFuHOgR5spSRW65OXRNyWFv4Cuc2K8R7Cei/4cT1x9oU+Jkka3WeQVWeJqH5/jIZsTiu+MDtSWW9HmSIE0bwT1oOwrOx/hr1T1ZI0CWBpCYwvwZFxpJmQCiVo3FQEOc7Kt38m6Ek2qAia3hO1nFgoWxZoJS8U5yobF7lmOaCN2kxefxC9iFbG8zmezF0mXLelCZTcPn9Qg9ze1vePSXKDYuY8KlMNtMqeGDQ4tRpCv2ldWmanFabRAqsZ2lFNUNaIPQczaOvgOKp9XVjG7MNmSYUAfuBtfiChODTOLWr8uyg8mvkqjZ2UtvFUfXDHn8vwKXoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIU9hbnyPKO4rmv2bFc88tWCvlQ563t9f31OOptKbTQ=;
 b=ORt8DYrkjzU+oRASd1Pq07p0uY8BFbHWsObDpIOoNBGDz+xcjszuGXGR9F8sXi4NN9gVhHyzABMLDynVd+qWi6rBhsIwq1M05wcpKIdnSVY3ImlCagdLjfMmUVv1baT1n3lNHpfn6TDDtf/VIx8p7I4xItyxN3bOG7kfgei09hZXTVu6YBEYL/LApuGO7kD5RYpAEy4xTSkSoHFXrnz2nyXvutwLvIkxewj+hi7bte/eMUUgJY7fpwMjRgncsJD5mjDulTDb+XGK1XDY+bMLbY11An6dL8l5Q08DkZmUvoGDm8rNc1Yj535l5RjCNq2R0N7XlaJgO9OFl7h34xH4bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIU9hbnyPKO4rmv2bFc88tWCvlQ563t9f31OOptKbTQ=;
 b=KCpQtxc0gnEJeUJON026g4rqhbTYg3gxT8ssGTuTjVUUrhGuRdO5d4gyt4DmED1LgmLTAKaOW2hX6KMGjSA0219wpUcYjndIYotF4W6uBkzzTdI8mpTJYGrVsVPxB9uG9rGijOjWMGlrEUHhU6XI2l4nM4sOfS1vO44MLrzQqXs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:39:09 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:39:09 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 23/23] mdrestore: Add support for passing log device as an argument
Date:   Mon, 24 Jul 2023 10:05:27 +0530
Message-Id: <20230724043527.238600-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230724043527.238600-1-chandan.babu@oracle.com>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0035.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: 97b2c88b-8969-4659-7d7b-08db8bffebe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYBRQtxJli+I+dxxYEXQAZ2j/vYDWATiaFTpstUdrWz6HokdBWKojevQLQuEJIz7hGMcwrApV2aj4YBPDT0Erx4gy0Ee63gT3daqAjizcaWq7p+6Npo2awYtgQJhAhTwK5k/tm8GpFPL5vtNTE0VxnLPAeXFjAxXpUo4foxdu66RmOKvke03+t7BWMnTSap+j1d5Q7CE3wfTFRUm/llj2WCzgF9a5JoqdBOFPbGWK9VMmvxbH1qFrjIUAWv4iJk0NocT32qvGf2/gTULGqe7XG7ylEzgzZ/sgv+H+wB1iadZs57edV5ymPjdQRXGD+DKPqqIGOXmTv66rTVpAIUErJ1rJst2YJnGB/cbyEIE2Uwt1FfaWPxuchZV87tmC1vvsf+6hg3c0cKXh7QUXDNyl4UTvt8WcDOhZIei+09F/9/u1LYf4OjU+Amu4Sqct1NAYZ1gL3iN46QBe336W56WX5fo7UJ/+1NNRJO807u74dAWQCKx7h869194JNBoSw/CabBDxSlq5fHTT1bJIendmcne/PzSi6HIALxdrOUrnys9IWanLrncA+UxY4K4nWtN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3E/ZGdqvZr8ybyhsiBSh+wecVc+ltUwy/hd5j9xoAs7Tt1kzVjldqd6wlT/P?=
 =?us-ascii?Q?Bf+PrBFjY/VNQIrU2lrHCZduJ8sYp0lqxwnq4DZzlGB525E1dA/N4zkfxesE?=
 =?us-ascii?Q?K5ttTZqS8VRgUSdFCOOYdmP/FYqGAtqyhAAJ1RFWqYce9bzRnMcMxR+VyJCS?=
 =?us-ascii?Q?41WRogItsSZ+HBi857qihBM7Zo5VxipyvLPgBL3lju7QMMqTkmKg0xQ1AUph?=
 =?us-ascii?Q?2pjd/EHHh85Y10MtiUatxh1imSoYds4g21z6Az+We9q+kI7e1JDrMo8YQGaN?=
 =?us-ascii?Q?7nKqc7WDvEppLilUWiBdV9nFlUgTp+C6F0NfG/aeEFJXP8qemuEvMs8vlVYa?=
 =?us-ascii?Q?13BmjeMZANEBmSTRl1Oxl5fRaor/qjZQGNvDmmChZFPAeNT7JkxaDAwrI7b4?=
 =?us-ascii?Q?vylZ1v2oOwSyYk+63Rxof0OmaZJjHtsackyJzP5cq6mCyyapvmhqxZM66A0k?=
 =?us-ascii?Q?Qq12L0JriBnX1lhlGGuG0qdGW9+b7E03JE6L2irDuyQ2D3R+EtYKLvuOOgiM?=
 =?us-ascii?Q?o+zGbb4gCQJ3mNfmFeiMyhkHvgpKjWOykZdHwwyut8dECe20gIfjnXvaQJkW?=
 =?us-ascii?Q?8Gxxpb1xxC6kQiTTqH9+PgVJYac2SE6uyKFDKpg3zNMxxAfpcvlLzv93n6aO?=
 =?us-ascii?Q?TO7+uCHmOOYF8NEXU+SyefrLA8FNEYqEy8TMSgCjyHODJ9KGwRx6ChbuSx5T?=
 =?us-ascii?Q?Gv3OvY6hsU4e8+dRwAbkqI9kmccWwopZ9ZQsmRPZ8BmUu3I06qrjnVZFdebh?=
 =?us-ascii?Q?Ui3FmM0xpiI7rDM6ejGYkSielJYaiK3QEVIKs9p3aX7f4idKHT6a1At6uakB?=
 =?us-ascii?Q?F8l8e3ojie3pVA9JTxsrrGGByjA3UPBP/yg3i0L0tTyV9lzmgndEJxvahrLZ?=
 =?us-ascii?Q?MspT2mwWPVt7f7Ckf5kAt29akFw1pzRPjxwpSN5qRgfQf12okKk9QCMRhvOE?=
 =?us-ascii?Q?48bkYWJiw3GC994at5T/q6EHEAgZDU++blbyjmxJXPvA69skQteD5r/uvUj8?=
 =?us-ascii?Q?S07U2B1CIbmg60axsE4hgfGaaPDE+oKONdU0fH16U49PkGH+PdRGSSWHnC66?=
 =?us-ascii?Q?dRbJkX0OpRA2U0MDacmuFP7N6ZyVtl5MyZo/TeqfvrsshsNc7YffdeO8dO/M?=
 =?us-ascii?Q?09am0Muyo+CT5KyQNEZkzofcUcM+xiXVjTBw6Bns9MUC7F8HZAe4R2+8UhfJ?=
 =?us-ascii?Q?Rui9+XHkZX8UgzVNvvBp/xaizxCwY3m+I3QdfECwVZ8kaSmbt6yJ34kiKAU5?=
 =?us-ascii?Q?2bSVayxEB+LO81mp8452ij2ZU5RfVA0mgNdkuBW9nFZlfM7SojgJc/Pc7Oi6?=
 =?us-ascii?Q?XrMj+CuCho3boopchAVOz4wHD8vLIH33TiDAe6RWxNqLfeOXttF++M8VvtVq?=
 =?us-ascii?Q?YYbOCXtbz1eJQpf3G4k/BrvcSxg3TF8DnCtfk5SzuKJN667FniN0K2U3+Z1t?=
 =?us-ascii?Q?T9ASOqVssj2BypUFgpx5yjmVXO56DHA+qMOLr9UxHRdthQMqy8+bbkyaQK4q?=
 =?us-ascii?Q?l1awk1iUHoc9S1nlUH13EOsMlHZ5A0A8HiHkAK8Z5jcLkPAcz3P5iJ2SAftJ?=
 =?us-ascii?Q?nGcOmOdWYLbpwsMS8n5agbW8kFvHKZVBdtM9oY3eb7tIlFgzvXuqSBogzIBI?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mfAv7tqwhhkrECYEJxz1Txqy/i4UbYE1NbnJh0KtQcWunC5yiflR16+mzF/xKOrAFOtb/BrebzZC35zi9ZKWUJ5lzGGHLZOV+Ac2Uaw/vHHtFDGG019OpuYuXaRA+EF7vupNyKHS4/l1mBWMsPbO7vx2YZReOL4xoHA7SPN8Tfdp3XkB6Adir1KOCs7HUrbNR5PCSN5u6Ydx3vGaC4AR03t0WB1W4JzUggNZGmK8bvMbz07Fugai9Y3eqI44m4is8Q+TBcenAKTxLsflc50a8CIJrjH+Glj5EPPnMmGK1uvO91fq6/bphnXff7K0MoYcyTtOvsEfFg0qeRPZkQ3BD2oTj/3c5jDZGNqs1UEJNAE2efewPCNAJwHr4x4s2mSlHQznoeq4m9fmQ7rf5TRzKfA9zFB9pBbfgxHrod4cGdTj54YorP3GaN2Mt/MW/jKvFWOy15yPLg33EWLU8YA8+JpZrdC/x6EyPNGHhTE/dsc2VkjuHEj0Lq14bvW7InkxUXrQ2hgp4k4JOH0mXCHBXwnGICSD1fN95+ey2Tzg/ND3oFLN6QUZ+T3gGPmncGVCix/6SJS1+HiL4OmeuVPATmmgVDVuKmNAr946v/Hh9qoURt1e5yoMfo0MP6R+Fb+JnpyeBBXivfLixh+/UlEd7hPCUWyNFYS2t18MM2n8dpqVRqnjWqiy2mv+N5c8YGeVd9me7IxvcClQf1CZHY3jMZf0PrfCfQASrqUfono3XPjhf3jGrdS/Zf6C8gJgG1LcNkhWiuyb0CkF1NbzIBcRdUjPCbtoRogFeXGmtfYGLfU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97b2c88b-8969-4659-7d7b-08db8bffebe4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:39:09.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWDkqtlmYeQbKvqxeBQBXkpuN3MwdJGZK/svRxxfCE8dpRbV6ATeOK4CyH4Qg2ZDt1x/8qPXVHtgkuFn/5lEvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240042
X-Proofpoint-ORIG-GUID: hgpgd6nBcPmFwldVNQgHIY7PYnVwWacH
X-Proofpoint-GUID: hgpgd6nBcPmFwldVNQgHIY7PYnVwWacH
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

metadump v2 format allows dumping metadata from external log devices. This
commit allows passing the device file to which log data must be restored from
the corresponding metadump file.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_mdrestore.8  |  8 ++++++++
 mdrestore/xfs_mdrestore.c | 11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 72f3b297..6e7457c0 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B xfs_mdrestore
 [
 .B \-gi
+] [
+.B \-l
+.I logdev
 ]
 .I source
 .I target
@@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
+.B \-l " logdev"
+Metadump in v2 format can contain metadata dumped from an external log.
+In such a scenario, the user has to provide a device to which the log device
+contents from the metadump file are copied.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 85a61c8b..beb23489 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -453,7 +453,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+		progname);
 	exit(1);
 }
 
@@ -478,7 +479,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -486,6 +487,10 @@ main(
 			case 'i':
 				mdrestore.show_info = true;
 				break;
+			case 'l':
+				logdev = optarg;
+				mdrestore.external_log = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -522,6 +527,8 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		if (logdev != NULL)
+			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 
-- 
2.39.1

