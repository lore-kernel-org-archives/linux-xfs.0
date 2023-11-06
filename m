Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BA8C4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjKFNLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjKFNLc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE67C91
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:29 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx4Ig005779;
        Mon, 6 Nov 2023 13:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=hLbfoQcMXYz+KyT6cw8UJkM0eNAfpv0B/G2bwXNAYVs7TN+n52riSceAW0s+TFfpzKkI
 9H44Jx5PoEc+Tz7ht3DaMiq/TKjSg3UNXmvb79gKVvrga/7LPaIm4i8L3rsdQ+yLYHs9
 6c4R436wAg9wuQGan0xxGKorcVB/xooauthrGuDxL2pBSLazJ3//rdJpB62DX9spv71f
 0Ui9uXN+0kglR20ZhRqVWo0DBYKsPsljg9jQCTCKe5fgOlHnrF9xtAzB5oDb5Dt6RNUl
 FuEVdO8czMLufCA/AtbmgHuJyAwFAQrWazLen61TMc4Hqmup/vUNyp6y/xmUK7bu5lSq jw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5e0dtw8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CtXfJ026847;
        Mon, 6 Nov 2023 13:11:25 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd52825-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/j9NWB8oT44IcRV9ate5p6FmDFq5ETex25E/Q5SYINCWv2n83ENv975z9uIJwvX9b3GDFAuoBhCHU2OL5s2Os6nz2eckq/zT5xX4fyq+vBp9X1M2l5W7SpVu/5Wtxa5Zu1tOIrvpS7P0MrcM9FekDbKxP/0oRrawLDtMrg//pAGotF9IbfyBhQwGtc7rV3Zc9yV70793c86EWQ6U9Rkt7+U3hrtFNnXmYnVC4GAqCTBQWuwxEhzmacw4luTlUqegvDNxfeag+ofhO+1l/Ym1k6ZyyBYUEVN1duCIu2XFk7ql6Q0xHv9jO/VuIwMqhmg+W2lkeXJyfLjbQ69jqedFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=ap7tyvn9cs8/O/JeXVxE7pZ42Iir+ENw6yABd9t+/eevp3cwzAK3Rz68XYf/o4vSOBRGCrUeTJgSzMNuZX1NWc5YJS1SNjcTzusZ/HpdEycFrJ5kfou0qesnRqr29zD4K+mxztwGXJvgfETpxltD+5pFhUMz4kYa6DCSy8TEjS8LkY06UISswPbQNPV8q8yM+KGW68MnOjbAjiQqc+hCz1POcZ3TrpG4+jz4ZuS1BSK36N79cePCKEB9uwAmgUIMevYmxn+SSrowTOsjzmf6ayA4nDsU4Pj3qdWMAnjgyGBtApV556jqvkgaOIIWrBA2ngbfSfGkyIQYC19r05RDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx1R60DXnIB3N5o6yMynJzdO/XXQYFPlNasasf4Q6TQ=;
 b=Gj7mTXe+9tR8o9JzjDVlC0oh+Z3hQZ4BZqLBS7gNT8SXBSrBnbjDxE7DxqlUZ3M1O55MfCQACbgnnhY5W7+juG/EvrOVA0JmUGK4/7iSvn1v38BzkzCySN3E2MtMHf30HfQmjCoN4D6umdoZrtO2EkNZKZxVrnEy76jrm7gw2IY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:23 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 02/21] mdrestore: Fix logic used to check if target device is large enough
