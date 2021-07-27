Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51278C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6FAD61009
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhG0GVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:21:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3516 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235510AbhG0GVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:21:14 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6Hge9023061
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=zcaWVRGAZapYBwPTm05fdPd/yboLuwxUwU/0SNcodcw=;
 b=Al3nKMtGr2E715z/UorkvZFXp942RBGB5OsrpNS/2xXkmloEpqlWk1YB9OvW+nnXBx57
 xJVRW09OFy2mYvnqSAdhdeeA9vAGXzRRmi21IpuH22PvfUfscy0KXSbYXfWJ3uOxpo3A
 77Bc0OH96UUTEISOub2CNs5SIYITelMij/KNVTe+APul3g+C4GKe8kMkHKILkzPjBJky
 7raSKa1k2B82pAHgOMuvsZYtgfOxPldQR/wXPgmx2AxR8RAEqZvu6eBnJu0vqGwMEy3/
 V3BmcewnS0dnsrafBCwaLGFh0s7COJsrAcYiAAtAgancDc2vp5fEo/Z8g//651/OzAHW uA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zcaWVRGAZapYBwPTm05fdPd/yboLuwxUwU/0SNcodcw=;
 b=DS2NVLRwHqBB1ExfvlufZYSA2Q2Y1lb5LrCAN+7Ws+foWAlbi1VmT3/xu4qagwtB9mgr
 FFXxECQnRkv9w1/QRAar0CI+MgI8VWkYvlm4DTMnMJbzTuD7Dxy53Rn532v8/bEcqTiO
 9a/f37GPxicz2yaTp4rEpFORu39IjzAdGAmqp9JYutH2RKsi2hSVqJw0MnQs47e1Oz+m
 qyjaVdgFD7klJ8IbzfZshUldxDNOUSslkkHd4UHlarR+CHFeMWAyvqdaoaw3e3Ibfm01
 0jgJAuLZh4il1XiKQiE+zI8nO/m4twveSYIOW5VDAnfLljZe1m7S4XFdiTRy8KFX6rQM 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a23538uy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FjRp114857
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by aserp3030.oracle.com with ESMTP id 3a2349tsre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:21:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Od7/CaR1Rx9xvRk/JXmoHWLYP6immF9J1jSwx+lxTIkrgArgsKztjcny3YXBfRIEeZYvbT1aaTi+AFKszoKtHovFWda5gExdGfDQuao3qe0zasdlOYnJ9Kid7Y+2qh2qgk+bIKfduJBOf5nr/hVzqGXt0hTnGpZk+KSbSBNKonljZAlYbmM3eHm7DUek0yHaCX7i4FxOa2b5ppvdIE8k3liJX1MWNWgks+NLxTXhyDvBYacJPNCc3UyDp1CFJNYd5yk3TTlYFERiQ87Tf99p12BgQm2s2BjwgE9HL49bChEDDXJZUM3+Ek5k5V3Me/4EWqN0nFe3O73Wcs55L+TeOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcaWVRGAZapYBwPTm05fdPd/yboLuwxUwU/0SNcodcw=;
 b=FV167nf0Z6Y5On4sKbIkGTwu/e355W5zUWoJ5HUGtzYDucFY/vZuDthdgZC9iZJ1EqvyCuBWXxO7asmFa6LlwpFzQ+lKaWLAYtVS/c3KhqtQeuePIPeCQuHnCrU2xnzadGzV429HutBXf9YZaPRNPXg3dSvAEJsiS1BOunsXUp5WrVjryAnh1tPJI7nwk2JtpvAIlWW0jfbYLfTOYNm/ey+mxGRCSLaPWIyNn6bntMS/fzwiDUxTSYlEc3bPqrCtWyO8Xt7NBKba1cGctkeNhtggWV6OXdjwFSBrwrPnddh1A0zkHWyN5aeMKwmyhYCNCsbKsfkp54mNv4YBwBOoBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcaWVRGAZapYBwPTm05fdPd/yboLuwxUwU/0SNcodcw=;
 b=ypoty6uXQ5PpGB3gTPmcCn9KOHWaZ10S8ELRuZou2wTvA0VsFQ3yWNbZ+jUdQoj8UM3EWoDt6CW+4VQgqDcS5odNyLxDAwlWCED6kH0fD0/qsx1FY+KmzcDs1Dd6yJKjyrnawnfyawMYC9r8xHqev2PVfCSH1f+285xesOeehyY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4669.namprd10.prod.outlook.com (2603:10b6:a03:2ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 06:21:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:21:10 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 06/16] xfs: Rename __xfs_attr_rmtval_remove
