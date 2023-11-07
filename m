Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A43BC4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjKGHII (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjKGHII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:08:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BB611A
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:08:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72O5oh014504
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-03-30;
 bh=Zoketw+P21XNyGSvoAzTndi5fG7d0zFoLTlfC4p8w3o=;
 b=aJaJzmuCJds9EST94iK3c3l/XUmLbG8LUxaNX7AEksPbNbEYC3Cg0LIMeaQFRZaTJ5WX
 fclWytSiI3BEpzw7BYudJAfcLwInWg667jVWvce98AD358mJ3vJ1PhC1mi5PutzFicDR
 pZzkHqPxdMTbmLaordpVFU75pA1SyrsdCQap0vsvACJIys7711PgLTVS8c/d8cW51eG8
 Rlunc+FnBqTltQ0MLbV6BBPkXI6ddvm1Cg3UWyFrocKxLcjXJIPhKz8Z28aRvSzfCSE3
 li7fDTwUPFk1oGf9h8t7nUfT3n5BcAqQjMqspkcu+dx0VuYVOII7lC4fcqYQtW9/9m6A Aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5dub576g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:08:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A75BLrV038278
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdda3f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTTw4KeuSd2RM9F+yoHK9lmuKuVYqmldznBNV6M6LiFifVgVKWEfOuE/cBAeWZPFSI65VqvCAvT3k0r10gaSk8VMykKPDbSou3tCTryF1rj/AF2dehmMaPO6WrSzTpVWxK6rB+jpK3dBK30gWnOCwxYyPHbe9226UUa1roFzBH/xxX7LpDqZbaluY4KFzZZFOuBFGSgKpJEGAHqEtA2R2TD9PgH6u5+qPUMkIQc9oftU7qo86WAV0VodRv/Wq4kMnZzBpoQ8l+qvvOgR/SNa+/eY1xuSQHCU3AUpjiCl8XGGyw34SbT928+PZ7oJyzZPaNDkuAPJv4ddVJbkv4vzqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zoketw+P21XNyGSvoAzTndi5fG7d0zFoLTlfC4p8w3o=;
 b=lFAQMvc7DlNrng9/EcA8d8ngDLM0R/qh/CBFNPVoRehOxpOjCdEspjw1mLSvb0/VH7FCCUs0MUkx5hCuLsJh7MuslCGMhSXxxKJ9MR9pE1dqGbC/lB7JZYkiHK6D8ITF3KYu4mUY6KSGRbSFL33vDUAwDmTHXpYEvL/RjIUGRC4gZc34sWNTOjhEE7rwbJVofiqk3NNNsMoZ7vaskR92Fw4gARdpOyLdqPsd1ONY7zBIP6F0slebSpaRbZ/bbfetzHDjADxjg6UTvX0Fs10Adt9XfWZQetLgycKrGT92GHw9UbTP7wbLqYSqDdFx5IIhCy3ZPi52KVZmN3IbHuFxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zoketw+P21XNyGSvoAzTndi5fG7d0zFoLTlfC4p8w3o=;
 b=doglMbIAQSIFONBrywCeDcvpoxJES545RbysJB0JnsOkluRtzZII/7mscix8k89PXQZaPKHL2zMhfgYIIlZjTlh4V1I5/QvYm5/MGFxjybBvMgpEq1ELDUZo36ql6rSQD676ZVKlQWUVBoav6uB3FTiDYfdHw2MZmgOICu0YN5w=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 04/21] metadump: Define and use struct metadump
