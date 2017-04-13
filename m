Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44042 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbdDMIOA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 04:14:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EFC581F07
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 08:13:59 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/2] xfsprogs: update man for metadump about dirty log/obfuscation issue
Date: Thu, 13 Apr 2017 10:13:54 +0200
Message-Id: <20170413081354.22170-3-jtulak@redhat.com>
In-Reply-To: <20170413081354.22170-1-jtulak@redhat.com>
References: <20170413081354.22170-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

This is something that should be documented, as it is not obvious to
everyone.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 man/man8/xfs_metadump.8 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 3731d6a..1b40fb8 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -59,6 +59,12 @@ options where
 are not obfuscated. Names between 5 and 8 characters in length inclusively
 are partially obfuscated.
 .PP
+Log recovery of an obfuscated metadata image can leak
+unobfuscated metadata and/or cause image corruption. Please mount
+the source filesystem to clean the log or disable obfuscation, if possible.
+If you have to obfuscate an image with a dirty log, tell about it to whoever
+you are sending the image to.
+.PP
 .B xfs_metadump
 should not be used for any purposes other than for debugging and reporting
 filesystem problems. The most common usage scenario for this tool is when
-- 
2.1.4

