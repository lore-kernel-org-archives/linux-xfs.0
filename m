Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1A2C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Mar 2023 22:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCHWit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 17:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjCHWip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2023 17:38:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCFB6284E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2023 14:38:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328JxuU4026697
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=K5nYh1SuT8O+ZbUYUlc9rpC4+vyhu5xR4zFh4s34nlg=;
 b=qOobBHSpWD659zZEuhuxXygk1l3Zfi0mZwaJiD1b3jRMPrFRReOrv1zqNxzKu1a/0NZb
 HwyjjiWN3rmESuYmfBIkgdsmLclDHnk5l4mZymImkmhnJl0lPNRgYEZUCeT8om/roPI0
 hk/51ZWMvpPrxv2WBHGzpxk6m3nkQESosDAOkr7bXmnynxNMq2ob68U8SsbO6mhVtgsw
 A9+OVp34YOqV7VI/NqxOIFYWdGmqdZLQOLpLUBPEAo4x/6h9AKkTytZ9aP0iugSDu9YZ
 5CG2uZoRrScrmZJSa4ot5RhIgETXoXychilL1rJ6mlyArGYLFWmOwIqjtlCMzcXrZaoM 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn95qev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328LpdAY021666
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2023 22:38:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fr9dx38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2023 22:38:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHexzkURXCzak8sTMNlx/y9kdf4ZI1OQMCjZju2ANyUaUtlnvXp7Y6Kor/q/Ci7eeL2uXMcRsmWk3twgvShExFzEgcR8vpNRVrfz/7OpNr/U6Fn+2dmPOHkW7om1oBtuoPl+4Txs2O6U4tEk+Cd9u63DDuh200B6sTqFNObptMpb/WDbzJ/QGjbZE1bIX1Flzbs03zTG2uiBBO0Qu1iziWvbOjcGW1T1WPr32KcpisCwRDkbEv9cbDII/rzZzp6Lwq4lywwO8rSyjy3G4rszITMCVSGoaBMIKjy9jE7SWmseMqOWHbDqnckrCc3E7MWRDxuKj1bIHdX/ig6+6zARrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5nYh1SuT8O+ZbUYUlc9rpC4+vyhu5xR4zFh4s34nlg=;
 b=SROPM6BZCpimGP+WhJBO2XJFr+8pbpbLLPUA+MHwPEHoaVzBRAVskXr9jvPyt19Zz+KI5SHtvivS9HakTjFJr0fqLNRN3cFUB4P47zb1a1B6+LGH3tdG8Gqk8B2o+JWN41qkw/nOnQ136qAYr6uPEqHShMm/2rucQXEmCclIpA0VxRravljdTbhiUCXzHx30nMEGH6TB9XOOpTeMMJ7p4KLWXHtjMWFK1+yqvdFTcI6jtgdSTIf7JB9n205G1CtN7pRIZolk5Jy8XADjKUhH2R9llwnpNbTS1v+3Np/lJgokeRFAiB9Uk8Ti6kTuIhUdRv5hvijtYmZpW68ievyz3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5nYh1SuT8O+ZbUYUlc9rpC4+vyhu5xR4zFh4s34nlg=;
 b=ESUY8F96gsbaXP4pxfhLkqMk4QqkNMUADVd0G2hL6e6ptpjeraBOGv3uC6aKmsC3rILMFM/WhPUtbLo/vgfTDZLjBrg90e+0NlwypLAYXZGEUFEZihzZhofaQqSZ5Xq0QrCMHc0EsCx3BEnLgn1R8ZKIljgoCQHFCPu3kyj9sTg=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN7PR10MB7102.namprd10.prod.outlook.com (2603:10b6:806:348::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 22:38:36 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::2a7c:497e:b785:dc06%8]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 22:38:36 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 22/32] xfs: Add the parent pointer support to the  superblock version 5.
