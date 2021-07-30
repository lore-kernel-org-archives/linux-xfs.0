Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B51C43214
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 10:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D7761040
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Jul 2021 10:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhG3KEF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Jul 2021 06:04:05 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32041 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S238383AbhG3KED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jul 2021 06:04:03 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A194Hb6pUDpcpucPFU3ZF6PQaV5rPeYIsimQD?=
 =?us-ascii?q?101hICG8cqSj+fxG+85rsyMc6QxhIU3I9urhBEDtex/hHNtOkOws1NSZLW7bUQ?=
 =?us-ascii?q?mTXeJfBOLZqlWKcUDDH6xmpMNdmsNFaeEYY2IUsS+D2njbLz8/+qj7zImYwffZ?=
 =?us-ascii?q?02x2TRxnL4Vp7wJCAA6dFUFsLTM2fqYRJd6N4NZdvTq8dTAyZsS/PHMMWO/OvJ?=
 =?us-ascii?q?nlj5TjCCR2fSIP2U2fiy+y8r7mH1y91hcaaTlGxrAv6izkvmXCl92ej80=3D?=
X-IronPort-AV: E=Sophos;i="5.84,281,1620662400"; 
   d="scan'208";a="112074018"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2021 18:02:19 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 13A174D0D4A3;
        Fri, 30 Jul 2021 18:02:17 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 30 Jul 2021 18:02:16 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 30 Jul 2021 18:02:15 +0800
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
CC:     <djwong@kernel.org>, <dan.j.williams@intel.com>,
        <david@fromorbit.com>, <hch@lst.de>, <agk@redhat.com>,
        <snitzer@redhat.com>
Subject: [PATCH RESEND v6 9/9] fsdax: add exception for reflinked files
Date:   Fri, 30 Jul 2021 18:01:58 +0800
Message-ID: <20210730100158.3117319-10-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 13A174D0D4A3.A33E4
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For reflinked files, one dax page may be associated more than once with
different fime mapping and index.  It will report warning.  Now, since
we have introduced dax-RMAP for this case and also have to keep its
functionality for other filesystems who are not support rmap, I add this
exception here.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index dce6307a12eb..f5910d178695 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -352,9 +352,10 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
+		if (!page->mapping) {
+			page->mapping = mapping;
+			page->index = index + i++;
+		}
 	}
 }
 
@@ -370,9 +371,10 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		struct page *page = pfn_to_page(pfn);
 
 		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
-		page->mapping = NULL;
-		page->index = 0;
+		if (page->mapping == mapping) {
+			page->mapping = NULL;
+			page->index = 0;
+		}
 	}
 }
 
-- 
2.32.0



