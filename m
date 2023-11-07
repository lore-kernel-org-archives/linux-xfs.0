Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8E6C4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjKGHJ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjKGHJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:09:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415D411A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:09:25 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O4CI019476
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=aT3xEat0EPPy+OzNeMXaoH+ik1wN0Duv6b2rtzAixvyjWnQpR9SEWvRFGBfXPs0mjie7
 jThb8Y/JzYO7Zkq7eZn7c6kHFhX9C2z0wdkwq2Ju8Bt4/dfflCZfPp4+lkAoCdnqRbrR
 vHikezaVfv/wNjpddtjbc0j5R12RM+8v5enTGiJFVoR9LtPDFE6O4Wv7XarhcyoBsJ7t
 fJKrq+XvnMtnc7V8pZ5kV20Z8oE7pVwiDURLUFXIDxMIee5oL5vCxVXMemfjPaDQ7Vs9
 F+OK9qG7an4T2KIgENPeX0/8wvI3x1rO09fWueZHoNPlxoQ6cF1fpJ503wg9YgD0s/n6 wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcda2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A76TLq3030408
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:09:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63gfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AemJM02ADozTO6XaZTtjWbGYslJEEBKfH9hyxpiRs0DhjI3wKyCt/mOQMNU1fO37LzyaYpyjwkATdU+OU4Un4/4Qaq0vhoPza/ONGSTR+bgLP2yL1BikABCoL/uqyy0jsyWa1HZa4ndlQYD/wUkHIEmd+MLVsn+FlsCmNWQlqcPhlq2AZfE9zzGSiWifaIY7T0easVjIv+Vm0ZGe+ofAa4+O9BsL8Sc4b7n8ebH/AbFICAYCnkX9YHbiHdwGbPBupedT/GE2chblcluQ7K1o87D2ocPqmbBb+rab93dg/Cos2BoO2eK+BTAafBBcDrqB7WLcLK2wejNNgsspZdzU4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=LACWzl06kyJweY/6RkCbwxDfjFY0dnQ3jEw2VMVT3YnPbTxynvINNvs1briGOFP9vINYkZsnH/pOU4XvCRbVgDrOWoRRqs7ageoguRgSc0IJu0RJ406Q1zKahEj1ZoKc+1mqVU4Ctun0SNdbthXI6f7PzNx9gNMMcmxE7IjI86rCxonfkkxysTAIboyjqrnHefGN9zayAqn47f6v8MFW0wWjNiRml0rfMoZbeeuR4of+ApGEvuraKPShaKvPVcLjvU8CkE/hsQ4nDa8t7p5/2NxNoEhsZQHW7kDF/LvapGPiIWWHMqUgdK/NjvPHDddLNtC4xLRBxWVW1WEpvwCN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0aqiVk+K8zuzG8NEp16kJakpNxtYtI1xbz+J/Z9R5U=;
 b=dEEvc4NeRdOeRUAB5thJNTJ/SHqEQjktUoagaBaNU2gYfp0VX0J9XDx+RCln3CYSRPCrOJYmdNKn981jXyAqZ+jt3WotjlMkd0l8hTjxnaL+XLrYiyyl5lHiAY+EY4gU6xyZ8uO17Uy5AKPBV7OBivmR6yVr4hWiyo5V62wliIA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 07:09:22 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:09:22 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 21/21] mdrestore: Add support for passing log device as an argument
