Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0AFECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 13:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiILN2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiILN2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Sep 2022 09:28:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DDA303FF
        for <linux-xfs@vger.kernel.org>; Mon, 12 Sep 2022 06:28:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDED4q020718;
        Mon, 12 Sep 2022 13:28:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=geLk1P9NK4nDHc2sDyxPuSEEzi8TD6DusDB+TtlkBaFSU69hBVQ4hPSTa/ayHG46AC/O
 CxtIj8udiXWt3yrw4TS06/0qRekRUy9apKBG86sqn1uDcnwlpxVTBqrVUJIzGlYKkbM8
 qlG9aQTOAs4QKjqBSy4QR8u/AUz2h1jM/pgKJlEWCuByosNqPUij8FQ+Rd1O0srf9O4V
 CvzyGgCyEWfMJZrpTf5IAIdEZaTbY0c8BPf1P/UXkMymMho+7LWTXKLyIW129e82hEII
 TSiQVtWejs7MXoYhJFDvPj1iR7Y2EAoDxZshjonqyCESseyPYglMYLLFOMwu72+Jf8W9 HA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6skf7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CCEh30023745;
        Mon, 12 Sep 2022 13:28:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12jb92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 13:28:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOvzKeF7ZJxkoZWZi9a5+0W5y2rI3Czmf6QLmAtvC+x69ipqorkO0ryI24HlS9owWAPi9b5uSl5KtZJQM7yQIzOkvo6lN6SiAZ8JYpXzsfVXAcrv5VW9Y4M1ChAwgCgFZwCqT2MEvT0sVgtxKzp0N+QPgOjScuc7lQ4nIsCxpxp5bjiMSj4bHBF91Ksn0WwN1XbFqbHT8YwvEMv5+Ty+XJ6TfmabCVWd0ocJPGMBQysmZtLP8mka99w+u1vr9KCYFVQAV/lZGC7q/nUZ81OS6yOmmvwhLWdrsKHFQlo/DMBT9urCJjm7sYjKWh7vyH9k788URaS81gTUA/Eb3kx7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=LmfJO0ihMo6SEom5BmI6fnVwzpA3Hoh9ySO6Ys9U8pd4P0NyxAyfK9QKpYpJx7tigoYkcWfQPR78rVop9m3z9I/7wYboRuuQWoxoV+JEQMY98Y+cwby2UvsPNVZnTo7s+zhA3yOh9xc4dLPLdoQ/peebdwW9b/KvOeiEGba69LjgMI1Fk/xenEHuUBJtNwN4/zMjeyB95z1f/J940lCrGN6VOlCKjsTMXpp99EpbzYThq19lWUWHu99OmAuFFJ1llwuPZmf8aJo5N4DnS6B8ZkmSWquFuiW+/9XkxYbLhcKtTReuiAkf0v5GPUQkIDTKFpQh3cymWm3WPKlEXqUn4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KYi8I5UGHdiY/XDIZfVB7VyQYmGX1gVp+ej3oH0Ous=;
 b=HYcZ6thcrIJU6PfYYqHL1cDyA2pf3Q+ri06ilLcMoGUyywL2QY3/wjzX6bHBSX3fMdZaa+DCiu5LkCkF0rhiXRjXGo5DnD8IXIZpjHClUO43AW+GqdFZvvJeEJZuuA2Ul+5ULQ60T/ET9nxAvbkgk5Yx5tfxiEvKkPscAxNK/G0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA1PR10MB5888.namprd10.prod.outlook.com (2603:10b6:806:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 13:28:27 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::709d:1484:641d:92dc%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 13:28:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 05/18] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Mon, 12 Sep 2022 18:57:29 +0530
