Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437DAC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 19:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237517AbiETTAn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 15:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiETTAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 15:00:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29443196689
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 12:00:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFnGtx019291
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=a4F8xTNpr6lDbLZiC/oMjqkRXT7Bqa0046dYwh7n6gE=;
 b=dkrw3Lvd/Kipo9PHK14kbEN6wB/56jCsrAe48gZwT/EzrWFtdYt9CSgwvjI+sPG7dTyX
 KInVZ2S6Kd6L4Ieqwj6EowyI9WS+PBkWwWVk8qCgK68j3MjX5VQlt5LP9CkdFvpwk/hM
 2Eq7ciyFKWTz2/UeVfZkmq4l8XjWUe2A9TrMVx5NA8uyeC2KBGKqH48xOzBeEuBCV8Kd
 hLq/5HQKO4/IcihgQPq6zGSgiZOW5B7EWllKIEptWByrFOyK3IeYaWvzla9+ms1jhfLC
 Eu3Z9UguWSDAorrob4lw22YNnKBRzUuu7neqgDWQcmShmnPXcQNDMZAZQ5K4+k8if3m9 8g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaqekj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KInuZK009768
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v6rkwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 19:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB3lyvZpCG5l0x0Ko8fMYv9LGsTTfm3R567dQ956ayx6vZ4dLTkubTYniB2Sg1kkykZ9EpLxewTUXbQyMIyZnz9DalehjRrbSu8EGlRbfnF8lNeplofaf2tIwetjVcx+PvqQIe2pBOClz3CMaw7dubdnFsuCpHCJAgubOd7/51CtNft/71Oft49NNLpQb0DdTVs5WFPbSEqOMa/qF1tQ0Mj962RGEU3zNkQ9yBAiUBBU0sVhYWRqDKCjPSiVffdhh6M1LJ7PxUSD7AYX4ClZw2orc+dejVXbeIPrSvnYXi/ws9ugl/lxPu6hWBOcKq1bRB9/QApWTSBjRnBSymgbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4F8xTNpr6lDbLZiC/oMjqkRXT7Bqa0046dYwh7n6gE=;
 b=XMW+92S3cWnAWoGmbnRhecKzWK1+BIJ99P8XuyI9OWZ4tnhLVTzv7IctsL2LxxBJ2AgXD6S8XcUXNNpsaoo+QueQdZF0nQHZPQxHnk4Vo8Mmvrg8/AWeZzL2HeNHpNHCnAAFNwJPxioQvBVu46lnQ3yIFfSkCF7/z8ZR5EOFk4dpM4hyk7JbZRxAZabPm2tjfQRxOY4uhh6rNLWPJfOAHklOu3PMQaRJvgPyGNN3+fVSNo17z6XmfYdWefb4KBJAQhYoWwtkhx0RvQenA2VHI2S0KJ2WSMM5K0TSm9BQINEsl2INwaNVEcNWqppuCwajibcFcelicVOTKanpQoL0rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4F8xTNpr6lDbLZiC/oMjqkRXT7Bqa0046dYwh7n6gE=;
 b=XiqG+ZAcHFy/9D5h6xhkOCzpUu4Cm+gTUP7ypOfrDneMK7Pb8EEyRIMuQUhuH2OGslLVD4DzJI0UWpZoZqhGVMqe7P7XdYmSA9FX9V8eYE/ZdDULzOJdv1VuXLIYejjt+sUy8AlUfVecayCFIKcwEYllu4POOUuuMJmymrK92so=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3658.namprd10.prod.outlook.com (2603:10b6:5:152::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:00:37 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.018; Fri, 20 May 2022
 19:00:37 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/18] xfsprogs: Port larp, enable injects and log print for attri/d
