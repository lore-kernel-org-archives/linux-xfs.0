Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01163C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjKFNLv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjKFNLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD27BD
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1uvk024922;
        Mon, 6 Nov 2023 13:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=e/BfH027MJ2b9yLXlriq5uDtBV+Z1zv0A9lzLH+Ywmn2ozfQWN4jLgnKYj5tAqCq8TsK
 bcRj++lYLwryhXKUfnt8C57y1AVPYpx/kvR0Jf1hT5PqfnZtGgLCQ9xLrBEAV2WL4GRC
 Iwxkq4Qh8+dM8Vm/tMhL5SzI8YljJPCttWNzCdsdBMTKoK97g4xx6t56qm458qIkXNqZ
 z0gtRbNbnIrnFH7Bgj/EMPPG14xoOx1p2/foPEH2+mcGvc22uIPOBq4JjDbwD2pCfR7k
 gt6u/wXYf9WwX+OXNuYDO69OoMes5wqGvEVpKjDkd+Um9B1Qo8FUdAlC2ZSHCEIoa2qh IQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdty14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6DBAL3023571;
        Mon, 6 Nov 2023 13:11:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4t9gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EthAy69IiVGXqLusagTxqnAj1kb4KYCbpKi8qnGzz+tG9WmAtZMuxZaEyXbbm7g9bB3OCyZHJHOzXIc/wyCfIl4DXdrur5gqWp4C5s6RoevTrY6/ejG0AGrYp4IiRGVxNTpQTVS+tuLPKd/iitr+W9z5EP0eaBOJUJtWVn9NoPITbO6XHEoke74YwhV9pJvImH9UClJxHOiEflr7RLBnxH9eot9pva3weYbb9FTDzoaCiRLSsz09J3r/pm9AZ5okcwhdIJpZFPHFJ33f6vetmSr+bli+tUD95sOkjzd80Icdvy3VeqQk+0MVDCpbJt6J4tONhP0OX65YGaKXH3URyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=NerS0IEf/T5Gdx95RXbGaMWJj8aCWJ711JMXRgdiICP2fo/2x562wYjVr7cpMbf6FpKFuB7w6DSP4UI+FcJk3QzIzllBi32Wfq7KvX0N/zPwvICik7kdfjbHnkzY0uziBdcSGNKMYmT5K+1geF2Zst5ULp/tbO4/sYfZe2KXGFxIbILx4Wu1KZKRgoqwU+5IyB2WkRos58KYreVgbJEvJpc7+wnN8MpRg/P3UNRGSssknK+8GhClgLIrdqXi8eeyoMl4aYPH4HgE3VR9j4uBXybbJejblky602HwO6PTJxnb+TGYjXHTdm5+ZUimlf1NPqeK5HcMFIqEP5RtGBY56g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHYflDpEN0btakiKojmMMe9NTsjNlUmSe9C6hc0DdVM=;
 b=IamkbVS9ylwLKBkLiCtcHLH4IKIggwiRzf+8cc5f+R6xdwjYj+4+hyV8hMHtNejfWlHW/HmQ9E3hAjMXb3OXX1Qy+Eoz5GagS914OUplw0wqJdA6VIj1wtTJYk3ZrcNsuZf494dCzPZES/c3DfOjlISf3qqyLIvXPr0cfmQUbK0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:39 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:39 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 05/21] metadump: Add initialization and release functions