Date:   Tue,  7 Nov 2023 12:37:05 +0530
Message-Id: <20231107070722.748636-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231107070722.748636-1-chandan.babu@oracle.com>
References: <20231107070722.748636-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0053.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c89f1cd-69a8-4a87-84bc-08dbdf604117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9wJqYaReA9zx0+ssDlUWVnz2bUQCTWxnDrmN3XKvNGygmutgCHcdxZYxA8wIq3RbFv9bryp2h6qg5cNLU8mOV/2Bj/pR7FeyJIoJD0OhuqDnEOMiYWjbw/MaIK5vOVRz+KlFixkESI5woiL7Ju1H052h91oKkUhcZpTPQhYYbB7mrTwzCo4vb8pOdY2N56zIszyZSSKsDmjjZFPJ4rQkLfNhVqqV8qFsFWi7JhQfukEVhisF/Ro0V4YKerD22BaTHYp7s2LlT8hPGcs0WA4QMzm+wne2PrXtNi4dn+/8gz36IEVDitMGQbwOiE5CRACmQCVdqkLzW1DQ5z4qnHw0FwiQe/9K4EHg3fozfox5uhC+qhje818KlkPQSvf03kdhH8nYb4PwcXTjn7Sn2OHa/akc7djnPJTxO4h70ek30aJAdR6n8T9/ti1MIo8L9XeWiz9gIAmM7m/fZydayOnNUFmJKq9EN+wME+EajR8YpWCH3fknb2xoEVTKA7pJI/eDhlBaw3atKuvKNMOdbZfuLruSWIOaWYQ0/bQSYAOktNrPVy99vPNhuOuwppCwr5O69cjQxHQiTBu7IiicGgRaWm5O0/NWgIinuphMYGss1hYz7ySjHqHIVy8UjXB+WoNL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(30864003)(41300700001)(2906002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?taLnmhOO3r+YIE2Tr0nzvoi8Kgou5fv//BwUjmIffsbTbZz1ZZQfTaAkLgig?=
 =?us-ascii?Q?2f0SoxJuPxCIlAbLPewzbGr2j/mmcYJYFP3mm3s3e8Hj4H8RVgmJcfhXZrMw?=
 =?us-ascii?Q?UPkDq+d2lynlULSj2o9rbI9q/8xSaRH48A6ps2NgD2tO+smtHlxU+azOs9Wa?=
 =?us-ascii?Q?hraOgny8P40Y3xAFCRPqVlSoqIBZSxQuAG3kSsgXZiE6BL8gRhzzUSys4HGn?=
 =?us-ascii?Q?vCNBh2Rz0tJhx9TBbiqp/e585QLvZdZ+ORIHhz+EqORnztj4FxLtYsm0WnRQ?=
 =?us-ascii?Q?CGayWicNO/ZHFRxAj4+9IlHicIRjz1fTYSdGoumolyYTbwIANn2cPB71OcUJ?=
 =?us-ascii?Q?j09ZbAh/qB6rjis1Pi/OuFLsRnS4ta1IT+X0w1Gwxf4aVfS0/DZQ3NJ7Bdx/?=
 =?us-ascii?Q?RIec3Qy7G8hn1Fqt00L+SFchnw0JbyNQmbMYdMm8wvXdIWqrm5yGbuTqLLpw?=
 =?us-ascii?Q?PG/WZ0BJbANGpoKiRky0DuqQI+4cOeVqBM8+DFYnKw0iQ6bK5Nzix2AE8NlA?=
 =?us-ascii?Q?ljEoADQ7TyO72vV9vLX/eQBeiYtXI+w9bTeY0rp1ju9yKWVZIvgO7vylQVvO?=
 =?us-ascii?Q?mxuty2GkemWuV9Tj1I3JKkWibISb/ayj+rVxAHacH/CgXNhQyQBsvhpS+G22?=
 =?us-ascii?Q?G+EKODq6Au7LMmEd0sOJlcRjoquIubrrTEr2KSCewVIYaVv6sHKzxeura5YT?=
 =?us-ascii?Q?VWSzhKh19Cvlb59LKMbsDgHWsyEC9kWWO3z7aDBGS+eO0SKmEAQ/mDt3TxRF?=
 =?us-ascii?Q?eC1Niw+vMOcBRQs75Zaps/ER9vRnJ8MZvSjg0a28Yj0PltrjhtcrhoPeoWKy?=
 =?us-ascii?Q?4Xhxnz//Z7enQi1iP2BtbvEif1gwr8vM20yVG7BVBN5+jwmMpG/7BdEArK+O?=
 =?us-ascii?Q?DEKya4E19XG4U91v7b9DBZPi4BrU2QWxy/kO/ywFjbsBCTucdXXzIMxZLWsr?=
 =?us-ascii?Q?QqGPoekXuxpYSowIkBCxflbTYz42Y98oZ4e8PKemIphCxDb6rb4U/XI6p8Xo?=
 =?us-ascii?Q?p9rvEGyI8mZBopitUagTy2W4LAJR2tlLaBBzYWjvkJZ2mShbB7q0pQXZbWN3?=
 =?us-ascii?Q?QJieI23fYEG7+B2HgQ5oUHfvNgqQTKBT4WcHknkV56i/G5EqxEOdlH4UHg8M?=
 =?us-ascii?Q?WHcgDNu5fF+gycSDs+v/s6WpGL0RTmbZ1spGvri3N3co4bcY9M6lPGCcOuXB?=
 =?us-ascii?Q?5NbSSiLXOClZXPaqrzf5ORTyQvq4mjtEB+xk6rguILclDHHrKG0TJZTviqZk?=
 =?us-ascii?Q?LJi0ImEIeFqQIoDE3Rw5mgSYJFwF8o6kcsIkafHy/qKDsHjs5BLVmiblujSQ?=
 =?us-ascii?Q?dp+0L6LEABklSeKwmu6D/nbrn47ZJZdOOQs660RORH2eJn/gyTeXci1aW/cw?=
 =?us-ascii?Q?9iwtqEUjiJNsJUtzemHpiVnVYRm/bBrj6+9YF4t2TnnX4oF+4lvf3fJ/N88X?=
 =?us-ascii?Q?NcjexTOAp7L9uPzvVmh1xL+fF/g77ajh4privr2iWtfsOFsnGIbsaHaTevZ6?=
 =?us-ascii?Q?wHS+h8sDGEgp55bqcmMBR1MZFB1IrzuotV3ES/D82bG7E359BnW/I9lBh6Vo?=
 =?us-ascii?Q?bflFjxDkfzLGs6w/5N8i7PAf/wJ2OiFJpWbWehuHH4XeSg4SNhpmPgv1+18E?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kLreRfFhEfGb0dIan8i0RthcRY6XAHvl3PdgTrAMVOMKjEKfsC2GkC8j8F7XVXrgFGdwnx9dsQvaE3Po0aDGxBGTd/Sh6vz+LKL0VnyRplkkHhBT/NvaL+RfKSxRcFA/ymLhZhgM5S6vdJKQQtt1JiyK8agKL7Qxv0S1Br3SlJinaPptrPw4KblWqoWplhxAI3v+YOz17/cpJDvKw+0iDluN+dy2cQdCS41yXPYx1tIWonm0FesbOXOLUPF+NpUSJizw8/Y0y/ZaFR9unxjpr6U77pFjx/CKk+QnX7zj7FiYFpkoFdvduZ8M2kNkQvF1FNXJF0YU9oFsrwRFZZMjHusU5EBzMnd6zAizxVmLW+C9DaTDtvAbtS8UCqgMCvxnmFchMhQdhZmnMwndyb/2mVAxZHPZtO9MHM3HYhoqhSXAvLO8tz3O5uhWeyxIKkkElauNiZfOQb9ktNSOoiRVMZG4dhPQPJBon/g8EEukCYz36iHrCYGzzudsxKcpkz4shcFsr00znCQpVDlDSLtCRGs5stB0KlgLXHJf6ix8BoO4Db8WGt5ysrStx/kv9VmmC843lFf0VDwhWPU/lRVIxYofMikRsy4k6LTS7lPe0eoLo7yahkTqtfKXItIXCTuOlwdpDijsAfDe3ymEvfuo/8uEPhqYDfLTX1h4T7Ys/TeYjNovWt3AkqnfiHqk0OaXpYWasWcD9VEYcmnyumHxgI0amU/SlasimvfXSXmQkPpUc2ncXwqrkHbpWVlTbtgJTOrksfQeGUCJ/hhmkk5lAA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c89f1cd-69a8-4a87-84bc-08dbdf604117
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:50.8497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwf4v/sFIRUED7riEn9hl6TrYPUJobEXnxl8LRq34h3KjUizmbC9eeTGyHnQo6WNnML52vUScEzSG6To1DS94g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070057
X-Proofpoint-GUID: XemXiGt8NnnaEOJGFEYMvyqRpove698V
X-Proofpoint-ORIG-GUID: XemXiGt8NnnaEOJGFEYMvyqRpove698V
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
index 14eda688..da91000c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -41,25 +41,27 @@ static const cmdinfo_t	metadump_cmd =
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
@@ -99,9 +101,10 @@ print_warning(const char *fmt, ...)
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
@@ -119,10 +122,10 @@ print_progress(const char *fmt, ...)
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
@@ -137,17 +140,19 @@ print_progress(const char *fmt, ...)
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
 
@@ -164,9 +169,10 @@ write_buf_segment(
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
@@ -389,11 +395,11 @@ scan_btree(
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
@@ -447,7 +453,7 @@ scanfunc_freesp(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_alloc_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -456,7 +462,7 @@ scanfunc_freesp(
 	pp = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -483,13 +489,13 @@ copy_free_bno_btree(
 
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
@@ -511,13 +517,13 @@ copy_free_cnt_btree(
 
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
@@ -544,7 +550,7 @@ scanfunc_rmapbt(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_rmap_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -553,7 +559,7 @@ scanfunc_rmapbt(
 	pp = XFS_RMAP_PTR_ADDR(block, 1, mp->m_rmap_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -583,13 +589,13 @@ copy_rmap_btree(
 
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
@@ -616,7 +622,7 @@ scanfunc_refcntbt(
 
 	numrecs = be16_to_cpu(block->bb_numrecs);
 	if (numrecs > mp->m_refc_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -625,7 +631,7 @@ scanfunc_refcntbt(
 	pp = XFS_REFCOUNT_PTR_ADDR(block, 1, mp->m_refc_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -655,13 +661,13 @@ copy_refcount_btree(
 
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
@@ -773,7 +779,8 @@ in_lost_found(
 	/* Record the "lost+found" inode if we haven't done so already */
 
 	ASSERT(ino != 0);
-	if (!orphanage_ino && is_orphanage_dir(mp, cur_ino, namelen, name))
+	if (!orphanage_ino && is_orphanage_dir(mp, metadump.cur_ino, namelen,
+						name))
 		orphanage_ino = ino;
 
 	/* We don't obfuscate the "lost+found" directory itself */
@@ -783,7 +790,7 @@ in_lost_found(
 
 	/* Most files aren't in "lost+found" at all */
 
-	if (cur_ino != orphanage_ino)
+	if (metadump.cur_ino != orphanage_ino)
 		return 0;
 
 	/*
@@ -897,7 +904,7 @@ generate_obfuscated_name(
 		print_warning("duplicate name for inode %llu "
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
-			(unsigned long long) cur_ino);
+			(unsigned long long) metadump.cur_ino);
 		return;
 	}
 
@@ -907,7 +914,7 @@ generate_obfuscated_name(
 		print_warning("unable to record name for inode %llu "
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
-			(unsigned long long) cur_ino);
+			(unsigned long long) metadump.cur_ino);
 }
 
 static void
@@ -923,9 +930,9 @@ process_sf_dir(
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
@@ -939,9 +946,9 @@ process_sf_dir(
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
@@ -949,16 +956,17 @@ process_sf_dir(
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
@@ -968,7 +976,8 @@ process_sf_dir(
 	}
 
 	/* zero stale data in rest of space in data fork, if any */
-	if (zero_stale_data && (ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
+	if (metadump.zero_stale_data &&
+	    (ino_dir_size < XFS_DFORK_DSIZE(dip, mp)))
 		memset(sfep, 0, XFS_DFORK_DSIZE(dip, mp) - ino_dir_size);
 }
 
@@ -1026,18 +1035,18 @@ process_sf_symlink(
 
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
 
@@ -1062,9 +1071,9 @@ process_sf_attr(
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
@@ -1074,19 +1083,20 @@ process_sf_attr(
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
@@ -1098,7 +1108,8 @@ process_sf_attr(
 	}
 
 	/* zero stale data in rest of space in attr fork, if any */
-	if (zero_stale_data && (ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
+	if (metadump.zero_stale_data &&
+	    (ino_attr_size < XFS_DFORK_ASIZE(dip, mp)))
 		memset(asfep, 0, XFS_DFORK_ASIZE(dip, mp) - ino_attr_size);
 }
 
@@ -1109,7 +1120,7 @@ process_dir_free_block(
 	struct xfs_dir2_free		*free;
 	struct xfs_dir3_icfree_hdr	freehdr;
 
-	if (!zero_stale_data)
+	if (!metadump.zero_stale_data)
 		return;
 
 	free = (struct xfs_dir2_free *)block;
@@ -1131,10 +1142,10 @@ process_dir_free_block(
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
@@ -1146,7 +1157,7 @@ process_dir_leaf_block(
 	struct xfs_dir2_leaf		*leaf;
 	struct xfs_dir3_icleaf_hdr	leafhdr;
 
-	if (!zero_stale_data)
+	if (!metadump.zero_stale_data)
 		return;
 
 	/* Yes, this works for dir2 & dir3.  Difference is padding. */
@@ -1229,10 +1240,10 @@ process_dir_data_block(
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
 
@@ -1252,10 +1263,10 @@ process_dir_data_block(
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
@@ -1268,7 +1279,7 @@ process_dir_data_block(
 			 * actually at a variable offset, so zeroing &dup->tag
 			 * is zeroing the free space in between
 			 */
-			if (zero_stale_data) {
+			if (metadump.zero_stale_data) {
 				int zlen = free_length -
 						sizeof(xfs_dir2_data_unused_t);
 
@@ -1286,23 +1297,23 @@ process_dir_data_block(
 
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
@@ -1338,7 +1349,7 @@ process_symlink_block(
 
 		print_warning("cannot read %s block %u/%u (%llu)",
 				typtab[btype].name, agno, agbno, s);
-		rval = !stop_on_read_error;
+		rval = !metadump.stop_on_read_error;
 		goto out_pop;
 	}
 	link = iocur_top->data;
@@ -1346,10 +1357,10 @@ process_symlink_block(
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
@@ -1416,7 +1427,8 @@ process_attr_block(
 	if ((be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) &&
 	    (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR3_LEAF_MAGIC)) {
 		for (i = 0; i < attr_data.remote_val_count; i++) {
-			if (obfuscate && attr_data.remote_vals[i] == offset)
+			if (metadump.obfuscate &&
+			    attr_data.remote_vals[i] == offset)
 				/* Macros to handle both attr and attr3 */
 				memset(block +
 					(bs - XFS_ATTR3_RMT_BUF_SPACE(mp, bs)),
@@ -1433,9 +1445,9 @@ process_attr_block(
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
 
@@ -1450,22 +1462,22 @@ process_attr_block(
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
@@ -1477,18 +1489,18 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
 				(offsetof(struct xfs_attr_leaf_name_local, nameval) +
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
@@ -1499,13 +1511,13 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_remote(nlen) -
 				(offsetof(struct xfs_attr_leaf_name_remote, name) +
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
@@ -1538,16 +1550,16 @@ process_single_fsb_objects(
 
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
 
@@ -1658,12 +1670,12 @@ process_multi_fsb_dir(
 
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
@@ -1755,25 +1767,27 @@ process_bmbt_reclist(
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
 
@@ -1784,19 +1798,21 @@ process_bmbt_reclist(
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
@@ -1832,7 +1848,7 @@ scanfunc_bmap(
 
 	if (level == 0) {
 		if (nrecs > mp->m_bmap_dmxr[0]) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid numrecs (%u) in %s "
 					"block %u/%u", nrecs,
 					typtab[btype].name, agno, agbno);
@@ -1843,7 +1859,7 @@ scanfunc_bmap(
 	}
 
 	if (nrecs > mp->m_bmap_dmxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs (%u) in %s block %u/%u",
 					nrecs, typtab[btype].name, agno, agbno);
 		return 1;
@@ -1858,7 +1874,7 @@ scanfunc_bmap(
 
 		if (bno == 0 || bno > mp->m_sb.sb_agblocks ||
 				ag > mp->m_sb.sb_agcount) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u", ag, bno,
 					typtab[btype].name, agno, agbno);
@@ -1893,10 +1909,10 @@ process_btinode(
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
 
@@ -1907,16 +1923,16 @@ process_btinode(
 
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
@@ -1937,11 +1953,11 @@ process_btinode(
 
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
 
@@ -1968,14 +1984,16 @@ process_exinode(
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
 
@@ -1991,7 +2009,7 @@ process_inode_data(
 {
 	switch (dip->di_format) {
 		case XFS_DINODE_FMT_LOCAL:
-			if (!(obfuscate || zero_stale_data))
+			if (!(metadump.obfuscate || metadump.zero_stale_data))
 				break;
 
 			/*
@@ -2003,7 +2021,7 @@ process_inode_data(
 				print_warning(
 "Invalid data fork size (%d) in inode %llu, preserving contents!",
 						XFS_DFORK_DSIZE(dip, mp),
-						(long long)cur_ino);
+						(long long)metadump.cur_ino);
 				break;
 			}
 
@@ -2035,9 +2053,9 @@ process_dev_inode(
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
 
@@ -2049,11 +2067,11 @@ process_dev_inode(
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
@@ -2079,17 +2097,17 @@ process_inode(
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
@@ -2131,7 +2149,8 @@ process_inode(
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
 				need_new_crc = true;
-				if (obfuscate || zero_stale_data)
+				if (metadump.obfuscate ||
+				    metadump.zero_stale_data)
 					process_sf_attr(dip);
 				break;
 
@@ -2148,7 +2167,7 @@ process_inode(
 
 done:
 	/* Heavy handed but low cost; just do it as a catch-all. */
-	if (zero_stale_data)
+	if (metadump.zero_stale_data)
 		need_new_crc = true;
 
 	if (crc_was_ok && need_new_crc)
@@ -2208,7 +2227,7 @@ copy_inode_chunk(
 	if (agino == 0 || agino == NULLAGINO || !valid_bno(agno, agbno) ||
 			!valid_bno(agno, XFS_AGINO_TO_AGBNO(mp,
 					agino + XFS_INODES_PER_CHUNK - 1))) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("bad inode number %llu (%u/%u)",
 				XFS_AGINO_TO_INO(mp, agno, agino), agno, agino);
 		return 1;
@@ -2224,7 +2243,7 @@ copy_inode_chunk(
 			(xfs_has_align(mp) &&
 					mp->m_sb.sb_inoalignmt != 0 &&
 					agbno % mp->m_sb.sb_inoalignmt != 0)) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("badly aligned inode (start = %llu)",
 					XFS_AGINO_TO_INO(mp, agno, agino));
 		return 1;
@@ -2241,7 +2260,7 @@ copy_inode_chunk(
 		if (iocur_top->data == NULL) {
 			print_warning("cannot read inode block %u/%u",
 				      agno, agbno);
-			rval = !stop_on_read_error;
+			rval = !metadump.stop_on_read_error;
 			goto pop_out;
 		}
 
@@ -2267,7 +2286,7 @@ next_bp:
 		ioff += inodes_per_buf;
 	}
 
-	if (show_progress)
+	if (metadump.show_progress)
 		print_progress("Copied %u of %u inodes (%u of %u AGs)",
 				inodes_copied, mp->m_sb.sb_icount, agno,
 				mp->m_sb.sb_agcount);
@@ -2297,7 +2316,7 @@ scanfunc_ino(
 
 	if (level == 0) {
 		if (numrecs > igeo->inobt_mxr[0]) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid numrecs %d in %s "
 					"block %u/%u", numrecs,
 					typtab[btype].name, agno, agbno);
@@ -2320,7 +2339,7 @@ scanfunc_ino(
 	}
 
 	if (numrecs > igeo->inobt_mxr[1]) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid numrecs %d in %s block %u/%u",
 				numrecs, typtab[btype].name, agno, agbno);
 		numrecs = igeo->inobt_mxr[1];
@@ -2329,7 +2348,7 @@ scanfunc_ino(
 	pp = XFS_INOBT_PTR_ADDR(mp, block, 1, igeo->inobt_mxr[1]);
 	for (i = 0; i < numrecs; i++) {
 		if (!valid_bno(agno, be32_to_cpu(pp[i]))) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u/%u) "
 					"in %s block %u/%u",
 					agno, be32_to_cpu(pp[i]),
@@ -2357,13 +2376,13 @@ copy_inodes(
 
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
@@ -2377,7 +2396,7 @@ copy_inodes(
 		levels = be32_to_cpu(agi->agi_free_level);
 
 		if (root == 0 || root > mp->m_sb.sb_agblocks) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid block number (%u) in "
 						"finobt root in agi %u", root,
 						agno);
@@ -2385,7 +2404,7 @@ copy_inodes(
 		}
 
 		if (levels > M_IGEO(mp)->inobt_maxlevels) {
-			if (show_warnings)
+			if (metadump.show_warnings)
 				print_warning("invalid level (%u) in finobt "
 						"root in agi %u", levels, agno);
 			return 1;
@@ -2416,11 +2435,11 @@ scan_ag(
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
@@ -2438,7 +2457,7 @@ scan_ag(
 	agf = iocur_top->data;
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read agf block for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
 		if (write_buf(iocur_top))
@@ -2453,7 +2472,7 @@ scan_ag(
 	agi = iocur_top->data;
 	if (iocur_top->data == NULL) {
 		print_warning("cannot read agi block for ag %u", agno);
-		if (stop_on_read_error)
+		if (metadump.stop_on_read_error)
 			goto pop_out;
 	} else {
 		if (write_buf(iocur_top))
@@ -2467,10 +2486,10 @@ scan_ag(
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
@@ -2493,7 +2512,7 @@ scan_ag(
 
 	/* copy AG free space btrees */
 	if (agf) {
-		if (show_progress)
+		if (metadump.show_progress)
 			print_progress("Copying free space trees of AG %u",
 					agno);
 		if (!copy_free_bno_btree(agno, agf))
@@ -2539,7 +2558,7 @@ copy_ino(
 
 	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
 			offset >= mp->m_sb.sb_inopblock) {
-		if (show_warnings)
+		if (metadump.show_warnings)
 			print_warning("invalid %s inode number (%lld)",
 					typtab[itype].name, (long long)ino);
 		return 1;
@@ -2551,12 +2570,12 @@ copy_ino(
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
@@ -2592,7 +2611,7 @@ copy_log(void)
 	int		logversion;
 	int		cycle = XLOG_INIT_CYCLE;
 
-	if (show_progress)
+	if (metadump.show_progress)
 		print_progress("Copying log");
 
 	push_cur();
@@ -2601,11 +2620,11 @@ copy_log(void)
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
@@ -2613,7 +2632,7 @@ copy_log(void)
 	switch (dirty) {
 	case 0:
 		/* clear out a clean log */
-		if (show_progress)
+		if (metadump.show_progress)
 			print_progress("Zeroing clean log");
 
 		logstart = XFS_FSB_TO_DADDR(mp, mp->m_sb.sb_logstart);
@@ -2628,7 +2647,7 @@ copy_log(void)
 		break;
 	case 1:
 		/* keep the dirty log */
-		if (obfuscate)
+		if (metadump.obfuscate)
 			print_warning(
 _("Warning: log recovery of an obfuscated metadata image can leak "
 "unobfuscated metadata and/or cause image corruption.  If possible, "
@@ -2636,7 +2655,7 @@ _("Warning: log recovery of an obfuscated metadata image can leak "
 		break;
 	case -1:
 		/* log detection error */
-		if (obfuscate)
+		if (metadump.obfuscate)
 			print_warning(
 _("Could not discern log; image will contain unobfuscated metadata in log."));
 		break;
@@ -2659,9 +2678,15 @@ metadump_f(
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
@@ -2682,27 +2707,29 @@ metadump_f(
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
@@ -2715,21 +2742,6 @@ metadump_f(
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
@@ -2740,34 +2752,52 @@ metadump_f(
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
@@ -2791,17 +2821,17 @@ metadump_f(
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
@@ -2828,24 +2858,24 @@ metadump_f(
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

