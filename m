Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A3DC001DE
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 09:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjGUJqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjGUJqc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 05:46:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D90D121
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 02:46:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36KLNJQB003496;
        Fri, 21 Jul 2023 09:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jaydoIx5euRqH98rEQ8yCOLTTyuuHGOKyMbmUexC760=;
 b=FiEhg8DKYv1meGqSEPJu2N3AGo5WLltL2ZoB+bSGpiPKDiwjztz7mbUZpRP5aZlPOXf9
 vpzf8GfJxmEQLIRSflVj1OFt8PyMCJC5K0BZUEQ5u4P2pvqnjQNvls8r+6jZ9gtVk36M
 KhUpR8B6NSVZZpAoQwikZUNnEnbk1vmuHRZszDnfVNM74LGxVb9SYXuswoq1qZLkyt2T
 KbdE1AsMo2DHt7uaOPOcpUebNfWTiWsiaUmgQDVjQxksSuSxvFLvMwAuxiuEIyMEHKU/
 ekYfvThDgjVwrYL4oEVpdkRohlOBtHlEfNV1zg5EmbyybbdAxhE9rUhqYw7ooaG3tN8F GQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run8abkup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36L9SYU2019201;
        Fri, 21 Jul 2023 09:46:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhwa91bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 09:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6hPK5BcRcMsXjtTI5X4EFUVS5pXwO2mL5LRsxd+9r8SBhb4o/JVaeCl/1r4uflSPYx7wjJOrE2Hi+ekM1c+QQE2gabTzsAqOCCj0j9EGwyNoXLFNnXp8MeevVTJdvB0lwLz1ynPxnz3KGVEjF76MdwNk/zRZwTEY0gC/z/ZvWy+aaN9wKiFeBpaHTRX7NV/cJ4+XgJ6hDGFh0OQyENZPFi+ZSmDZsr+/L02Mzm7BjKiFwhHcZtPMhMFPYUI6VdGkBz84u6opMhhbdhmT5rKToZSeGr6A2BYcYDH3Z6je3jNGR7/MtsTCdT+7n+CFWoN+szc7wex2BQpc+NBgL6ORg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaydoIx5euRqH98rEQ8yCOLTTyuuHGOKyMbmUexC760=;
 b=VJ7zTCrkNBnpmFBSMvjYK99P4ECmINIgX+LKhDUi/QJrdVsVyECkxmJQTNyTdRT0UZm3kHNHubAeFMVTa9EoAgILXZJ46B6YRHv+YhnHjSlBQHVfIPwkdSoYcSEfvJ6bEZDN57K7Dy8bpbFswK+ar7Qn4bUiiHGGSrBSHPLyZsS2RBRhBn9qdFke36O0jVc27UX07kr+Gd9Tyf7XavEX5yzLcr0P0k6Wibkav3cgs2g8U9ECmwm99qXVvrZo+++ymnxmu8dJ6BU6JZrwOqYiQnPk7spgiemFRq7Z0GJDoJYsQFTbmKJFOzOzdheSvQyhT0AbNdt6oErvNHiOZR0xfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaydoIx5euRqH98rEQ8yCOLTTyuuHGOKyMbmUexC760=;
 b=lOWLvXjW2Q2FG9zC/djm56Zv+erN+Lp8m++UrO2fNANFZJnbGaP8gJ+PbXHH6iou2jhkAl7A2OJm37u6T5PZrefkdw4Jqqho0WEWdAmie/N+hvcImzZwdLGwXB8OuKFekFFHhy24QkRB64/q2x0dgFmCUa0ifiku6v+tP5ATWO0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 09:46:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.024; Fri, 21 Jul 2023
 09:46:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V3 04/23] metadump: Define and use struct metadump
