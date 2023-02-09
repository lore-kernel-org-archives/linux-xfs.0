Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBC5C636D4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBIICY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBIICT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48170265AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:18 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PgdP024435
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=lxvY9viKEy2ArbqJqa6VCwdhZoAuZNbYYHp3cwl7fphB1Fhk4sqvj7M8fmR7lu20UYOL
 5nI0on/yTtCqwIO9ENw/jslvcTKyF4Tp8W7ytN9/boQfDYUx2DQmAegagKbHRPZDxO7a
 HY2KpVf3x51ZjnpvSOTIo5sv+h5RcrWpnkQO3XzhKRQWeZ6ZABRqYY/FwmltB1Mhq/ys
 xIrDAZjME17g+vrrg26Jfy22lK4iZXAh8MbI2Jdeqo+lqx4hXMGW3p5wzsXcwtMEBUoI
 p78juJW+I+f+RMqdHUwtwOOVkop5hzFPvDj5FT8AkjNUwQu1boQVKniCHe0YLB0GLxOf JQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwua2m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eBvG021294
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dv71-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2o2rbQ1ZpTBT0IlYxhJQ6cO/LdVDWiYWzu6Y4k1dDAiBGcMFhggjNLWlIQOXI6QIJ8G+S5eAi7TFCi0avBTdPm0w5CNc/q8VBqrKT/fJvayWoLuiHTDCMa3t5aVLuWvijQ+KSPtvXGdE9kDD6TF3J2nYJRRClnf78Jaz3EP1c5n+ugeoFbqmjKLVqLV03qT094nzxiEiQEWC/2wKmo6hqqasHrFItGd4BHD9SLeEOYwHJH2LJqqhXtA6KbaJQhcEVw3ZkMj7LoJ+/KYoPAC2ZUN8QajJuI/H4wQrC4XbuW9Z7ICFqlDpomXr9hKwyapW4AKiGUg0vBAYSkr1t2Yeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=IQ3qO1lRZSimXqSPPGqffJNCxL/bktHsXGJaThCGY7OZnOodXmKHp9KN8PKHohUOTPc1kQt1Ec58jxw+vyBW10oQY9c3o8Zb/Ux3xf4Yqek7G+A2DLQ+B5GVF/Z9uBKC/pbDTWdPFnFq2i8VcpAg38fmTxhiRooxGHkOpE5rrUA8Sv4+vyiR7g5+WbD+FpPsHu3TJlkM9cOwNHIBlYDLolhY2s6ChZgrhh8MrBFJwC7dtM8JxAIpR91ginm5Shpudu9jjwRV4ZEILn813lI8eIFaASt/WUVACr8U+Nnr9masasTCdss9MS5A4r5wafZnKdW4MyNx9sWkx5D+XZSG1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GP8mJBw+M/AN5gzsRzuXZkkeJob7qVdrYUi7TC2yiA=;
 b=aspmw0SFyeVO6LtbUw0f/xxR/nbyIjPsSZVDMiqobsM3l97EbHuqO0TDPEbAzmBtBSFZq0YY0NLiY+UHl6WRmOpX2WpBX6auWcqdd3jl8s98uASDg/ZPBgT6P2WNE0b2GXZ3ifF9jg9G3wiDEqdDmUFZq2Vx3TolKYg10ee4RTo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:11 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 13/28] xfs: Add xfs_verify_pptr
