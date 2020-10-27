Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D686BC55178
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929B42076B
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900789AbgJ0RYf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:24:35 -0400
Received: from sandeen.net ([63.231.237.45]:49178 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818874AbgJ0RYd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Oct 2020 13:24:33 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 64860328A03;
        Tue, 27 Oct 2020 12:24:18 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1.5/5] mkfs: clarify valid "inherit" option values
Message-ID: <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
Date:   Tue, 27 Oct 2020 12:24:29 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <160375511989.879169.8816363379781873320.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clarify which values are valid for the various *inherit= mkfs
options.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0a785874..a2be066b 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -377,21 +377,21 @@ This option disables automatic geometry detection and creates the filesystem
 without stripe geometry alignment even if the underlying storage device provides
 this information.
 .TP
-.BI rtinherit= value
-If set, all inodes created by
+.BI rtinherit= [0|1]
+If set to 1, all inodes created by
 .B mkfs.xfs
 will be created with the realtime flag set.
 Directories will pass on this flag to newly created regular files and
 directories.
 .TP
-.BI projinherit= value
+.BI projinherit= projid
 All inodes created by
 .B mkfs.xfs
 will be assigned this project quota id.
 Directories will pass on the project id to newly created regular files and
 directories.
 .TP
-.BI extszinherit= value
+.BI extszinherit= extentsize
 All inodes created by
 .B mkfs.xfs
 will have this extent size hint applied.
@@ -399,8 +399,8 @@ The value must be provided in units of filesystem blocks.
 Directories will pass on this hint to newly created regular files and
 directories.
 .TP
-.BI daxinherit= value
-If set, all inodes created by
+.BI daxinherit= [0|1]
+If set to 1, all inodes created by
 .B mkfs.xfs
 will be created with the DAX flag set.
 Directories will pass on this flag to newly created regular files and