Date:   Tue,  7 Nov 2023 12:37:22 +0530
Message-Id: <20231107070722.748636-22-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: bde2fe78-26b3-485a-6223-08dbdf607782
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8r+qT6OiyUt+aArO+Qpn46E1haqSAxu84Q8z1v8eNGSnFddMx19KdmTCV3RTMY+SKaDdGRPLswOcuSpGTwB/9IDboeXjJlw8gndmkgA3c7o097/Cd/+zzENmmn02X3kHeYVtQHt+K89Mw8MvCFTm8DR1fzs1zYzSlK4DPeKKR9yapD6rsQZLJv8EXZegQFrdycCt1O77uAihRXo2AyDd+vh3eWu0lWcivz9MMlKw0INpQlathsISiqOx/+8Wl3/6YJAvs3w7PTRBZPgLL+AVaFk0EuzcQGJZl66dSwm0677ybQ/yizhZlHbV4Kfrgq9SZl6h87G5omaVoFEZsX6UWFWTULSqZ5MrgVK0tqZ0NXVHQeJXmZ1jGFFSobStFVPB7pVthNWpScThaGSbY8cH/JZEbhXhjKs0RfGmOoyxXWtscfDX/gu1iDoNJseSb8j7FQlKEmg+G20CiDK5olrVhJV1cuW9agLzL0/kv6mwhFIDSWe44mRNethlM1BTcHuODenTCGN/Z6x5NpHpgFa4wF184QoRRguJXuLnIBADOLEKcVKm93o/NO5O/u0ldr6laSXGEYOBIvAA/NBnm/eThKLnX5w9arHecHFITl3WBjp6Gn/kAN316n8ENqwApFbN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(39860400002)(396003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(2616005)(41300700001)(6512007)(1076003)(8676002)(26005)(478600001)(6486002)(8936002)(5660300002)(36756003)(86362001)(2906002)(66946007)(66556008)(6916009)(316002)(66476007)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E83BoWOHaH/NvOMas1piKu7Pm+CwIoJK/16+8hqKBSJNChUL+3pM/DWAf0Ku?=
 =?us-ascii?Q?YOkjNlsrwuwEDy7mn9ReeK7OM1u2gsyiXt0CRvLEPhy4bw3kPJySrvwBTVFM?=
 =?us-ascii?Q?4sXXJmN9SfCf4mK/VMRwGKN0AhfGlTLxUutUMMU5s3shhw81yjn0+8aoiiiS?=
 =?us-ascii?Q?68CLTMXLa/gS2RscLDmze6pJYRdMfVp5WCkbzTEz3qwbr/ydkB30wurDcWXe?=
 =?us-ascii?Q?3onnnqGDYIi2aMoQsSEq14Lj8tIkPCb/iI0VCeRjLrR/LN+J/dvTnuL4lRRB?=
 =?us-ascii?Q?hA+OttsmpgohucR0PeJfsE8Decrn1xlrH2YcLsGjwR8wI2PXJo8TeP0RrOgj?=
 =?us-ascii?Q?wy6BymKvavRVS/+sHIeTDJqXAMdOMi77eW86z6A8FDm4uJn4biQaGa0aNv4G?=
 =?us-ascii?Q?Wshr8zT7EsXuHGuxZ1FSwHsssNLH+xPhXScgx4gJMPtFWrpNLxcQAmXJPP5B?=
 =?us-ascii?Q?fEtHLqygQmtclcPOiyt/7L99gCbtOLKnhMaryAR/1S5jCSHRkARr3NQOho3p?=
 =?us-ascii?Q?kalD4jJK9H1+LIlZGAofVe1fu8LXU6j+L23QWrKJe4q9IcQsiS2I3VI7gusm?=
 =?us-ascii?Q?DS2n+gkBNo+wzs5+hOrDsPB+k9UhCc5IYAyqXBhGfRO7jhNWnW4jlQAUP7jt?=
 =?us-ascii?Q?pnIfsrlUbuCq5ez33VtSFSX0OK0uK7u6ZRWVrb+ql+Hs+oCfOjUEBbk/AXCL?=
 =?us-ascii?Q?61JE/9qsS/fXdGCwhBKC8QUAm5YzxeKvhi6IEBuZgAT0k593J4WEtvLyV0iy?=
 =?us-ascii?Q?mvHornxbikvJVqXcG3oFSE4veOJKFuEGTZPO2N2nacbR34EwnoLMqXxPnN5d?=
 =?us-ascii?Q?HG+poSbucSFsqY2SWRaA5ifS68OUDB2mW36LeeBS5+AE0yc/zH0B7AKXDqZv?=
 =?us-ascii?Q?5FoF1HT0bAhyshZoZ5ZRrFQLR3QOgY70U6icdRy7/61o+jQoaHBmoM2xceyk?=
 =?us-ascii?Q?O/wLRJC4HA0PBkSyzHq08NvhxX8ge3lzKYum7W1gof+FLawoOodl9t+AEsXF?=
 =?us-ascii?Q?CaKR2mjB5JT51cWXnQRe4dTMi0G9K1IpFCo5pF+Q/Psj90zThYbaV3FUvo8/?=
 =?us-ascii?Q?VfRLe9JNwsj+UYvH7eO+N7FwcoE8fFGwkqrq5dric6mdNGMeVrMoSxTnfdrn?=
 =?us-ascii?Q?UzcgL6yN8EqrRbE+pRWNYW5teO15YJ0pW6bUh5m0YiDJkqDlX7YwOb9VhvC3?=
 =?us-ascii?Q?Yy3qTOBheXvfF5780QvMVgvsAnzGMms41DvcOsIuUIGZL+d1PWdL+qZ2Qt0S?=
 =?us-ascii?Q?98NkX2EeBK3Pagmi8In+Vcjffx0Hv1kTMrdbyF6kb72zhzv5YSDXEaGMo0VY?=
 =?us-ascii?Q?ZeaqG/icOC/GCWrBgMDO4fhyFTKnw6+Y9mSJR9Rne7s8vvTMS9+tAPbqZF+7?=
 =?us-ascii?Q?xBC9kFjB1z4px4ZHVovgd9feq17cnS1MlyZNVrKbkKoB7+ltYg7Y5mhbkPcC?=
 =?us-ascii?Q?SO3U9sPf5lyhs869rKQqtYKrHXmH5Wp6r0+wF2cDCFgW4h8fX0T/TP7nIvkz?=
 =?us-ascii?Q?u3JDP127LdAla692VuFDyI9+J0Kvh+iNR0Y2WC67ZHo5XsMjTq6hGiAMSQHb?=
 =?us-ascii?Q?v56rZ6+Egdcg3Jmb1hnyg6UL4YqRCDM9crCUftzuwgrsDo2q0bwOl2Loy0qg?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: opp10wEZ0MEpL6bdhXoLUUHGHoRC8/9na/MBzcr7flOivRsa7mo1GzRyf/2BIu2K1kSJisORDRS8LkweW9oOOvuHvedYXTLAmPkundw8LSiU95GtynbPZQC2wtMJ9XFMyR/hN/wh3XJ2W2r4JbdjweZPjBnN1il9bu/OycJtfXttVQDhTPAekAx+Am5P4szllrX90WPq0TOIbwRXbFeoKGg+re9REmU7uzbC8I9wSmwiftbhVs6lsJByohLbO0RJXLbJIoO6k4WSWYDdKZz0ZUFvyuScAeCV3DF01+7ymcIHAiz+Sy/IZQ9IGMz/snqtM6IIFeUK063ceO8NvR1RnORYhp6SDj4+0Nx4Ys3w3HjZ8cNfopiLaaEcQMir6rZsEprQEbUYG5CdADtcC0wrzvuimjj4s54VR4pt4+ySGe3AOGBsB/n72Mumk6RgVGZ8J6I43Z1QIEgQRfSsqIR2lD/dPpFVBI/uHopr5wGLz6plhNMCiPSbsm5PwSZO3aKBR0GAftn/Rx+Dbw7ft9kE/uwcR3yoP5+TWi2H5uBG68k6aSI2dp88Tqkh5Xqw6gon4B065JF6hafFcOXS6HHLVjSguubINO40fqj3qoabwgvrh12UEiIHpJ1vyle7gO2uBWcmxIn8/t9l16iR2pd8qEqGo/+EZNSymL9q+os0Gjh3TfKdFkEQqnASBuU4URZOS+vN7HRQIQ3xYe8vbo8yU0aaIvJYYKHC1U/OsQ2wtqMjIEgI0Qtg7A5dliwz5nwCenVWJtDGsldRkFAPQZTmnA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde2fe78-26b3-485a-6223-08dbdf607782
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:09:22.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJrec2MA/e8+7ht5qcVQKhutR5soXDF6YMm5lz/jEJWcAuDI3YYt2MnBupGrvcRxabk8kOKOV/M4r+YxGFXBCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070058
X-Proofpoint-GUID: yrvjNF-FqvQx1yZkOz1m_MaqIsInGG-_
X-Proofpoint-ORIG-GUID: yrvjNF-FqvQx1yZkOz1m_MaqIsInGG-_
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
index 105a2f9e..2de177c6 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -459,7 +459,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+		progname);
 	exit(1);
 }
 
@@ -484,7 +485,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -492,6 +493,10 @@ main(
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
@@ -528,6 +533,8 @@ main(
 
 	switch (be32_to_cpu(headers.magic)) {
 	case XFS_MD_MAGIC_V1:
+		if (logdev != NULL)
+			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 
-- 
2.39.1