Date:   Fri, 21 Jul 2023 15:15:14 +0530
Message-Id: <20230721094533.1351868-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230721094533.1351868-1-chandan.babu@oracle.com>
References: <20230721094533.1351868-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0186.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 43432ffc-d557-4da4-51ee-08db89cf4fd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BKqioARz6SZfLdCbgAQkF0tewsBUhYOAqrxZ+4NL9oUp9OrqhV8wvM/bmsNP1dulLwkoQtXVVYhZGBF+tsBBrpk/pCcFNlyP3Of9CzSiO/qpKqCUTQdgepL089TXP9QRG8obZtgSarG9FSGrCh8QwVQu7+w3frOiiVYwxC/YMrR8nYGKARj2tTlvKySM0Id4ziK1Z7F9i7JPjZ89AMsGiO4eMjQcvt4rnckHnzsze6oINNisr4lB0x88LSSAtHOotPGwbzUNKMpY0VGk2+pREFQSsqX6ZBQ7RlhmIO++YFLef6oGewHw9IiMTSD7jDgWT4d7vbBOV5uQTBALVFQ0veqzsfHwTggdW2+sMe0iDciqSrsBD0i2KvW8g8NkLKIsGbZYl+Mh3EGc0B3HLCfkN/e/aUFu8rm2tPGOR4A29k5M6GYMV80mnLHKOIL1O3xdcRQuNMKrzRfdsfotz1kjGNxY/tzCXX5MoFxqo2XrFxfu1btnlSYm/QK70KLYuhetLXq5UA/0XSCbGThchARUAHTnqOBOBSTd1R8E1HJhZQO9BuuxPrc+PzF1kFyAJi4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(6486002)(6512007)(83380400001)(36756003)(2616005)(86362001)(38100700002)(6506007)(186003)(26005)(1076003)(30864003)(2906002)(54906003)(8676002)(8936002)(316002)(66946007)(66476007)(66556008)(4326008)(6916009)(478600001)(5660300002)(41300700001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ta8+0ISEWcBKU2saktrJe7c5xvwpJ6q+8ga2fKfs/5fO9qX8POb2Naw+zyoC?=
 =?us-ascii?Q?344k+GGrrn0BQS6ZipMHyO9lvHAFNYfuALXM1XpRcPIjjB+oCncGdAhWrExm?=
 =?us-ascii?Q?fQI8SQZ4DJKk6yKE5Dte0VCa7PIjXIU+lAhS23aQBf5Z0+jy4vCUg/nX4Lvh?=
 =?us-ascii?Q?TpK0v9tYm/YdPzYsMCt5fSeVC9jedYqGrhWg2IxSMwY2UaGgRlKIbH+h//0E?=
 =?us-ascii?Q?S287fgvE20Tx37mRFk1RWwpi+sE1n2SWrAyev6VcP4MIztD/6Dz0lUNL56OJ?=
 =?us-ascii?Q?V2fHeoHdiu7WGYbAloHblgo1Iw4T06YjD+FE09cClWc0tz+18m4lzmCTW04c?=
 =?us-ascii?Q?XILMBkzRseu+td/IkElxSn7DMTnXHzFg7Tbd1o/OKmFnuc+thGByWJDlGdBL?=
 =?us-ascii?Q?xrhW99Qt3PDtSqt40IA5/4IQBdQovTmu5gmcxCAikSEUNx61E3eZuK3iBUFH?=
 =?us-ascii?Q?xhlSMcaBKqnILuuuXsrwnivu3lwaEjhWZxo3tIZPY2TeyOefDVLq24UsEvzb?=
 =?us-ascii?Q?PPw8kgUkrvvwv/pwybG6Vbp6ncKfJcLi4Ni8TlprVjOH1bEvbP5keh99DlKI?=
 =?us-ascii?Q?MD7/4amstoxwBom0LftDAaRzz90C9qbYfpQV4AVstaTHUY7IEhz2PQNsjRSc?=
 =?us-ascii?Q?/KowOHmTe+fud31NK1C+p5TvYHX+CiYMaY5YfS0pZl4O2pXUH2+aDoSny4lE?=
 =?us-ascii?Q?38/qINeIE4vtELLHjUETDkMraQECncVQzPifv1eHow9T64dubJDx1BNFsLa3?=
 =?us-ascii?Q?2wwJuuOyuYWG/xs9SWcpHcPbSg2mjD8GvChfYd43MGqsPltRP/AUdmMRToGZ?=
 =?us-ascii?Q?PJRAuHNI9MIubDv10EipAY2sbnqwBr6EPNt/s9aeH3sercHXDTCmhC+cQGLe?=
 =?us-ascii?Q?zSk257rj1aEcuVFHa9NKIhkUwnkbWm4bmUCboy4cwLF0WGE9mjXQWtoQTPmM?=
 =?us-ascii?Q?1LLRzRJC+GUm+vJn4Mr+u+9paGfmxMOC1+fier83J1uSUP3+zI37ANPPUVCn?=
 =?us-ascii?Q?tf//fGnERT47uLjT6NoKvkcNaxU042M0+vzyyPezG8odvj5Tn/4/ClPiI0KI?=
 =?us-ascii?Q?oeBqLtSpumdEXKEi5zG984QPxo9UwLNogr6sFp312QbCAs+LRoAOtSHh6OnT?=
 =?us-ascii?Q?l6XAqLV0mfOwehghQccLPxT7hlDTmGTytWDZta9qs9VvSwmkQYfXsc3L6orn?=
 =?us-ascii?Q?BVzYBO0X9FZ39XN9AiZD4N4D/jBaTS253z5OnN5RWnXW/j6rVUMzMDbYYO5A?=
 =?us-ascii?Q?lFnTExuGDuLiupQKV9CgE+0lkuBER1mrzFqEzhivw50fyVSwkwsT7ftM/iWc?=
 =?us-ascii?Q?FW9RBYfoN24iaES89iHpTGv/WTKlKTbg4n6cYcSZAFDPF7Hv2c1kl1z3Y1X3?=
 =?us-ascii?Q?Wn3AKHli4DAjJdUykUDH/IaZpRgbLdYoMOCQTzh4NtSrKmtUwjQBBlyFIZKP?=
 =?us-ascii?Q?RGk6dhBi2uAVVwggNQSqTLDTlYMlvVo8pWzknYOl7CDB52RxE3UghrmulK0x?=
 =?us-ascii?Q?NqF21RwB214sIN5McBYhcgwBzsyOImvYqHXDdb2jqMfW/ygeOww8dbWoGT1w?=
 =?us-ascii?Q?nH+0ywXYZsRZ+u5ieHWLa9LOR5lQ8hjjc1h4n9if?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0+nPdF52ypKnauZtPbf2hoXvlfHXIiRm6K5gSzDSyim4DyCp1/gMRm/oXs4g4UfxTrpwrXfxmDMnXMws6z20UM6UBXXtw6gjSznKoImnzZp1uUOOFffiqH5Opmj6RpCbkRA7zz/7TC2U2KGbHOHloXQeVaZ3ZkCNWUqkXAlXck3qc/tb/D+ITxJs/VlkWVUgG4cw6C2AzulgrYa0Rt75dNeTEwkn6IPKcb7xnzcmlH5AH2MVOc7wthq93UwPvGHjy/WKOmMS0vNbK8t21B0bP8sFEm63v91Zz3OoC7sB/tJfUN/RG3dE1Saf8viyDiES2cc2t/9urp6HE0b5XOKJYkdci675fwha1VTNFCmeXsL1WaMZ0ybc4YT+rGRByPbgtNl+SjHsxnATHJkvX7oLfWrsTcir8S1MWpjHsfFGhCLCJ/3DXcQBIUVLtNFgGNfHtISrGiun1a4rb7zvkk33i+Ba8gnm+A3JOm5fbRfO4XcPdr7LdDd9VZb2fFdMZLsB0MnTelzkf2/lozVatQFFloC26vYZoDrkfcowvwIBZ2wRW7v0gE14wo0vOrQo+NE2RA88JXZmELVUrRD0T+h77eWo5JX/q1moDeKsD2cI6vtjtRFe+FXdTqZU+RaS10ShJBmQU/ZeXzL+XCLuhGEolamJSRJlgmYdun5GSEcBpTyit9DWALb2LgF9VBwhyhjbf5CpluImrepNF9aVpKrlZVKbnPO5r1bNhJwooAZp71w9v605rn2R/s4vdyWnxQVNLLjmQduyFUe4QDN/e//bqfmqCdhXNp1SERG6SHcudLJeC75/o1i0ZudcVdq7Cpfm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43432ffc-d557-4da4-51ee-08db89cf4fd6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2023 09:46:10.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57qY6ag2ZZJH8FVe/voPzzopbcaeE6y6Ktz1EEvvhD5AvHfgQTLPvEuU8sVJ7wQa8E9LFwJPA0DFJxg70FKwHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_06,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210087
X-Proofpoint-ORIG-GUID: 0-6-2WWiOEtGC9kFLbEMpbLS0kOlqDsC
X-Proofpoint-GUID: 0-6-2WWiOEtGC9kFLbEMpbLS0kOlqDsC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit collects all state tracking variables in a new "struct metadump"
structure. This is done to collect all the global variables in one place
rather than having them spread across the file. A new structure member of type
"struct metadump_ops *" will be added by a future commit to support the two
versions of metadump.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 458 +++++++++++++++++++++++++++-----------------------
 1 file changed, 244 insertions(+), 214 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8b33fbfb..c24947ec 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -40,25 +40,27 @@ static const cmdinfo_t	metadump_cmd =
 		N_("[-a] [-e] [-g] [-m max_extent] [-w] [-o] filename"),
 		N_("dump metadata to a file"), metadump_help };
 
