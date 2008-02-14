Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 19:33:51 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1E3XmBq018480
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 19:33:48 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E927FE10876
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 19:34:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Gnm6TcLkZfRBW0k5 for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 19:34:09 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id CD9D118E215A7
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 21:34:06 -0600 (CST)
Message-ID: <47B3B6AE.4030505@sandeen.net>
Date: Wed, 13 Feb 2008 21:34:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix mount option pasing to make inode cluster deletion default
 (again)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

mod xfs-linux-melb:xfs-kern:29683a / 
git commit 574342f4ad450b33bc85ec53210b8aa8bfff2fcf

broke default options in such a way that empty inode clusters 
are no longer deleted by default, because if no options are 
given, we "goto done;" without setting the default 
XFSMNT_IDELETE flag.

All this logic could probably be rearranged to make things
clearer, but for now I think this small patch fixes it:

Set IDELETE a.k.a. "noikeep" by default, but if dmapi is in
use, turn it back off (i.e. "ikeep") *unless* noikeep was 
specifically requested.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---


Index: linux-2.6.24/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.24.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux-2.6.24/fs/xfs/linux-2.6/xfs_super.c
@@ -171,9 +171,10 @@ xfs_parseargs(
 	char			*this_char, *value, *eov;
 	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
 	int			iosize;
-	int			ikeep = 0;
+	int			noikeep = 0; /* track _explicit_ requests */
 
 	args->flags |= XFSMNT_BARRIER;
+	args->flags |= XFSMNT_IDELETE;	/* i.e. "noikeep" is default */
 	args->flags2 |= XFSMNT2_COMPAT_IOSIZE;
 
 	if (!options)
@@ -302,9 +303,9 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_NOBARRIER)) {
 			args->flags &= ~XFSMNT_BARRIER;
 		} else if (!strcmp(this_char, MNTOPT_IKEEP)) {
-			ikeep = 1;
 			args->flags &= ~XFSMNT_IDELETE;
 		} else if (!strcmp(this_char, MNTOPT_NOIKEEP)) {
+			noikeep = 1; /* explicitly requested */
 			args->flags |= XFSMNT_IDELETE;
 		} else if (!strcmp(this_char, MNTOPT_LARGEIO)) {
 			args->flags2 &= ~XFSMNT2_COMPAT_IOSIZE;
@@ -410,8 +411,8 @@ xfs_parseargs(
 	 * Note that if "ikeep" or "noikeep" mount options are
 	 * supplied, then they are honored.
 	 */
-	if (!(args->flags & XFSMNT_DMAPI) && !ikeep)
-		args->flags |= XFSMNT_IDELETE;
+	if ((args->flags & XFSMNT_DMAPI) && !noikeep)
+		args->flags &= ~XFSMNT_IDELETE;
 
 	if ((args->flags & XFSMNT_NOALIGN) != XFSMNT_NOALIGN) {
 		if (dsunit) {
