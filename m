Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7CAE732D0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Sep 2023 09:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjI2Jys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Sep 2023 05:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbjI2Jyq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2023 05:54:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E671AA
        for <linux-xfs@vger.kernel.org>; Fri, 29 Sep 2023 02:54:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38SK9SMh022443;
        Fri, 29 Sep 2023 09:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+2RGFUK74Hob4rt0egt25TmHZjkY4t9q8LsbgPTMJgE=;
 b=BltMKpsM7IpDfzli6mnDTWXR/yj2sv/dakIDyJturPvx/b/nSfR9k6SpG/RuDqc9YrT4
 8RCaavyBPPAKcHg33USLCeAuOxWxxtzWKr+Ri2aizlzEo5JYQ2KAUOm8wsiqNjLC+b6b
 KjvTsn9fOg1xfH+eZ+vQhR+4ksUq+U2xExCrOtQAZ9jAVMsgzKyp0STAu8dX+1nyEQy2
 5ZcfDdIAWhRki0fZVq2+MQTptSIJaAwwyDc78CLxYZM0YQHd1XP+Eg7x62CK9K1f51KN
 ldRXp7c63YnLWHMuic0th8xthx3wX0Jy5/OEibg6J9AvXD1DQRPtgE5WtGcMqvJiyHsF oA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qwbpa7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38T7wvle040652;
        Fri, 29 Sep 2023 09:54:23 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfhbtmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 09:54:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQVkOE0LLG2meKGCkFVCg6aTcCoTFF5FmOB5L8zjjYe3pbyD7F4PvByBLYS0drV+ahFc+YWMjvWBUGv8KDDYO4djmGDTPojOcHl2zN+ssQq+OftL6VL1yxfZT1lq/odQ0Dj/9d8FUuZf1xZ/Ja9IQ7uN8ZyB939LnerZ4LDRXXJV6r0QvVk8oocnj79NsYAAecQZo341NRu9jRkU/nmD5FGDiAsWhiOpBOFYKH94guY+jY1v8RW51ZD48uUATN0wt5IhbW+4CP1Z0Mk64Y4V1M02PpC+jA40iWVwXEs+qTSTxXAs+J/En+B8UTw4TabzWdqcr0Px2BXhwT6+ygn40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2RGFUK74Hob4rt0egt25TmHZjkY4t9q8LsbgPTMJgE=;
 b=Htq7Kh12i/jtypfmY2rWT5Hui+yV8Z0Fl7sE7omseVlqt3RCvsYZB/Y5VTYFJ1+KYyrd/jCmhS5NFhP6ULiqc0FXAd8aAkNMuMvwx9cKbyQsRMhds4JCxPs2ZXyM0q6o4xdA38OJ7yA1gJdf0Y+f0auIU69j+dPaOGR/TMS9oFXZq05aZO0QjE6SgQ52/xsQ6bzFcP+nfD0DKGhgrhNagRl5x9KodS4AztkWOrZHv81IuQ1jKIx4gj4uiKeZTQ60+OfRYPNAO9+fP242RnZWy4ggOaoilJjx2Cvz9Icyng3UCIOD69LzBbeUeDt1k76nErGuMAG2Hqi8sPmEeAtLsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2RGFUK74Hob4rt0egt25TmHZjkY4t9q8LsbgPTMJgE=;
 b=nn7MVAZ4JvCJkfBIltSUctBe836qCavHzqV/f0JMi9ey8aaaaWZlbwN415YpZMtI1gMS+k2Qh7p2VpK65LYcphyKK4r6poPxAhwZZzYog00EmaHQNw6PlMGicBWG/M8zJ125cIAU2rNab44JVQc1XIdRilnt7UHIrlwt31H6ZPM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5742.namprd10.prod.outlook.com (2603:10b6:a03:3ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.21; Fri, 29 Sep
 2023 09:54:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 09:54:21 +0000
From:   John Garry <john.g.garry@oracle.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandanbabu@kernel.org, cem@kernel.org
Cc:     martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 6/7] mkfs: add an extsize= option that allows units
Date:   Fri, 29 Sep 2023 09:53:41 +0000
Message-Id: <20230929095342.2976587-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230929095342.2976587-1-john.g.garry@oracle.com>
References: <20230929095342.2976587-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0116.namprd07.prod.outlook.com
 (2603:10b6:510:4::31) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: fbef5a04-3e08-48c0-1591-08dbc0d20dbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyWLoToB4tAHZ2HQZgBfRrKiykAYk32BvYBUWgN3HXzpljPRcnfUbGCRrlTu7Y+0QiCbntnq0LMsSDyyrGx/b1VhduIIZzQd5CiS4yBp89QfCPtZLY16ZvAeT6XDb5o9JiS66HSBsWGGPrOeuwq6hZb7lrWhu2SxDP89Gz34gFh8M+oOSQ7L/GUkn2xZbeh2exnz93qfgldTh3HBx344ohMeOYEVS7+JYxxLlIcpbKUoqZavvMc/fmPbNhX8sOfzJ9tJ0DLYxntGWHi5+rkChIiOJIMd5vhYbr5nYYf8uevQEwlfcDxhuHIGwPu3s4GraHft1jqpH+4Dhse1043XeoQOJzcx/rKTj6e3eycEqu0TGqLGIzR8lcF+p+4zcDkQ5WM3dDSUvwMslO0v/VjAisXJfKKDNE1rqv74jsv6HXA3jV51qbn6MNol244bqC2l/da/klGa/ROJIWotrggYXKrAjiMvbO0dkqob8Kng8cvS4mJi5Af5d3kCqvlG7bWJXtKYs0X6ho+1snFyIhL9+dSZO/H5Fmv28AjCnEvSvHGwb8jf8ZxVs+ues6OseTHvr8jbR2wKaP5rbx6BlSHGyqjuy0vsM5jk6WMwpfXX91I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(2616005)(5660300002)(107886003)(4326008)(8936002)(8676002)(6512007)(41300700001)(26005)(6506007)(1076003)(83380400001)(38100700002)(6666004)(478600001)(316002)(66946007)(66556008)(66476007)(36756003)(86362001)(103116003)(2906002)(6486002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PXEbExQfI/KrP4iHZDrzitOOubI7seW8iULVfAvobF+HQudnFiwMeoAOW/SY?=
 =?us-ascii?Q?mtskrJcIo86xBQ+cYXAANRRimU83XGeVO0d2BK2X/LL7Ud+ylP3Qj9UyTHuk?=
 =?us-ascii?Q?RLnxMu5JJ/XXxCCveioyAUvRuFr3XaZ0ZgutlRQEEMG4+HFs5tP1qIzFjLPH?=
 =?us-ascii?Q?MsLw94LoUfjU3L9RYUnys1E5IUuUzoEMIceycnvcHn89fvichTDHvY/6r+iU?=
 =?us-ascii?Q?9h+PIMkk5EE7tmX4hi4jWjNDTjYH26WYGJi+L0zsWde9kCk+DFTicH3HHooV?=
 =?us-ascii?Q?ifpF4fs6NfDkq15rq3qLr8DFZVRvWPP9L8jZzrbQf/hR+QxEt1VQwNydObY8?=
 =?us-ascii?Q?vKoUOxOOA5SCjkZ9+rgV5tcs/LJZW23ioP8UyueYF8sTEckdezipvnH/muGd?=
 =?us-ascii?Q?UfI/4xwC5cCqUf/2JlnKP33plp+gm7TvyHtWnW/JU6JV2JxrA8XaPDXxfEtW?=
 =?us-ascii?Q?CnUT8b7dRbVeONMrCs0GAhRQTDtdlSW4PTROGL2RYxdQ7YL8cmwQ5voECkhV?=
 =?us-ascii?Q?OE/Guxnjx4u67ab+0R1kDKUQGFqWGHMvGVf+TpLgWtIXTLvTRCCbXCWMV4MT?=
 =?us-ascii?Q?5e7xYXC8QNVdLVFSy3jPdpz3JC/XqWwvRm8VPoCCsDZ+Bt4gmYl2lbPHDVFl?=
 =?us-ascii?Q?P1ZzIHvfy7j1rnhlqQQ5ZHlmFJ3QJ4Vh6faN/J3tA2+DkwrLzevzdqWiFDmx?=
 =?us-ascii?Q?GrBjTMzTHQ56aEG2EECA888Q0x0S28eUXpoT95KVKF+qp+PzK6icbKw4m8jz?=
 =?us-ascii?Q?/OsCagZcXoT4+MUMP8eLaBcSjrhZeMdkiApKUQlRxhknWIG1llxaXbntk3Q9?=
 =?us-ascii?Q?hcz9Qvn3emUIjUV2/8RqbaTUxFtzWRe7wJdMeg1FMP+1NShvpn48BJk/MGXR?=
 =?us-ascii?Q?jvh7idLEp1Nz8aJrbqhRzUzpwSl/klxkOaRR/mBM3r1MUHAhO7mTJ0s+MExw?=
 =?us-ascii?Q?qP6dNOfmyoWNMBLpO37NKDS4dgPxvvsWJ7nBlefWQH0JC61QV9UGzncM8/DD?=
 =?us-ascii?Q?nv695rf9SbAk7VJ9wl/+oIYrl28uH6IbzFRYXsNGL1b8PRNamAwaxSMdHCmU?=
 =?us-ascii?Q?FqJkFTscbHyjlDKVerKeVjvVCQc1mzPPF8YqFv7/E1MYGNmfm/Krq6gdDz5x?=
 =?us-ascii?Q?R6yOW0nowtWYFFDuqWZcS6WrrBHXmVaRLsvEw8vhQzh0oMmYmZrcIgb/n/Ln?=
 =?us-ascii?Q?V47C7C/3/bcyk3Xt1XGKFPGRz2zaAckjMAT2tEX1EqNzcjDXhHEXDZnKbD3I?=
 =?us-ascii?Q?572OpvbdR6UviZEfyUAJJz3K9w0oO6LsP5SJpOeNpD5sxXR25YUf6MENojq4?=
 =?us-ascii?Q?0CK7gH9j/5l9LuhgGtsRX3ZUElP9pBQVKIanqWNI29y1yOOg+NnsD+Wvydnu?=
 =?us-ascii?Q?35up4ViZZ+AEOAgu2Vg9KgbsYeYaL10LtDTexd60r2BovaDT+VICndKPlc5i?=
 =?us-ascii?Q?7s4Z7zQmTOQkY9K6TbUDs2zOYmsG4F49kawGh4MHjpofGRM51NRjovfhRKb5?=
 =?us-ascii?Q?0CAaT0wxMvnO3cblJoPvAnVqGiydAwdEkHq0lT5epKeRoxkx0cEzzPJzXhG5?=
 =?us-ascii?Q?DpYNtCnEEMDy0mdMnfGBJrxCzyPoytApYWGKz/pFy9r2cY9j8dARLnSnxxe5?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HMke9V/Fu5UR5VHLf8w84ow7G2O3Le2WcEM2pepiO7Gc9WVx13EjEIV1VE+D8/gZ+mT4+MS15dHM3luAc0joDGarVULTkcjVPX1rZC1S20xOaH/Y80dNqOrs8NmKgTUs594CmvqoO1OkzUEtCnVcka92Wnbu0f3h2E+bYfMfdClbB1kzsRw5YfV5AayenDDpwGqpENQvaQfkS0NaaEKmernpdsz3SySn56tAKSA2Q92B/iZwWg7gQX228ipoEJAQ7BPErQHGKZyw8bxRZUn9bxniatw7i68HE7nz4GQZdKFDqVA2WKBozMh7tB1qNvQlVewDvXkM407eC1nNI6FvoEpT9E+udRfKUSDB5sN/oRihHi04rzNCb8tcpYhv2dnA0QTCX56z+YqHZGpUOnikNdwpz+67IFaqOuPhOv16ux4JxyYF0iSgwPcwBA2glnuSNiIOKT3HK0nVAXMrxpPHJYRvOxBqfMDhoFRhLOQxuDCprgEceiTaldJDrODJZgylIzB+bW9qMjG1q3oBVoNIi4vgAOIq2aSTAftaMMEA94/0Bnca4xx+67r0QYvVQkmTkF25RfgOJzHsyMsgZpxLEPHxp8SUm0n/Z9wuy6Y0DItH0UZqxshmn6xKdU2WCs+nWjuDsJ2J+TIMkNRZ1Qq2fYA4URrt/hlmmOVkEI53PDtUTe0HqS3oSv0rg5m1yh3LAotVRHZ0kKWsvMYYpb2ZdmlhuEraO3AcvMI+g8MvOeOUl0em1jM23B6FHvN3IGr5qvqOcE5tCOxZgw6BRodi5N4vXS4MfvoOj/sy92aAXzO2Q5GR3lkE6g1oeWJE5CHUHJQFkLwnAJOzfYMHkh4W+w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbef5a04-3e08-48c0-1591-08dbc0d20dbd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 09:54:21.0095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czcP71KQ/SoUWmSEKXA5GqbE27XQHj7SHnIvTooeE5RN0NLwZy7PkfX+WLMBtgZrXDHb7wApdJ7k5hP2TdKjUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_07,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309290085
X-Proofpoint-GUID: GCyPA7O3edKj-OnOIJI3hIUMNhK7wada
X-Proofpoint-ORIG-GUID: GCyPA7O3edKj-OnOIJI3hIUMNhK7wada
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

Add a new mkfs option that allows the user to specify an extent size
hint with units.  This removes the need to specify the option in
filesystem block size, which eases the computation requirements in
deployment scripts.

# mkfs.xfs -d extsize=2m /dev/sda

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 man/man8/mkfs.xfs.8.in | 15 +++++++++++++
 mkfs/xfs_mkfs.c        | 48 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 08bb92f6522d..9742482dcee9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -482,6 +482,18 @@ will be assigned the project quota id provided in
 Directories will pass on the project id to newly created regular files and
 directories.
 .TP
+.BI extsize= num
+All inodes created by
+.B mkfs.xfs
+will have this
+.I value
+extent size hint applied.
+Directories will pass on this hint to newly created regular files and
+directories.
+This option cannot be combined with the
+.B extszinherit
+option.
+.TP
 .BI extszinherit= value
 All inodes created by
 .B mkfs.xfs
@@ -491,6 +503,9 @@ extent size hint applied.
 The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created regular files and
 directories.
+This option cannot be combined with the
+.B extsize
+option.
 .TP
 .BI daxinherit= value
 If
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d3a15cf44e00..bffe0b7ea8b0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -74,6 +74,7 @@ enum {
 	D_NOALIGN,
 	D_RTINHERIT,
 	D_PROJINHERIT,
+	D_EXTSIZE,
 	D_EXTSZINHERIT,
 	D_COWEXTSIZE,
 	D_DAXINHERIT,
@@ -315,6 +316,7 @@ static struct opt_params dopts = {
 		[D_NOALIGN] = "noalign",
 		[D_RTINHERIT] = "rtinherit",
 		[D_PROJINHERIT] = "projinherit",
+		[D_EXTSIZE] = "extsize",
 		[D_EXTSZINHERIT] = "extszinherit",
 		[D_COWEXTSIZE] = "cowextsize",
 		[D_DAXINHERIT] = "daxinherit",
@@ -422,8 +424,17 @@ static struct opt_params dopts = {
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = D_EXTSIZE,
+		  .conflicts = { { &dopts, D_EXTSZINHERIT },
+				 { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = XFS_AG_MAX_BYTES,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 		{ .index = D_EXTSZINHERIT,
-		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .conflicts = { { &dopts, D_EXTSIZE },
+				 { NULL, LAST_CONFLICT } },
 		  .minval = 0,
 		  .maxval = UINT_MAX,
 		  .defaultval = SUBOPT_NEEDS_VAL,
@@ -881,6 +892,7 @@ struct cli_params {
 	char	*lsu;
 	char	*rtextsize;
 	char	*rtsize;
+	char	*extsize;
 
 	/* parameters where 0 is a valid CLI value */
 	int	dsunit;
@@ -993,7 +1005,7 @@ usage( void )
 			    inobtcount=0|1,bigtime=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
-			    sectsize=num\n\
+			    sectsize=num,extsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
@@ -1601,6 +1613,9 @@ data_opts_parser(
 		cli->fsx.fsx_projid = getnum(value, opts, subopt);
 		cli->fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
 		break;
+	case D_EXTSIZE:
+		cli->extsize = getstr(value, opts, subopt);
+		break;
 	case D_EXTSZINHERIT:
 		cli->fsx.fsx_extsize = getnum(value, opts, subopt);
 		if (cli->fsx.fsx_extsize)
@@ -2084,6 +2099,33 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 
 }
 
+/*
+ * Convert the -d extsize= option to a number, then set the extent size hint
+ * to that number.
+ */
+static void
+set_extsize(
+	struct cli_params	*cli,
+	char			*extsize,
+	struct opt_params	*opts,
+	int			subopt)
+{
+	uint64_t		extsz_bytes;
+	if (!extsize)
+		return;
+
+	extsz_bytes = getnum(extsize, opts, subopt);
+	if (extsz_bytes % blocksize)
+		illegal_option(extsize, opts, subopt,
+				_("Value must be a multiple of block size."));
+
+	cli->fsx.fsx_extsize = extsz_bytes / blocksize;
+	if (cli->fsx.fsx_extsize)
+		cli->fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
+	else
+		cli->fsx.fsx_xflags &= ~FS_XFLAG_EXTSZINHERIT;
+}
+
 /*
  * Grab log sector size and validate.
  *
@@ -4251,6 +4293,8 @@ main(
 	blocksize = cfg.blocksize;
 	sectorsize = cfg.sectorsize;
 
+	set_extsize(&cli, cli.extsize, &dopts, D_EXTSIZE);
+
 	validate_log_sectorsize(&cfg, &cli, &dft);
 	validate_sb_features(&cfg, &cli);
 
-- 
2.34.1