Message-Id: <20220912132742.1793276-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912132742.1793276-1-chandan.babu@oracle.com>
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA1PR10MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: b406171c-847f-42ee-246b-08da94c2acee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13aAZEpVrdtqOJZF/0kA5TkbO6mDkNCwBUBIAsJVa+ur0hpT/Nqi64KRqGwpkNyrmbj8ga8FzTpt5isYSyB94aVU3qjm50j2S6lwMyexNOhdTjIb0H6oSVLQcXsegu1XAvfEReTo2VwFF6fDyItzifvKz5YPC99ckkW1JsLTdqcNxClWb1OW9G1aw2coMVAHHLSl1sHM9Rv3ZWPZB/EWHxJy9iC781rE4468+tb2FexqYp9CksRYhb3wUGkLTHejUqe/74kheBTwD2DB6HzbIdAFItvixQVyGslIwtwi7zVSpczf1N7DYDrmKDpZfISfyXjqYfuoJHV0sf8POzPa6/oZmZtzqrB47bFQtEeAHsedQBc+6wyWxSAUBzetaaeHv+Otvc+FTPboD4cFCCiFm5FMAgI15fuDqn7fv+A5pt9hdD+sU60lcg7WLivU4zZURE9LMNWG3ak+g7KWrsqfZFpcPy9i7iVFnWSHGQCPwJwv5eFtMkuElvdvZg+5IxsiwyCGX4hCntLLYmgCQAIYGSkspKHhUyNYU2tz59qOquzvJSCFkYNQ7g0d8t8VVO6p1geslonBEEvfo4KBPcjV0DAZ33QH7C/P06bxnhA/3afj7FVgHmCpoHw8f+7vwgBZhoUMDP4JQZyw4ge3NZ4IIFhj1NRkGA81qQ52E0Qz7h+RYub9XHoSpGhv+wrKqKl/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(136003)(39860400002)(6486002)(36756003)(316002)(8936002)(6916009)(6506007)(83380400001)(478600001)(41300700001)(186003)(2906002)(1076003)(2616005)(38100700002)(66556008)(26005)(6512007)(66476007)(8676002)(4326008)(66946007)(5660300002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gEaVtjo9h2p8YqOdTzFU3+orSydEo+rOcn0J2NwLcEnYhtmfsUGHfX1DWG/f?=
 =?us-ascii?Q?X4tLtXzAGfp3mPhBZzqNQStpi5htLw8RF8NXr/J2OycenKmueuV5O2n1WFdc?=
 =?us-ascii?Q?gTv5ySb3e9ZQFubtRcykIO7uSAjL+jkmyoaVHK0ZZ0hFm032hMBXF9G5R3KF?=
 =?us-ascii?Q?dgvjEQYqMJI8g/VlwRnf2pZgrBU/9QNM55qGD1X9eEI+4nAdqrJIaJ0akuge?=
 =?us-ascii?Q?SJ78xCGUgZCpUrba/um6IhUFATmVGHJ9GwAMcM/zABgCurjDISlv3BHbx3My?=
 =?us-ascii?Q?KKrs9fSabWR+lscnYNiSyyDMQqzTU1YA+62ZMWV0PbrwpmHi6dI1HhqbaZ9s?=
 =?us-ascii?Q?jJFXK23T4XhfL1FJW6FyBgfJI+4/ySV9O8e9K9r6onCQ2slvrbZSNlO5G1zx?=
 =?us-ascii?Q?1uNAVd/snp4GyA632ZVY+71z2aCbMOL+WqBEIR3oTF+7yWOkL0oEZ5jq8Zfv?=
 =?us-ascii?Q?0XE47ombWskowaP9qmzYRO4A3ZHCZpnpQOZSWwXUVEo4vbEg6ELElI3sz2rt?=
 =?us-ascii?Q?m/hBTvtjerpb64Hl2PA0dMOnsRsK/SCENle1b5BX0qf7XSzHuSe8LZEIYF20?=
 =?us-ascii?Q?SPE6X1WFpwV5by86cp9EP2HV5QipWfmpmFqwMPR8QDljmMExizGvJ948m0a0?=
 =?us-ascii?Q?FWrAUZMcsp4mrMsCkJt1tJmFHYGS/cPMMM5ag10aJet1O8LGKxewHPxFdbPd?=
 =?us-ascii?Q?nOufvD+BW/f/cG5rHiPCyvaUZU6yb28Tm7FRRSvDr8DyOAguYvhVbrDOXlsA?=
 =?us-ascii?Q?ZOzZGgyzRsU9Z6AQoWQg39Kly74Rxj9//OnYE6g4e3ZawhzVMLQZryKi9P/f?=
 =?us-ascii?Q?WaRLCkRlEsDVp9NYokWtFhOtpjNMtyI7UxduGZlzMhArPDgilxq2RsK1JSRq?=
 =?us-ascii?Q?/rgeLI0iP6knMpI4FkV+4iFl3IIlOj7NgS7mmcE/illvJAEnzEt3bQ//rUx2?=
 =?us-ascii?Q?UubrWjhxsgy+9UPEKhOSyNxdT4ZJUUqcKKR/gobWYM4wxTjhy1+GHsiPKwTC?=
 =?us-ascii?Q?GeHlzC4cyBYSJn344KK++iEEbKY8J7zXrdZhtFVozQCQPzmRvq51L9bEeItg?=
 =?us-ascii?Q?4vbpiJHe1nxQ+CjywrUaJSODqGJ+7xemAFFt4w6RuifjrZyNg6SjM8IWqAxm?=
 =?us-ascii?Q?yRj9IOhZtQqzUToHBTtR1clDCIinE8XJcJlCuce78RLwKNU6nv6rXVdI8xJi?=
 =?us-ascii?Q?LkO/mTo1ynSxEd1nLSPXpR8rWlieKlC2wdf9bRejaqVv+7rNtfvsNzrPdzCJ?=
 =?us-ascii?Q?X4pCRpvlxgnzixZQE1T0gD8z01JzqFaeVxOv3s9wr2SooDYk3IeoAgBU82N4?=
 =?us-ascii?Q?Pmj88/E13JfFsxWYAzNfPTWf0gW4qVrptPVEnWijGEhL9FZO44DrP3IXFXzz?=
 =?us-ascii?Q?0q38P9GAb9N4aBgA7OhE7jtFx/S4g5MuMA94J9hM3OcW6yOyjq4yvQ38EhC4?=
 =?us-ascii?Q?pH8mElDvtZMX06xkrkWDOmY/Ka24C9dy2L2qaw8T+U1/BJoPcdPAednMxGSy?=
 =?us-ascii?Q?NjAsM42Qtf0hKha20szV8FyOeXfAnw7a+KX5FfiC9QBKmG9yrra4e/ni4fv3?=
 =?us-ascii?Q?gtzpQLRD+tflMDr9XURWYPESUcPAtSKtO/kOSPWFanNWF2EwQDjKZRkgXON4?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b406171c-847f-42ee-246b-08da94c2acee
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 13:28:27.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RaYw54iessAWZf7bWt5vziulopB7ccDxtfn65Qdbc8n73VQlQfoi0ERfn1nNomSranWCuNYHcjLlsu/ZizzcWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5888
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_09,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120045
X-Proofpoint-GUID: z1uEGzOVLlU7ARrLKH7-uNw0KfYK3-3s
X-Proofpoint-ORIG-GUID: z1uEGzOVLlU7ARrLKH7-uNw0KfYK3-3s
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 88cdb7147b21b2d8b4bd3f3d95ce0bffd73e1ac3 upstream.

We should never see delalloc blocks for a pNFS layout, write or not.
Adjust the assert to check for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f63fe8d924a3..058af699e046 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,11 +147,11 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
+	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
 	if (write) {
 		enum xfs_prealloc_flags	flags = 0;
 
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
 			/*
 			 * xfs_iomap_write_direct() expects to take ownership of
-- 
2.35.1