Date:   Mon,  6 Nov 2023 18:40:35 +0530
Message-Id: <20231106131054.143419-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 203a6b7e-add4-4893-c395-08dbdec9e018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLUoS+0SiJkXBJ0/OW5+ZpUo5BQ6RUjreBeLw2hGOE4fFfprWIcLMTkosq9jimNu6kBH90LZH9v1qPxbIyaClegwoCVX6FkGazAOytw7StibSrFVPKnXGiuKyQx4v9ZILmTkOJ+MB40+ZH2WX8L1eztUXanl2oNwYB2qxxzGylC0ZCVzjY7pzz5//8kqDekl8qiRalKp5JhKArUt074NNCLmoh+oiIAh0CEb0wFmcFKZ2l/BPsFZDrAViKx96xTHePiVWuDIwk5Gq/AYZGYAyjA3Ka0vbYOrCwVmPMIiWRTmE/jGSACmz7Zxpx0fpy5XGFaIYQBfWkM23MG7rFlq7in8Hz8Cobu6mKmJ8o6VjQkmIfky+Q+ILr7cX3qSb7KssWxb0k+tnmbw5nEH7HAQ+Vq6NaeHvRxhgANF3pwHTuB99xhsGSytop/1nYOOU2vTTTeshcoYThv9I7U+k8VoSODG9PA8QKKmBAxoTqNRkBDpzCIHN7XsLVcpwBq7np/lcbfeEVXWiLmb9vkRDzOb1KK7IGIUo48snlt8vhotgQ7DoU94OqkIF3ujk30DnvxB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(4744005)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UpwOemVNV4qe7ejGyA10iRMX9Mt4XZBXvVFzooIfGadPHt0g9udiQWle6ayi?=
 =?us-ascii?Q?cVqU3XgC5cjEFqeVYvWp5cdjzackUYX1LaYagQwh+UIVwpKR1uWInII3Vx0J?=
 =?us-ascii?Q?8lr4emKr15+vy9IasjJvpm5Nv46C/EaaPvgFrE8O1Tj2w4euzkDYthxGeG0A?=
 =?us-ascii?Q?iDTm8qOONJSJsZxkCxrLDZR7WNo9H5NlY6/sEEEzII4+GEUkPuzGXlgEbROq?=
 =?us-ascii?Q?G0q5h0g9UW35xDXhV59VaQdMTMdZjYw4hNXVVaPqJ5dVJlRfSTx83wy0Bl/a?=
 =?us-ascii?Q?aRWy8fkBs+BNKpJd6YOZQXwy3KRlmh0ob5zdAd9RXg+VaGjXV0Nb3x+tG3Iz?=
 =?us-ascii?Q?qu0d4PwoATqW+5yF9p2lai8QXBPgAMt6pIOQElkKflaqzUe8LwyOlc6zX6nT?=
 =?us-ascii?Q?4/hvVAjka6MGos+ayI2lpYer1TcbHfe4Y2SNgP16swKPkCkv6VQB+bEaTAGS?=
 =?us-ascii?Q?o9b4vvRQGs5ivzvU74PsLci+BUFpkR9bkP2Kq48hl+YvIpk6wVJxnEEBGc2T?=
 =?us-ascii?Q?0V9KHjuVba+eBwJcZzPeM+1uCQh2x0TRikCPsbOMBOmpjx2W8FlH9HO/bzjB?=
 =?us-ascii?Q?jNLLe8tP3ZNNK0zuMZkgQWRxVyVxZ1u4n+ao1ut49BceoARgnL58vrdKxm03?=
 =?us-ascii?Q?ZPo5KlKnXpDQp9IvHrdzmNV2B675DLdR6gEsLzA+Uf3PuuTVlfNC+Ln64/6F?=
 =?us-ascii?Q?YdNz1LDWxf9NW6z2xM0qQ3X9tt+WpGbeh8Km+DTneq09KfSPW559BwKXwKi0?=
 =?us-ascii?Q?YJIfeNqDHwqZ9pMu4xgPaaKGFoYa2KjZLqQ9wvJ2Rvdql7/1r7UGCj4ImB6O?=
 =?us-ascii?Q?3ZUU8GmumD4aUxdZR3AAT0HVFSqD8lsKSEB46TuiCkDj7M60xUfBbOaGQ72e?=
 =?us-ascii?Q?xd9V+/3sFcKv0sX4gJpgPskafxJ20mMMIq65ao0VuFqGs7d879mD4RmjiGXB?=
 =?us-ascii?Q?qFpe21IQWW0ifLx7DAUWWR8vWV0kFcKz0mP0RDps54XcKpOFYOZYLArK7hOf?=
 =?us-ascii?Q?ITganYsUFlp7CrwofzAZQ8mv3xnNanFDApchAfCuOp7CL64G3jwqOl8isaVx?=
 =?us-ascii?Q?vlerL8+XmfRDrFph0bCn7SZbeFH1mGbJbIcKgXGQ2aOdZtKcVP7e4wnPgTrg?=
 =?us-ascii?Q?2T4myoLm0KRgNo1SG4elgXgOaSjbUbHTLyTMbmaLO0T2kZoHlhtg7tnkozgX?=
 =?us-ascii?Q?LzXLNXXNurdB1XpM3++rXFGK3s+edh90JUloay0fZOeTJA2GFOn7ZpM2u3RU?=
 =?us-ascii?Q?joyP85r8IdwgCQCzbojeaH2qWXK7aHQaSB6cJuasuKBub1yxPIFaT/AT9kph?=
 =?us-ascii?Q?brRaCr8YS90cPvlX/ydVS8AVGj4H/vShRM4WcWqjE5C3fjBpjDGuNN5sAhbM?=
 =?us-ascii?Q?031w1uOCOuMBNjlwr7bJfBZjnffEkwgpRIS4doKh1ed9V6juRbeN7JLpcJ5T?=
 =?us-ascii?Q?XZHpRsF1JOC2tcOm+mHPoUR8vZGxHgtZEbZzln+oA/dRsn2jyw6b7fvwm8BH?=
 =?us-ascii?Q?sFP5Cnone5HILA26Rz98hPuptl3OB2NVI6XH+6wKpVHmVExxLLipiZvVPfed?=
 =?us-ascii?Q?qQ20mKnvu/ANwVQV9IAlBx0+/XlIU7LGKZW+IfJ7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q36cRgh98JmcMRGO3i4v2qlY0nqFdR1B+FejKYqmEO7HcEjetRFL/qWJrAYhXzEtWUyk8qzGDWo17uA9gUHOtqv+4luWm4gLJKx2n2D/GDmqj01SQyn7Z2FRHoGESQtOM6W5rIrEQ55RmIufhq2n4+l9qCe1FncGa9As/ZRRrWxiYk8gk1es1dMlBgKaJWNdITL1hQrb4XX4SDpK4FI0PKymzsOjnCZF33OTheo1c6mjIyuiVrVykjHQGV+6ZgZ1+ZCofZsfStqu8kO2dPGewCuq5qJAZTWXSv6t9qijIE60uX7O7whSFM12g0ylcaOw0je/ePcPeCRcvpA+b1ELHHgbI73sHQm3OFcxTXvvR0zRepD5l5RA8ZgeKkIOemzKoTItyCem1xNiZF4uyBDgtTmoUypw/kbMlZ+wkk7fh/AAdwKIba4ry5Le7217nd13/Bfly4O3hWQCDAFVqWahE0sQDLjk9kOjy2LOPzLS5CWdBhGwkvgOn5o3WujT+96Jn9cPCqBE1YRaAf+xNud8UxP8XD5a/99yTCP0CoMq6OGoqq0C6t1F2Cths2j7g6kH7iUXPp8oGi16FGzIkaSAIawmMjsSVlU/poSU3/ds95+4SGJaUlBmXBlbTYq/EYCavoXMIl/Hf7MemRwSmSbZInIPdjyMRCwxrbLGdTgK3DnHQdIogEL2Hw4ftXMHsuh9uTErzl1KYrnfWeINBq9W9KtzbXd+xx/IZrarsWlnSPOYQM6sguYYNKt/5nbWo1nPa64pO9Y35xW+epTvVNh06LyChQbkKe4IB5K49d22+Xg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 203a6b7e-add4-4893-c395-08dbdec9e018
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:23.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQuyRHHMvIJVqDcbSRDCu7nfzBKgjZIsdM9fV8Re37W5P4PUTQyRhm0EXsJCAHv7NXNcKvxgWgnSposbw99G2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=957 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060106
X-Proofpoint-GUID: uNe8egKRULblGdIjYmW2vTUeKuD_HFen
X-Proofpoint-ORIG-GUID: uNe8egKRULblGdIjYmW2vTUeKuD_HFen
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

