Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0085C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjKFNMW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjKFNMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:12:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9959EA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:12:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1uvn024922;
        Mon, 6 Nov 2023 13:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=orZbNJ0RSrG2VJy64L7XjI4NkHqZMKdPG+FQ92mLLbxJGtplVLEpzS4r2WoilHSweeex
 M8QGcthH4XmcKpZGoHdLQ272hD6iINA9zq4kFF1xknyclr4qIEDPA1hQVOAHKIMvmxHz
 jykiVllkZ5SiFoi1A1vUWjpSqopeYsovFGjKcmcRqd5qRsD5zibGeosw7T9h2wEBX+J+
 FBkQEup1NcPzfIrLzbSl6wpEJ7aq3XUGJVL9fTbfpxRgGov5qTjFkirT0NWFIm0w2kec
 brggc2Xb28kIB9ReC0fxyR8BVnuAL//ClUT9HZ3rhV5nIDKUAFa2jvCW7jTo9wCYpsXW Yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5ccdty29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6C46c3020427;
        Mon, 6 Nov 2023 13:12:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdbacq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:12:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asXSjr6XTbU4RwtLb8UrwhS73ijrDpAuo+Ihgk/miun/VJYTpNSmiyC17ikd84X8YUGOH0ulKZLz9NG7EBL4n6D5h2ddtLTIXHxfuJsEHbQ/NOKyrSfaZjtlN+PFDzF7nmZJ1J5h0rq83FEV1+s96VrLZHfbtolBNY+8DcPnJ5CCNo+tw+fRDZPvWkjTrsHQVdJ3T/yo8DIeCC0pUmN/H/8J4Dltv+rx3HvdVI6j/gBLUfLGriylS0bu6MuROJn6x89z+VZ13ERo0rZhC0pIg8lNfQdrGn6ZLaVtwjx5UXIA8sPloaG5oKVFzL4Evj3FvOcd3Z4GvDWNMK1o0nGQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=PoSCVZiNNz0BOn6s7HrNWYbpcz2AF3RxxuLxXSbdJlqjfIc+HKm+J3vBcVqF9H5LAMIOFIeWKzurl4l4zPjxa49AzZ70Z5n/4stBPHTmojhsxGzhRsh39KZcnG0Skg53MsYfddClrWWsi/hT1NxNPaCwJGeJmDJxS90Di4yiiQIZmHLmFdaRt2pYvdAWb0DtiAGD694arpGAbbY0iMVacEe520e5vG21FP6d1hkk14Ot6dABUUMK22kDXTqd8QdQfyHkVDFjgGymohvGbnBTp+ZSdls86tx6BsW5nnc3AFkUmgM24UkwILQLHvbh7TX9ZyGMN1iQ7P/oJM3lbzVA0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/KP32ZJg7SDQdPTH1tDHHHVFET+KgjOaSgavp0Oa2D8=;
 b=CQYjqT0nZXpOkPIFSr/Ukf9dY+WhH8lrjO2YyrDYHei03DXP+kPXA89FImnWm1cr2wjrpKT9tMEgwOn7QhFV1xLUH2CFu3q2Q9aGajLKTo6RG85RB6adGRQyN7awwChNMJclc5J6RhiEFvAVywwfdaz+GPcsTkECbaVVQ63KYsU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:12 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 11/21] metadump: Define metadump ops for v2 format
