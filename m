Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6511C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiB1Twr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1821E5F61
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:57 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJKSY018833
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=EsYhWU1dfglZvkoiXD5PpvQbwCsth+ZB+5QLAXN9rb6pv40SzpzHXLGxKvGG6AcgvBs9
 A+OkCoyDpkHjYsUCMyvZd1ht4m8Fqd157JsnB4FRtYL61WV5ekXCh9lA5wDCJaAPWq6G
 fpLFLZicE1aNc4gPCBD/0Kk6eLEOA5B1xZaJukj8UT/s4zsYCDtsr33WWxE9zc5nUFqA
 fJex4mQXhpMBvpfmF/sVlOuHMX0UPCwcvh5sZJ5TfS9SVnP8cC5ldkUVqj1BWL/DKBht
 3B0hGOFZ6RrX5YWhkBl9aQXTc7mkJsJGzWdkaUqlHe+GHyLizLKsicQ6BFd4v1WGPhl3 cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15agqsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJklti076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHrl7ilnUDwLwXHHub7FlJGlTzXbGOq6GtPoJ2U8gdFORcPS07CjYKicTtQszgN9f2PVs0t7x7s9Yt/DmsoHb9SFuniL7BlXoarrQh3QXDMIx3mGxppnlC+GHNLwdLV8CM6J/YUdPcjAKLHqi/tj9WJzBgWIw806XOZg9OUcYTeOS8jPVbkdiKPeA8tmbRd2k1qHjxgKArEbIazHuaUS9EflLA82FGlbvjWjpE/47TM6vxkV3kgkQ17sRKpwyTv/6Vxkpm2IlYfHtLdkxSP1uctdUUpjEpAax1PoavN2j0OpOggp6zfFGPhI0KFJ6ItT19PaAz1pymYkp9EDKep38w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=fL+JmCeRaCPuEg7TNdKy94Z47teT6OYHChkYQZ/Y+MnXci75MfBByt6nWq2zfa/DVERUmywl1G9F0Y3qaSPJPd+usshvugKsg/AL4LCRn1TlrlQrLfymNWMK8fQ1aN8Am/aptbBdufqOfsiN28J/kcwpKF+rc0G9aq9nktYo1QlGtoFJ9tyy2riFHxXynngJqmbeMzBFYmjciJbpU5EiFNIwjIf5KLzQ2aH3cIDrJIcBiQoBP2AWE3IsuVDg32K845ivp71kQ5MCAr5MHN8ijK/Ojh+pxsuj+DpWyFojdbROUxIldccMMGjxn0Z1LfOGo2X75OcqAUUpMeXIDoAwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPI9yaH4OGc+g9W0ZCpRY8Yi/inmc7wmPYCxIYPPVAg=;
 b=ig1130jK3DiYyTJdJh3vVqRzX++k8Prj3541B7Mp+zxSrW15mK6OAEFIlcOe1tXJDxOmDiGHWm+NLYtEziy+DU+GS68NAmpkdaKQHv0QyYTurABuUP23aqW1kLUA8AWbstKumPagvGuuDy5hQvGfXxtIGVWvY6BJe9a0bcb4MBM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5612.namprd10.prod.outlook.com (2603:10b6:510:fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 19:51:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 19:51:54 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v28 02/15] xfs: don't commit the first deferred transaction without intents
