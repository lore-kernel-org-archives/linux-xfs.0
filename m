Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTQts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:49:48 -0400
Subject: [PATCH 02/12] libfrog: cvt_u64 should use strtoull, not strtoll
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jun 2019 09:49:42 -0700
Message-ID: <156104938235.1172531.7192571581132527840.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

cvt_u64 converts a string to an unsigned 64-bit number, so it should use
strtoull, not strtoll because we don't want negative numbers here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/convert.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libfrog/convert.c b/libfrog/convert.c
index 62397507..8d4d4077 100644
--- a/libfrog/convert.c
+++ b/libfrog/convert.c
@@ -105,14 +105,14 @@ cvt_s16(
  */
 uint64_t
 cvt_u64(
-	char		*s,
-	int		base)
+	char			*s,
+	int			base)
 {
-	long long	i;
-	char		*sp;
+	unsigned long long	i;
+	char			*sp;
 
 	errno = 0;
-	i = strtoll(s, &sp, base);
+	i = strtoull(s, &sp, base);
 	/*
 	 * If the input would over or underflow, return the clamped
 	 * value and let the user check errno.  If we went all the
