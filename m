Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A03C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 08:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjBIIC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 03:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBIICV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 03:02:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1C32CFDE
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 00:02:19 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3197PkhO003380
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=lxvfLUw4TO5TFIw19Rc9Ae41y50Ia4JlxYiv+rJVvrw=;
 b=FxsAfxfA3z8WBrKLact8fsFduW0NLb5fhrCaNyAn+5kkMLZpRIrCKhIRt4lkuEK5rSXa
 Jz6Jclh7S6b99Z4ZB1o4O7Q0EAGshmpLJFSaDP3AjWja8BjFmt1SWFxFk448Xk0VfDOT
 pVpW8TIyqOrR04C74jf8SkVukmzqcG1wr1XV70R0hFLaBG+EqbM1PKUPzdUBqsygxxgS
 BBmnpB/fqf/XLJtTT1XamMMvm/BeiXIfFoppgQGbOjfDwN8XQjOpdvKxeCAQsI6rE2uU
 4DSS/URDP7ZmbNJXk8irc9seOvCrYH5KyMWSmqi+nLwXcHw/V/igwcVjyEEqzknAF3x2 Mg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8aa44d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3196eBvI021294
        for <linux-xfs@vger.kernel.org>; Thu, 9 Feb 2023 08:02:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdt8dv71-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 08:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APWVWlE1//u03JKhhqha4tRzGEDhcqEsQ4RhHJdu8Bk3T8s3KzPVJri0g23voXDbUI0j1VjirI5lISXW5k3vGJkl8UStQVNjfUnRoKSrZg6hf+NDAN+U+draB+1HhIhWaAEwcYGmptWr79s4hjjuP+gME+f99iF9IIJP/hVxRnMWv8QUjv2yPLKT1sdJjihhDEo8aT2nFUlndaRHpOKFCtabgxaXxASUcxpeITDEH9X8WFV+uAQ2EJXAczswqoaTf3Nx3zGYuowVOhgeNRuvi/iS0Fx8cxmTLlg90GEsan0EdBYeUv8Tca0WBOdkArnHCxpgqw+5GdhX6AAjbMcIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxvfLUw4TO5TFIw19Rc9Ae41y50Ia4JlxYiv+rJVvrw=;
 b=f0dIuQXlDp5woc9GG4q8uJ6Ac+LG4I/7FKonpA1HpTaBIm8pH7QTYNBvpSvx8WfcUqHQ6uSuIZgIVi6WqtYfhr7uOldjLua72w/lHBYqHhntInGiSwYofB5U+M85i7Kg/aIEmpET/T5JQRABRacDsp2TN2WEzNFe3MQt3ssvVM+O+fLh0hxGz+dDGYkdMvRVPlr0VPhjC5caZ7OIWsxnLgI7jP1MlE6GFdhGgh6RkNEKhpLBLfxO/hG/9zPJGHR9sMwtnZwcnYcxtX8/MylmGtEWVhEqJb3UfSzmZEaS8M2mrHxBurujeu1klILwIXqkWh4I2w6GB/9NCyLd8f2oPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxvfLUw4TO5TFIw19Rc9Ae41y50Ia4JlxYiv+rJVvrw=;
 b=IR+2/Ngxpk2zG1uOYjGwhs8c10BhJzztDfvnENxX/5nMCP4FfQ18KzymgcQvboSuwyPUzlsL7ekRyIG+/sFftNo5j3Xo/0MMPP8hGooCk1qV9jlI2rPHXbkZMLVtrJyiU0uMdGoGsf3I62/tBlnE8BOjacXSRaAOp9O9g9tRAlM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.14; Thu, 9 Feb
 2023 08:02:14 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::eaff:9f55:4641:db38%4]) with mapi id 15.20.6086.011; Thu, 9 Feb 2023
 08:02:14 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 15/28] xfs: parent pointer attribute creation
