Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7A5C10DCE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84882206B7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 08:59:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nokia.onmicrosoft.com header.i=@nokia.onmicrosoft.com header.b="xxGrbk+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCLI7O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 04:59:14 -0400
Received: from mail-db8eur05on2128.outbound.protection.outlook.com ([40.107.20.128]:24687
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbgCLI7O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Mar 2020 04:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqC+mO/AYUiPcNXJGRKBuYbtugdxzd88iDpv41xlsnEMKUycamUvCzpo5JMZk0b540QMtlYRUIBVBi5kXp2QV7bJJjcNxBfZzMFSKp1mmRsSw8mpG+UR5SP3EwQrcEkKH5Md5rEXKGk4NUHkPz9RGvBUIkVnikEttSL2w4cx245zX69rq8k5nUXpXjo8bwzZoJJot4zL7Hepz4oXr390PSbaW0kMEV0FGDrX37DpUOiG9/scor+eLx8/pJ6jpNqZ2LXD8puO5XNQyqLV7qafMOh8R7id3ocTFGcE3+PIiRxYNQ9giiI77HotPHOGhgOjjOfahnf6wtLMD/Ju/A+/xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVIyJifZ+Mj6NeWUOmYREnc7pAoXEmmx5oIlpEy+W3E=;
 b=WsL+2vrI8CJEaUQlpuSFJq/sKHzZWR6qLSG92ECYG5vBKGHyjGagAsRXVGXvcJ9ocIyQNo2jM1JTHZ0atrxydDMj+UyUHYMpxZ0Lu440JTz0dLaJQ/lu4cbuEVpRNZCYYbsOWftE6SpZSZuQ/8/unGTn2mhNxTSRBowbQchK20SYhU3g+dky00mWSdE+7DIgWIZ0EyWUZLVOf6ibvZTkzf5qoPQO3BAXUxaEVtK7hB6zkCrZGxg3x8egFpA/6LaHKq8L3wx68AjeRCB3raUt5C7fb70Gyy4b04M6TcC0q6KTx0ut3uPpjpNxrlKj+9VF8xBhiRmJWP9Nl3voAKquRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bVIyJifZ+Mj6NeWUOmYREnc7pAoXEmmx5oIlpEy+W3E=;
 b=xxGrbk+Yw/cF2/E241lR7GPCqi7CKVFhoNwCczQCCvZsh/zsdKJV6hk7blYeEfIL5bVuG+rMYlbYJTJr5MnsYk0ysOxo6GPFUfxJzLWWTZQQHoGbi0YvUY/Xyhn/e6sod3icrI6cstmcBbT3oIgbWWLNwqqJ3uxgG7DGa58PtuU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3674.eurprd07.prod.outlook.com (10.167.125.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.10; Thu, 12 Mar 2020 08:59:10 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 08:59:10 +0000
From:   Tommi Rantala <tommi.t.rantala@nokia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tommi Rantala <tommi.t.rantala@nokia.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: fix regression in "cleanup xfs_dir2_block_getdents"
Date:   Thu, 12 Mar 2020 10:57:28 +0200
Message-Id: <20200312085728.22187-1-tommi.t.rantala@nokia.com>
X-Mailer: git-send-email 2.21.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HE1PR05CA0220.eurprd05.prod.outlook.com
 (2603:10a6:3:fa::20) To HE1PR0702MB3675.eurprd07.prod.outlook.com
 (2603:10a6:7:85::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from trfedora.emea.nsn-net.net (131.228.2.19) by HE1PR05CA0220.eurprd05.prod.outlook.com (2603:10a6:3:fa::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 08:59:10 +0000
X-Mailer: git-send-email 2.21.1
X-Originating-IP: [131.228.2.19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed8da60a-f3f3-4309-64cb-08d7c663a136
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0702MB3674033039B593B743916A32B4FD0@HE1PR0702MB3674.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(199004)(6506007)(4326008)(6512007)(2906002)(316002)(66946007)(103116003)(478600001)(81156014)(66476007)(8676002)(66556008)(6666004)(36756003)(81166006)(2616005)(86362001)(8936002)(956004)(5660300002)(186003)(52116002)(26005)(54906003)(16526019)(6486002)(6916009)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3674;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAmWhk5zZ37hujHAPkg5a8AcRZglTG9Aqdgg7VLYvtapAS3Rvo/iLdZ3UO25dlmXtSqBwqZCxpVTFGskyYCfvSId0cWuEPErbOCuoG7sL8uUj5kUhc3IFiXJ0eQIou01Nww+Jzy9MtqF6ibDLEOZEkSAIZ8zBGwf0/CKe6Z5fm2r+hM0dHrWcYs1i/IfJl5W0VIipZKeomPg7NLPYRUjSpBXqcLE2bI1qizFaeC6HvVdY1BI9+T8Uczv948RfLztwAAN1c8vJek+FLwIQctqDQltbLw4kSyvc2XyLQFusCkjKNFciUR0uieHqOKt0g9Cl3epvJZZLId+WELmDG5Ly9ML25CDq1tnUUD9eKr+tMiCxxf7OO+PkWiZi8HQG1jRYeM/2Ak2rWnVZIUvkdOUQHLSnTxlf0TUE3isaqppLRs068rwLmyYttsIQoXu16Od
X-MS-Exchange-AntiSpam-MessageData: WhqjOolZcj//+918zHG9P8uNdF/nd+sY+Hqo7NJdzh9tz4q73kI8p6z3SsDC04JK4d6kiqeu+RXJbK8aw3r1DYakWnSY2XFit5nuzfqKTuA239CfLS/eT1WK8U90ZfwgGdkp56Y3AFrmOTGeF1mJxg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8da60a-f3f3-4309-64cb-08d7c663a136
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 08:59:10.7011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EO/3iy18H+PhgctFE8dsFT+dTJOslF60gYSnL41mqbcOiuQ2MXN52thN/OFqs4V4zMqaqBR9LY0OFIpEbCAuLdbIXpUeXFLGh9WHA7DHFcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3674
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Commit 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents") introduced
a getdents regression, when it converted the pointer arithmetics to
offset calculations: offset is updated in the loop already for the next
iteration, but the updated offset value is used incorrectly in two
places, where we should have used the not-yet-updated value.

This caused for example "git clean -ffdx" failures to cleanup certain
directory structures when running in a container.

Fix the regression by making sure we use proper offset in the loop body.
Thanks to Christoph Hellwig for suggestion how to best fix the code.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 263dde869bd09 ("xfs: cleanup xfs_dir2_block_getdents")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
---
 fs/xfs/xfs_dir2_readdir.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0d3b640cf1cc..871ec22c9aee 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
 	int			lock_mode;
-	unsigned int		offset;
+	unsigned int		offset, next_offset;
 	unsigned int		end;
 
 	/*
@@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	offset = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
-	while (offset < end) {
+	for (offset = geo->data_entry_offset;
+	     offset < end;
+	     offset = next_offset) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		uint8_t filetype;
@@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
 		 * Unused, skip it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			offset += be16_to_cpu(dup->length);
+			next_offset = offset + be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
+		next_offset = offset +
+			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
 
 		/*
 		 * The entry is before the desired starting point, skip it.
-- 
2.21.1

