Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2387C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DF861185
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 10:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhIPKIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 06:08:46 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51502 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236175AbhIPKIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Sep 2021 06:08:45 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G8xjDR030302;
        Thu, 16 Sep 2021 10:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=maILzok1E6MDvJS+GSU4e+rQlHsExbJVXniYi8D5PLI=;
 b=XCa64VTOKN9U75+WzKHdIDwlGUeR1rRf0CCOSWzAO5FCvZO+avcfv6iOKBSo9+AEvaG3
 tr1Mf3Umv3bpa+6DqOvIn0A6XOPGQF8/q9tz0NRxI+QW0d7LweRoeQFTjLLK9bel0Vzo
 xjwjX+JrC0GEoR5LvsbAP6hZaNSte9cg90FMwKdr7SZLjSeKejBspcoPFiJoKcCBoS/E
 Ohna/LaocT+EAA8FeKVENpVWs8T9h6OWKjqmy+2OTizvzRiCR0pjX5B6q93nXznCkrw+
 1ekfY7HQno6F1WQYM7ZQvcVFTCQcIJ/8UubAmGTW8k8DpQWP5JAtDbsDU3xmJ46flXG4 Fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=maILzok1E6MDvJS+GSU4e+rQlHsExbJVXniYi8D5PLI=;
 b=T9czC9A3yOKmQpS8iFY9E2wHZGWQs4oooNXdm9wwK1NhFPG0lk94lGBATqprSTs5PnPG
 17C2Mp4HUlTnttrl1MBneJIJiiQuHUBM+hVCft+fZC/zehUTL+Mw9jaJr5i2H0Vhcwzh
 s3KcIpWhwwSLmAqMu0fou7fF/BJvNkubJNMUZYHC4ZyJO58Y8553CC8S2fp0hsuab+wM
 zDcZMaGrcwmXjPvXUQ763R+JQajfbBZ5RDw/7Yr2pUs2bwl7B/aRYp0WED8ebyeWzrP0
 Jp6lQ8qsDg3vS/EQLB3sC9P6aNt1zZSnu6HS0DmUux3033CTLHTo2xW51iWD+rXUox0Q 8g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhsbgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18GA5HKu030773;
        Thu, 16 Sep 2021 10:07:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b0hjxybk9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 10:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHwU09wuk+ofCnoIZrTkn5hWO1UmVKkFcufhx5k1ne9z0Jdzayij2FX6kCXOATZIXyO88mJZvF/7VwJXXR1BwUfQEozb8KhTQQbWfntyjkE4qkfN7ZC2M222OZuMP/GS779pfeu+wKHgXw1pNZEQkKzEIWWDWZtOFzhEdRBTZudbH+pk/+xud78XcAg+VChelXoroZ9fEcWUlohIDJbIiy1Vk0KR3U/0cxHD1jBfmXIySTAlOKLo6OuWumRonLsI36SP6ys8VeYmyd4ADY0XWnccrqhlH1gosoHxP06L+StDMq4lyw2mPHimlrii9Dp6KfE2Ze49LNhJ2hL8Y/aHnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=maILzok1E6MDvJS+GSU4e+rQlHsExbJVXniYi8D5PLI=;
 b=EVR+vXRqklxNu0tIORAU0XP65ro3YPEn9x+frK/z/LYQdKkEXMlX/29k9H5PTvQTGDfA41GSUFgGzt8zRaOYKOkDF4NEZ4O4dasr2P9yL2caFnFkJgdz6Zx/IFEuvTfpQqG4H0yPn9g/LxMIEbDZmDQ75AIaXL/ib6rLP1+QidwEo8DgEhDDBxde64jNhTtms6X6bmoZeTnE74Whe3npdDO2q0qlQMzAkuwiIIYU2OKNQviMPM4qgeY5FZI8HlCNYdDj1DnBlTColz5N+i2vlGX/DVA62RRj2A1tmExLIQezvLzuzkw+DqxpqVnT8wit2HuNa8a9fOgyOmr9t9uVTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maILzok1E6MDvJS+GSU4e+rQlHsExbJVXniYi8D5PLI=;
 b=Px8qTzkxCmc2utQqQPaHdLdbc7w661Fy/CFnsAWLQfVXxjwZGwWp0a+7ORvW0dedmZ+x2Z1RaElgnp/zAzd9VKSXjQrd7wyjEJFaKWjschFHtKxBIe+KK/GDQoXHOShiGHObBDoW8IwmqAhyKGSnMZ/wjpEuMZrwOBHjUTJ8YpA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SN6PR10MB2878.namprd10.prod.outlook.com (2603:10b6:805:d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 16 Sep
 2021 10:07:20 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 10:07:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Subject: [PATCH V3 03/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Date:   Thu, 16 Sep 2021 15:36:38 +0530
Message-Id: <20210916100647.176018-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210916100647.176018-1-chandan.babu@oracle.com>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:d::11) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from localhost.localdomain (122.171.167.196) by MAXPR0101CA0025.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 10:07:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36abc617-0945-485a-607c-08d978f9c53b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2878:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB28783577812B557CA480DE0EF6DC9@SN6PR10MB2878.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:196;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oq6ROuL7YjZzDXXJOeHCRZXB9l1s2YydffAhNWQq9RZpHonYgT4LZHtzJF6trBg45dxkCPhPRQ9/P5IVkknFrvaUSfljheYuP0QoK/jn4+Ud2FUmqDKF5GXejt/k+9brsIO7ZVeofTw32ilJLpVYkU363g+hrLPmDUg6T0hRRSDpObLiP8I7bSaLFL0ZQ11MpGCBaXsdVPTCTvtH73dfMk5b//dQXX+e4AiZKsuVh4bBc062PhheMOVCvsqUrSrTpF+GOxFYltgShwBTe2EBTXQwFQK7yd6Jv0jYEvKD8te/u64HU7zzCOrlmdPyQNmMGFQzREh8bKa0KHnCY0V+kmbzTWuA7/gJAFpLZy3Bwmwrmc19h6f4gwCdLiq80AHLAVosjLl2W6/44reV3ZhNaciuaSyAk0HyXJvx5sz95VXQENu2Vh/7BoQyWpkfFdH64fTRxLiKO+IF8jKNm+6TPoRDEOaG5wKsBEx0ddqqdTSjyi2OJH7rSJcm/kKS8YldrubX0oYGdUYzDu6dyVSlox2+MBIdc3tYZcMXLTtww+Pn0J+wT/uy59ImvNzPt1+luPR1Af/HcOfIeBHOVLb82Nmh4iXk6Rq4IOMsqxl/GGoziZozqnHWcqKx34gPEK03nTGgjzzjmayWyHAzzz3b3rAKtTHOWWj7lask6y1MUtZkvNKVb/k3IOIiNgyLf4GGzk3ipKi58+Wt23IFttwlBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(136003)(346002)(478600001)(5660300002)(186003)(66946007)(86362001)(66476007)(66556008)(38100700002)(2616005)(83380400001)(6512007)(8676002)(956004)(4326008)(26005)(6916009)(52116002)(38350700002)(6666004)(6506007)(1076003)(36756003)(8936002)(6486002)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NIEUALvSkEt7GsoSDuBVglVBf4HkjxB9Qj5jdNxfOLVCEPIefMdltUBvAzx4?=
 =?us-ascii?Q?197nj7vqWWT54YGAhb9y7tkZq+RGwTWo3p+lpy8Q2fIMcZgm3Iu4gNwFEzux?=
 =?us-ascii?Q?J8NCRbKH9fEdqoLR7jGndwwJxArh8GsaCSl3uahaFYmGXJs6aG+8pixxv5a7?=
 =?us-ascii?Q?lTc38GOQWOB/HiE8sx/BgcTJsgd+8/lsIrWbKYvcyaIz8SVoxHl6W1uPHS/P?=
 =?us-ascii?Q?rO+GuGsmXKzEQ5SoSggQk1SSe2t2KrR8mz+ho6VOH1QOG+k0uiOp58QuUBUk?=
 =?us-ascii?Q?mPA22sdhiABTDdnYoHNE7h4kYILvB67xiZ8gFbaF5oqCv9BJPlrNcjWaUz6/?=
 =?us-ascii?Q?h03CS5JmcTXNRQBVBdgxRFjyB1aCPI0xH7AQDfprc49Z0GK3XXHi7zdN2U54?=
 =?us-ascii?Q?YwXpKE6BIpxNJ3FQ9thgWnoFk+IxSpf/ZNMk7lvWGeM58io4wmjMwOSBSQFi?=
 =?us-ascii?Q?O7NqbI5LYKz5JuHNlwpbpDogJ4IZEo0IBK3mNX61vPoJoYpcVca4jwRj7t1H?=
 =?us-ascii?Q?NLCUGLaYmFOVdSLTAx/PVyBhlBvt4SJd6RiS1iBNwHIl4Jgr6umMGb2PNu43?=
 =?us-ascii?Q?9LjVB4UeuE7xD9rO4R+5CrFtT6E8gXNjm/HJp35yPLKV9wIhLq8jFW2ujoi8?=
 =?us-ascii?Q?F95E0ubnKaEvPEANEbPVOSf1p8Y8YRoAhyAstbb5rUl3rmE2tSBVs4wM9MJG?=
 =?us-ascii?Q?a340dZ99pQDlpb+hH5vOAqkN1mWKs3bncdNECrHVMsak5/H+EQZCraR8Rszr?=
 =?us-ascii?Q?eiTgBosJOSH4EjVG1bVVwtphNFzFQ4nihTOsPeTnb6kb8mRGBxI8y2mPq4NB?=
 =?us-ascii?Q?QsVVb91CPuKK5HgGcBSmnrHbR/gzNH7vhvp/Krim2OJmzagFk3nF8JY/4npc?=
 =?us-ascii?Q?OoJbJdCez2LRergMBARAeC7lXi513H5u37mQgRUWd+gX0/JZI5xWzgRSyxPc?=
 =?us-ascii?Q?glNdDx66AS8iracxFxz6jgPBvpS0G9tM4f4b2sWpfOTcGKNB5LJHUX/qOOyb?=
 =?us-ascii?Q?zeksdrb67L+GLDfIHj14sbP+rUlVLYmODb73r0iE6HIxEKEhTpZi2A7Yt8tV?=
 =?us-ascii?Q?ARRMEr+b+ZYluIOcRtaleDFZD/l5LnJVkyc18cWHzncXxS73qCexPfK5abM4?=
 =?us-ascii?Q?rXOAkp57MpQdfh8ZBA+VvYVn7opk/R6sJ+S2NVnRY8nhXbG3YhxX0HrIJ3Bp?=
 =?us-ascii?Q?QN6bAo+HhSAJ7b6QyVtbBnUuIQnvzHuga4D6qgeAXsLgjRdqs1Cp5UAI5doh?=
 =?us-ascii?Q?F3k701tlY1+By5rvYvGVc5gduspbYLa2PKhvx6lvdj3bfWkDLhsz2dEytujx?=
 =?us-ascii?Q?GWzqiVuJINU0qfkgYLoFCSmf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36abc617-0945-485a-607c-08d978f9c53b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 10:07:20.4193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ramzMWdISvsBAFsJk+tfKzIqwvARUgV7im29mZ4xMV6w7zT4tyjHdxnAIUZfxH1KKt1kAeIyZhGH11n+iL8tPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2878
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160064
X-Proofpoint-GUID: fMXn6QVWuLlMHKmxxbguUiKWoFeHK8Zn
X-Proofpoint-ORIG-GUID: fMXn6QVWuLlMHKmxxbguUiKWoFeHK8Zn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for introducing larger extent count limits, this commit renames
existing extent count limits based on their signedness and width.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h     | 9 +++++----
 fs/xfs/libxfs/xfs_inode_fork.h | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index bef1727bb182..ed8a5354bcbf 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -873,11 +873,12 @@ enum xfs_dinode_fmt {
 	{ XFS_DINODE_FMT_UUID,		"uuid" }
 
 /*
- * Max values for extlen, extnum, aextnum.
+ * Max values for extlen and disk inode's extent counters.
  */
-#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
-#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
-#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
+#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff)	/* 21 bits */
+#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
+#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
+
 
 /*
  * Inode minimum and maximum sizes.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 6ba38c154647..e8fe5b477b50 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -137,9 +137,9 @@ static inline xfs_extnum_t xfs_iext_max_nextents(struct xfs_mount *mp,
 		int whichfork)
 {
 	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
-		return MAXEXTNUM;
+		return XFS_IFORK_EXTCNT_MAXS32;
 
-	return MAXAEXTNUM;
+	return XFS_IFORK_EXTCNT_MAXS16;
 }
 
 struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
-- 
2.30.2