-static FILE		*outf;		/* metadump file */
-
-static xfs_metablock_t 	*metablock;	/* header + index + buffers */
-static __be64		*block_index;
-static char		*block_buffer;
-
-static int		num_indices;
-static int		cur_index;
-
-static xfs_ino_t	cur_ino;
-
-static bool		show_progress = false;
-static bool		stop_on_read_error = false;
-static int		max_extent_size = DEFAULT_MAX_EXT_SIZE;
-static bool		obfuscate = true;
-static bool		zero_stale_data = true;
-static bool		show_warnings = false;
-static bool		progress_since_warning = false;
-static bool		stdout_metadump;
+static struct metadump {
+	int			version;
+	bool			show_progress;
+	bool			stop_on_read_error;
+	int			max_extent_size;
+	bool			show_warnings;
+	bool			obfuscate;
+	bool			zero_stale_data;
+	bool			progress_since_warning;
+	bool			dirty_log;
+	bool			stdout_metadump;
+	xfs_ino_t		cur_ino;
+	/* Metadump file */
+	FILE			*outf;
+	/* header + index + buffers */
+	struct xfs_metablock	*metablock;
+	__be64			*block_index;
+	char			*block_buffer;
+	int			num_indices;
+	int			cur_index;
+} metadump;
 
 void
 metadump_init(void)
@@ -98,9 +100,10 @@ print_warning(const char *fmt, ...)
 	va_end(ap);
 	buf[sizeof(buf)-1] = '\0';
 
-	fprintf(stderr, "%s%s: %s\n", progress_since_warning ? "\n" : "",
+	fprintf(stderr, "%s%s: %s\n",
+			metadump.progress_since_warning ? "\n" : "",
 			progname, buf);
-	progress_since_warning = false;
+	metadump.progress_since_warning = false;
 }
 
 static void
@@ -118,10 +121,10 @@ print_progress(const char *fmt, ...)
 	va_end(ap);
 	buf[sizeof(buf)-1] = '\0';
 
-	f = stdout_metadump ? stderr : stdout;
+	f = metadump.stdout_metadump ? stderr : stdout;
 	fprintf(f, "\r%-59s", buf);
 	fflush(f);
-	progress_since_warning = true;
+	metadump.progress_since_warning = true;
 }
 
 /*
@@ -136,17 +139,19 @@ print_progress(const char *fmt, ...)
 static int
 write_index(void)
 {
+	struct xfs_metablock *metablock = metadump.metablock;
 	/*
 	 * write index block and following data blocks (streaming)
 	 */
-	metablock->mb_count = cpu_to_be16(cur_index);
-	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
+	metablock->mb_count = cpu_to_be16(metadump.cur_index);
+	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
+			metadump.outf) != 1) {
 		print_warning("error writing to target file");
 		return -1;
 	}
 
-	memset(block_index, 0, num_indices * sizeof(__be64));
-	cur_index = 0;
+	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
+	metadump.cur_index = 0;
 	return 0;
 }
 
