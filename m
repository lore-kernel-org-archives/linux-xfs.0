Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093F9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFEFA61A01
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCZAb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:31:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38462 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCZAbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 20:31:46 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PdHI066887
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=o+Tjtx1gKojMD7X6I88pE8sIwOKGTCOKMGP6QmK+kj6V3pI9awzJSuTq9kN/OrxuAgfx
 TpaRLFLO/H+s6B4PAlaYSv9L8yoFOyhC0wSYw+M+ex3Vgz4L9jSEfl4k8NdGsVj0rpQd
 +3sLk/Aadp8OPQteemaYNmhSnGUZTXyGv9Fqb2HJedkl6tg0D2CDnXI00K9/PF0V7I+L
 NMb3s4O+lB8mpatHDJuw+2B/F1Bnio7xMHs3Tz5xZvOuyQN82WeRVRfLn0rCWRnuQfMb
 3G6SxVFOl8mPUUxfoN+Qassw0IrcgAqYyDQA/1znbG84f6eEriaH5dB8nwEJ1Bj8D2jh Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37h13hrh59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12Q0PK6H155451
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 37h13x0454-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 00:31:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpfYxfr2/GL+VRDNeeK9/MRuod2NsNDTnGuy8VFweuaB7KMy8FcHVHMqCcgGOArpgOY0WyOEvNvoesdmzE9hOg1IgISRVZQY6WC+BM0Hn0fJtT3+qbjG6hJv92d2ojPZyhmyI3AyZGOt7VPPRU8PwYgKLYG9dqYUDV6YLw9Lrc0yOcJ9y2rEsjtC/nkLLBlKB/D3vyzDPd2a6zRobg7YhnLeF2lDyE/7nE3aw9jrhhkPd6E077bG6Mp3a4i+so0hg3km14KW+IJ61FSGrEkWorIjDofPMUGUfZMXOSbF9lZP64/KtMC6rwU48crO6w9b10vCBRuhCPELqhfQkDXnJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=KNjTHRud4CrZtpOPWpMl18S8OyHd76G6znarM8+nqmLPSzTpp7jlcbDch5NI9kpsJ4RNF51byDHtSMMCKnIUSs0+VrxG0ZF1BYs/XkRvQ40iwuRanWlq+iOQe+jOGgJhKF2Lhct0QBsIEOu1K/Bs7SNiaZdfBdniyNTd5PDDABsr7jotiB0xjx1ppvi75kBXp7/mq8NnuRVLq6CfGBmcADx/Sa4Tg3XXIDgP7b9kRLVBBA7S+We/EabqTO9L3t6gmHURp4FKeCEjdssq3kqnEzORgI8OCKhSWvkQMm/VYLi4HlcKU2i1r5OKwMfgP3sJh9vnfj3/U0xBD0P4nfH8/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAMUuACTRGIujAa2Ft+VkOaXt1vGoXhu1Bn3MNi2w48=;
 b=rHS/vT8x7oIskExsPNvsM6pAvJg9+gL5gsLRf7l3A/EDQAYEEYMpY84awx03m3R19YdlYE4KR5pyMsNBJkKpHXyTNhj0AyobS1X73XVval5SQOjUnqy/HcRlIyz3fBt1O+Sn+8NoYT2FTpgapzcpps2sdb48LgdlPgmCva+ycDM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2758.namprd10.prod.outlook.com (2603:10b6:a02:ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 00:31:42 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 00:31:42 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v16 01/28] xfsprogs: fix an ABBA deadlock in xfs_rename