Date:   Thu,  9 Feb 2023 01:01:31 -0700
Message-Id: <20230209080146.378973-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: aae65cc1-4123-41d0-987c-08db0a73f28d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5AC+x8HGKnQekBVWe81WGnjeopnyRvg9cI3GMVn0bDD3iIzf3nu1Cv1U9mqPBFYw4LJk6WUNpeZnJE9GglS3U93seC/PB6RpkJygALnvQ7kb6net3WEcIlxC0zWaYta6ed67WqjIuPX+uVbgCmlDjxpFuLI+8NOVGXT79MmNUpvrc6kL70Y13PNrPIc7qV0ofutn5jmQM3/wJgGUvxKoHXMXyYu3MKsenDlyZuCnqb8uhsQunCMcj7m45wJMJthGtHEGtUnprYKd7rE003JCAIZNMtTnGAh9/8apyHZsUqqATYFVCHhHyuPlWN5bbFqfT9DJqM5a1vzH08SK9G9VHoafzU9EEm61L9T4PPaeGdeAltLuS/jLESrwiIrJqnz3pqHVt1K83LOI29QVfh93t14Tyaj3l3tKnc/T28jZtlOehqHVIc/eScNreCsZKuHbpmO38ON8lCwL3nNCy68SRODaoKgMq8OaN2wMVBhiOHZG6tIgESDcAnXwK24VkqKbyprcyF7yhRieWfKpDwfx+diEaP4mfeLRH3wZeTo3j3VdfGbk+j3j0Q96jF7RkDF+Vs7GKNzU7cpgDAMrsM5Jfs4B74r0WQUnzoqpXdlEHy3jnguLy8XvEoH9xTMkir2aQhw2jo/oWpsiojat6iZZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPV2lA3ebP7Ch66MIG/U4OvgXwLoMoaea30VyETzqktWxuWKcRGk4VrqqXPu?=
 =?us-ascii?Q?fqQP48UYgBwlISfwOUl+/0CoLs9ikQmnYkmqXxRL42G7d0J6sn0FSZ8TEg5k?=
 =?us-ascii?Q?tqbU1cnRD40ZH3UfkCRFmc7FRlgx9uZQUO3uiuBp3CeQc4DqlDWbwDvCqwhO?=
 =?us-ascii?Q?J39cAd/ujhO04AukBViJIOd2RImvbtmys9e6PVV1sFsn6KyJrO7MkCtawrnF?=
 =?us-ascii?Q?zDpWTxh6dGwr1SNz3Hl+P8IgVGzH9AesqFHigex98AKh2VzyeiCcl/yyMbvu?=
 =?us-ascii?Q?KUl/3UP4MJjnJXinh5h00SlNsRha8wTFmLUfZ2tE8WcpnoRd3U0mkmddWIhY?=
 =?us-ascii?Q?LHSI61stebO6+K/69Ny8rjsXzElvhpnRSbiml6PzB1DgVGkIiGerML9Xoh5w?=
 =?us-ascii?Q?dA/HiFii0yis1ox8Ht/wF1JU/WE8xBsQSy6rLfbwgO2IoqcC2UiDC3wvHwfU?=
 =?us-ascii?Q?Fe+Wq9N5YOCSMrC/QL+rYCPXHDXSolYBNhtnULP7iUcrwXvrCklM953DVmPz?=
 =?us-ascii?Q?RlK6BWp/IcB75j8emlRn6Jzvjc2BRu/+XcMsJaGxt4X7iFXrkE7lgFGlwhKc?=
 =?us-ascii?Q?e9nl2Mm7DkKbxm0uR2D35daYT7DpgivtygARpHn1rJw1M0y5TITzmZuL37+i?=
 =?us-ascii?Q?h8Q/YGPZDXkRQYGM45e88ozz/4aTcf0Tk/KiWrHuZtuKZZyhYovXo10mnet0?=
 =?us-ascii?Q?gIqoSsK5WRmEMjFrsfIg/MaeXtUTOedMDz4TTvP/nEfzYJ/sjUtcqc5xUz4L?=
 =?us-ascii?Q?X3uPPc5Io02CwYUB72WFBRpP6qkuOt+69bjXKrXMncbIDhBoRkDsQG8xTWMP?=
 =?us-ascii?Q?Js/P9MgvriA32ZMs98fkIBeUS8/7IrId8W3DfuCTIHs2Fn/5d94uKdcSZMp3?=
 =?us-ascii?Q?8PBzwwBZzmCx+KsGOHOY/NN8yHjYlMORpL4Yf1k34Hx9VGf+mgMk+3pq2k/Q?=
 =?us-ascii?Q?yoBN7T2MxUKqCPX1X2LUiUgHofN+vGrIhQIwX+3nZZD5/xK57wEslru4Kh6R?=
 =?us-ascii?Q?1rir8Ev5+Hg+5Sx0SJSUNEgEtLRdIuTGidU4ahp3USldSVleZbjXtisY7+XY?=
 =?us-ascii?Q?E7WTRSbf+6Jbi7DOMsqLyhbG63Meij+qH2O9BiuYGKb5Wc/AkNg7H37ItJxa?=
 =?us-ascii?Q?nQdNSGCzMBETIomxc4IV5alQLc4h5SGymwj2Wx/bRBXkUizPNVHYbDQHGff3?=
 =?us-ascii?Q?R+VJUs6I7KoHquzb9oSc8Pq79zKSEA/VeAJkIQzsOfJC+cDMO+doYk1gkqNg?=
 =?us-ascii?Q?ldLAkJRrdTtYrIx+5YMPkCGh1tPlMSswI1uMlfRum6rBUknx7Ka8rjlbXd00?=
 =?us-ascii?Q?q0zA5uUw4bOc3SBLczGqARKF9C8OXBgDavmB8/Wvq3TlcKJEkLE5kximU6yD?=
 =?us-ascii?Q?DROXTAQFUx9QbIRJnQma5IsdhQGsa+EYShsdROw698fYRBew7ISDfQNXhyY1?=
 =?us-ascii?Q?KIZ3zQ3/IxGt25omTd2YM8UOSMionEi9K0pDi9cHrKNXbKCXiZTCEToKT0W0?=
 =?us-ascii?Q?dvnHLa7ViyWVK0oz/1jzzPSPI20yYkpbDHAbQJAY2TJZV75joeZv0tuxo5v9?=
 =?us-ascii?Q?C5/T9parGnpiByviaRuKHs50RIWIEDutXQ5cE56f2/9Y8p73dCGlkwz0Qiis?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ordu6Jsr1SF8gZJwRuq5TWyy6SnPouqRgL7u3eqajFFdC5a2Kzldyse3wozNoElNdkXrwguv9IcP3qlEurS2izikYJY6tK4V9/RmbLlgsXG1OI6EhtCVlGgTqQQfjze06b+5CNsuPWWxAU0j/S2E82Xl3HufiB8myzPu9d/lKPtU2Cy9/H4zQ/M/q9yOS8U2y8qCyjt3OqOxcKX5OZ5lvUtMTwzcniD6cxjlwwElqFt+pHpELqWt9srHC8dY/F1ThQQVNIKqJ6sWFlZeyQpnlWqWCSzlUDHzz3aqscwTpch3XbB4irquF6NWiiClDhj8v2XoQC6Iu7aSHpd2kJ7fhjB85o11sJLtRB7d9L9XJ2R39JDWFwUSLcNWkmCFyTeKfdbmONLDT1nSGWAdDySguMMjvJgnIbHgIcIYH/09h398HpG0TqQfELF23JRk47gxAZd0RvbUgSf4LataJ+Uxw4dSGH2VNMX6CIpjtRZL/niGsnVAKKaRd5VZtcTVudPalHvswNsc15chp0dmgtaSJf8fgTu8Y6Gs0V4bW8TMD+ACgWjQZhDcUOvILQoFZ1eIi9pSn0KgP/ejTWaZdHv+jP7XPE1p3yxPcJvLnNoPN8cBGXFtmI+jcIDzPJpm8kH/HPxbmAkioMbtEYCcLvCveEmtRDS9eWcGpyznAD1k/To9bUooYaqAXiv9tSkU9DY/h1qBar7MkkqeKxT7qEyE/ch8lr2+ESf2AiJNSq086H4zkruAQas5fiQmD5eAaSce
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae65cc1-4123-41d0-987c-08db0a73f28d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:11.2126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDngsYmV7gQ1u/+Tlm+jSsI4UCth7aFm1Hs7h6rzywSdqdc8zDaLWfZpuz9BsOtYmNft0PZuULVFd26tuUj2jK5K94iqBslXQmzLpxhoJvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-GUID: fFUKXOeMpQyvfwJogL5toU2on01xSfE2
X-Proofpoint-ORIG-GUID: fFUKXOeMpQyvfwJogL5toU2on01xSfE2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 47 ++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_attr.h      |  3 ++-
 fs/xfs/libxfs/xfs_da_format.h |  8 ++++++
 fs/xfs/scrub/attr.c           |  2 +-
 fs/xfs/xfs_attr_item.c        | 11 +++++---
 fs/xfs/xfs_attr_list.c        | 17 +++++++++----
 6 files changed, 74 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 101823772bf9..711022742e34 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1577,9 +1577,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1594,6 +1618,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e81f3f48560..b79dae788cfb 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b02b67f1999e..75b13807145d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 9d2e33743ecd..2a79a13cb600 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -129,7 +129,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		return;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 95e9ecbb4a67..da807f286a09 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,7 +593,8 @@ xfs_attri_item_recover(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
@@ -804,7 +805,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
 		return -EFSCORRUPTED;
@@ -822,8 +824,9 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(attr_nname,
-				attri_formatp->alfi_nname_len)) {
+		if (!xfs_attr_namecheck(mp, attr_nname,
+				attri_formatp->alfi_nname_len,
+				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..a51f7f13a352 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -58,9 +58,13 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
+	ASSERT(context != NULL);
+	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
@@ -82,8 +86,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->hdr.count * 16) < context->bufsize)) {
 		for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen)))
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags)))
 				return -EFSCORRUPTED;
 			context->put_listent(context,
 					     sfe->flags,
@@ -174,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -465,7 +471,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen)))
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags)))
 			return -EFSCORRUPTED;
 		context->put_listent(context, entry->flags,
 					      name, namelen, valuelen);
-- 
2.25.1