Date:   Mon,  6 Nov 2023 18:40:38 +0530
Message-Id: <20231106131054.143419-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b621f51-7ce6-4b58-1bd7-08dbdec9e98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bySrtmyNDHQJi2E2E8xTxp2oAZ/ZMseWkR47vmCYQJLgjl9EpjasSxRCg5co1koUJACIr0ONhwlow4izuLfk/xB34/zSOSDZEyS55Rhpm5119ynVJO3mS3Q4jlnm1FYdAItjROiESeObkHiQST7PIz66I3lyOK4paSC680k0iA9k4FRrOK5h73qcY5RpgSq+/9RXouLhQxVLKR/3T4T9pxNI9ZRbWW6fPVjG9EyOqZzsN3MISNvwGgHSO9pbacJ+Kjb4rRc96ISx6aFEP70Vdb1OzCCs4oFs9dacFHE7QMcrILWdlAd5Pp3CMeqmx4cZcu/8hai/ojtzTRbLEGroWmTSiJk8QgnI34y+jARRCoy7g9UreSlQ5+Ca7myfAwNPYgn0J++pma4AyAmlPPmUpYuxtcR5kh2GdGR8guUlYRVonLsFMVRYl9LZnllBaprkmUW3+TO5yGbLJFZvHFVJttuuvHBeygtZwIisTID/jJQvZOsJ6F9q1eAv9xauOGotH12RQCPGh/oTrWDOSyeP3hVXTGtRwNHFpYEGLgjthxulUAk6M8O1GGPHWRyxopAj4wbUlk7ICViEax/n3wy3I8y2tkDt3+wugT/LcBELYe4ghXMkmmBUpfMWYd3sYesL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/iwAxodK+omjV2/83UaIg9acjLYq2bCVv2da9ppbzrhbAjSJfPh1oO5r5B7f?=
 =?us-ascii?Q?/MqKR+aNYrnxozDsa9+GHMDQzT8d+4IX+XRWEf9PqoEoybbc5KVw+fKVxxjb?=
 =?us-ascii?Q?w8LnOqcqcb5tjAkcyjyUfNig2rYyavuyRABmrMxJG7w/uScGtuxAdclPUhGC?=
 =?us-ascii?Q?49yS4DBF3rIPdM0jYh/54cDr6QTJq4xWseXI0md9uR4FdBygrShQ3OSJUxJL?=
 =?us-ascii?Q?J7aS9itO2zFElRQCo/TArbmrvhmErQR0WZ7P+WJOIFLe6kk/HRXtvGYCFfKF?=
 =?us-ascii?Q?57Y7nZ2YgjeXHYgtjEr1tFTpCaH/LCFsqqlsIusYxBNbLk8nyyl8H+MMbZo2?=
 =?us-ascii?Q?OqlM+d3yTT8WBP6KqVctaE9Tai84WCp+m7iJk6+7XupGfG99EU0jIOP6+6VZ?=
 =?us-ascii?Q?krPM4mfjKl6jJ0K4cb2b0X+dbMmL1RYlK09orAEDrA8NoohMrINWVZ0r039b?=
 =?us-ascii?Q?bSXPQ3F/GqTHSsygVaZJJQW2fHaCyW5wUOaYV7VYhImqIizHtu6k9MvS7ij5?=
 =?us-ascii?Q?r5va0gj0HgVmi76RyD9b5lqbbA4uY4gsdsU6NssEeYasOCwOLcRNaMfwsUPY?=
 =?us-ascii?Q?Np38HzqhwTIC6/uraZvh9yBuOnegoS2bW0gKwN9BSAowy3b19/8uxr0pEYiH?=
 =?us-ascii?Q?bPzXE87jHuSCLH1I9Fv6zku3dJJZOtvXAhTMR4dGvnb3L3iIGjkNL2+ImdTE?=
 =?us-ascii?Q?WIyKQkWYUes5WigtIJThEst2vvnXFSPyCyLmxD3lFDQBJTPPXSiu8ddqehxM?=
 =?us-ascii?Q?BnBIVoW+G54e+KgH0xvTib+GcJc3KWPMA/N5F7KKH98e5pUwOBgnSu84OrHO?=
 =?us-ascii?Q?PPGjA/09X2l5O+UNxCsL/Txbm+CETsWpov9h2T4uT+OAUBx3ucpei7Z61mog?=
 =?us-ascii?Q?+ZPlRR12u5QbyKFwE6XfrKe/cEvp0HmIi4jKRAPek99NVsKpohtKd3DnJs/H?=
 =?us-ascii?Q?T5V0X8audv3d3P848f2cIFKwy4+M1v0p02LaYcayLHqvH+PcVhoPMS8TG6zC?=
 =?us-ascii?Q?0mRvJ2B+18bKIoHSBsqDh3V2FNnHdl0WPTUD6yyV6IFVottfCdgGWe8QjbSH?=
 =?us-ascii?Q?C2MYrLUCOTFQTZamSdC06bjacpdxLnk6BS1g5VS2Fahux9oJCjhPEMwUQdi5?=
 =?us-ascii?Q?u5WTBev6SYE6znaVapyTMz6EsG2rIuba3/zo3U5hLHdLxlzrt4a4Zr0MH4kl?=
 =?us-ascii?Q?WPoLJQTAY5THmwe58WwJpy8Z4nctWEobgrUY7arcsyOQdz4mx56Q82rN3r4g?=
 =?us-ascii?Q?BL0nVgvJfYyoXVI/MBV04Oz6HWomexSoZ5FKeP77l4trH3npWjKeaSpZ4aTo?=
 =?us-ascii?Q?omaVsoH4Mp3gx2ju8jPLB7+T2XJZXXtoElZH1KQh2aWiDT/ek9cyW6prxIAs?=
 =?us-ascii?Q?OhV5TUKOk6p8DbEnKXX86JX5FzHLucrJdvzuTT9g6wTk2UbKZOuHGVclrO9q?=
 =?us-ascii?Q?yW0U1qrWR8lVnaEbyga+YNmv1J3B5bG9R4I+MAmIWvLmDJxtPpSXfUcTg3l3?=
 =?us-ascii?Q?CSI0tInRs3xXBNCTrhpSOMj22hZtEBGcvV7/uX/XIMFScIhrbquYsTWJnu1H?=
 =?us-ascii?Q?hQChUZyFtl49UXq+Xe6HHzQllCehx18D2WrvsBmm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dqdX2LxilNRU//gmq6MuM+52eM9D4Lk9z1W10HOmuRJX/quIS4OA//YtRMQGYbD47o1guSSR37MOrSahiNnOh8j/wcU9o7PDBIvY8FpNfuCspaS/MH+t6WRlWEH4LBAr60HabuSdkLi2085d8uy+bIK7opoeWLsYt/O7QMQAWj+k8MxGMfA//+99OpjB/5Tabp+hCORmqgPCofK7oabLlJI+wqPOlRY1F8nsmGSCTlcCpbN5J0DwacDk5xxNXRAyNNtuDGUCThobwvkSauNqBOcD1jFHyZLrCrAlP6xZ6XJ2Pn7bkNiA32riH/HlTN3locZDp005QLeREduo9xPEbA6yTKlIul68oYo6rHFGLa/ZfhOg0te5WBdwg4G73w3BbPgZ5uQeDGBi/KBFQVLBi8AsAsl4WLk2FLN3QspZfgdVPiNfj6Z0ovWB+nRgY2t3cTvVQQtSULL1WRFbA9cnpipjocW6JFIfqQp51rcDDegFuqgF7XfDsiYShq77x8obIvyzyHm1V7md/4WYtygdWA5nTPI5Yhzk4/tSpLvv5Pdgej5JzeLeKfxXeFW3AhQ4Er9DCDc/yjKJxSlUZJAIQf3uuOJRJ+zL3wPjKdc3f7JS15OD6KpSGgM933xQvjWjMW7fifz9csJu62KvZ3QdNBDXJOzczyZVizQto8uqK4j3XaR0m7Mhq9YuCu87r+qErTYNsrcigyDio0MNrs31r5VxVLPQLJkgfJGiugxOuWLTTgunkBhCNMhSnQOKwvt7UqokDsEb3S3+qK3rWoTaD5X89xDmWHDjWePCdYITqqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b621f51-7ce6-4b58-1bd7-08dbdec9e98f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:39.4463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OjiaFsfFbeeqb7B1RI6Q07Xuoa2xoxtn9fE6PTp17UKojelcfRdWkCytfDJo8VcVa7rcTEnvv6iRIh/o2BYsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=888 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: 9RAFJebbwjjW-sQU9PvWNNsu_jA-xHm9
