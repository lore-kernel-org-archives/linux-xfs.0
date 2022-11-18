Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC114C4167D
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Nov 2022 23:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbiKRXnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Nov 2022 18:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiKRXmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2022 18:42:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B6C101E7;
        Fri, 18 Nov 2022 15:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=L1Navczq1wYsve2+F0Sj0wGflk8EnLu/Y0Q5tECbri4=; b=pLqPpOyyarFNuDaaLxrOJpBl7c
        nPd3J6Roy8E7Bq9Mho5iNehKTqJ5rx4Q8ETIWjnlxU8HDPrdHSAP4lxH5w3fhyUtMznMqEztSzwga
        FBdpKM227BbZh34irtqkbyV/If7t88IY1ZOGVoUko6y4tgllr+JQ0YsxfA+9L6OpoXSTFn0P2nabS
        awEZfdI8M03Nb1oLKtAU5CNSPRpZhlLq/REtQtwc5j4T9dPR7RS06BLGexgllC2L+5D4HN69vFSdd
        yU1lFKnaDDlFfjYNgtUO5Okdfqe0EVUubPRgHNhDH327Vr9vQc8nadhE1U9uwWQeDyZUOfsOH970d
        4Urqg/6g==;
Received: from [2601:1c2:d80:3110::a2e7] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owAhj-002mOk-Ku; Fri, 18 Nov 2022 23:23:28 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-doc@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] Documentation: admin-guide: correct "it's" to possessive "its"
Date:   Fri, 18 Nov 2022 15:23:17 -0800
Message-Id: <20221118232317.3244-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Correct 2 uses of "it's" to the possessive "its" as needed.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/admin-guide/mm/numa_memory_policy.rst |    2 +-
 Documentation/admin-guide/xfs.rst                   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -- a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst
+++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -111,7 +111,7 @@ VMA Policy
 	* A task may install a new VMA policy on a sub-range of a
 	  previously mmap()ed region.  When this happens, Linux splits
 	  the existing virtual memory area into 2 or 3 VMAs, each with
-	  it's own policy.
+	  its own policy.
 
 	* By default, VMA policy applies only to pages allocated after
 	  the policy is installed.  Any pages already faulted into the
diff -- a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -192,7 +192,7 @@ When mounting an XFS filesystem, the fol
 	are any integer multiple of a valid ``sunit`` value.
 
 	Typically the only time these mount options are necessary if
-	after an underlying RAID device has had it's geometry
+	after an underlying RAID device has had its geometry
 	modified, such as adding a new disk to a RAID5 lun and
 	reshaping it.
 