Date:   Thu, 25 Mar 2021 17:31:04 -0700
Message-Id: <20210326003131.32642-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326003131.32642-1-allison.henderson@oracle.com>
References: <20210326003131.32642-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.223.248) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 00:31:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ee1d098-5531-412b-11b7-08d8efee870f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2758:
X-Microsoft-Antispam-PRVS: <BYAPR10MB275844A4DC953B1B1AD564E595619@BYAPR10MB2758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyMhsJDVWSl4iz+uj+UjNIFcfCh5iDM/11T4dim4m1bC2EH1i6RFgaYV+awTDnMcoQXTO+T3gR4R04FZAEpymGXu7MFHUZSKM0h2DdKo7mZ4iegDJsAt0MH8YzwfJ/7f8QuphOejevI4izZy0iZdkgGFPYSn5zTDMClJh2lTihGUYKlQY6ci9jgbl7NP32kyLpEROW10BtYucaUX2h8E+KDAahbZ3xQO65q/oFV7fLTXYpKz9fZBnriSKUdT22jn32MAs3tFLOcUav9hHDS2E+ALn1Quw8Nl8qwYjmUzlwZ9PBk0lrEHpxN1bvdpKNBv9ZtDM44Su8Vf/K8nfuEohaNXtFU8DIevORc/UVZJXVjlWHrd6FrYHnol5T1LqJXFbEmdmJ1WH9sV+S6kDAoLP1MIlNKMLwa4nzaAh54twSxqCOtKSznq5viOcwTcZgYFRyhp/WeemeGSJZPQk7Wky/qAng7LR32MOv2c+neCd64MtM+1iiqeBm5YRydp6EmtIf4PLv+1cFwdoDvpAahsj0OqMTnQmB/qugMiDsryirYhHCHY7NIQAvYVxJ4yVcWRYKR2b0xehaVwiU61DA23W1qo3PHdxPGrwmISFQZr0azbKNC/ml/BSviz9mBqXF+GE5gClFYC4xmT7mA9Jh/i996xldQaN2/XmY6heKZz9n1oUYL6MwsRB+lPsqWdr/Gq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(396003)(366004)(136003)(316002)(6666004)(5660300002)(6486002)(16526019)(478600001)(52116002)(8676002)(186003)(44832011)(1076003)(8936002)(956004)(2616005)(66556008)(38100700001)(83380400001)(6506007)(2906002)(66476007)(86362001)(6916009)(66946007)(26005)(69590400012)(6512007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IDKb3VXznsTuDpPocZ85eFslxZeqmRaKr+Z+r+I1XZxLXpmlIc9eTPiaSe5N?=
 =?us-ascii?Q?p5GG+1cz7QcbqJ4Jfz0CbOFbnoZQg9652PWkD9o4+p9QL5kH/iqMidF05iIK?=
 =?us-ascii?Q?uTE3PaUnKM/FGevCsB6Wda/Fyz4gu74aEQWRqwscvhkuYN369I2DFEScT5VQ?=
 =?us-ascii?Q?ieKN9JZLZVHqu4eZC6CLDSjT9Su4vjpNaDKa/suiBsEjjnAYA07PVKIlOdyZ?=
 =?us-ascii?Q?RCCEf+U1UrQ9qDdZVVqGI9Sl//QKEniSL6tui9QLLeCYm7tXBfD/zWhisEdf?=
 =?us-ascii?Q?eyF9bruEry3fapM6t977D/uxdf0Bq+blQ5ESG6oQJqMCdOjq4ZpRKlgPL+ul?=
 =?us-ascii?Q?/dL90SdDtaPv03yeTFOQ8UiBVGqHYPnaN8h40zbPANohsY17seAKap9uqHrH?=
 =?us-ascii?Q?JifCo7ZiTiQ7vUw+/xCV0SnbHmOii+egcsaoYrkK7tj4/E53jo+Ty/NMchcC?=
 =?us-ascii?Q?W/pGRn7u/l4PNIjp9hYT51nZLztTnxCf/vPEDJ0/w1x+FLm8jYJfjYbJEmi0?=
 =?us-ascii?Q?nhfKxSmMxMcKa1ib/gqXb0ZSIFhfZpRDUa4WHBnrrk4RSKjGOXoauyB9AX5g?=
 =?us-ascii?Q?HrSVWyPDyRJVc2AplO8+4JCLR5E8AZA46HWjSfRJMDwvdMvCluxYoMZo+aNZ?=
 =?us-ascii?Q?X4d6SYkfRCa8yJ+EcEdP47ZGww7m+XxN9XSscU1k0DLwe9fm6U06bXBTxNub?=
 =?us-ascii?Q?IOfDfIEttbvXqVrXYXYgzIP7sVbitw5qW3ij3xnHBPFyzmgF3wV+BDvukjXe?=
 =?us-ascii?Q?Tk5zdveIqX51jPLkpDxI7THJ5jylALokI/8Ep5iIczY+XKmh1dbTPCrvFGFk?=
 =?us-ascii?Q?wyPyfRtiVtWPcOhNPZo5TDck2mfbIebgv8d6p3zYC/kxU+O5kkiMPNXplhcJ?=
 =?us-ascii?Q?08BQ8l++LMSh7/GNN7b6hD3oYuzvrLlHGhsxzUwnkTQKBa3XECNCvlo7XCfb?=
 =?us-ascii?Q?lWDLlcCu9fO2XevbAa5REYgb8bjio4ciy6Gvu0MGLjvEZDEEE9bxvMmgR6Xp?=
 =?us-ascii?Q?DxYA3plGaytTzVZG3UqFi7OmNLdTrjYBmNBWZjvfOj1Y15EVwMZbcLDecyOU?=
 =?us-ascii?Q?eEd9nOQrmTYw2v9wzwG9T3mPkI06+v78JWOLSZZQzhCaO+iFFSX8WoP3Kkgl?=
 =?us-ascii?Q?DiOxd9AMoZaPehRCJ2dSML5PkLjUw+eK9wnMd1W77CxJvLEJ7CzxmMv7bJgU?=
 =?us-ascii?Q?Q5ocGgu0zmvj7J7wNIL7D/Cgc5ioEgkWD5V4UzT54EqGxw3D6Lx1giFxCV8/?=
 =?us-ascii?Q?unhCoQ3vLi3eB+YIc1QZptucG0vzz45Jc0l9dF8CVPjp1IqCc5He19ws15NM?=
 =?us-ascii?Q?KVawMa3Ve1yQ6Zv9rObDcU8Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee1d098-5531-412b-11b7-08d8efee870f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:31:42.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ygkNfGIv//oNXXh0OyC5iGLMQm/MyZjEOm/pqvyXxWAcEJ2BkZfc43wTqHaMZx2Ns2VaHVZmVRe8sPkw5rTZTTOJtufqIGcerE4Ga3XAEhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260000
X-Proofpoint-GUID: QjTJWC1uFg5SpVT0Yx67lYm6v7DM9cMk
X-Proofpoint-ORIG-GUID: QjTJWC1uFg5SpVT0Yx67lYm6v7DM9cMk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 6da1b4b1ab36d80a3994fd4811c8381de10af604

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_dir2.h    | 2 --
 libxfs/xfs_dir2_sf.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index e553786..d03e609 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -47,8 +47,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index fbbb638..e5a8e0c 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -1018,7 +1018,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
-- 
2.7.4

