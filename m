Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F347CC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 19:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiB1Tws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiB1Twm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 14:52:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19129D109B
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 11:51:58 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SIJJnf018824
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=sdsv84fszZbvYH752V/kCibSrOIAmenkMEl2tV3WFFmpZiSGJ/dc4YsndbAlGLMz25js
 xoh4X9R1Hcr90RLdIgV3abJmdxaXReF4BK2cqH8oBTkih0po5bkXWiuEiZ9vTgLjbLvK
 LptVGROHnK3OlodFy3EWuyD4CmLelWAWp4qwJArQbX9zyk8+b2fObHJOea7QwIvl6piP
 Xh2jM80YJv+h02Lw/uiWGn95WyFLrbVVHQSuvHN4Naez+F1EffT6CThMMGXDFA+Wyik0
 hyouoI9jhFQ3PiN8xZCSyS+K45UPQWSi61aZmadRXDHOd8A+K9N/jkpYpWu1xeIVZBZj /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15agqsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SJkltj076550
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3efc13e3fr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:51:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltIeiiizUEs243qrCvia9rqywkeav2F9qJncveOyIXir+yNpJfFQNMRGfyM1m+96PQt5Kpql6fj+j/TMSu3WsUslyZvsq5vPGGHrr29bdEUoQDW7WEcyN1bqWuEqVUcKuqi2GQwGAPu+QOMNk2/nrGUaEyofhP/yu3+AGpN6UJBiv5M7rRBojaL2fDlPFAZAmLshK+g12doB5rT3n0iqvo++8LnC+MctCbVD1i4Ul3nZmD7k7WRVY1wzVyKpcCyUrgA13ww6yRn+amOSmD7r4Y0UT0x6HIBWF60zxcsOA5VBSEFyyNmKZMFdQ6QrayDg3ujEb9NRXFqQpONZ4gFhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=jJ+b78u87BAH4lAYO0UHHnFHGKVO8bYPJiSv9bkIN/xF/8/VZDew20jGRYlcskbXq3qvlFWiYMjBvAppu4sQX9Ss3Dp3LmX0VcL8XBCOQ89LtgHfB7KlfwP3nxR4W9GmggzhueDnqLVgZ91/+W00vUiEdmUDY63uUN36FZ4Co8FkcTfFFSeiarLrt+eSB/vDFE/XsLHv4hwvvXzPRoDslKz2sebrV04udyOhQIyH4MnsLVz9msjnyvhDXKrWphva3rm+UiIIobX6MeFpYacKM+67lOuY2iqeZuvAyflRROGmKt+SAy0IRpkkaXSN0av5SQn9rwTLLiBJQNi7a/Xkcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLTFl3bdtlWGt6UMCQpgcnbNsiEqYCv7cGYKd50yvM4=;
 b=lO0pd4kXHuewDazXYtj4HHn4PHnYR9/OwFuM92BG/sAf6qwGjVuOyROVtgyMahSPy3PAWolwOd++OI75M0CaZ8CgyEwkXS7roPTQy6h/YYWbuUMSpM8ERFezxf7b84oZ2F4XgryrfjwsS6kz9wmn0N/NturMzh2mQyQEXyiv/n4=
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
Subject: [PATCH v28 03/15] xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
Date:   Mon, 28 Feb 2022 12:51:35 -0700
Message-Id: <20220228195147.1913281-4-allison.henderson@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: d4f905fc-623a-49aa-1fef-08d9faf3c56b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5612:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56124D5B206B0183AB4DDBDC95019@PH0PR10MB5612.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IpzV49mecFHhP113pJsCEfB5Rk6seltoCqHAhZJt9s2vPL4fLn7gOGhSG7ZJ3KHCKfDLHBczah7VMfJeTevoUqRvBSeXHLrzTIHV/khAmijeNTWJzLiEDL40puoWKLJNaXAAb0nTSSowZWQOVH8fhho27CW+HwLdCAMUPGvtxy5TLBtKPOZncSTMBoGMOxdfccHkYBJngpRHDuWPFXy2wG0mNTsITSWvXyGXeLOrmS3yYqZ7p23KXIs3ueL8rxhqvXLSaGRXA+cB3RTgx/RDdj37CSKBjrIy16qKEVEmsdQ7rha0WI/obb0kWle/X+JAT91R8JGiBoiJkMVhpEq5GzO9Ib59uqcG10+wL5gz69bf6n+JAU1lrF2pqHml9XIZw6vvUIpXx7OGUZnSD5Yh4CLpXO0N6gUtHJeIIdnCeGRXH/DgGwg76HEurU1sO3EUKos53Cnd34sgM56w9BA2EuRYbpc1er7SDHRi/qR2rZNvdPiNgLgzcKb76NQs4c9at3zcQc4kDaY7l7Gn0iv1ugkBFM6nWb7akrRdHenTxDbmaMppcX2lpnW9ilmpt+Y2C3k3mJ/RtrtzxLqARA833YZ9nHjuQEY0Rz+vfn1EAONRZ+ndSODCKatXFFWgATox00JBGnNRuv3j9m8w8Bx2dXZ5N5A4HIY4W5HuiY7OURqtUwTie28Vg62OxLM64GZWOohyRSFGWvEOUWy0vvddj5ZKRJmQInz3ybXEwSZzT0exeyjw68SDEhe45skOluHU+/4+WKQGRnSgaKZJ1lCSZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(86362001)(186003)(8676002)(6916009)(1076003)(316002)(66946007)(66476007)(66556008)(2906002)(2616005)(6486002)(6666004)(6512007)(52116002)(8936002)(508600001)(5660300002)(38350700002)(44832011)(83380400001)(38100700002)(6506007)(36756003)(29513003)(40753002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+X73keytSBW+dZNnHhFugJwPrWOWlIGq+hnmvQbA17K/4BplQjQaMEg5wFxu?=
 =?us-ascii?Q?INnFE0h/lDaWiJB9BPNIPOYdAsJAc80wahDZwCldf4aG2riZ/M/uG2kswNCV?=
 =?us-ascii?Q?2LCbBWcNbaIR/E8+NxjrwxLXznfdpgvATU8xbkCmKnqSh62gCT3GkuW7vD4P?=
 =?us-ascii?Q?szBjAPGfHjvzV886rrAkZbw182Nwh/mgONT7KbfuKwaLxOEQ8D+3UWUQyY1e?=
 =?us-ascii?Q?y1WMkm6e5IhBugvokG0sslexKPzOyq8wMhzMuRIY4teSHcRF2FuH6j8m6Qb6?=
 =?us-ascii?Q?hRW4uY6AyXVGt2eCV1hgwRoOEKt2Kvb1vuFH+8XPEuY+yN1/wDS6gkc+whUS?=
 =?us-ascii?Q?gZil1R+NqqhNu8OsmdKhapYOSAd5YixxceF0h9oDnILcIrPmjpmcoc4llHn8?=
 =?us-ascii?Q?K5zAXXRg5FVlXtgnv93JD8nCRhRrf7OHIuQ4EOeBAsEwoqFca4wCvFeLpgWs?=
 =?us-ascii?Q?hDVU0Wphwc4+wuDkazfolK4b2gTokLMh/cnYDuMPb79p4MtUq5DBuVuUaOyB?=
 =?us-ascii?Q?Ll16Af24if+21zoA+zH4bt3s7m4io0dNLVSY2kKEEhxCxooAuWsQ1UNuFru/?=
 =?us-ascii?Q?OceAqeV6aFyDN7zA7mN1wekoItGMi5A4j3e+YAdzInfKtkrPZrFcywLLcHNY?=
 =?us-ascii?Q?4geimGxfhYYdwLIXhrjYeLns8J61l0x2PUBZ9dp/zfmVk+n74rsaXGDiKOqU?=
 =?us-ascii?Q?YkNyXyS0jsBwwWAv3WUZ+XzwEDkTxpIVy5s2rVmGADx9iZxrMir4wsmtoAuS?=
 =?us-ascii?Q?5Fp7Mc/GlZYnPyiB6q1m/6sAjCFmug+oNr5Cj1ZryUWeUFMKaIHph3Eo4fHO?=
 =?us-ascii?Q?V3hKrPCZpJjma5hDz9qvj51pvV8ELw+aeevPUm7mQEAqEXnPxd2K/6y7PVmK?=
 =?us-ascii?Q?zk4tybYonHcQsyYNIV9oJ5oB7oOXfQDAvHGUyxyUbJjOsjYmazE+PDclxLvF?=
 =?us-ascii?Q?RcQXCNdTGjtQOBQItFxKcm/dNafkezwqXb1xbhF5vTTarPpwJb011xKWCzpo?=
 =?us-ascii?Q?9BMFF3lCqdTqCdArdnG+hnXUSQb/7Wy0AFF15DoKIpPxsAHnp0xvvPoDp37z?=
 =?us-ascii?Q?vMGCtmwCXbDoyM8PdT2QOvUo9RvBdrSa/1YCRwA2ZKY17LjAxaFjfOEn4n3i?=
 =?us-ascii?Q?GpgI3I9goZreVNHqO7I9mQXrwBXgnuwrhZkDMeark5sV12kZ1T+7edEfXXl+?=
 =?us-ascii?Q?lzmUjNQup/FBn3DZX2nzV5uoVS1gbGAjRqnAWkJA+OgKK8TjnSsBvSd/VEmv?=
 =?us-ascii?Q?VG9WjDJHZkpWHtTGWjs9mJpjxCeuZqTXxUGjhh/91SFBZKSXqcXxto/rPAku?=
 =?us-ascii?Q?LIQHQ+svg3fO9VviLmjuflmHCMAZz3fRD5HL9DIeNEjqltIpBqMfuyQj3yLX?=
 =?us-ascii?Q?+QlunVPJEadwsyNhrk8JaKIQ0ubuh86fbv9NYO2IE+dhySH6we/gfOYXjsXH?=
 =?us-ascii?Q?C1sK0ZKaAYEzPfPvFiJ6NNQxN3Bfn7ATGOE0jH/Vw6jnc6HcQA5cYlg6YwQi?=
 =?us-ascii?Q?EhJjzJRGv7wSoaL2i3GB/qQmf3ZJ8i/4xZjmvZz/iSQWz14K1GTs1g5UoK57?=
 =?us-ascii?Q?oLXFRZ0y9gEUDvPTXmh2J7vcl8c6yZT1ywf7COpstAyhRCeNvZqfa256Nv06?=
 =?us-ascii?Q?Gw9R3xhcMXOLQIHdEjERJci7y/21HFw8OqXSFQFXP+UAAGkEqUOOEA5rCu6V?=
 =?us-ascii?Q?WVx66w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f905fc-623a-49aa-1fef-08d9faf3c56b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 19:51:54.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9yp6R/UHxXgZkGNW7L6eNXj+8Q9kd/cRJZWdQ4Oki1stbhtvlOe3zfowlbrScdwxp/EbIWXhOPhTNFh19yzCKmh9em2yVIHPd7NpchgfD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5612
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280097
X-Proofpoint-ORIG-GUID: jQzag1zlh34UJ-TDrRaKYtdbdayKb2mh
X-Proofpoint-GUID: jQzag1zlh34UJ-TDrRaKYtdbdayKb2mh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During an attr rename operation, blocks are saved for later removal
as rmtblkno2. The rmtblkno is used in the case of needing to alloc
more blocks if not enough were available.  However, in the case
that no further blocks need to be added or removed, we can return as soon
as xfs_attr_node_addname completes, rather than rolling the transaction
with an -EAGAIN return.  This extra loop does not hurt anything right
now, but it will be a problem later when we get into log items because
we end up with an empty log transaction.  So, add a simple check to
cut out the unneeded iteration.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 23523b802539..23502a24ce41 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -412,6 +412,14 @@ xfs_attr_set_iter(
 			if (error)
 				return error;
 
+			/*
+			 * If addname was successful, and we dont need to alloc
+			 * or remove anymore blks, we're done.
+			 */
+			if (!args->rmtblkno &&
+			    !(args->op_flags & XFS_DA_OP_RENAME))
+				return 0;
+
 			dac->dela_state = XFS_DAS_FOUND_NBLK;
 		}
 		trace_xfs_attr_set_iter_return(dac->dela_state,	args->dp);
-- 
2.25.1

