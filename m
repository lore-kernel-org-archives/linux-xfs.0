Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53178 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeK1KPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 05:15:18 -0500
Date: Tue, 27 Nov 2018 15:15:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 7/6] xfs_db: add missing string name for DBM_COWDATA
Message-ID: <20181127231545.GA8125@magnolia>
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154181071499.3727.3910572718199592407.stgit@magnolia>
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
 db/check.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/db/check.c b/db/check.c
index 352aab3f..f5b5e845 100644
--- a/db/check.c
+++ b/db/check.c
@@ -164,6 +164,7 @@ static const char	*typename[] = {
 	"btrmap",
 	"btrefcnt",
 	"rldata",
+	"cowdata",
 	NULL
 };
 static int		verbose;
