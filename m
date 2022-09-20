Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F60C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 12:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiITMud (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 08:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbiITMu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 08:50:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E20963F0D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 05:50:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KALKAC024499;
        Tue, 20 Sep 2022 12:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=xD0g3+woHOJPXI4mGgyWsxSTc1OhDqKklk5vCWj1BHHrVhe6XAAur8VAl6u4NcwQB7Xy
 mflZd9yv5me9S3mWt3fHb+sKWJ5jTSrViqtzOW1pzmgY+gmlmm3vF/94EEfSiuzfSiuW
 QkLoOG2X7CwYblo4tLpo5ei7qssp3RoKWNanNlKdP7zmvYOU52UEaDZqp3t8tKKcQQbc
 WgnD94Cnu5X3OrFJcyMQSVMXiRfAQKzWOl4bETNEN+mpJe5uVahMBvuIUWkGOabdeiqD
 tCLaUVkedVSMlWIDhT5qCjw7EGrCJeCNp5SnUNBS8feedHjqC0gTLc9J9R4KCkRpg8yq ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stexjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KAroTH027861;
        Tue, 20 Sep 2022 12:50:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cn9jhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 12:50:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hmtr0qLTGzlmE/x31hq3coSK9rlXUKh/CQpcTnXy9z4zauGRYdjBcEK2/l996fZpqaxQPld8v2O5CdHNEXvt7JPFCA1ZXdHlJQPACHLvOBxXjjtVj11Zl5KRZ74kKko3Sri4Ga7vBUviGUARb77qKiYST/P0qdqAtJ8HkwZ2O4zSDz8La2jQB+aSRrqy0nKCl2qeKY75N1owPDQRud6N6bV8vU8+nZo5PwSwX1Czb3OemXgBqM3f3UW3NvrnxT72XSST2ucOdXpgFHO6yaOxqu4nyE9iR1nZI47Cg49jb2htpdzj0wXOPOYUXpUkmWEQf+9Kg+mtNyi1lgYeA4egqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=lhIjJhs6VcPEA1oL9aLRy5Q/Fd0p4HDhVvv2rt64XWHgNpd6lhsocmwLF9idcy1Zc17Xglho3jIfV521+aBPTnkjaxwlu+LOHk6VGEtn0ueaSYnWJbBGJ97fWpAKlHHL2i85zXRhWhFJfEN68FcN7sbJj8CMPGJgbs0dm+Ud5wSUvQr3Ui89cuzFiFPVet/ofBobaTe2f6dMXEwjRAefRwbfmXGmBGEVlgSAitJ/xg11L6GkhxWf9+rr41uFjoQody0CcdoUzMiXiMtoaVsF1C4bszEQZxo/O3n2U5ohUkLP4lHAaRxU56OJLX+FPuzx1uWlzXGUk/AxFf7XrjSJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1keeQzCTVytQp3OFPOO7Zjmvdb5rQDgP1n8vzAz3v0=;
 b=zejLEoyzWxddL1mQYeGerKZkkv9UiOpoBTLixf2CXznW5bAC6Z5Rd3lIZZCkSboRuw2SBxd0aCj3HAOm07XQXpZRP0t87JSmQ44iuWAu1rt/CUDBNQZFRtZneumZ5SL3VDE6hw0MdY+OUU9v0n3qN3fhdbYXQhTftJ437eqb9lo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5203.namprd10.prod.outlook.com (2603:10b6:208:30d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 12:50:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 12:50:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE V2 14/17] xfs: use bitops interface for buf log item AIL flag check
Date:   Tue, 20 Sep 2022 18:18:33 +0530
Message-Id: <20220920124836.1914918-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220920124836.1914918-1-chandan.babu@oracle.com>
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0121.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::8) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a2b9d39-09fc-478a-3ab7-08da9b06aabc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/BghYnaNQQN3nV1I0SwSazORYCZZ5RfrRaPle+QWSk327SHI0/i+AVQjVeEciPfPE2sXv0JBa4A3JJxjxGMMJtwHGT3CLzfSH/jAaJzmHEaxeKTBxHBFy99N+3CR4yO6CWhzfnKMIhoFCyrNZ5qDA6ooQFFwxZbBH+2/N63FOLjjHIgLxAIXGLcnaNvUpDGyaYhhEqKvtQ1w0PolEIWkkUuP7kKVNQ7on8xxDNYwfD6fiuDWwZ2xojTNzdNKC6ubpbiRuCiI7lC2LeP1qQZXbufLJUUYKmDGh6lHiBNBttcSp2+7o0eqqJwO/ZXxYVCBQuUDEFJBye5mIRH7X3uCulg7L5crR7QIyvfPUfnxXkYk+BpJnwTmyFu/nkV3c8QZDCHxblo1hq3UJ0xWsY7nxjNYX/b4cP4JSL/16Nq0j0Frnqb7jxWDc9u2bxovff5UDXMq8y2QxF5cg2xrHb+533r5LwZTwtXqN/k7iyKmybjRd87rsELkgO+f7Jri21iMR91Od9SYKej++tG55+JcNwkLRAKqTKXbQq6OKseipasIoe/JV3CCqfXTN79+3xwYLv5jCr/009dsG3tzU/oybC7GP5QXoLXEBwTiUw7c0VdhC06GUJntKEHNXL4nkHe0X+6xKuki/sBog/l5N0DhZM7F8q/NMwy7vXOjD5lJE44QZhqDb+KYfVJOZqcIB8xGIWptMV+AsIUyZlfDwFuhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(86362001)(6506007)(6666004)(41300700001)(4326008)(8676002)(8936002)(26005)(66476007)(66556008)(6486002)(478600001)(36756003)(66946007)(6916009)(316002)(1076003)(186003)(2906002)(2616005)(83380400001)(5660300002)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3hi/KgnK0ycB1oaE71STMerr9R28dinlo+cCnbJpi0Nc+Wv9jH/A75vsuRU8?=
 =?us-ascii?Q?9cnXQV5lbogVBgMGOymoAg3YzdLqsr8SzqIroCbDgnimxkL1x+bdOcJAFdcC?=
 =?us-ascii?Q?DDXxka7qowyiaAapr6xmdBG6r4S6Y0FxiK/uuBIyDHGFpt/vSC1fqVf3ls6c?=
 =?us-ascii?Q?ZWefcC+V08sEUAsvTyokRdJ4BHNuNAFvpKaZ1t2DWN8Kt2K4CQ0rib5n3epX?=
 =?us-ascii?Q?WdXcp9igSRQt1yb2b9KgJt0bKZ2uEXXCdzgE3mHbDTsnpTpwWy2B34YgpYU1?=
 =?us-ascii?Q?F0GJJ2hmSD9LGUVhYXMYVOumGmges4voU19CdPPG2djsnlqKXTFEzagL1KiW?=
 =?us-ascii?Q?QcZZEvFKlfkc6zWi2GuqnZzUY3N5MhUTHh/RaRNBtRaQpl1KdgXc8hNi4DQW?=
 =?us-ascii?Q?hnwmw/6BrV1JJArM1nslgLorBUQoRC2BfykeHj3nPNL6Ls2/wiJuOl9tcfo6?=
 =?us-ascii?Q?T34kLGiJnTR1jFER5vOiyzNDFnGfFq17f+EEsdLCXi+i8A0/SPLG2wGz99w/?=
 =?us-ascii?Q?P/fVoDv6ZrhGRvaqZS5qQVdXhxJBVetv8FO0p2wyQUBeoOcCdDR7a1zbGG60?=
 =?us-ascii?Q?b2gbMUeGDEJHMKZ53EBb5X5Wwmyee3SHO0VtYRuo4EnWPCrVVKOmyDN5qkfU?=
 =?us-ascii?Q?9oeGtO8k3kvG/QlguEtnQioAwmU0LzCuXSG7LjBwSy0k/O66NabDDlwC8Gwv?=
 =?us-ascii?Q?ylqT48mIcaU5qAP9bRGIE9U8COJ/ytH8Gac4xwNAg+F5psHdneVAZPIq6V4M?=
 =?us-ascii?Q?2UH8thwqjWybKrvxz3+Y7SmKxhAxUWSZNe/aHGpouPBRYTuOAtJaECZZz4E0?=
 =?us-ascii?Q?wdsOpxK/zVMKT7omlkzcj1E1ie8Y5S+gVXt8i+8wj2sn+amX86NPhc0sWY2q?=
 =?us-ascii?Q?RofPpoUByYLgniNdy/QvTKYUYdlOpT5MdkYdUo1nlRjtfzw4NyEE+G5+ityQ?=
 =?us-ascii?Q?J60Gpc01cTcLCE2vOhzHI0co0L0PZp5IQpFakd+ftKwL151e+xVhYOZ2/F2R?=
 =?us-ascii?Q?bZAocNIvze8kX7cXVAD91jFa2Nz72DrkMItmJNFu999oAUFakMNRpNRhWwOx?=
 =?us-ascii?Q?tvEKnz4lcx5IcjFrHFtpvm650pTha90k9aRMxRyKOoJW38quZOOyRaLgnU2x?=
 =?us-ascii?Q?wp7rEnTBrnVrJ93NT1x0TWpG4WPkJkp+tG0caRG9SxaF7lcHBKHgq0ckZe/d?=
 =?us-ascii?Q?F0QU9LAHJYNf8ghpHtDzY8MD+Y9WQEC9dJaEUQyDhSPrgNezuKeqHfevfKpY?=
 =?us-ascii?Q?YR9IoU9DBlalhwm67ddff8o7bRzykBVzN4ko5OX6aQm30hekgOJGfOX8qPuN?=
 =?us-ascii?Q?1iFuTXOWLDoqUk4ZMKc/7wGBisKkkwQfs8lVPynftpp+EfWlkFYCwiHdsDy0?=
 =?us-ascii?Q?s10aBVNU79uHd5uU2sS/0fnqoWEVLZoXtMsUD0j2JmjysWKlz6Z4YeVR5fCa?=
 =?us-ascii?Q?3ZD7ob+lkTQD3YPEwOzhwLgFeydFEik7q3QUlT3BeLi03rIKkRaALs61D49+?=
 =?us-ascii?Q?dzooykAUcv0s+IGAKegi+OYwe3qeW6kNVO6ldKvYENt4UhFFUAFn24aUNG4J?=
 =?us-ascii?Q?P28Ui+O9BGGYxG5PcqxR2LRJ2i3GiQ1naxBV7+/FEcuu65D4C4j/+0BXHkBN?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a2b9d39-09fc-478a-3ab7-08da9b06aabc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 12:50:16.5105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1B8w2ieNQd4UHUZeHuiVeAqeMZ3RFzuR0DOz8EswAczqBFsx2ZOccusQBUnUbaSX2Mjr4vTBlurbJrFG0wHXIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200076
X-Proofpoint-GUID: t5pxOw-TJEGlLrtTwVc3apT6M_yAl5EN
X-Proofpoint-ORIG-GUID: t5pxOw-TJEGlLrtTwVc3apT6M_yAl5EN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 826f7e34130a4ce756138540170cbe935c537a47 upstream.

The xfs_log_item flags were converted to atomic bitops as of commit
22525c17ed ("xfs: log item flags are racy"). The assert check for
AIL presence in xfs_buf_item_relse() still uses the old value based
check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
and causes the assert to unconditionally pass. Fix up the check.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Fixes: 22525c17ed ("xfs: log item flags are racy")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d74fbd1e9d3e..b1452117e442 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -956,7 +956,7 @@ xfs_buf_item_relse(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
 	if (list_empty(&bp->b_li_list))
-- 
2.35.1