Date:   Fri, 20 May 2022 12:00:13 -0700
Message-Id: <20220520190031.2198236-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:a03:217::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08d242fb-50a5-4167-0c2f-08da3a9306b6
X-MS-TrafficTypeDiagnostic: DM6PR10MB3658:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB36588C71975CD5A0117D939495D39@DM6PR10MB3658.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwSX7skz47FEriuPsM7ov1AHfpOYcDsOHHY/t3zTjU9YhcI2QyXpYimDmVgW2U9gN3bhmYYvSTSvnGSEuDEY98DjIjKr9Mfh24VYzbnfbYoMH65kI1lznoUuRPL7gCZy7x+DCsu6CGQIqU/U6x0f8P0e362wmBy7SA7S12UBM6JrPq4vdSUsHUca4t8bkOSUc2xeoR7pwmcn7zpEJYgn2Leb31aeC6vCOVY76hpOAlg20GaFiRtuf1Ksky/kC07UW3fNHlu69TNJBmZXCquFmqaSzhI8omyo4EYjk7ukwdZqDVU5SSIVVaSRka2jS3bwNAzytNt0gZ5J4Ir7/DxJfCBZYBj8ONkUC6rn2ZEeVHhMAIVromjci1wFEiN/iTSvn78fcyL1INBbG8eyj9wm5e+lpjSwN0T/hP4Yorgg4hxt0oW+tBIIqADMk0okHOie4Bg97umV526PCEaY7YXo5M047jIrtG4WBtFNPQ9N70bcQBQ/mdv1ODg1wn1WdjNmhGTckWGKwvIo9duGf5Ld7LYTCYpsl8TbWvbfwkywrEday8p0cNU2qaoquLyTSl3PT97C6UjU/NvQA4x/1D0F02wk8WYwMiJgz/cWmmfh1irr/cnkLKcpNd1JTFwSlfr5j3+S69EBGGvEf4ZQG+1yPzHv5EmiI+/k2B3BL6NLpZFjvcYci+MEPF9cVmNO+0fDp/LWIFQPpY2GfzcUJKM67A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(86362001)(316002)(66946007)(2906002)(38100700002)(6916009)(8676002)(66556008)(66476007)(5660300002)(8936002)(44832011)(1076003)(508600001)(26005)(52116002)(6506007)(36756003)(83380400001)(6666004)(186003)(6486002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ARoAdGU91qgKJD1zBIRsVD3YXZhwsselvvJlsAKHzP2NS9PWYCQmRz+m/Sj4?=
 =?us-ascii?Q?OseGm0+wvONoJJjfBmUm1Np1BCM0Ayvz/g8e2FZxV91lkvLDvrHgIiBerfwx?=
 =?us-ascii?Q?LDbCR4qlmzgHemtqKxUnTbqgTWp4IHWXly7FgagwAilWh5AMUM1G23+h0bZB?=
 =?us-ascii?Q?EGnjuDTOiepIaPWVeI5KzRgNbMcwy3fBEhB5fLtyjwrJiNI2pxysE3couY8V?=
 =?us-ascii?Q?xV59cAvcjVn8W/HsQdxeHn4r4kgWyFgMSBS+rg6G7zhMy+cE/8Il9Do7cwOd?=
 =?us-ascii?Q?VJFBsbzlr1gPHbrv0EfGD55Pg1ztquXf0nStSmQSr5TkYoEHPBqEvRHxHGpc?=
 =?us-ascii?Q?z8etaX0aI5EF5CQVSICQiHc7BPnHgdAoLSASZIYRaRZ6ff04C60nAFmZsZN+?=
 =?us-ascii?Q?y0Ew0kPo+uAdHgsOGWM0cyGR/tvJ6r1aezcsnUlL9jrLURU0fvqEWHQz+AZ5?=
 =?us-ascii?Q?MT5L3cBHo+Lx1EdJ6533xAVw7G8xzmYkuguLGmDYjdNBIfqYCUWeqfzbGpHw?=
 =?us-ascii?Q?81uLPtTiAQBSmR1aIQwgxBfDTgjQ2heyghTbiNW1pHcrNjTOEwD5k7P6xgfX?=
 =?us-ascii?Q?6gBS8jEfDPR+CATIabWK3bdG2l6c2J78FLpomF037P/NeoTbzvAsD6AgtfNC?=
 =?us-ascii?Q?Zitdj/OQfpY+0kB+LBxN1XOpxKbYnLiEF5/xpwaAvzVCgeEyCbLY4WzreAfT?=
 =?us-ascii?Q?f2coLPsIpLeGbyON4g6pOvNxih3H5NgFfihT6IsEEuk+gKf23b8gCa9pl5BQ?=
 =?us-ascii?Q?ZFunIuk8bnzwqJ3k9z8opshZC8ToQ/bltBuOjY/cRszPpBqLIDZR4vON7Egp?=
 =?us-ascii?Q?9etBg1eqfYLPG2+vHYCw8uJjhcv7FDUqXpHqPsL9ngHzlZ8O8enlGht8p7Yw?=
 =?us-ascii?Q?Giv6sNAG+vFurJjHgMQ6VBo/m2kwu1b7foDvZRNcnM2WlVjVMRwy2gJPsXuf?=
 =?us-ascii?Q?1hJpqh52mE1j6RI+KyWhMoy7TgsPUn9rODPEdb8iE0jNOnKY9o1yHmflbkcg?=
 =?us-ascii?Q?rZUCneO2sJI7XTtXXyJuOHpBsj0PrK1YOTOeO1vQmi7q6lPVfgESzS0k96j4?=
 =?us-ascii?Q?WPoplzn+kWD6RAiafVPiIv7RyQVqwxMunhJ3ttbD8OY15fREAiHruIAACasL?=
 =?us-ascii?Q?IgGLjzwdI5B/i5dC/C//5Sqf6DuNfARNedpaTzZcGhOGvG7yJ5w5h0Jo0t0X?=
 =?us-ascii?Q?MsLJSbhNHLi9kYTQMbjw+xjKYmdf+Jc75iu9XY9SDKH9v3DOm1/5myof1dIf?=
 =?us-ascii?Q?LvznCW9EX+nt+u8To8RrJqCYH5JR2iVdT1eFcwiS58HF/0DpfZ2gbxg1lai7?=
 =?us-ascii?Q?8nWsQcNY/DPuUQ8552OzvPZS9UDMCVuNWDYjios4/WPFW58j6cRZ9bhRAIef?=
 =?us-ascii?Q?2W7biabCJtCc1eKj0DjLmgJylipCw6JX6O+TeURiuf4eyv3kb6W+PVHeVJS/?=
 =?us-ascii?Q?rHTAUUK+5zjYOfOQnznEPRXRU9sDEMfBK7UKEnh4aqVFqk6YKk9foEiGhR6x?=
 =?us-ascii?Q?UALMn0geRz2Xe7HclWn669TI4aXDLRWo7XDPRTGEeM+Wl+eB45tEiaH+s3dY?=
 =?us-ascii?Q?OoLu5SIxqJ8uu6aJtVCEeMgveDzESrMApmMGGkWIFi8cZ53Bj/d6Bke1myQ7?=
 =?us-ascii?Q?dO9V2LLWwBDUjT5UkvPu2eBV0g0o1PG7EQO4A9039uo7zbi6qFBqWvd1yWWi?=
 =?us-ascii?Q?MA8Y2Az3wLkSC3yyT/ef664V6lNom0ROmAcJJp2Tjr9exuU5XxSSfRyJp+qE?=
 =?us-ascii?Q?p1GaHC+741YTxdwjPchL01PoK1nNWBg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d242fb-50a5-4167-0c2f-08da3a9306b6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:00:37.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uf4SFxCA5WAhkrwXCU8+PKpL+gABWlVuj4x4Q/GX5z67fBWE2WGVX3ZlgYlj1kioRwQ19/mKqXCNbKt/CV4LQfquWKC4KVkoxORin1S91fE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3658
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205200119
X-Proofpoint-ORIG-GUID: DOIInl8vlgIQMrdVTYfiAluZW442-Hkp
X-Proofpoint-GUID: DOIInl8vlgIQMrdVTYfiAluZW442-Hkp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set ports the initial larp patchs to xfsprogs.  This will
allow us to print the new attri and attrd items, as well as set
the error injects that the test case needs to run.  It's not
clear to me how or when patches are selected for porting, but I
figure this will get us started.  Some patches needed hand porting
as it looks like things that appear in the xfs_*_item.c files
are ported to defer_item.c.  The last patch is new and needs
reviews of its own.  We'll need this before larp mode can be
enabled in the kernel side.  Thanks all!

Allison

Updates since v2:
Hoisted xfs_trans_attr_finish_update into xfs_attr_finish_item
Fixed white space nits and added max() helper function to new print routines

Allison Henderson (14):
  xfsprogs: Fix double unlock in defer capture code
  xfsprogs: Return from xfs_attr_set_iter if there are no more rmtblks
    to process
  xfsprogs: Set up infrastructure for log attribute replay
  xfsprogs: Implement attr logging and replay
  xfsprogs: Skip flip flags for delayed attrs
  xfsprogs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfsprogs: Remove unused xfs_attr_*_args
  xfsprogs: Add log attribute error tag
  xfsprogs: Merge xfs_delattr_context into xfs_attr_item
  xfsprogs: Add helper function xfs_attr_leaf_addname
  xfsprogs: Add helper function xfs_init_attr_trans
  xfsprogs: add leaf split error tag
  xfsprogs: add leaf to node error tag
  xfs_logprint: Add log item printing for ATTRI and ATTRD

Dave Chinner (4):
  xfsprogs: zero inode fork buffer at allocation
  xfsprogs: hide log iovec alignment constraints
  xfsprogs: don't commit the first deferred transaction without intents
  xfsprogs: tag transactions that contain intent done items

 include/xfs_trace.h      |   1 +
 io/inject.c              |   3 +
 libxfs/defer_item.c      |  98 ++++++++
 libxfs/libxfs_priv.h     |   4 +
 libxfs/xfs_attr.c        | 484 ++++++++++++++++++++-------------------
 libxfs/xfs_attr.h        |  58 +++--
 libxfs/xfs_attr_leaf.c   |   8 +-
 libxfs/xfs_attr_remote.c |  37 +--
 libxfs/xfs_attr_remote.h |   6 +-
 libxfs/xfs_da_btree.c    |   3 +
 libxfs/xfs_defer.c       |  41 ++--
 libxfs/xfs_defer.h       |   2 +
 libxfs/xfs_errortag.h    |   8 +-
 libxfs/xfs_format.h      |   9 +-
 libxfs/xfs_inode_fork.c  |  12 +-
 libxfs/xfs_log_format.h  |  44 +++-
 libxfs/xfs_shared.h      |  24 +-
 logprint/log_misc.c      |  49 +++-
 logprint/log_print_all.c |  12 +
 logprint/log_redo.c      | 194 ++++++++++++++++
 logprint/logprint.h      |  12 +
 21 files changed, 805 insertions(+), 304 deletions(-)

-- 
2.25.1