Date:   Wed,  8 Mar 2023 15:37:44 -0700
Message-Id: <20230308223754.1455051-23-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230308223754.1455051-1-allison.henderson@oracle.com>
References: <20230308223754.1455051-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR22CA0008.namprd22.prod.outlook.com
 (2603:10b6:510:2d1::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SN7PR10MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d641a69-8af3-492e-b823-08db2025db14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4OhxCD1BB1yYbbBxYP5hQ14kJSb+RbW5DwF2TesDfYEZDPS8+mkpRTJLx4BKWDvMEEOooobjSHOcCj+N3HVGg4eOufNAUtx8aSu3vggNm4J3B9GOVOuieCFSuPkI5/inyyJhI1rnCLAsrpCwVXY8Dh6SyHXtPKV0xeVCS816q8+zwRyVa5u0gu2s89Oih4Vm0AEhXt6btLa+bFLtw/J7GfO7H82WoRCruuskM94D/abu8Nw10Mnl4vt0QWS7cmDl22+QylzofRm5CabZ7SrY0paR4rW8lkeBXQ6mv0Hx3jz1FwJDdl8uM37UP36ZAet5pllv+yhaCRGFxLXdVlvb7sJNLx0O3FagVyfHB+13BmRER1k4hQvYJMU5dtovTKaWh2r2Dxk9TtHcg2Dun/at1FsckE2In3JBCJLjJo2paWHTF6uBXLZDjpB+ATDZ+1cJgozc8yiy+MWsZr7BYtoIvuPpQepzY9ytQIp9emrToDX8XRt2uJ+fEqEiTT0q1f2jkfuvza5dIMc0PRBwVyTSvzKoBPYNhYzYyIUtE13nWN3XBT3+iInqwzohKTgZkOShIjIV1yqeIzj38bDT4VezvQlgjTeVorPQbhPlBKt6cLhqoL3mBo6pwnlbuqYC+pqVZ89YLrHWbj9NzzfevD/Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(36756003)(6666004)(8936002)(6916009)(41300700001)(8676002)(66476007)(66946007)(5660300002)(66556008)(6506007)(2906002)(38100700002)(86362001)(6486002)(1076003)(6512007)(316002)(478600001)(83380400001)(9686003)(186003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ilhYxa4uegS0/mCXFL+NktX0ewtgEpzJnoPa2nonS4p87aWfOrXqQi03PzVk?=
 =?us-ascii?Q?CEnEqt85Nn1hZ7CTc1hIZATJt6UVRUrrM/QoCPOu4ZbRRKpAPnychEl3cuLt?=
 =?us-ascii?Q?60VblOWjz7D/PeYaH1oN6RaC0fP5a9rBzBZuG5PxkDUAW/3iWRlfKTx8OQg9?=
 =?us-ascii?Q?s13N2EOB4qEeaQjZKmXzQkikkD/v6C64KgRlLLhNY2B18Luo+FUAF3B2evJ2?=
 =?us-ascii?Q?5arigySPAUNYtTrCq4hbg/H2/+Mdkg45DsiGAf3uVs1lziwndvb8MCqyl1Ps?=
 =?us-ascii?Q?lXbsDaRl+9juoNp6bLXx32xOcTar9+S0aBmD+fk9JDBBmNckfdzMZyER3QjZ?=
 =?us-ascii?Q?6o03hX2rzIv2uVDv7v/66wYFDJF9qjjkD460uPdTFeMAnD8Caxg+ocEp+JY7?=
 =?us-ascii?Q?qQ3bFSzLCVz8FxqfQSgND1qD2QPCAYXn/NSF9uwkLQFE6fnhXpJksv2ytdkG?=
 =?us-ascii?Q?4p1PWYA77hu1nX3hjpMQq9V81TliBCN4h42Innpoz5rxUv3F2rWrwyFDzEph?=
 =?us-ascii?Q?HKj75rB0vheXpQdj8GD2tEtJxe7F63+9XZsEVyiNFYAbZsB06kF3+VEz88EI?=
 =?us-ascii?Q?BFlcH2RPX8MjBCu/QE5xDA8GUiC+/nRWL9NipM6JUodQjFSfJYImdmg5TeRW?=
 =?us-ascii?Q?iyTXxouP9iuYJBtQo/VcrXLt2PhEZYKlaEcC2OFHji66uEgO2TRT3xAMVpDV?=
 =?us-ascii?Q?7SdoOiiV/+GAkmRi/FSvM93dQyLonLZ20roK6SWtn3LaYL2qm6EwFtUlknvy?=
 =?us-ascii?Q?nIM+FBoCczcEQh9hhHyXikZHxJ0NgGPifi0XKnibjfJkMc7cUCXyxtkK3Z16?=
 =?us-ascii?Q?3FRSZGJmWDONjbOO7JPdMH4T4+PT6SEG10Q1lKjkea6G+AIvf/nealzQdKpJ?=
 =?us-ascii?Q?CcWpxH8wBpu/dM8rZyijuJyiHmoqe4ykL7/iROneb7wNVHixeh7vTiRiVtJv?=
 =?us-ascii?Q?XNng5VRLT4xqyVsDfJK1sftWcZ4Jllonr6vRFBkpksK94ANX6MLK6MVGv6G3?=
 =?us-ascii?Q?m2P9xRABADh6DZxHb2543Qz6h40wf0nRx3k4VTABmitnL11v9nXn/1t/4PYo?=
 =?us-ascii?Q?H8IpAPjor5tCujnz7jkNRHG+7GJQdA2P33eSZI1L3oziEayfUNrdWD6a4pqH?=
 =?us-ascii?Q?1fVlSeCn7/cjTRJ6vURsDRq0ayjwwQb2IWEPLES/aw9+6fe2hyrY7/8LtGcw?=
 =?us-ascii?Q?OoVnX1bhc+qm3r/Zj+ptrjace9KfxxKaiGF0gToPF0YHHUSod1IDkPNMsyc+?=
 =?us-ascii?Q?zWziJC3Rp10RWbo3Rj+GOKnjFaMSHovRdpeeuzIP3JMO/iFvkJ1+PGWFmxMr?=
 =?us-ascii?Q?17xakLnRGC20RJFngVhilXATucBRPJo7c0I1fjQDEQ4FDr/Txxbopd5x5WJb?=
 =?us-ascii?Q?OwVRIkkVsIXCy9S7ygvwZM5UWkfC6c/K1nli/T+UCPd+7XgG4arzoF/vas69?=
 =?us-ascii?Q?EhsFlaqG37hdLlG40xys9fjahbSTFFAcyE0yhjfzCGSvXWC65I6ok8kw3r6y?=
 =?us-ascii?Q?blMtREtnsAZF3bt3sgigY7V54gNpgst7aoFPraVh1ZbexyDfyUi6WqUVJjI/?=
 =?us-ascii?Q?Y0aC3Mv9NChhMPs+FGP0XbGzreNCoZD63pwm1hKkvP+goIhVaSyDKkupVmAK?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ttUbgqUb3PCM6MPAyrHxyPc/BNb9QGDH0HUhiL6dHlJ+qRxk0tIcoM3HITBySx0kgUejdgc1NleBoN7MGCgpKqaTIg8qtM22YihrP3zr/O1e+tnSf4P7pkQcU5XtDOOWLRm84YF25lQ/vbt2Glh7QVFMC9n47014+adlyj7B+0eCaSjGZHLiBwGcKwnaBf3yCPSI5e9i0JY7aWPEMiC/CdZusSgBlKkhx8x9APRH4I+atdMoKJM4IO5fyOTx0JAbFDvpKPNn6XsST8JMDwAOXEdRqOY+smcMs9yQ5lVxVANykAw1UMphy8KUVkjN/SJ3peFh9KORy0YuCqKl8XYn62GCybeTEUgOmyLBo+65H7t3j093HMzhhyLJIaY/9tHfrjcZnerTM6NHPY3jtdwkDjRy/Vs5j69Rquw4xiMraYtxsgSlRXOH88rM20coriisFjSWJbIolfKR5kGX6TMX1lzWHOknHp6cjumaGkjg14+swlMc074YcuHSnhi4ubmqqILZWTwmcahjVJ2u0PaNTjUTuErztnvFsWlysEPNRg1rCBE0huj35S1NAFdV8mmYC+GuiGrEwiriMqoPp17iLjeRL7IQiLcjvsCMrTnWGUorm+lyVHg8hNQiVDcjkaBs9rNJA1ljdgdQPagTwKcRpdH4gEm/IbHGCZaeILUS9hqoABVQcu9QghqMr39ZAsDfS6bHvTrr2C5jAt6e4VRy/3eMAmcNH9FgMJ+eqKkSUuoKDVVHOdmRIGoSS5YE/XDIxR0GGv2mN8uFTYecqntjyg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d641a69-8af3-492e-b823-08db2025db14
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 22:38:36.7472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yp26UYhwNdOnmmkPF+qwzSwDYupV/nrqP45Qarl+BeE/H4uXk49QBHMiTxrMA7gWYm/F59Ycx+rLgiDaejdP7J6+I2ZOCYdGksNz8qBraIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7102
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_15,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080190
X-Proofpoint-GUID: aj7s2rWr5E7tV7y4LU4NNsZIdNqoHrC5
X-Proofpoint-ORIG-GUID: aj7s2rWr5E7tV7y4LU4NNsZIdNqoHrC5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 4 +++-
 fs/xfs/libxfs/xfs_fs.h     | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 4 ++++
 fs/xfs/xfs_super.c         | 4 ++++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..f413819b2a8a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -373,13 +373,15 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
 #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
 #define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 6)	/* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
 		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
-		 XFS_SB_FEAT_INCOMPAT_NREXT64)
+		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..b0b4d7a3aa15 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit nsec timestamps */
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
+#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	    */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 99cc03a298e2..c47748b95987 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -173,6 +173,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_NEEDSREPAIR;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
 		features |= XFS_FEAT_NREXT64;
+	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_PARENT)
+		features |= XFS_FEAT_PARENT;
 
 	return features;
 }
@@ -1190,6 +1192,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
 	if (xfs_has_inobtcounts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
+	if (xfs_has_parent(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
 	if (xfs_has_sector(mp)) {
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
 		geo->logsectsize = sbp->sb_logsectsize;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 69ba6569e830..a0212622507a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1674,6 +1674,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
 
+	if (xfs_has_parent(mp))
+		xfs_alert(mp,
+	"EXPERIMENTAL parent pointer feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.25.1

