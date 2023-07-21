Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D1DEB64DD
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjGUJqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjGUJqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB94F0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLMVvf004927;
        Fri, 21 Jul 2023 09:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=AwujAh3NfPykF5yy3WtLDZOtPVxeYexAuRfEtIY0U7eCsE/cLUWl6EB7IX9lrmxD5eAT
 Kra27HPpULCDxpuGOt9F5B3atO7tyfSjf+220SSt39YmDIUt4vPli3hbA3zyu9y4k/2E
 B7xaDsLBNJ/MX6xm015PGyX+gEGSzMXPskwQQwiiQQEZqqPzyb6NH9bp8yJSmFI9hFAm
 19wn1XvoUzjJ+vd5X9CLCAPS0pW7Q4aQzNz5I+otimoi8tntpPLK5Mggw+5kodhI2wh+
 GM7CwMtHUzwwiaMJk2+oyz6COwp3N39cfGNW4QqWim0U3DYUNBQj1ZHg/xsWrHrQQ44z ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8abmy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L8jPEN023834;
        Fri, 21 Jul 2023 09:45:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa27dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:45:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nz9Y6BArqywlx2hOYR/3L3SLH+i7v0E6IJaadpVh4glLtLXk57nZGtnXU7d8KNd2aKS69P4KHsRX9uefVdBUcppisdQjll3sHwHAn0G2fRiIgdvxC78CKGRM5E+icPdAKYhW/cEdEBB6evMuWbJ6Rl5rHGj3KQn626wy0D4RTovuhJIvn8pI9Pc42KKxPXm+RNAyULPh1sCAADuoyIAo+Kk2pIw1ACrR8cs8qT+wHkaL+BM0JLGj2Ix6KajzM2Oxwzk6Sq/Xa9smDaidrurwGcjE1mhxLSLoF+y7LirIfs68L7zIVrGe9PtMY+UC+5pdSLtg5UK0JXQ3KHZzGYoLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=JPJJVW84B1UkWi+rQk18ei1RMkwSwSG007NrmaCzQXuOHmBo6y6vOCmbmhH5VZ8tXSjbm8BwqCYqkql4O476gJRn7Qn+o8l8SqHB0aRJJJkmehX1QGPQ/35ECmqi64WsmD/P0jfiIWlKdetT8HWTNNkgPR5Vjl0t0FgSHHY3ql8d4+87eOC9omzwo/Qe7LrB9LmvuG3Bb74RLqDp1fBJDt28XAn0Pmcd53/nyAoCKW+r5Xn0QAUm7UENtvUb8DaXIF/RQFTzW/1HbFXxHcqlpDTnlOPuyXRWMI3e+DSm/H7vt8y2qph5oi+y2oonlgw0BmCLiIBT+7YdE6gAqLXzjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=OvRuJJZ/44mt4IxekIYlL18f8SJHSMS7OhnK1mocnTfp/wPPSDq2+DRRrRg1gkF8HVSlghCaiYFb6xL2Ke68z1GrL97aR2KGZUTlNMo6C9EU/r8b0YWmpZklQaEVt5+ZjtxyaGFm2gPA/K8i1DL1w6V5rxBWTElVXOAkcuo73dw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:45:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:45:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 02/23] mdrestore: Fix logic used to check if target device is large enough