Date:   Mon, 26 Jul 2021 23:20:43 -0700
Message-Id: <20210727062053.11129-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727062053.11129-1-allison.henderson@oracle.com>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0191.namprd05.prod.outlook.com
 (2603:10b6:a03:330::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0191.namprd05.prod.outlook.com (2603:10b6:a03:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:21:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a312eaf-1c13-44af-65a9-08d950c6b9db
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4669:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4669B804BA191B7D70196EB695E99@SJ0PR10MB4669.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uxoOuouLR8Pd01uCCyLH+MRsDWPwlxJm3DRlRiVrPtC1NUcW20SmR3tn2cG+P0WtJ6Id7Q2iupipJKz+9mjpocTjuc0cOlDeKSOuTKH8mg5/PKdtvg5R2MDkSMgoIQsSQYVdLoBvhle61GnnKKA9bieJnd3jcnxMvM43QFog5aUodrPqk9qtINeNw8wKWE2PhQOKdnRfBKhCH+PUHPTQaZmgNfm7PPY+d7R7uRtAs+bNF1bK+Q8FFMOjgEt4rwWOKP/JTqF1wBNLdR/lS8vxe5Bwf2kUPx5OS5MbMK2ldQQ+eq115J0GbkIjK30X426Pr8XkcrIj8Bl+nPO/xqA7+X5eCbHRvkuA576poBzRbxLEP6meiNQalxgZP55BqILQvgVLuiqi9FO5Vmq3TnAIoFWizG7AdEdaGN8J0kAV27u0vJW2I3va1QMOR1eAKJ6hbHPyVIyH9pnPZn7jAlMVof+eOG0tzt2gpD9QaaDPKn70phDADKaUHJ8v/E1ulUcoWUAgMg9V2hTCSt91N6AAl/FsyL1tAv31zQa+D9f3cYDF4pRLOhWYkM9gJB+QmVhu+hURnSGpnzSgXhLJH+QLoLlNc3VcgrHZZsy/4oIPptfc4ZMh5uLZ52AHW6DWIAYaT5JT9QCKlngH/84SZk3GFXjz7vNidUAOf0W6eU9p7BBZzg6Ub21GVO+7OAcwVc3o70S+dZsNCdTUsZtIBMQsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(6666004)(66556008)(66476007)(66946007)(36756003)(186003)(478600001)(6916009)(2906002)(5660300002)(6486002)(83380400001)(52116002)(1076003)(6512007)(2616005)(956004)(26005)(8676002)(316002)(38350700002)(38100700002)(44832011)(86362001)(6506007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NYiI76+EJkMSt2NJlNO8hV5/pwp/dY/LHP26GLZJT4x96PyhAZ8OrNcMVZZL?=
 =?us-ascii?Q?mUpgVL5rlkAsWI7lG16LEJ1kvW4excE6CJhv2usarbOdDfNd4ELLVHCCk3tO?=
 =?us-ascii?Q?Fp8FtRC+rrjIE+scg+Jcwj9ZvTzojUJohHxIAHefYVp53v9T7ukXFgNl7+Bu?=
 =?us-ascii?Q?7+34VXZp7tHZQ5/8C1curlPWXF7AER+o8/PRea2kK89wjP1cf1KIv48vOh46?=
 =?us-ascii?Q?nqUqYEI3hwcXZoZsEVdWF6d87LJeB/YSaIEw5mDyzR4WV1Peurteas3nQhV2?=
 =?us-ascii?Q?9On5UkS79OX6RNGerIQiuPjCD/xHw5PyLARn27oq2az/bgwtLMLMvkVNzfbz?=
 =?us-ascii?Q?onMdfhTrV3OtTT8q219vquiUMd0LfOO/PFGtjdliX1IzQCanlIpR/ABQ0Ubb?=
 =?us-ascii?Q?FRKVvCRh+nRwrGSA6CSGxBHlpVqPY3o9MitUpAlwE+aBa/DHzaokxCPGo2wY?=
 =?us-ascii?Q?DGnDGOhyowtK9W+moR5KyAlUZbY1ENm7lWOluxCiKHMgQn958WbOiWwXAxeZ?=
 =?us-ascii?Q?XBgp4uZXDB0TQFJUgr4Zzlu4/svYjj/WjjGHLZW6+IeVLPtD/njeQBN43tRl?=
 =?us-ascii?Q?0qRM6WDxp1kgspsuQ7xBLgfvNy6MZArI9+ELE+3huLSxQR4dl/SzWPzaS7pX?=
 =?us-ascii?Q?BjiBE3wqllAmV6JHoZwev6uEYhs7MUI3YopBLYzguugiu9nlBJZ+wZAZNhA3?=
 =?us-ascii?Q?gex1J9gTiGgEcG7b/ooG9YysjUYaTc1UNYX+kcJeerzE6A9cQiF6cer1PkUP?=
 =?us-ascii?Q?blPL1KuHAnk5vCq2vCZfeyl9A104pG81rLBnys42DJAfchgKPtijlGIYJ7vM?=
 =?us-ascii?Q?mgbK1EE9GLzBhDlJyEpCWfGMG26SVUfKL0Z+Iva87sC05SwIb69mnARuqTw5?=
 =?us-ascii?Q?TFtM0cNWbgNh8/yJfIJEsBNchli2lsg8Mi9tWQqlsVGT0ebiA/0sWzeDPUQU?=
 =?us-ascii?Q?U6bXGDIlXHmxn5q3I6vr77f0IZMxg0SJ+cvkyOnBoEtdk7skCH2s72mpyrny?=
 =?us-ascii?Q?ZBWe1Dy02fgbLI9IHz+f4VWBc2g2cWH38nykwIIrr4lAvQoek6kpNg0yOhDJ?=
 =?us-ascii?Q?HzERjEuMSIEVSvKH5uwCMmGjHf/Lino8T743igFkIYWO7meQZR4g95hjbmuW?=
 =?us-ascii?Q?rGSivbuiBezMgRxVsucIAYwj79Ta8IkZY1LnLgwarqd65qEEPrhE4ndkPM/P?=
 =?us-ascii?Q?xNL2OvlE2uZ2q6vVOjytairE9jB3wOQG6Knr/R2sBnQ0miXNkgfMQUpYven2?=
 =?us-ascii?Q?p0tp69YgHluUHwxUo73pMdNo8KEv8Vm96riLwZRKPWgyq7m53IaGdd4El/ep?=
 =?us-ascii?Q?sTl+g+OvYVWgnVKvObEsu2RO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a312eaf-1c13-44af-65a9-08d950c6b9db
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:21:10.3158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rd09pLtyWpviFPkRW4oPWpm0atyNbiLZEZxKVrV0aG2bW1FABJUcToFVu+8t3UxQ3+1AfYl5HAH/9UNytNtDyko9yw/H2R3AUZcowkHPh3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270037
X-Proofpoint-GUID: H9r6FYpVyqt37gEGYmF6E3ia2ppW5XwS
X-Proofpoint-ORIG-GUID: H9r6FYpVyqt37gEGYmF6E3ia2ppW5XwS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 6 +++---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b0c6c62..5ff0320 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -502,7 +502,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_LBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -615,7 +615,7 @@ xfs_attr_set_iter(
 		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
 		dac->dela_state = XFS_DAS_RM_NBLK;
 		if (args->rmtblkno) {
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN)
 				trace_xfs_attr_set_iter_return(
 					dac->dela_state, args->dp);
@@ -1447,7 +1447,7 @@ xfs_attr_remove_iter(
 			 * May return -EAGAIN. Roll and repeat until all remote
 			 * blocks are removed.
 			 */
-			error = __xfs_attr_rmtval_remove(dac);
+			error = xfs_attr_rmtval_remove(dac);
 			if (error == -EAGAIN) {
 				trace_xfs_attr_remove_iter_return(
 						dac->dela_state, args->dp);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 70f880d..1669043 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -672,7 +672,7 @@ xfs_attr_rmtval_invalidate(
  * routine until it returns something other than -EAGAIN.
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 61b85b9..d72eff3 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