@@ -163,9 +168,10 @@ write_buf_segment(
 	int		ret;
 
 	for (i = 0; i < len; i++, off++, data += BBSIZE) {
-		block_index[cur_index] = cpu_to_be64(off);
-		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
-		if (++cur_index == num_indices) {
+		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
+		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
+				data, BBSIZE);
+		if (++metadump.cur_index == metadump.num_indices) {
 			ret = write_index();
 			if (ret)
 				return -EIO;
@@ -388,11 +394,11 @@ scan_btree(
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read %s block %u/%u", typtab[btype].name,
 				agno, agbno);
-		rval = !stop_on_read_error;
+		rval = !metadump.stop_on_read_error;
 		goto pop_out;
 	}
 
-	if (zero_stale_data) {
+	if (metadump.zero_stale_data) {
 		zero_btree_block(iocur_top->data, btype);
 		iocur_top->need_crc = 1;
 	}
@@ -446,7 +452,7 @@ scanfunc_freesp(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_alloc_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -455,7 +461,7 @@ scanfunc_freesp(
 	pp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -482,13 +488,13 @@ copy_free_bno_btree(
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid block number (%u) in bnobt "
 					"root in agf %u", root, agno);
 		return 1;
 	}
 	if (levels > mp->m_alloc_maxlevels) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in bnobt root "
 					"in agf %u", levels, agno);
 		return 1;
@@ -510,13 +516,13 @@ copy_free_cnt_btree(
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid block number (%u) in cntbt "
 					"root in agf %u", root, agno);
 		return 1;
 	}
 	if (levels > mp->m_alloc_maxlevels) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in cntbt root "
 					"in agf %u", levels, agno);
 		return 1;
@@ -543,7 +549,7 @@ scanfunc_rmapbt(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_rmap_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -552,7 +558,7 @@ scanfunc_rmapbt(
 	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -582,13 +588,13 @@ copy_rmap_btree(
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid block number (%u) in rmapbt "
 					"root in agf %u", root, agno);
 		return 1;
 	}
 	if (levels > mp->m_rmap_maxlevels) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in rmapbt root "
 					"in agf %u", levels, agno);
 		return 1;
@@ -615,7 +621,7 @@ scanfunc_refcntbt(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_refc_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -624,7 +630,7 @@ scanfunc_refcntbt(
 	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -654,13 +660,13 @@ copy_refcount_btree(
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid block number (%u) in refcntbt "
 					"root in agf %u", root, agno);
 		return 1;
 	}
 	if (levels > mp->m_refc_maxlevels) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in refcntbt root "
 					"in agf %u", levels, agno);
 		return 1;
@@ -785,7 +791,8 @@ in_lost_found(
 	/* Record the "lost+found" inode if we haven't done so already */
 
 	ASSERT(ino != 0);
-	if (!orphanage_ino && is_orphanage_dir(mp, cur_ino, namelen, name))
+	if (!orphanage_ino && is_orphanage_dir(mp, metadump.cur_ino, namelen,
+						name))
 		orphanage_ino = ino;
 
 	/* We don't obfuscate the "lost+found" directory itself */
@@ -795,7 +802,7 @@ in_lost_found(
 
 	/* Most files aren't in "lost+found" at all */
 
-	if (cur_ino != orphanage_ino)
+	if (metadump.cur_ino != orphanage_ino)
 		return 0;
 
 	/*
@@ -1219,7 +1226,7 @@ generate_obfuscated_name(
 		print_warning("duplicate name for inode %llu "
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
-			(unsigned long long) cur_ino);
+			(unsigned long long) metadump.cur_ino);
 		return;
 	}
 
@@ -1229,7 +1236,7 @@ generate_obfuscated_name(
 		print_warning("unable to record name for inode %llu "
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
-			(unsigned long long) cur_ino);
+			(unsigned long long) metadump.cur_ino);
 }
 
 static void
@@ -1245,9 +1252,9 @@ process_sf_dir(
 	ino_dir_size = be64_to_cpu(dip->di_size);
 	if (ino_dir_size > XFS_DFORK_DSIZE(dip, mp)) {
 		ino_dir_size = XFS_DFORK_DSIZE(dip, mp);
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid size in dir inode %llu",
-					(long long)cur_ino);
+					(long long)metadump.cur_ino);
 	}
 
 	sfep = xfs_dir2_sf_firstentry(sfp);
@@ -1261,9 +1268,9 @@ process_sf_dir(
 		int	namelen = sfep->namelen;
 
 		if (namelen == 0) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("zero length entry in dir inode "
-						"%llu", (long long)cur_ino);
+					"%llu", (long long)metadump.cur_ino);
 			if (i != sfp->count - 1)
 				break;
 			namelen = ino_dir_size - ((char *)&sfep->name[0] -
@@ -1271,16 +1278,17 @@ process_sf_dir(
 		} else if ((char *)sfep - (char *)sfp +
 				libxfs_dir2_sf_entsize(mp, sfp, sfep->namelen) >
 				ino_dir_size) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("entry length in dir inode %llu "
-					"overflows space", (long long)cur_ino);
+					"overflows space",
+					(long long)metadump.cur_ino);
 			if (i != sfp->count - 1)
 				break;
 			namelen = ino_dir_size - ((char *)&sfep->name[0] -
 					 (char *)sfp);
 		}
 
-		if (obfuscate)
+		if (metadump.obfuscate)
 			generate_obfuscated_name(
 					 libxfs_dir2_sf_get_ino(mp, sfp, sfep),
 					 namelen, &sfep->name[0]);
@@ -1290,7 +1298,8 @@ process_sf_dir(
 	}
 
 	/* zero stale data in rest of space in data fork, if any */
-	if (zero_stale_data && (ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
+	if (metadump.zero_stale_data &&
+	    (ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
 		memset(sfep, 0, XFS_DFORK_DSIZE(dip, mp) - ino_dir_size);
 }
 
@@ -1346,18 +1355,18 @@ process_sf_symlink(
 
 	len = be64_to_cpu(dip->di_size);
 	if (len > XFS_DFORK_DSIZE(dip, mp)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid size (%d) in symlink inode %llu",
-					len, (long long)cur_ino);
+					len, (long long)metadump.cur_ino);
 		len = XFS_DFORK_DSIZE(dip, mp);
 	}
 
 	buf = (char *)XFS_DFORK_DPTR(dip);
-	if (obfuscate)
+	if (metadump.obfuscate)
 		obfuscate_path_components(buf, len);
 
 	/* zero stale data in rest of space in data fork, if any */
-	if (zero_stale_data && len < XFS_DFORK_DSIZE(dip, mp))
+	if (metadump.zero_stale_data && len < XFS_DFORK_DSIZE(dip, mp))
 		memset(&buf[len], 0, XFS_DFORK_DSIZE(dip, mp) - len);
 }
 
@@ -1382,9 +1391,9 @@ process_sf_attr(
 	ino_attr_size = be16_to_cpu(asfp->hdr.totsize);
 	if (ino_attr_size > XFS_DFORK_ASIZE(dip, mp)) {
 		ino_attr_size = XFS_DFORK_ASIZE(dip, mp);
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid attr size in inode %llu",
-					(long long)cur_ino);
+					(long long)metadump.cur_ino);
 	}
 
 	asfep = &asfp->list[0];
@@ -1394,19 +1403,20 @@ process_sf_attr(
 		int	namelen = asfep->namelen;
 
 		if (namelen == 0) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("zero length attr entry in inode "
-						"%llu", (long long)cur_ino);
+					"%llu", (long long)metadump.cur_ino);
 			break;
 		} else if ((char *)asfep - (char *)asfp +
 				xfs_attr_sf_entsize(asfep) > ino_attr_size) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("attr entry length in inode %llu "
-					"overflows space", (long long)cur_ino);
+					"overflows space",
+					(long long)metadump.cur_ino);
 			break;
 		}
 