Date:   Thu,  9 Feb 2023 01:01:33 -0700
Message-Id: <20230209080146.378973-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209080146.378973-1-allison.henderson@oracle.com>
References: <20230209080146.378973-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0091.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::6) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: d21ab1c6-18bb-4092-6a5e-08db0a73f493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5jNZInnWCxFNVE3Tut9UPMbQ20ortIJhPDvMonKRBw0UMLNuycWZccYG+cmojj0fiAoJA2EnDWzFlLuD3koR9pTWeFmuA4qlpVgcmSTrtTEtMINRIKsVudKqH0Spu2GFd6P7mzsqs6pecyywkEEXmgypyOoqF6onuErjWfTfGI8/kbLrvTxZKT0+pS075Ik+mGpeOC+/Xuu8wbBH+EkiFgF0OzzjIp4OKZm99G/+z8+eiqbjE0x1fVVV5Df80D1mnsI1v+nET+MFEJKR+OLnISkfHxS6B++e3dKTqhpNQ0sEWNEGMgA914nE4/Tgh2BnI+kN+a0UnqyyBap6UG38uU1p0KPmhiZW6hBx0a55xfLlL0SP9uu8Q2gKnskqCMa22l/vESAhKfF4gxoPwICPoEG6+se+Y7h1kPS6sQ6hcnhc4Ocow1KnTwzrUO9n6XkN6CY6gQH7ZwF9Rv+bPppDo4FThBZy2owLQn/rgnE/kttgJED2Sbc8UxndIXnVqHV2RaSk4nApoSH8+v4VkaYIP1Se9gH+diDqJKiqVPnQ2ftqxyK4HdX8/+j4K2UrKHHjWjeOfmYIA8us7oes4XBPF0lniZyqxR6xhrD4EjgvJgXthq21Nic+wQ6/YMR1TGAmtYp0uHruYlpdnpEX/PLvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199018)(478600001)(6486002)(8676002)(83380400001)(6916009)(66476007)(66556008)(5660300002)(8936002)(6506007)(1076003)(66946007)(6666004)(2616005)(9686003)(186003)(6512007)(26005)(36756003)(316002)(41300700001)(38100700002)(86362001)(30864003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MndwmCXE9w3nY3UEmU7PCQWouizRIT3btYu1kPJSReJzA3+VsTfTcWvArwbn?=
 =?us-ascii?Q?alN6ykCoCJqpxycaJxoKUqb6ls6CHXUVXJ4LfTkq+yifWubvMYQnM03Tkai7?=
 =?us-ascii?Q?9Wyfj6umnNPCt58L0sK4aiHiKQnUkP6/Es6WjaltqBUgVk3SeU+lhLti0CHT?=
 =?us-ascii?Q?h5iPFGqsbdPT4qBiLf/DGhf6Go/gNt1ItjRXz5/w61S2qc9ABmFCXdzvOUHy?=
 =?us-ascii?Q?13GmB6WdW5okox4K9PPK8MlVSq9CNFJwS5nVUMKOjPRCrJlNNc8dWCvqxpVF?=
 =?us-ascii?Q?zivv4pscdDViZo6iTwb+X040c38jdf1PrlgSEFbTAn6Izh5jM4KOFDMGB+1X?=
 =?us-ascii?Q?vX+8O+J+Oiwm/6bwzdOwdiq7Zq+RVs/9AG26s1/aFd9QvUNvnMAoceNGk7NV?=
 =?us-ascii?Q?UdW4TkjcUb8Y19ldVuMRR9a4wXuS5FQXWBLFkYR/eAfOgUykIvLkHWz1h3/G?=
 =?us-ascii?Q?jm8sLSqdIXH0952qW/il86rWwFhCsPwFilE1xwB8nbh9HgWQo4KkZJpBY9vb?=
 =?us-ascii?Q?LV+rmycWAy6Kkzm5iu5LFM1KEyPN7xQfQBCO7I0+yJPWMWzPXBdhvHFq45Vv?=
 =?us-ascii?Q?u0Tg4c3zkSujQNTBZSwo2aAWJ9W7yk7H2WsiPEm4gGD6z+HGzdE7KSeEyx4Q?=
 =?us-ascii?Q?GEgjDl5Ugfi5Ih/v0z4NC4gfrdX0j5tfW2qjGOu1DVEcgYxcBxIDIYtHqwQ2?=
 =?us-ascii?Q?SP6OTY6sjwOW2RlEKXRzgQNF6SY2xGn3BozcW92CyaOBgBs44RCoqaJQwrXv?=
 =?us-ascii?Q?IQRAcodZffCpCEfozB5+fcgq4M52SDAQrZ1/tsoBOCsxtYK899gmF3aoc+OE?=
 =?us-ascii?Q?3eeyGWh/+DqZ+qXiphhHSxU2lRBGI7zJyGnUTKmRsKA6AND3AgNzgdli75G/?=
 =?us-ascii?Q?Z5xXyafytqQmr5ktgfuqZ4v5HXvS6lc50nYeUugBmch/8/3qG04MG5I72JPZ?=
 =?us-ascii?Q?Oto4p9RPOl7U4NoyyRS2C7p5YuUBr4F+efxOXyR+iqyUA1RHBlb0vjk/X+zS?=
 =?us-ascii?Q?rzWwCbhRAQAnbMgHxWSW0G0oNQ5KXz98mUd2vSuttN/MFqYBPVV+OPUj1L2h?=
 =?us-ascii?Q?Oe0bdgS8zHre7InT0PwjN4q1uXgRiKQyrJ8cRa8zqAjUr7N9xIIw+3RFhSWX?=
 =?us-ascii?Q?J+HnTfLlZmrtyk5iJjCRj/QSrJhXu8AzyDNU7VLsUXjDiJpHB3kxja8Qo5W0?=
 =?us-ascii?Q?78TbzLjY8+/2tzZ62EYADxeuFQbITAJhe+Vtp2zu9MY1DADNY2et0GRrCfvV?=
 =?us-ascii?Q?UQnGhHtm7tFckadijxL+j+QbIuQi3Oa0kq0GpjSdAAz51pULdAC6FK/UOX6b?=
 =?us-ascii?Q?v3gAd0RRBX+gkzYZzRqP4Uz5+Ha0athbiF2tRO1/JJ6TWMtI+QhHj0QBHddG?=
 =?us-ascii?Q?nHSN3LbM8AXETbK2qKehYUKXdRxC6T61k/rS8RJANNZcmFjieSMneDGqcFVf?=
 =?us-ascii?Q?wByOa6cOpysDGgJNRtLKyUwuykF+H7xG5vG/u3PvMcgvP9ltNzUjRfEzqva4?=
 =?us-ascii?Q?hNxrN+wdk9m84nyxmcN5+v8g8L8/X8PSqBDjjkT39RsDd5lv+jryXZghIGKB?=
 =?us-ascii?Q?3k9lFvu6SXigJ68iRAs/e37Ejh6AQUNV/EphjwaZnJodBe4/9HTgWr8W/maa?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vY8MuvA5F6NbJuDXZElrTZpLNWJKzk81XpKjGm6ba3om4FwIuEJqy2/JnNYVicRkepBWVkaip7J+CrNjNiFD7GgzvaZ9SWgshPaXCCPW8acnbLmfXfbRwV/XvAMh37rmJZjlPJbBHSc6Pc6FnSkeuZjl/X7RJRdj5kJyMwu46967g1IMkDQFFFlh2xPqsmT+3lxf3sKu+JK6zfaB7DGCefzf31+MqxbEHjjHpqUG/s/jkOotlPPqj0cbJtMf9eZ9SzBVLv0VR9xHliCTRcoz8NPB1aB3ML9eN7ffQGt1AGOFP1JLPc1iGGIEYB2ed/tevzo/qgWZm7u5B0rmADb65EJlMnY/4WXi03iCSmfQXcRBdJZDsqia2bz9Gc+qQafB75sb6eaWkheDE/8GGnhRhmlHXmMncFWM0hvcfzEJxIZHtNkyPiS33PrIe0DvUuROUyjkVO7TVoxE2u7pCS7wytSs0rhz85t5R9s52fPSmrQAewaDm+6vOIPmMPZrTzVSboUw3bFpkeCnIvNKK6Kmrdw9ZfnOkKaeP3LeqkYwH4DeMeSree2PPw8PKlBTlOzcqsjjUVdl84eAPhs2WFQxQPunwEmNWzJKrN4gm3Ded51v3pV6wKz2sIrE9jUXMyKnUq4FqgjulDMaw9tBdTOQWpdwbjNOSNOW7iOUc8K1KC0A2cmKBnUJtPvZZ4Ldxd6t1Z9d9m9eBp/DCQLLAhiO8KrttnK436Ai/9AGUQnRnm4nyTJs0CHbQtv7dCSeOdj9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21ab1c6-18bb-4092-6a5e-08db0a73f493
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 08:02:14.5751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHHEwyOq6zosgdqL4B5nuTVwWaHcxSBBV6HVdHvi1eqQP02ktWIY5V8KMUPH89t9+9W9Xw4WOmB5U/T5AxM4RJRmAL5d5ZEicm+NkmidLt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090075
X-Proofpoint-ORIG-GUID: 1I4sKtyvAcSxaF9wFMVGuvQ6RTEjgsfh
X-Proofpoint-GUID: 1I4sKtyvAcSxaF9wFMVGuvQ6RTEjgsfh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Add parent pointer attribute during xfs_create, and subroutines to
initialize attributes

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_attr.c      |   4 +-
 fs/xfs/libxfs/xfs_attr.h      |   4 +-
 fs/xfs/libxfs/xfs_da_format.h |  12 ---
 fs/xfs/libxfs/xfs_parent.c    | 139 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h    |  57 ++++++++++++++
 fs/xfs/xfs_inode.c            |  64 +++++++++++++---
 fs/xfs/xfs_super.c            |  10 +++
 fs/xfs/xfs_xattr.c            |   4 +-
 fs/xfs/xfs_xattr.h            |   2 +
 10 files changed, 271 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 03135a1c31b6..e2b2cf50ffcf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_parent.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 711022742e34..f68d41f0f998 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -886,7 +886,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
+int
 xfs_attr_intent_init(
 	struct xfs_da_args	*args,
 	unsigned int		op_flags,	/* op flag (set or remove) */
@@ -904,7 +904,7 @@ xfs_attr_intent_init(
 }
 
 /* Sets an attribute for an inode as a deferred operation */
-static int
+int
 xfs_attr_defer_add(
 	struct xfs_da_args	*args)
 {
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b79dae788cfb..0cf23f5117ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -544,6 +544,7 @@ int xfs_inode_hasattr(struct xfs_inode *ip);
 bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
+int xfs_attr_defer_add(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
@@ -552,7 +553,8 @@ bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
-
+int xfs_attr_intent_init(struct xfs_da_args *args, unsigned int op_flags,
+			 struct xfs_attr_intent  **attr);
 /*
  * Check to see if the attr should be upgraded from non-existent or shortform to
  * single-leaf-block attribute list.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 75b13807145d..2db1cf97b2c8 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -826,16 +826,4 @@ struct xfs_parent_name_rec {
 	__be32  p_diroffset;
 };
 
-/*
- * incore version of the above, also contains name pointers so callers
- * can pass/obtain all the parent pointer information in a single structure
- */
-struct xfs_parent_name_irec {
-	xfs_ino_t		p_ino;
-	uint32_t		p_gen;
-	xfs_dir2_dataptr_t	p_diroffset;
-	const char		*p_name;
-	uint8_t			p_namelen;
-};
-
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..6b6d415319e6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
+#include "xfs_trans_space.h"
+
+struct kmem_cache		*xfs_parent_intent_cache;
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+
+/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+void
+xfs_init_parent_name_rec(
+	struct xfs_parent_name_rec	*rec,
+	struct xfs_inode		*ip,
+	uint32_t			p_diroffset)
+{
+	xfs_ino_t			p_ino = ip->i_ino;
+	uint32_t			p_gen = VFS_I(ip)->i_generation;
+
+	rec->p_ino = cpu_to_be64(p_ino);
+	rec->p_gen = cpu_to_be32(p_gen);
+	rec->p_diroffset = cpu_to_be32(p_diroffset);
+}
+
+int
+__xfs_parent_init(
+	struct xfs_mount		*mp,
+	struct xfs_parent_defer		**parentp)
+{
+	struct xfs_parent_defer		*parent;
+	int				error;
+
+	error = xfs_attr_grab_log_assist(mp);
+	if (error)
+		return error;
+
+	parent = kmem_cache_zalloc(xfs_parent_intent_cache, GFP_KERNEL);
+	if (!parent) {
+		xfs_attr_rele_log_assist(mp);
+		return -ENOMEM;
+	}
+
+	/* init parent da_args */
+	parent->args.geo = mp->m_attr_geo;
+	parent->args.whichfork = XFS_ATTR_FORK;
+	parent->args.attr_filter = XFS_ATTR_PARENT;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.name = (const uint8_t *)&parent->rec;
+	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+
+	*parentp = parent;
+	return 0;
+}
+
+int
+xfs_parent_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_parent_defer	*parent,
+	struct xfs_inode	*dp,
+	struct xfs_name		*parent_name,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*child)
+{
+	struct xfs_da_args	*args = &parent->args;
+
+	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	args->trans = tp;
+	args->dp = child;
+	if (parent_name) {
+		parent->args.value = (void *)parent_name->name;
+		parent->args.valuelen = parent_name->len;
+	}
+
+	return xfs_attr_defer_add(args);
+}
+
+void
+__xfs_parent_cancel(
+	xfs_mount_t		*mp,
+	struct xfs_parent_defer *parent)
+{
+	xlog_drop_incompat_feat(mp->m_log);
+	kmem_cache_free(xfs_parent_intent_cache, parent);
+}
+
+unsigned int
+xfs_pptr_calc_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	/*
+	 * Pptrs are always the first attr in an attr tree, and never larger
+	 * than a block
+	 */
+	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
+	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
+}
+
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..d5a8c8e52cb5
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+extern struct kmem_cache	*xfs_parent_intent_cache;
+
+/*
+ * Dynamically allocd structure used to wrap the needed data to pass around
+ * the defer ops machinery
+ */
+struct xfs_parent_defer {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+/*
+ * Parent pointer attribute prototypes
+ */
+void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
+			      struct xfs_inode *ip,
+			      uint32_t p_diroffset);
+int __xfs_parent_init(struct xfs_mount *mp, struct xfs_parent_defer **parentp);
+
+static inline int
+xfs_parent_start(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	**pp)
+{
+	*pp = NULL;
+
+	if (xfs_has_parent(mp))
+		return __xfs_parent_init(mp, pp);
+	return 0;
+}
+
+int xfs_parent_defer_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
+			 struct xfs_inode *dp, struct xfs_name *parent_name,
+			 xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
+
+static inline void
+xfs_parent_finish(
+	struct xfs_mount	*mp,
+	struct xfs_parent_defer	*p)
+{
+	if (p)
+		__xfs_parent_cancel(mp, p);
+}
+
+unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
+				     unsigned int namelen);
+
+#endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a896ee4c9680..ba488310ea9c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -37,6 +37,8 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
+#include "xfs_parent.h"
+#include "xfs_xattr.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -946,10 +948,32 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+static unsigned int
+xfs_create_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_pptr_calc_space_res(mp, namelen);
+
+	return ret;
+}
+
+static unsigned int
+xfs_mkdir_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	return xfs_create_space_res(mp, namelen);
+}
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
-	xfs_inode_t		*dp,
+	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	umode_t			mode,
 	dev_t			rdev,
