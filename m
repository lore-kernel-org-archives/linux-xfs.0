Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728869AbeJ0IEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 04:04:55 -0400
Date: Fri, 26 Oct 2018 16:25:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] misc: only build with lto if explicitly enabled
Message-ID: <20181026232538.GK28243@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the LTO default to off from probe because it wastes build time on
developer machines.  Anyone who really wants it for release builds or
whatever can still turn it on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 44a4b3a8..f8f29c07 100644
--- a/configure.ac
+++ b/configure.ac
@@ -109,8 +109,8 @@ AC_ARG_ENABLE(threadsan,
 AC_SUBST(enable_threadsan)
 
 AC_ARG_ENABLE(lto,
-[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=probe]],,
-	enable_lto=probe)
+[ --enable-lto=[yes/no]      Enable link time optimization (LTO) [default=no]],,
+	enable_lto=no)
 AC_SUBST(enable_lto)
 
 # Enable xfs_scrub build
