Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53166 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbeK2L63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 06:58:29 -0500
Date: Wed, 28 Nov 2018 16:54:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 7/6] xfs_db: add missing string name for DBM_COWDATA
Message-ID: <20181129005454.GK8125@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <20181127231545.GA8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127231545.GA8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In db/check.c, typename[] is supposed to have strings for every DBM_
type, but we forgot one.  Add it now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add build time check
---
 db/check.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/db/check.c b/db/check.c
index 352aab3f..442600be 100644
--- a/db/check.c
+++ b/db/check.c
@@ -164,8 +164,19 @@ static const char	*typename[] = {
 	"btrmap",
 	"btrefcnt",
 	"rldata",
+	"cowdata",
 	NULL
 };
+
+/*
+ * Make sure typename has the same number of elements as there are DBM types.
+ * This function isn't called anywhere; we just use it to trip up the compiler.
+ */
+static inline void check_typename(void)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(typename) != DBM_NDBM + 1);
+}
+
 static int		verbose;
 
 #define	CHECK_BLIST(b)	(blist_size && check_blist(b))