-		if (obfuscate) {
+		if (metadump.obfuscate) {
 			generate_obfuscated_name(0, asfep->namelen,
 						 &asfep->nameval[0]);
 			memset(&asfep->nameval[asfep->namelen], 'v',
@@ -1418,7 +1428,8 @@ process_sf_attr(
 	}
 
 	/* zero stale data in rest of space in attr fork, if any */
-	if (zero_stale_data && (ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
+	if (metadump.zero_stale_data &&
+	    (ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
 		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
 }
 
@@ -1429,7 +1440,7 @@ process_dir_free_block(
 	struct xfs_dir2_free		*free;
 	struct xfs_dir3_icfree_hdr	freehdr;
 
-	if (!zero_stale_data)
+	if (!metadump.zero_stale_data)
 		return;
 
 	free = (struct xfs_dir2_free *)block;
@@ -1451,10 +1462,10 @@ process_dir_free_block(
 		break;
 	}
 	default:
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid magic in dir inode %llu "
 				      "free block",
-				      (unsigned long long)cur_ino);
+				      (unsigned long long)metadump.cur_ino);
 		break;
 	}
 }
@@ -1466,7 +1477,7 @@ process_dir_leaf_block(
 	struct xfs_dir2_leaf		*leaf;
 	struct xfs_dir3_icleaf_hdr	leafhdr;
 
-	if (!zero_stale_data)
+	if (!metadump.zero_stale_data)
 		return;
 
 	/* Yes, this works for dir2 & dir3.  Difference is padding. */
@@ -1549,10 +1560,10 @@ process_dir_data_block(
 	}
 
 	if (be32_to_cpu(datahdr->magic) != wantmagic) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning(
 		"invalid magic in dir inode %llu block %ld",
-					(unsigned long long)cur_ino, (long)offset);
+		(unsigned long long)metadump.cur_ino, (long)offset);
 		return;
 	}
 
@@ -1572,10 +1583,10 @@ process_dir_data_block(
 			if (dir_offset + free_length > end_of_data ||
 			    !free_length ||
 			    (free_length & (XFS_DIR2_DATA_ALIGN - 1))) {
-				if (show_warnings)
+				if (metadump.show_warnings)
 					print_warning(
 			"invalid length for dir free space in inode %llu",
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 				return;
 			}
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
@@ -1588,7 +1599,7 @@ process_dir_data_block(
 			 * actually at a variable offset, so zeroing &dup->tag
 			 * is zeroing the free space in between
 			 */
-			if (zero_stale_data) {
+			if (metadump.zero_stale_data) {
 				int zlen = free_length -
 						sizeof(xfs_dir2_data_unused_t);
 
@@ -1606,23 +1617,23 @@ process_dir_data_block(
 
 		if (dir_offset + length > end_of_data ||
 		    ptr + length > endptr) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning(
 			"invalid length for dir entry name in inode %llu",
-					(long long)cur_ino);
+					(long long)metadump.cur_ino);
 			return;
 		}
 		if (be16_to_cpu(*libxfs_dir2_data_entry_tag_p(mp, dep)) !=
 				dir_offset)
 			return;
 
-		if (obfuscate)
+		if (metadump.obfuscate)
 			generate_obfuscated_name(be64_to_cpu(dep->inumber),
 					 dep->namelen, &dep->name[0]);
 		dir_offset += length;
 		ptr += length;
 		/* Zero the unused space after name, up to the tag */
-		if (zero_stale_data) {
+		if (metadump.zero_stale_data) {
 			/* 1 byte for ftype; don't bother with conditional */
 			int zlen =
 				(char *)libxfs_dir2_data_entry_tag_p(mp, dep) -
@@ -1658,7 +1669,7 @@ process_symlink_block(
 
 		print_warning("cannot read %s block %u/%u (%llu)",
 				typtab[btype].name, agno, agbno, s);
-		rval = !stop_on_read_error;
+		rval = !metadump.stop_on_read_error;
 		goto out_pop;
 	}
 	link = iocur_top->data;
@@ -1666,10 +1677,10 @@ process_symlink_block(
 	if (xfs_has_crc((mp)))
 		link += sizeof(struct xfs_dsymlink_hdr);
 
-	if (obfuscate)
+	if (metadump.obfuscate)
 		obfuscate_path_components(link, XFS_SYMLINK_BUF_SPACE(mp,
 							mp->m_sb.sb_blocksize));
-	if (zero_stale_data) {
+	if (metadump.zero_stale_data) {
 		size_t	linklen, zlen;
 
 		linklen = strlen(link);
@@ -1736,7 +1747,8 @@ process_attr_block(
 	if ((be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) &&
 	    (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR3_LEAF_MAGIC)) {
 		for (i = 0; i < attr_data.remote_val_count; i++) {
-			if (obfuscate && attr_data.remote_vals[i] == offset)
+			if (metadump.obfuscate &&
+			    attr_data.remote_vals[i] == offset)
 				/* Macros to handle both attr and attr3 */
 				memset(block +
 					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
@@ -1753,9 +1765,9 @@ process_attr_block(
 	    nentries * sizeof(xfs_attr_leaf_entry_t) +
 			xfs_attr3_leaf_hdr_size(leaf) >
 				XFS_ATTR3_RMT_BUF_SPACE(mp, bs)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid attr count in inode %llu",
-					(long long)cur_ino);
+					(long long)metadump.cur_ino);
 		return;
 	}
 
@@ -1770,22 +1782,22 @@ process_attr_block(
 			first_name = xfs_attr3_leaf_name(leaf, i);
 
 		if (be16_to_cpu(entry->nameidx) > mp->m_sb.sb_blocksize) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning(
 				"invalid attr nameidx in inode %llu",
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 			break;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			local = xfs_attr3_leaf_name_local(leaf, i);
 			if (local->namelen == 0) {
-				if (show_warnings)
+				if (metadump.show_warnings)
 					print_warning(
 				"zero length for attr name in inode %llu",
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 				break;
 			}
-			if (obfuscate) {
+			if (metadump.obfuscate) {
 				generate_obfuscated_name(0, local->namelen,
 					&local->nameval[0]);
 				memset(&local->nameval[local->namelen], 'v',
@@ -1797,18 +1809,18 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
 				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
 				 nlen + vlen);
-			if (zero_stale_data)
+			if (metadump.zero_stale_data)
 				memset(&local->nameval[nlen + vlen], 0, zlen);
 		} else {
 			remote = xfs_attr3_leaf_name_remote(leaf, i);
 			if (remote->namelen == 0 || remote->valueblk == 0) {
-				if (show_warnings)
+				if (metadump.show_warnings)
 					print_warning(
 				"invalid attr entry in inode %llu",
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 				break;
 			}
-			if (obfuscate) {
+			if (metadump.obfuscate) {
 				generate_obfuscated_name(0, remote->namelen,
 							 &remote->name[0]);
 				add_remote_vals(be32_to_cpu(remote->valueblk),
@@ -1819,13 +1831,13 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_remote(nlen) -
 				(sizeof(xfs_attr_leaf_name_remote_t) - 1 +
 				 nlen);
-			if (zero_stale_data)
+			if (metadump.zero_stale_data)
 				memset(&remote->name[nlen], 0, zlen);
 		}
 	}
 
 	/* Zero from end of entries array to the first name/val */
-	if (zero_stale_data) {
+	if (metadump.zero_stale_data) {
 		struct xfs_attr_leaf_entry *entries;
 
 		entries = xfs_attr3_leaf_entryp(leaf);
@@ -1858,16 +1870,16 @@ process_single_fsb_objects(
 
 			print_warning("cannot read %s block %u/%u (%llu)",
 					typtab[btype].name, agno, agbno, s);
-			rval = !stop_on_read_error;
+			rval = !metadump.stop_on_read_error;
 			goto out_pop;
 
 		}
 
-		if (!obfuscate && !zero_stale_data)
+		if (!metadump.obfuscate && !metadump.zero_stale_data)
 			goto write;
 
 		/* Zero unused part of interior nodes */
-		if (zero_stale_data) {
+		if (metadump.zero_stale_data) {
 			xfs_da_intnode_t *node = iocur_top->data;
 			int magic = be16_to_cpu(node->hdr.info.magic);
 
@@ -1978,12 +1990,12 @@ process_multi_fsb_dir(
 
 				print_warning("cannot read %s block %u/%u (%llu)",
 						typtab[btype].name, agno, agbno, s);
-				rval = !stop_on_read_error;
+				rval = !metadump.stop_on_read_error;
 				goto out_pop;
 
 			}
 
-			if (!obfuscate && !zero_stale_data)
+			if (!metadump.obfuscate && !metadump.zero_stale_data)
 				goto write;
 
 			dp = iocur_top->data;
@@ -2075,25 +2087,27 @@ process_bmbt_reclist(
 		 * one is found, stop processing remaining extents
 		 */
 		if (i > 0 && op + cp > o) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("bmap extent %d in %s ino %llu "
 					"starts at %llu, previous extent "
 					"ended at %llu", i,
-					typtab[btype].name, (long long)cur_ino,
+					typtab[btype].name,
+					(long long)metadump.cur_ino,
 					o, op + cp - 1);
 			break;
 		}
 
-		if (c > max_extent_size) {
+		if (c > metadump.max_extent_size) {
 			/*
 			 * since we are only processing non-data extents,
 			 * large numbers of blocks in a metadata extent is
 			 * extremely rare and more than likely to be corrupt.
 			 */
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("suspicious count %u in bmap "
 					"extent %d in %s ino %llu", c, i,
-					typtab[btype].name, (long long)cur_ino);
+					typtab[btype].name,
+					(long long)metadump.cur_ino);
 			break;
 		}
 
@@ -2104,19 +2118,21 @@ process_bmbt_reclist(
 		agbno = XFS_FSB_TO_AGBNO(mp, s);
 
 		if (!valid_bno(agno, agbno)) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number %u/%u "
 					"(%llu) in bmap extent %d in %s ino "
 					"%llu", agno, agbno, s, i,
-					typtab[btype].name, (long long)cur_ino);
+					typtab[btype].name,
+					(long long)metadump.cur_ino);
 			break;
 		}
 
 		if (!valid_bno(agno, agbno + c - 1)) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("bmap extent %i in %s inode %llu "
 					"overflows AG (end is %u/%u)", i,
-					typtab[btype].name, (long long)cur_ino,
+					typtab[btype].name,
+					(long long)metadump.cur_ino,
 					agno, agbno + c - 1);
 			break;
 		}
@@ -2152,7 +2168,7 @@ scanfunc_bmap(
 
 	if (level == 0) {
 		if (nrecs > mp->m_bmap_dmxr[0]) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid numrecs (%u) in %s "
 					"block %u/%u", nrecs,
 					typtab[btype].name, agno, agbno);
@@ -2163,7 +2179,7 @@ scanfunc_bmap(
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 					nrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -2178,7 +2194,7 @@ scanfunc_bmap(
 
 		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
 				ag > mp->m_sb.sb_agcount) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u", ag, bno,
 					typtab[btype].name, agno, agbno);
@@ -2213,10 +2229,10 @@ process_btinode(
 	nrecs = be16_to_cpu(dib->bb_numrecs);
 
 	if (level > XFS_BM_MAXLEVELS(mp, whichfork)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in inode %lld %s "
-					"root", level, (long long)cur_ino,
-					typtab[btype].name);
+				"root", level, (long long)metadump.cur_ino,
+				typtab[btype].name);
 		return 1;
 	}
 
@@ -2227,16 +2243,16 @@ process_btinode(
 
 	maxrecs = libxfs_bmdr_maxrecs(XFS_DFORK_SIZE(dip, mp, whichfork), 0);
 	if (nrecs > maxrecs) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in inode %lld %s "
-					"root", nrecs, (long long)cur_ino,
-					typtab[btype].name);
+				"root", nrecs, (long long)metadump.cur_ino,
+				typtab[btype].name);
 		return 1;
 	}
 
 	pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
 
-	if (zero_stale_data) {
+	if (metadump.zero_stale_data) {
 		char	*top;
 
 		/* Unused btree key space */
@@ -2257,11 +2273,11 @@ process_btinode(
 
 		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
 				ag > mp->m_sb.sb_agcount) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
-						"in inode %llu %s root", ag,
-						bno, (long long)cur_ino,
-						typtab[btype].name);
+					"in inode %llu %s root", ag, bno,
+					(long long)metadump.cur_ino,
+					typtab[btype].name);
 			continue;
 		}
 
@@ -2288,14 +2304,16 @@ process_exinode(
 			whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
 	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("bad number of extents %llu in inode %lld",
-				(unsigned long long)nex, (long long)cur_ino);
+				(unsigned long long)nex,
+				(long long)metadump.cur_ino);
 		return 1;
 	}
 
 	/* Zero unused data fork past used extents */
-	if (zero_stale_data && (used < XFS_DFORK_SIZE(dip, mp, whichfork)))
+	if (metadump.zero_stale_data &&
+	    (used < XFS_DFORK_SIZE(dip, mp, whichfork)))
 		memset(XFS_DFORK_PTR(dip, whichfork) + used, 0,
 		       XFS_DFORK_SIZE(dip, mp, whichfork) - used);
 
@@ -2311,7 +2329,7 @@ process_inode_data(
 {
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			if (!(obfuscate || zero_stale_data))
+			if (!(metadump.obfuscate || metadump.zero_stale_data))
 				break;
 
 			/*
@@ -2323,7 +2341,7 @@ process_inode_data(
 				print_warning(
 "Invalid data fork size (%d) in inode %llu, preserving contents!",
 						XFS_DFORK_DSIZE(dip, mp),
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 				break;
 			}
 
@@ -2355,9 +2373,9 @@ process_dev_inode(
 	struct xfs_dinode		*dip)
 {
 	if (xfs_dfork_data_extents(dip)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("inode %llu has unexpected extents",
-				      (unsigned long long)cur_ino);
+				      (unsigned long long)metadump.cur_ino);
 		return;
 	}
 
@@ -2369,11 +2387,11 @@ process_dev_inode(
 	if (XFS_DFORK_DSIZE(dip, mp) > XFS_LITINO(mp)) {
 		print_warning(
 "Invalid data fork size (%d) in inode %llu, preserving contents!",
-				XFS_DFORK_DSIZE(dip, mp), (long long)cur_ino);
+			XFS_DFORK_DSIZE(dip, mp), (long long)metadump.cur_ino);
 		return;
 	}
 
-	if (zero_stale_data) {
+	if (metadump.zero_stale_data) {
 		unsigned int	size = sizeof(xfs_dev_t);
 
 		memset(XFS_DFORK_DPTR(dip) + size, 0,
@@ -2399,17 +2417,17 @@ process_inode(
 	bool			crc_was_ok = false; /* no recalc by default */
 	bool			need_new_crc = false;
 
-	cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
+	metadump.cur_ino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* we only care about crc recalculation if we will modify the inode. */
-	if (obfuscate || zero_stale_data) {
+	if (metadump.obfuscate || metadump.zero_stale_data) {
 		crc_was_ok = libxfs_verify_cksum((char *)dip,
 					mp->m_sb.sb_inodesize,
 					offsetof(struct xfs_dinode, di_crc));
 	}
 
 	if (free_inode) {
-		if (zero_stale_data) {
+		if (metadump.zero_stale_data) {
 			/* Zero all of the inode literal area */
 			memset(XFS_DFORK_DPTR(dip), 0, XFS_LITINO(mp));
 		}
@@ -2451,7 +2469,8 @@ process_inode(
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				need_new_crc = true;
-				if (obfuscate || zero_stale_data)
+				if (metadump.obfuscate ||
+				    metadump.zero_stale_data)
 					process_sf_attr(dip);
 				break;
 
@@ -2468,7 +2487,7 @@ process_inode(
 
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
-	if (zero_stale_data)
+	if (metadump.zero_stale_data)
 		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
@@ -2528,7 +2547,7 @@ copy_inode_chunk(
 	if (agino == 0 || agino == NULLAGINO || !valid_bno(agno, agbno) ||
 			!valid_bno(agno, XFS_AGINO_TO_AGBNO(mp,
 					agino + XFS_INODES_PER_CHUNK - 1))) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("bad inode number %llu (%u/%u)",
 				XFS_AGINO_TO_INO(mp, agno, agino), agno, agino);
 		return 1;
@@ -2544,7 +2563,7 @@ copy_inode_chunk(
 			(xfs_has_align(mp) &&
 					mp->m_sb.sb_inoalignmt != 0 &&
 					agbno % mp->m_sb.sb_inoalignmt != 0)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("badly aligned inode (start = %llu)",
 					XFS_AGINO_TO_INO(mp, agno, agino));
 		return 1;
@@ -2561,7 +2580,7 @@ copy_inode_chunk(
 		if (iocur_top->data == NULL) {
 			print_warning("cannot read inode block %u/%u",
 				      agno, agbno);
-			rval = !stop_on_read_error;
+			rval = !metadump.stop_on_read_error;
 			goto pop_out;
 		}
 
@@ -2587,7 +2606,7 @@ next_bp:
 		ioff += inodes_per_buf;
 	}
 
-	if (show_progress)
+	if (metadump.show_progress)
 		print_progress("Copied %u of %u inodes (%u of %u AGs)",
 				inodes_copied, mp->m_sb.sb_icount, agno,
 				mp->m_sb.sb_agcount);
@@ -2617,7 +2636,7 @@ scanfunc_ino(
 
 	if (level == 0) {
 		if (numrecs > igeo->inobt_mxr[0]) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid numrecs %d in %s "
 					"block %u/%u", numrecs,
 					typtab[btype].name, agno, agbno);
@@ -2640,7 +2659,7 @@ scanfunc_ino(
 	}
 
 	if (numrecs > igeo->inobt_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs %d in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		numrecs = igeo->inobt_mxr[1];
@@ -2649,7 +2668,7 @@ scanfunc_ino(
 	pp = XFS_INOBT_PTR_ADDR(mp, block, 1, igeo->inobt_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -2677,13 +2696,13 @@ copy_inodes(
 
 	/* validate root and levels before processing the tree */
 	if (root == 0 || root > mp->m_sb.sb_agblocks) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid block number (%u) in inobt "
 					"root in agi %u", root, agno);
 		return 1;
 	}
 	if (levels > M_IGEO(mp)->inobt_maxlevels) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid level (%u) in inobt root "
 					"in agi %u", levels, agno);
 		return 1;
@@ -2697,7 +2716,7 @@ copy_inodes(
 		levels = be32_to_cpu(agi->agi_free_level);
 
 		if (root == 0 || root > mp->m_sb.sb_agblocks) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u) in "
 						"finobt root in agi %u", root,
 						agno);
@@ -2705,7 +2724,7 @@ copy_inodes(
 		}
 
 		if (levels > M_IGEO(mp)->inobt_maxlevels) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid level (%u) in finobt "
 						"root in agi %u", levels, agno);
 			return 1;
@@ -2736,11 +2755,11 @@ scan_ag(
 			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
 	if (!iocur_top->data) {
 		print_warning("cannot read superblock for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
 		/* Replace any filesystem label with "L's" */
-		if (obfuscate) {
+		if (metadump.obfuscate) {
 			struct xfs_sb *sb = iocur_top->data;
 			memset(sb->sb_fname, 'L',
 			       min(strlen(sb->sb_fname), sizeof(sb->sb_fname)));
@@ -2758,7 +2777,7 @@ scan_ag(
 	agf = iocur_top->data;
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read agf block for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
 		if (write_buf(iocur_top))
@@ -2773,7 +2792,7 @@ scan_ag(
 	agi = iocur_top->data;
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read agi block for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
 		if (write_buf(iocur_top))
@@ -2787,10 +2806,10 @@ scan_ag(
 			XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read agfl block for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
-		if (agf && zero_stale_data) {
+		if (agf && metadump.zero_stale_data) {
 			/* Zero out unused bits of agfl */
 			int i;
 			 __be32  *agfl_bno;
@@ -2813,7 +2832,7 @@ scan_ag(
 
 	/* copy AG free space btrees */
 	if (agf) {
-		if (show_progress)
+		if (metadump.show_progress)
 			print_progress("Copying free space trees of AG %u",
 					agno);
 		if (!copy_free_bno_btree(agno, agf))
@@ -2859,7 +2878,7 @@ copy_ino(
 
 	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
 			offset >= mp->m_sb.sb_inopblock) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid %s inode number (%lld)",
 					typtab[itype].name, (long long)ino);
 		return 1;
@@ -2871,12 +2890,12 @@ copy_ino(
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read %s inode %lld",
 				typtab[itype].name, (long long)ino);
-		rval = !stop_on_read_error;
+		rval = !metadump.stop_on_read_error;
 		goto pop_out;
 	}
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 
-	cur_ino = ino;
+	metadump.cur_ino = ino;
 	rval = process_inode_data(iocur_top->data, itype);
 pop_out:
 	pop_cur();
@@ -2912,7 +2931,7 @@ copy_log(void)
 	int		logversion;
 	int		cycle = XLOG_INIT_CYCLE;
 
-	if (show_progress)
+	if (metadump.show_progress)
 		print_progress("Copying log");
 
 	push_cur();
@@ -2921,11 +2940,11 @@ copy_log(void)
 	if (iocur_top->data == NULL) {
 		pop_cur();
 		print_warning("cannot read log");
-		return !stop_on_read_error;
+		return !metadump.stop_on_read_error;
 	}
 
 	/* If not obfuscating or zeroing, just copy the log as it is */
-	if (!obfuscate && !zero_stale_data)
+	if (!metadump.obfuscate && !metadump.zero_stale_data)
 		goto done;
 
 	dirty = xlog_is_dirty(mp, &log, &x, 0);
@@ -2933,7 +2952,7 @@ copy_log(void)
 	switch (dirty) {
 	case 0:
 		/* clear out a clean log */
-		if (show_progress)
+		if (metadump.show_progress)
 			print_progress("Zeroing clean log");
 
 		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
@@ -2948,7 +2967,7 @@ copy_log(void)
 		break;
 	case 1:
 		/* keep the dirty log */
-		if (obfuscate)
+		if (metadump.obfuscate)
 			print_warning(
 _("Warning: log recovery of an obfuscated metadata image can leak "
 "unobfuscated metadata and/or cause image corruption.  If possible, "
@@ -2956,7 +2975,7 @@ _("Warning: log recovery of an obfuscated metadata image can leak "
 		break;
 	case -1:
 		/* log detection error */
-		if (obfuscate)
+		if (metadump.obfuscate)
 			print_warning(
 _("Could not discern log; image will contain unobfuscated metadata in log."));
 		break;
@@ -2979,9 +2998,15 @@ metadump_f(
 	char		*p;
 
 	exitcode = 1;
-	show_progress = false;
-	show_warnings = false;
-	stop_on_read_error = false;
+
+	metadump.version = 1;
+	metadump.show_progress = false;
+	metadump.stop_on_read_error = false;
+	metadump.max_extent_size = DEFAULT_MAX_EXT_SIZE;
+	metadump.show_warnings = false;
+	metadump.obfuscate = true;
+	metadump.zero_stale_data = true;
+	metadump.dirty_log = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3002,27 +3027,29 @@ metadump_f(
 	while ((c = getopt(argc, argv, "aegm:ow")) != EOF) {
 		switch (c) {
 			case 'a':
-				zero_stale_data = false;
+				metadump.zero_stale_data = false;
 				break;
 			case 'e':
-				stop_on_read_error = true;
+				metadump.stop_on_read_error = true;
 				break;
 			case 'g':
-				show_progress = true;
+				metadump.show_progress = true;
 				break;
 			case 'm':
-				max_extent_size = (int)strtol(optarg, &p, 0);
-				if (*p != '\0' || max_extent_size <= 0) {
+				metadump.max_extent_size =
+					(int)strtol(optarg, &p, 0);
+				if (*p != '\0' ||
+				    metadump.max_extent_size <= 0) {
 					print_warning("bad max extent size %s",
 							optarg);
 					return 0;
 				}
 				break;
 			case 'o':
-				obfuscate = false;
+				metadump.obfuscate = false;
 				break;
 			case 'w':
-				show_warnings = true;
+				metadump.show_warnings = true;
 				break;
 			default:
 				print_warning("bad option for metadump command");
@@ -3035,21 +3062,6 @@ metadump_f(
 		return 0;
 	}
 
-	metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
-	if (metablock == NULL) {
-		print_warning("memory allocation failure");
-		return 0;
-	}
-	metablock->mb_blocklog = BBSHIFT;
-	metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
-
-	/* Set flags about state of metadump */
-	metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
-	if (obfuscate)
-		metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
-	if (!zero_stale_data)
-		metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
-
 	/* If we'll copy the log, see if the log is dirty */
 	if (mp->m_sb.sb_logstart) {
 		push_cur();
@@ -3060,34 +3072,52 @@ metadump_f(
 			struct xlog	log;
 
 			if (xlog_is_dirty(mp, &log, &x, 0))
-				metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
+				metadump.dirty_log = true;
 		}
 		pop_cur();
 	}
 
-	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
-	block_buffer = (char *)metablock + BBSIZE;
-	num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
+	if (metadump.metablock == NULL) {
+		print_warning("memory allocation failure");
+		return -1;
+	}
+	metadump.metablock->mb_blocklog = BBSHIFT;
+	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
+
+	/* Set flags about state of metadump */
+	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
+	if (metadump.obfuscate)
+		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
+	if (metadump.dirty_log)
+		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
+
+	metadump.block_index = (__be64 *)((char *)metadump.metablock +
+					sizeof(xfs_metablock_t));
+	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
+	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
+		sizeof(__be64);
 
 	/*
 	 * A metadump block can hold at most num_indices of BBSIZE sectors;
 	 * do not try to dump a filesystem with a sector size which does not
 	 * fit within num_indices (i.e. within a single metablock).
 	 */
-	if (mp->m_sb.sb_sectsize > num_indices * BBSIZE) {
+	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
 		print_warning("Cannot dump filesystem with sector size %u",
 			      mp->m_sb.sb_sectsize);
-		free(metablock);
+		free(metadump.metablock);
 		return 0;
 	}
 
-	cur_index = 0;
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(metablock);
+			free(metadump.metablock);
 			return 0;
 		}
 		/*
@@ -3111,17 +3141,17 @@ metadump_f(
 			close(outfd);
 			goto out;
 		}
-		outf = fdopen(outfd, "a");
-		if (outf == NULL) {
+		metadump.outf = fdopen(outfd, "a");
+		if (metadump.outf == NULL) {
 			fprintf(stderr, "cannot create dump stream\n");
 			dup2(outfd, STDOUT_FILENO);
 			close(outfd);
 			goto out;
 		}
-		stdout_metadump = true;
+		metadump.stdout_metadump = true;
 	} else {
-		outf = fopen(argv[optind], "wb");
-		if (outf == NULL) {
+		metadump.outf = fopen(argv[optind], "wb");
+		if (metadump.outf == NULL) {
 			print_warning("cannot create dump file");
 			goto out;
 		}
@@ -3148,24 +3178,24 @@ metadump_f(
 	if (!exitcode)
 		exitcode = write_index() < 0;
 
-	if (progress_since_warning)
-		fputc('\n', stdout_metadump ? stderr : stdout);
+	if (metadump.progress_since_warning)
+		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
 
-	if (stdout_metadump) {
-		fflush(outf);
+	if (metadump.stdout_metadump) {
+		fflush(metadump.outf);
 		fflush(stdout);
 		ret = dup2(outfd, STDOUT_FILENO);
 		if (ret < 0)
 			perror("un-redirecting stdout");
-		stdout_metadump = false;
+		metadump.stdout_metadump = false;
 	}
-	fclose(outf);
+	fclose(metadump.outf);
 
 	/* cleanup iocur stack */
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metablock);
+	free(metadump.metablock);
 
 	return 0;
 }
-- 
2.39.1

