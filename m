Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB87C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 05:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbiCUFW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 01:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344387AbiCUFWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 01:22:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481B93B556
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 22:20:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L3Wgxe031204;
        Mon, 21 Mar 2022 05:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=X2zqbys97A7/j+eq018CVog2y9rX0+4oJghUisq+XXnkpnp20aFyNYCIOFpGNqMyt5ry
 2gwHYMlPXWWSzqrb+/1SGPtoR01fyAUQjnzVdA3p/6VKPDWqzC2SXmRkvYLwaAtFkNvp
 KOC2o8T3UaPUeM5Tond2uw2TmwmWgORQEJNPk/nWMRjg9VTP7D2ownYBcnmm7aJhDLeP
 RcStV/p157xHI1W1NhHsZbfGjpldUZGlp63Hwc56gyIv6JvJSdtxHYoKwstGxO/cv8Wb
 Fp6MHKkWOSSmXDPc7Ux/smq186iA23BL1ynxZ//M3f5/Nbc8WW3GGyClhsjQYv+rK5cf Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0j53m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22L5KHN6163046;
        Mon, 21 Mar 2022 05:20:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 3ew700976x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 05:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKrxyRQLM1jxXTCAJi7Hu9qbQ1pLf3s0W8gS+zoFLKngztDz7YF8djL6Q30On4hqpHuCKIl0WkTL4xsNcIffbmuM78yJN84MHCU2jXzpbzi2W33v81+XeYzZSXmBi1Ot/lOaq0tmFz0kOfEzgv5tc6rZrEtW926VvJ3YHXi1hdIw4ychJks0/eyXLxxw5JmP0aJjClTF5kLD+kzhUcQ08Cw1L1FvihsQQc+kp9RVTwPe2GE3aoTZbAps7pbVHpYmzSzEWKwWcdJ07EKyhVTVltMkurMm2ieNlm3YHCzFoosL4UqshtUnNA7Njds+Nyz8QKrXeCXID5zKwzt7hhAAjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=LewW/uzfabCyxNg6+5qptc8Q8k/3guTfLGiOYrL0bRKPMniU79iKHdmMtqEqURJycXRcSp8+JICku6fNgFe0iWo2xmhaGJMerr42Dztf/jBwZwLWvdbEITpbulUmyax1rjgk2DlXkAaqKij+FAa1AXhrVx2B17z9GaKhivOY6VQzEdLBa9L2D8mgDoWbtrYeY5X5jZkRpuYwHm/tS+vyniI1VfTQDuFU/KIWB3Iv0s52HciEgeJoNQfrrRdKWI8Q69mGcweseEaqSsuzRkoeUxBWwQXreiyafmAVPwvmOmrEOJ5OMLPeN+kRuZ5lawxfJcI/OkHz0TrwPazVzzUdQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xchVTKQTW4IECbvoTNa5POR6is+dNUfG5DRGSLJKnqw=;
 b=tgmST4zfQb1v2RF+e5d1H+ArFsjr4jAzMBKN1tRRtWU/gqre+InYHzQWA/InNcXy1eIZDYdig3Se/oIzxsuHoT3yaFRkyzlRPdZ/ezHfFARVFrXYSeRt3nO77A9uaQqlppRmfu17J2tdqHhX+sVT52Uh165/7DYCA9jd5hYvir8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB5563.namprd10.prod.outlook.com (2603:10b6:510:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Mon, 21 Mar
 2022 05:20:54 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 05:20:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com
Subject: [PATCH V7 06/18] xfsprogs: Use basic types to define xfs_log_dinode's di_nextents and di_anextents
Date:   Mon, 21 Mar 2022 10:50:15 +0530
Message-Id: <20220321052027.407099-7-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321052027.407099-1-chandan.babu@oracle.com>
References: <20220321052027.407099-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78d97988-cba2-480c-a212-08da0afa9246
X-MS-TrafficTypeDiagnostic: PH0PR10MB5563:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5563BE3C4C911BA0A584C37CF6169@PH0PR10MB5563.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oH2LqE9YEzHVTze4QNBHKRs/ngrX7XiZP2juZdGXjLv3JXEmw3QXfN+P+O4OuSI7+MKLVuEZSKlar13WiS5vfjQncGNAepGvmoQKs+YPPaIVrgH6nTpYP7Ovzcm3OWZFnp+jZLwzrVD4hqkIl6hruS676tHDHLKFFIezYmdiXp9xKGaGAmg94A0IkqnShXNelvAKm743jpGaNliBR/oBp5Qi/TNCNmdMRzos4Zdd3U7WWI+sCJfI7J/73LiCAIdSjy/L1VTG+MznlmVsSHqR3wzYK0xz9L481SLkpz0ElObpI1cV7zfsNlOKbV2ny/j0S+1OoF3s+ibyitGFnchjCn9u1I2z/rSaKc0AFQ1xLRECHKusaVoOs55yzFXkP6demi18ROyTc14jbUNRqXzsqaW6DZ3cex2Cs98Z4/Odu/ZJgZC/N7iRtX/8W479bDsttxvHYr95DmheLtjFB651X2j7EE/2RD+EgnQJ+esDrPmzifd8+LzctNR5gWaXmtogeF3T2wLY50U24ZqCtSG8tBHhiCg/mn8KuYgwuB+Vbiku1VouPG+dIHVEksAKK/AqSCt5rNUBCeC8Ba1CUZFHzPXStRIrYugunPtN9ruUibdK3p7vUi+I34NsIMEr/u0LSGMtNpEufVTLAuMaQJWKBXW6oMtHgRelPuV4BooEk+uEK1rCpvXhQ8Gzp/coYLOdI+XQT0O0fOk1g/joZgJ9Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(6506007)(6512007)(86362001)(52116002)(2906002)(38100700002)(38350700002)(6486002)(6916009)(316002)(5660300002)(8936002)(508600001)(8676002)(4326008)(66946007)(66556008)(66476007)(26005)(2616005)(1076003)(186003)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ye4ZqGW5znXlq3x9xITKszxtgyEsl+tpmC4XrijtjzH+s7Oem7JqJYSaXEXN?=
 =?us-ascii?Q?BT3B2iBWFu1VYHiGb6DYFcVIORQ2ud8S4cLlOA+inNLOM2VMx+HZO4ZGX2Qr?=
 =?us-ascii?Q?+dSdMg/5KvvWHbL8R5/npstm1ySl2bqmbmKyvcjHzps2V8qHjLr6edVtprHi?=
 =?us-ascii?Q?aYfge92qvHrGr2UsFFzJUvKHxRNQHO+tHCQ9BdOvBVWDIZIivYc0ErEww1DB?=
 =?us-ascii?Q?sBhXkFa8RzxOpt9vjwbiVO5UMOcu797xbhdF1jwdALCFMxrdz2od+b/hfCWI?=
 =?us-ascii?Q?zERV12POTL0TRz6WG57TjY/12zy5u5mqYG/Bc4/bbLwZi4wPICOhnJwqR300?=
 =?us-ascii?Q?I9J3J2owIVI5TzEw5Sa5NjeusO77q4Nlhjx5ePEsIacYVC4e6sEDRZ++t2n1?=
 =?us-ascii?Q?N1V1aaktMb3L6XxRVnm1D6GxgWZR4Is0x1LDOSnipbQ8Wt5pJl0CbO/5SUd2?=
 =?us-ascii?Q?qXj0H1f60XL27bGkF0K33LD7XDGG3kwelbRAsJXZCcYMW4TxzaWGaPXMQySq?=
 =?us-ascii?Q?JJ6t8/ngzFcsvJ8/81dySrl8MuTmToosaecW+zJKz4ZqISQnQKrlmnyUz1qY?=
 =?us-ascii?Q?bkmwp7tGDcSZpwIjp6P5Xq2ULhQZCwUyehCLJ6k8vA/OZsdVb8WqQfbhpQfx?=
 =?us-ascii?Q?9lQxspXhpWFCF8YIgVNmh845g5TFkggzbfqGno6C2ebwWHOwqr04RNcVEgh8?=
 =?us-ascii?Q?xyTlybohKYhSY03ehiIeKmAEtD03GkOBHqgR0fjTJqUTYamCvspuEUSdxXW3?=
 =?us-ascii?Q?3k7oCUvV6F+/UrybgYbeqYFvOLUK0PYkWLT6XUp0ngVDEGBFu6iaBkeB0z9V?=
 =?us-ascii?Q?dJlybLFA8IN+ta9t0nkat6dxvaqhb8zWDCP86ZyertHS++8GsY47+6u8KF6B?=
 =?us-ascii?Q?/knHO+widedRVXEyEkpZKq04FFO381HF1W1a0Ite5xWoLUEATcfCS9+iZsxm?=
 =?us-ascii?Q?OWvDa94Mw59c7sdSR48J6tPqGBgC+CKEe1KfB0cSxoNa3p4P3UH66YjJrjtn?=
 =?us-ascii?Q?s5nYwTXxfPhK5aTQIad8pWdnNW7WvdL8j89aS9EhAvEdyvjgbAnFoD3hmMDs?=
 =?us-ascii?Q?PuYdVUzbuj2bwzTxM+H39xgq3/R2B/5sIX/q9KEDjzFwVMMyH34TeCpfJ1gZ?=
 =?us-ascii?Q?BtHWAejSwBd1pVCD5og7pRKYHHmw6mmuvzgfcb+bp5kB1hnPVyiYDwXmRpgF?=
 =?us-ascii?Q?20nki1LXb6RNKvSeoLbigLDLXFCoob12Hi5TRFoAS+RWc2EQHon0BZx4/VmO?=
 =?us-ascii?Q?bdkxu9nLBJBp3n4j8KpErZByq+6FvesQldrJZjE9HXvlGeCIT5VjnU/LyJAN?=
 =?us-ascii?Q?SUtJB1lmF73Ms0UPAnsUMwrHdeMvaT8ecwn1VgIFBg+/q2xQEvdofBV9yQIH?=
 =?us-ascii?Q?HECNinWDuzCP34I3w6Lkoc3ozLMS0dJlG3Of9I2a3UEGq0nBn6T2UxlaKHC9?=
 =?us-ascii?Q?gZKvxw7V63ziw1YXDLAxcL57HUtLhsVHMvOJBiYmYat4qjUyYNOijQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d97988-cba2-480c-a212-08da0afa9246
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 05:20:54.1363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHCXpj8+H+Md92QKoWC7hP6ZqtKYlOUhJevt7bdxz7dXdGyDyFRetxnYRqRulIBzJU44jmP0Efti6xJ38Ue0Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5563
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10292 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210034
X-Proofpoint-GUID: Nl_iPputTb9s3JtrxF-4Oe0v5LlLm0vA
X-Proofpoint-ORIG-GUID: Nl_iPputTb9s3JtrxF-4Oe0v5LlLm0vA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A future commit will increase the width of xfs_extnum_t in order to facilitate
larger per-inode extent counters. Hence this patch now uses basic types to
define xfs_log_dinode->[di_nextents|dianextents].

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b322db52..fd66e702 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -396,8 +396,8 @@ struct xfs_log_dinode {
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
+	uint32_t	di_nextents;	/* number of extents in data fork */
+	uint16_t	di_anextents;	/* number of extents in attribute fork*/
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
-- 
2.30.2