@@ -961,7 +985,7 @@ xfs_create(
 	struct xfs_inode	*ip = NULL;
 	struct xfs_trans	*tp = NULL;
 	int			error;
-	bool                    unlock_dp_on_error = false;
+	bool			unlock_dp_on_error = false;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -969,6 +993,8 @@ xfs_create(
 	struct xfs_trans_res	*tres;
 	uint			resblks;
 	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	diroffset;
+	struct xfs_parent_defer	*parent;
 
 	trace_xfs_create(dp, name);
 
@@ -988,13 +1014,17 @@ xfs_create(
 		return error;
 
 	if (is_dir) {
-		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
+		resblks = xfs_mkdir_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_mkdir;
 	} else {
-		resblks = XFS_CREATE_SPACE_RES(mp, name->len);
+		resblks = xfs_create_space_res(mp, name->len);
 		tres = &M_RES(mp)->tr_create;
 	}
 
+	error = xfs_parent_start(mp, &parent);
+	if (error)
+		goto out_release_dquots;
+
 	/*
 	 * Initially assume that the file does not exist and
 	 * reserve the resources for that case.  If that is not
@@ -1010,7 +1040,7 @@ xfs_create(
 				resblks, &tp);
 	}
 	if (error)
-		goto out_release_dquots;
+		goto out_parent;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -1020,6 +1050,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
+	init_xattrs = init_xattrs || xfs_has_parent(mp);
 	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
 	if (!error)
 		error = xfs_init_new_inode(mnt_userns, tp, dp, ino, mode,
@@ -1034,11 +1065,11 @@ xfs_create(
 	 * the transaction cancel unlocking dp so don't do it explicitly in the
 	 * error path.
 	 */
-	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	unlock_dp_on_error = false;
+	xfs_trans_ijoin(tp, dp, 0);
 
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
-				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
+				   resblks - XFS_IALLOC_SPACE_RES(mp),
+				   &diroffset);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		goto out_trans_cancel;
@@ -1054,6 +1085,17 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (parent) {
+		error = xfs_parent_defer_add(tp, parent, dp, name, diroffset,
+					     ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1079,6 +1121,8 @@ xfs_create(
 
 	*ipp = ip;
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	xfs_parent_finish(mp, parent);
 	return 0;
 
  out_trans_cancel:
@@ -1090,10 +1134,12 @@ xfs_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (ip) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
+ out_parent:
+	xfs_parent_finish(mp, parent);
  out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..6795761c31e0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -41,6 +41,7 @@
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
 #include "xfs_iunlink_item.h"
+#include "xfs_parent.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -2115,8 +2116,16 @@ xfs_init_caches(void)
 	if (!xfs_iunlink_cache)
 		goto out_destroy_attri_cache;
 
+	xfs_parent_intent_cache = kmem_cache_create("xfs_parent_intent",
+					     sizeof(struct xfs_parent_defer),
+					     0, 0, NULL);
+	if (!xfs_parent_intent_cache)
+		goto out_destroy_iul_cache;
+
 	return 0;
 
+ out_destroy_iul_cache:
+	kmem_cache_destroy(xfs_iunlink_cache);
  out_destroy_attri_cache:
 	kmem_cache_destroy(xfs_attri_cache);
  out_destroy_attrd_cache:
@@ -2171,6 +2180,7 @@ xfs_destroy_caches(void)
 	 * destroy caches.
 	 */
 	rcu_barrier();
+	kmem_cache_destroy(xfs_parent_intent_cache);
 	kmem_cache_destroy(xfs_iunlink_cache);
 	kmem_cache_destroy(xfs_attri_cache);
 	kmem_cache_destroy(xfs_attrd_cache);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 913c1794bc2f..c1f4bfd71e73 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -27,7 +27,7 @@
  * they must release the permission by calling xlog_drop_incompat_feat
  * when they're done.
  */
-static inline int
+int
 xfs_attr_grab_log_assist(
 	struct xfs_mount	*mp)
 {
@@ -61,7 +61,7 @@ xfs_attr_grab_log_assist(
 	return error;
 }
 
-static inline void
+void
 xfs_attr_rele_log_assist(
 	struct xfs_mount	*mp)
 {
diff --git a/fs/xfs/xfs_xattr.h b/fs/xfs/xfs_xattr.h
index 2b09133b1b9b..7e0a2f3bb7f8 100644
--- a/fs/xfs/xfs_xattr.h
+++ b/fs/xfs/xfs_xattr.h
@@ -7,6 +7,8 @@
 #define __XFS_XATTR_H__
 
 int xfs_attr_change(struct xfs_da_args *args);
+int xfs_attr_grab_log_assist(struct xfs_mount *mp);
+void xfs_attr_rele_log_assist(struct xfs_mount *mp);
 
 extern const struct xattr_handler *xfs_xattr_handlers[];
 
-- 
2.25.1