X-Proofpoint-GUID: 9RAFJebbwjjW-sQU9PvWNNsu_jA-xHm9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move metadump initialization and release functionality into corresponding
functions. There are no functional changes made in this commit.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index da91000c..8d921500 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2665,6 +2665,54 @@ done:
 	return !write_buf(iocur_top);
 }
 
+static int
+init_metadump(void)
+{
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
+				sizeof(xfs_metablock_t));
+	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
+	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
+
+	/*
+	 * A metadump block can hold at most num_indices of BBSIZE sectors;
+	 * do not try to dump a filesystem with a sector size which does not
+	 * fit within num_indices (i.e. within a single metablock).
+	 */
+	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
+		print_warning("Cannot dump filesystem with sector size %u",
+			      mp->m_sb.sb_sectsize);
+		free(metadump.metablock);
+		return -1;
+	}
+
+	metadump.cur_index = 0;
+
+	return 0;
+}
+
+static void
+release_metadump(void)
+{
+	free(metadump.metablock);
+}
+
 static int
 metadump_f(
 	int 		argc,
@@ -2757,48 +2805,16 @@ metadump_f(
 		pop_cur();
 	}
 
-	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
-	if (metadump.metablock == NULL) {
-		print_warning("memory allocation failure");
-		return -1;
-	}
-	metadump.metablock->mb_blocklog = BBSHIFT;
-	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
-
-	/* Set flags about state of metadump */
-	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
-	if (metadump.obfuscate)
-		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
-	if (!metadump.zero_stale_data)
-		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
-	if (metadump.dirty_log)
-		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
-
-	metadump.block_index = (__be64 *)((char *)metadump.metablock +
-					sizeof(xfs_metablock_t));
-	metadump.block_buffer = (char *)metadump.metablock + BBSIZE;
-	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) /
-		sizeof(__be64);
-
-	/*
-	 * A metadump block can hold at most num_indices of BBSIZE sectors;
-	 * do not try to dump a filesystem with a sector size which does not
-	 * fit within num_indices (i.e. within a single metablock).
-	 */
-	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
-		print_warning("Cannot dump filesystem with sector size %u",
-			      mp->m_sb.sb_sectsize);
-		free(metadump.metablock);
+	ret = init_metadump();
+	if (ret)
 		return 0;
-	}
 
 	start_iocur_sp = iocur_sp;
 
 	if (strcmp(argv[optind], "-") == 0) {
 		if (isatty(fileno(stdout))) {
 			print_warning("cannot write to a terminal");
-			free(metadump.metablock);
-			return 0;
+			goto out;
 		}
 		/*
 		 * Redirect stdout to stderr for the duration of the
@@ -2875,7 +2891,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 out:
-	free(metadump.metablock);
+	release_metadump();
 
 	return 0;
 }
-- 
2.39.1