Date:   Fri, 21 Jul 2023 15:15:12 +0530
Message-Id: <20230721094533.1351868-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0179.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: de8e1afd-e6a1-4add-6c1e-08db89cf4857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNkpKg+EgDAHnQRcy7y4xEecLJv0nMM28SsMlQ4bzJAJBZZXyzabm2mRT8Lyjni3NOX83bKvqQmkP2H+u2UxcgYi/gwFIgYzbaXhYNMl4lRe5teGswKoN2WbfWredmgNdCc13v5NsncV9ruEiSg5rl6kxmBm5ycntg1J1Xt97n4SIQjqlr+fOSFQ+vWYouYYW3I8LxdJoZByudVFMIKVe2oXgvOQea60CXsfNFmyTO5pVNFta2eL3mGNdkMr8aDVxh6fnR5QDI+IktAxKYASwcNPa0lVg4xhcxWOk81ooQzKqSlG3AXai95GttQ5eVg5v3T5u+vbULCTX+aw73KduAzBOMP581zbVzUn2iI3jJHITORmbhlbA00Qol4dAbWKp6ahR4dD+lr6geKZhbwuPKrvTeQdb7L1ghVow2jSr1p8uW2mjG4r1R/Bi6XztiJ1+4dVVXVHS3EUVauaeTJya0A5JfUBtnkT8LXnsgiZe4LAWbcYN4GyxRQYE9EGW1SWzr4u4+9fvXA7PNgU4mp2wtuqB005LJFt4HO81Yx21XPAvkvPjPy00ri881ySS2G3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6666004)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(4744005)(2906002)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UOrX7SRNMMsASLUf6FYg4vSwH3++7UZ2uSLvLzg9HdWAgkT8k82hltRFg0FR?=
 =?us-ascii?Q?S59M1uhJUMJXVZFiwwkcUcj0canEYnXxmLf0+yUkhy2NIypOaYK5swOvkNrI?=
 =?us-ascii?Q?VGfCSfRrv/fwvwUZOcIruiyTPBIlJOG9fhp3uWkUEWI+ddYSff1zN0D+pC4m?=
 =?us-ascii?Q?rdEPC6JE1B+E9jl/8eSEpuZeKiJNCP+EadIzy92NpIbOPuY1s59Pyei50Ggg?=
 =?us-ascii?Q?66F+5EOQRDV4HO94IAeaddZgO65lz0x1eIX1ybC3YKMN2vGYxv42k8SIzNAP?=
 =?us-ascii?Q?/SnXzSMrIy6DYx6jkwJxomBMYQ4UZalP642uvpu84enkf6ZwGnIXHsUdaWc5?=
 =?us-ascii?Q?Mp3QKZ4OW4hqoE4x4TpcFDqwcdcrvictg3uoYombSz7IxsRE+x03DvFWNSV3?=
 =?us-ascii?Q?6pu/WnWSDnnU2vZ/xVA6p/iIBHH/2B+yAsVSzztvVnqjgSrEORbhQ8qjkEHD?=
 =?us-ascii?Q?jy6LnsNd/1AcTBSmCktAhVsBsGrfEd1KdpdUpwg6FvsaGR4ZVp4lJwVEI6uB?=
 =?us-ascii?Q?ypL96TtuXhUe9mHtIA4EWh7dRk6JbYZ5MJXdb7V333F/ZOeCk4pobkqNuokq?=
 =?us-ascii?Q?uWAqkIfvsyLPzxM2RJA8jj6P/aIFUMlZX4+LKufyPMcrzNZviF/9HgVrSrSJ?=
 =?us-ascii?Q?R4f4BM1peVj0VRiit1r0CbOxexqbB7XBm4wS99aYvdv8eNbWKfhP/+nmub98?=
 =?us-ascii?Q?xSSryy4+PPbceMM3idudgzkKIrIMBcvW3xDgCtthafUHdKOdt3+w6GVfmEb0?=
 =?us-ascii?Q?Tl/33EEPl1lO27vUars4DGQQiRAPF3rFhrq4MrQPiG5SPe+qlql71OaQ6yYy?=
 =?us-ascii?Q?wnZLDRFOVBiuV8M7fsyuuy4BvoewSbivFq7i1WZbAE3z9F7MYknJJC/ckk5O?=
 =?us-ascii?Q?XqTFAuwIW8ZTTKPda6CxzfySH7IcaiccXok7q8nfFZ48vXRXVbnbMMWKH+Yi?=
 =?us-ascii?Q?+rT8NsCUcvzAF8q8DmwBap1AbEiKHzv4NYogo8P13H9r8u+TmDlIC6wKuBT7?=
 =?us-ascii?Q?P/BYUKt4MFEAK1wDbzs72IvWtQCrIMIV/O2mJbiMa5Tsu7driH7PBEEDqopN?=
 =?us-ascii?Q?h/Qb49fMoGYLZjFUY8Jb6lByp+bMDVvHBEcSN+x66aYy0lQBWStlFdtaqtiH?=
 =?us-ascii?Q?ndngWiTfM3eC3FAqkg9/ekkkYHRDcIiCF5KlI5d/iI57V2O09n3rbnpXwXD0?=
 =?us-ascii?Q?ZQEY3L7fXZc1Tt2h75DZVNsPRnGOZ0rtQE7LbUKf2PuJahGT9UdTolaXbjKA?=
 =?us-ascii?Q?beZcmlrX36aPh9zm8nhar+euCGQ9QEQxraBsp+m/jNvqBhAUhIQQfrjRe755?=
 =?us-ascii?Q?k63uAbMeiuoH6zjJE44WE/8dTkk15BcYbNvrcHsEtDB2mBaAtMXiqHHJyofF?=
 =?us-ascii?Q?qDEJg9p0SOz4HX+zGwxA94fQSvTuxlmqR9uwx/YcSU5Bhmv0NaGMyfqesEY6?=
 =?us-ascii?Q?E/UMaM2fJ3pAgv0gfqL5U29k/oEm4IMvQpWXOS/zTx3r02A2ff9/opRG9BvD?=
 =?us-ascii?Q?ZTRsKkiiysHQGiEWhqkMEWUfyIQwzVEiFvKiGGpgxqb0XFUsG5z4pwjS4x1j?=
 =?us-ascii?Q?POTBEN54wF2uM8kQUe7gRA8POUV4yzWyntR3l9ESH42R43dt4GNLr0X0SMRy?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V/+eiTin+r3iTBnpLy4RH24Y9mXjVIFpsbgwqBIJbroysPt6ypoGDFx4LDZejJQFdv+2WdFUCGoxbgfbBlolWedmMKaYEkEHl+uMujV+z1bIM5H1aRg/7IOr1sGusmxS2LfA6qqXMfK/5X3cHSrnjXrF+Hsl4Pgrhp7oqUBhmi5vZ8ICfsrcclP2/BcplfPfICxHY3aSqlR++Pli/yqqu0m2Hx96ODVjd+B7zaG+aPEGjz3n+MzGBEunYMj5aiTRk8Ji46dCzu3eyAKPJBFJFCi67GfG5vcg04DysiZN7bgmxGMcXekGDVtHPzR0crMISTEw2csG4Ctwgk5RIcf5RYUDiWSSXO/svRpAKXEcc4d0piuaTDNEOsD59AhisAH/iN7N0QYXcyrFRVf4w6wT+dYHeXs/LTsz2F1NNgdWKvYLnXkW3plb2MEcHGULhvP/NQBNK9NtA/u0po4sGhzRrBhkxRCM5DhWkMix7a/cqypu6GZVpCqeZVX+r6VaA4VHbtSLgLCNvguziKcRXnIVuwItO4fyKIjvPEtkSjntsbPBXfpggnjhhjuN4OtOuSHCtgo8P0nhU3LnU7+M3LLsZW72GdXDUR3KPblfB4NV0fT9ySgAQxYG7ONKg2L1gKoNPN+X8LNirWFzv1uwQj/lE3UxRn07EtGZRWM/1/0+WTWPZLkYv7VfKMcPQ4zw3PM/UWGwUDg3OFcI7JBXQbDNtg5+Kvzq1iQR63O2VD9BWSeNYcacx+ZgUMMoN/UweH6/rJoXY+L676OvOR720rC40Y8JqtyXC0UD8amWLvEuLJA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8e1afd-e6a1-4add-6c1e-08db89cf4857
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:45:56.8652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xN4bchZpebtyDWG1P1qeR5Ts3lk2hWfSKpdl++RVIJoMfcFuBBji3wLZGAQT3Mn76Y72x6Bgr8GGhLUFItOgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxlogscore=974 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307210087
X-Proofpoint-GUID: TvZxfy-RDi1DtqSwgQPJTF2CcNHe9EMF
X-Proofpoint-ORIG-GUID: TvZxfy-RDi1DtqSwgQPJTF2CcNHe9EMF
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The device size verification code should be writing XFS_MAX_SECTORSIZE bytes
to the end of the device rather than "sizeof(char *) * XFS_MAX_SECTORSIZE"
bytes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4..333282ed 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -115,7 +115,7 @@ perform_restore(
 	} else  {
 		/* ensure device is sufficiently large enough */
 
-		char		*lb[XFS_MAX_SECTORSIZE] = { NULL };
+		char		lb[XFS_MAX_SECTORSIZE] = { 0 };
 		off64_t		off;
 
 		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
-- 
2.39.1