Date:   Mon, 28 Feb 2022 12:51:34 -0700
Message-Id: <20220228195147.1913281-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228195147.1913281-1-allison.henderson@oracle.com>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::33) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d64d69e6-779a-4134-aa4a-08d9faf3c52d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56126A00DA2E0C4DE952D10695019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mye5c3ItTf//veo2yJgbLkxZFm1o4EIMrkqz9t4SjFNTO2IXWJga0bFSxvVp6Tx8+VgEmdOCK0cZd6m1vU18fphSW/7Q+xt6zi58bZCI9PcgapuF1v3F+i65Ix2WlG+NQpKIAoL5qgu9UDIgmRSX0BXj40vh6+ACMC62IHhoxbDoBqrIHAnMTdn1tff8W+e+4IklpqyzqRxRVA4d7Ih+wRVn+Ygy+2kf0MqDLlDTXmGtFbgn8zCihA55yQ/LXcRjgtULlyn1UVX7+eLgAv9PkqBAGyqneiOby62lfqvzZHsL7VvIrXI2zDA+6giM/dC4Dxv2tYs2cqaRBrhJ7iEJvxvUiz570/WbXJokNdgGfjSbPzm+IKAKLBJhebjs9Vpt7CDKN2YZZ1jUrpNGKTRC+rk1NiN1h/Ezuvkrg0h7iU93qDXO9Ozgdn5Y9aGFxBf2vGIjnk82A8C9kPsgl8pgblN9/IlzE7nzcjOsyLeep6/oJ42MzehN92aXBVvY5bprqAhli+eQPzvVF884QpffpAFjo2jCn5MNJtvN+zEn93ebr5fVZHrowtSz2WH1zU36hTzcgiyM9ZxO03I20tAalHIsoy0ZHbqhmZ3Tt1XNpYDB4qOG4AY7/FbxOoCrbna6bCu8NNKttIwPcY1ib0eGyF91WnOD+o1i6v7y54u8drgifZP51TUIEIFsk7SA13edLKANlS8UhCATd3052LKL8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tAjisPLnKMKzgWc0i0bbdu3POXf5gNg0OBP/DFy9fiXsJhV3df8lAhN6xWwr?=
 =?us-ascii?Q?Idzk/GD7hawxTjGtlGNLrq/fNBw3fwS7QXsHZnzXbYGfQVlsM7w7/GD4ZYXq?=
 =?us-ascii?Q?EegzBfr+ILHAkC3mukFsy8Jq+8nDhWT0BPuWZFhBaokCKpUoAWJKQtG9NXLj?=
 =?us-ascii?Q?qMg5bpvjthvDI8ThG4bNGf0IC7men+8MmlRODwPNpRix0joWMeOos98Cz5hu?=
 =?us-ascii?Q?tYrT08BCkOMwqy6mYBNnx9fF06mIlqQsSaWvjwIN58jV6g6dqe4AidGrNuK9?=
 =?us-ascii?Q?15kHFB16GFGbsCUFR1moRTw/TmEt/WVUHY4xlaSl19LLyaavD2Fr/n58g4IJ?=
 =?us-ascii?Q?jG+XIGb7oPP/yfT9E+RSPBYl9bkEl4C2iPu6Guij6csUCdYaRHK79G2mj1Vm?=
 =?us-ascii?Q?JTAG4U8lyqrtoQvwM+DNQ+C2P3gNcM15BWAALElUVw/Xv7/W2yx+UXiZ1JGq?=
 =?us-ascii?Q?5wosAiFuvbTdSh7VQgRdqPzNqVoSwJZ9lGyJ8c1QJfv5RqE8LKVhLt+PaNff?=
 =?us-ascii?Q?j3/ut+0UO/hFJy5u2LO2RMo685Z6sQaXD2kDmRJMGoc7pAiIM8ohF/GysaRY?=
 =?us-ascii?Q?fueTMCuWb7oyRrCmTie321EPYu/AIpxaBvUIg+X9OIPP/WoG3EJOrOKOvAwO?=
 =?us-ascii?Q?wlKdsUkrK0nu69P5WOySSKfXVBjdcRFjhAOSCLg/GVN8ikFKhNdLLrI//40I?=
 =?us-ascii?Q?F5OXRYA7N68yAN2mYn7PAkplNaI7xSt/RnpM9+em4cLMNEDK2PnpaEqK5x/u?=
 =?us-ascii?Q?fgsD/32ah4RiYw7MDhs/m7xy6ORZ5iPyNjBW8YqoeSUntY8aHYRPH084IRK+?=
 =?us-ascii?Q?mcnKu7CF2taHwLPL//jtQcXDcWYai3ZTxR1R4PP5/pyywSE2gPNuReVSnEhh?=
 =?us-ascii?Q?2xy4biJOyV/nyDU9Ef4JD78lKm7yqyJRz09+HzC7Csf9hPv8Cuak8xHjncNP?=
 =?us-ascii?Q?L5RGxERvmdUNuwUFTepzXgZfyqHLZdyOtQ7ePq/1SMxtty051RLLuptpwx/B?=
 =?us-ascii?Q?gcxSD2LAyVEC9UgTG33lmtxREmrGlE076iMWJseA9USspzqYchsR3wtRZuVv?=
 =?us-ascii?Q?GuivoxQhA0blqlZH/ySIiQvIjhwCXDdklNIn3CqMCCC9L/WhfwMi21DU3eFm?=
 =?us-ascii?Q?+FEtq2U2CeKp0A0MqcLkR8p0qoVp7g2AE/ROjbwkgPRKx2dIeb3qcqM9VrpX?=
 =?us-ascii?Q?A4pEn318V2Psg7XUE0aCdKrpNiOaiubAutR+HpQce6+CbvPQw7kZMhmr6lrW?=
 =?us-ascii?Q?fUC7QS8IPaI07lZNkYm4TF8/vufWYMiAE/E5wk5HtE0yTNnSBJ6oJL2Z263R?=
 =?us-ascii?Q?7Wu9WZVVqkXuU/3irjXmWzLHTMLOeo9hL9SPFzctlpbwVd3bi1pJHj+DSSQ3?=
 =?us-ascii?Q?dgS2NmYrPA3Zq6YF0KiJgc5a0CUxVLd2CtCC6Cx/7lzY6J/mncO47Niq5dnu?=
 =?us-ascii?Q?Q/GwXvLpPRO/3cKwcZ2xnn6eIoLgP0yG+yIxS3AcBNfsw1qFeFmTOFKFOFK/?=
 =?us-ascii?Q?kBkVLzytuduRBJQdfT8/MlSFhdOjIc6EjwWDrmEQFnwUu+K4RiGTe6V9bGra?=
 =?us-ascii?Q?N2aCM4MUvUKOeLOzV2veyW4GH72Pc/xlhL2MINt+oi572dcC33JShwRfMFcK?=
 =?us-ascii?Q?/hNxabKHKnF0hd6fvYJSvTX1KzYXpkELXYnrtjb+p7/qhqPyIGAlNoIn94Im?=
 =?us-ascii?Q?yFntkg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d64d69e6-779a-4134-aa4a-08d9faf3c52d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:54.3767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zxFKfH0AmNRTVRJC2PHOROGCPVRfJhK/3uE8fdQjx21WG9iupFpnpbNAlre7pEESe4F6Rwm7+yJ31+S9lQ/QVSa1utvPMjwcvzxLkWX9UFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: BsP767czTOh9Rk-TEI6CG5ihr8cvA001
X-Proofpoint-GUID: BsP767czTOh9Rk-TEI6CG5ihr8cvA001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If the first operation in a string of defer ops has no intents,
then there is no reason to commit it before running the first call
to xfs_defer_finish_one(). This allows the defer ops to be used
effectively for non-intent based operations without requiring an
unnecessary extra transaction commit when first called.

This fixes a regression in per-attribute modification transaction
count when delayed attributes are not being used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 6dac8d6b8c21..5b3f3a7f1f65 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -510,9 +510,16 @@ xfs_defer_finish_noroll(
 		xfs_defer_create_intents(*tp);
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
-		error = xfs_defer_trans_roll(tp);
-		if (error)
-			goto out_shutdown;
+		/*
+		 * We must ensure the transaction is clean before we try to
+		 * finish the next deferred item by committing logged intent
+		 * items and anything else that dirtied the transaction.
+		 */
+		if ((*tp)->t_flags & XFS_TRANS_DIRTY) {
+			error = xfs_defer_trans_roll(tp);
+			if (error)
+				goto out_shutdown;
+		}
 
 		/* Possibly relog intent items to keep the log moving. */
 		error = xfs_defer_relog(tp, &dop_pending);
-- 
2.25.1