Date:   Mon,  6 Nov 2023 18:40:44 +0530
Message-Id: <20231106131054.143419-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: c404922c-76ef-4eef-164d-08dbdec9fce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gRwrrokzKRzBzt9JHSooaqFm+1HyIX95cJuG11/k/uKHy3ngTkqnTkbZJTwFktqKrf9Fa4l5vi9ReadXFwKzOBMFtHtpEqB4ju5OA7rtQN8BrxZmRzQX4SOwf3EI0Hj7WyTwxLWK28D9a0YPF4YNbkbcCXxIZZ/Jyg4ttT/wljL3RVv5V080KhNNz81WrHIBdAv7aPXmrMVPB/G90Am+8mTZABT/M9a0EKwRRt5GgyVcNf2jy20hGeHHN/vOnPnCcjkrGzgh8/RL227hwpjTo6bJ9ArM4093VzwszDssogWWO3JaJp609BKU01KqjIVPZhv5+CCcH+EXg8FnldE+TMhLoHb+7kAkTI8x7kMxNCdScksyI413s8hALLrLJxMbOBfnfBI2xQ19Rg1YP083LvcqQofksS05cd+AzJM8zeLuxUXLQ625OG7tgghqyBhM5KXG+SJH/6VQOOje2mhZm6q2TasuPDynkRCpgIhowv9xx5aEY4shP+nvCD1FaZkT2/IxdUjGyFqJzgjcrge55UoMFGmTJwlzGrguTBWR9azJILjELzaZf1+OIGUQyN0Wk4VZJ0XV1zMaPqX6hYkSfD0y4Kq9Jj/3+NNnY80uNxbGNaeiKa1TLAsI2wlxA8L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTXVMcmfPx/qDS9johnZpuUxgs2sOf9aGp/AsJ+CaL560oWYil8ho+ROGaXU?=
 =?us-ascii?Q?dajDISdb3a6XBJFf2c/CdTeoWNFFvQ1HHK2I7HRD787vlAPnY/W7hg5u/+qO?=
 =?us-ascii?Q?pmlVRNeSU8XXGCebaDeDRC/G8xbd/zz8I3Ag643WmHGR2RaYFzUIDn8XT+Bx?=
 =?us-ascii?Q?VqGrZh6XYDSaGDVlcdtac3whj2aFV4nWk3Gmkniarn0q6Yl3C2XOzMXyyjXw?=
 =?us-ascii?Q?U1Sgpqf4cIizs52jENHcAJzIHyInmQuaj+NU+Pa8U13Zhn7+Crt6+GDyioLh?=
 =?us-ascii?Q?s2aPPwAv9uQegoSffclv+KZX1aLXCf0UJRmhPtIr3IyCHWoSMGdvjBd4mZ1b?=
 =?us-ascii?Q?P9HBvtjydbb+iyMlSdQXJdXwkfLesV83pFBeXROBQ95ugjugpqTNq88gYzwk?=
 =?us-ascii?Q?lTYAj9airitEj05E9vOpvxt/VIIA8KFdUKbnbGeYxbAErl6CSnho6nNqTSLr?=
 =?us-ascii?Q?m2EL0YekPh6BprXY+bbGy1xBrcH3z3/nX2v9KQP1j+oZG1Qp/m8V59y4nbil?=
 =?us-ascii?Q?Fem3t/08kzhtMbCOSejBt4kRk+C3/IAv+qZcTPVFLJvUSlrNZleINPR2Vh27?=
 =?us-ascii?Q?+O3wN4AVf9kafqPSg0yrE4y7zArX+6TM1B9dLVY3OPu6eTpJJl5D+nLxsMD3?=
 =?us-ascii?Q?3lXurlUnrC6ZttKuz8E/vzpY0qVbOF07VAX0KDjEdZgy6juaFklY0xtt5riA?=
 =?us-ascii?Q?3hgyCMuSF+g0Jo4NgFJaEkK37HeEr5zNYyLQ1pp4hQ4dUAfxuPeUN4tqV8et?=
 =?us-ascii?Q?gnuZC+X4NYPmQIz+G7qxS5NxTu+zdhw2Ciipof5KFPoIt6/MTJ2pfuL6n8A0?=
 =?us-ascii?Q?k2nwcsE0PF54iLsQNTIDoJ6LcOpUrObg2ng9Ad4gSXm2ymkL+DtsF5oeySSt?=
 =?us-ascii?Q?mgtq+EkRvcL4JSQepq7SknKotgnLah7s5SCgp62IaD09hdJcB/dyKlQusY4O?=
 =?us-ascii?Q?Ho/cXFzzP4EpYTe4JsywvI8NDgruaiXwK8O9hnnEEzFfwYUMyWDj5igHnAwV?=
 =?us-ascii?Q?jsssQVRMhaCUrsI+507xEodqso3H6+cAvMQTv8V0WWaTvoJx28inM9ysTFSG?=
 =?us-ascii?Q?VR24pmzS8hG9w8hMKO2ZwPp+Q3R3nuUsB2BlNGpKMNhD3fTriF34tX5S0trS?=
 =?us-ascii?Q?11DfqUMh4o13rzZ3IIAeiolfOfvyq3XxQcRun1iDEmkty7oFmCUesjp6eOIE?=
 =?us-ascii?Q?RmRQ8601gmmmT0RgiKwLNOhFttC4sn4avQDwJyM9Q6YdRVBfmdokzi0UiRUu?=
 =?us-ascii?Q?r8e98cfOnsS59OsBIV/AXKxfR4nR5mZT+87JQuqb1uowm+N152jeEeZrq22c?=
 =?us-ascii?Q?sFq0KWXcdV3SrAjgU+tFowAPSejIO/DarwyVwag0yLefFAoFcWCoHabYi6yT?=
 =?us-ascii?Q?QBDRagJua/NNyh8QjaQfFB3nlApIfZca9GHICoLIwdGVEk6SsdIzBkQX7rOc?=
 =?us-ascii?Q?iklwSmFQJQwxshA4w8C8/Kart5vZuiYbyio0sb/eQRAHkYhI+LU4R5T+U+ym?=
 =?us-ascii?Q?54DSWV0L6vprrbLO4ctYqu8rkGYd0woC404rFZ+upToaBHh3tGcck1vbWdCf?=
 =?us-ascii?Q?1L5MZvfzIuyf5Sv5WteF1shzbgklkSTIXBjPz2YYBjQs+GFtmFk6GY+wpCbh?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6pE5m1dDaS30S6/tXiocX1xNoN1QnNk7cpmcM6IcfHgun6GfxatV8icF4K8exW4gAzy299YWWAsYAjI0eBvCmf2A7WXyh4g2JyABUvp4d2FNZDXLEaDoxfVssxdEWuSyJAF8SocIVeElm7EpPpZtUkNHy0Mmllf0e412g1KFR48iAM699T0AytBjNHb75FC+2z84uwdsfcK1h2F40aV1pgDHIiVfXKcLs7PkAuTW8OZFmcn2Gnv48hQYD3wgyTACE9wB0mavQNf5f4PXNSinhsoiOtfI0jRwPvaW5hDR/4cHlzG1SxjUkzCz5jrGTc0pti61OJNNiPLaEMxl7OKzM3/FnDZlitDEbgTiknpWfWgI0EbuHpA/bzGemttLK8sF4e0371wKDRRv4kvejNM4upHoCyuIGzxAHB3B/nBx/O1GtVtCLoU5O2MWOIKJqlYGmxaSixOVWl8L014mDqnd3kpzjf50eEQa0TH33H6vCx0rRQP5b0cMdCqaCGGFD6uTNYjBLaLstG9RIpRSpWOre6O+sgF0XjFiT56jwKLV730BMh/N77mdkH9k/7+VTT6C13F5aakDDg6CFjor7lEgWcappHFBUBjdsoXP/iMU5Dx/76k9pc0ZdXcIbi9Ld3bI7xxL+jhsGJjN3++i5wr7m6DPqOB/yh2tXe83QvWeVkJMtV6e05quXeWKcb57pOx/Duxh+MXpW/fMOXF4a58Yjh8b1JVeMV60w8EwzdXxU9bMJErIjYzmiRWa+UO+McUb3UDlqWObhGBQO9KvrmMRobYXqHPP4nqoh9udw2NIWbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c404922c-76ef-4eef-164d-08dbdec9fce7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:11.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oUboKjAU5aBDH+xfFhiCj3CoRR1C/6p1XG7uhO9LjTuNscFiyP7r81aroW7v6DR58CX6Qnp1VSahkjTk+G/Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: iLFK3hPj2yS-0l-qWDjx_Gt3oRZMwjsJ
X-Proofpoint-GUID: iLFK3hPj2yS-0l-qWDjx_Gt3oRZMwjsJ
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index bc203893..81023cf1 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2736,6 +2736,70 @@ static struct metadump_ops metadump1_ops = {
 	.release	= release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header	xmh = {0};
+	uint32_t			compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = cpu_to_be32(2);
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_COMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_COMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm		type,
+	const char		*data,
+	xfs_daddr_t		off,
+	int			len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_LOG &&
+	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init	= init_metadump_v2,
+	.write	= write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -2872,7 +2936,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init();
 	if (ret)
@@ -2896,7 +2963,7 @@ metadump_f(
 		exitcode = !copy_log();
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
 
 	if (metadump.progress_since_warning)
@@ -2916,7 +2983,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release();
+	if (metadump.mdops->release)
+		metadump.mdops->release();
 
 out:
 	return 0;
-- 
2.39.1

