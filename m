Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Aug 2007 14:06:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l75L66bm026047
	for <xfs@oss.sgi.com>; Sun, 5 Aug 2007 14:06:08 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 4247D18015183
	for <xfs@oss.sgi.com>; Sun,  5 Aug 2007 16:06:10 -0500 (CDT)
Message-ID: <46B63BC2.7020109@sandeen.net>
Date: Sun, 05 Aug 2007 16:06:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] fix nasty quota hashtable allocation bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

This git mod: 77e4635ae191774526ed695482a151ac986f3806

converted to a "greedy" allocation interface, but for the quota hashtables
it switched from allocating XFS_QM_HASHSIZE (nr of elements) xfs_dqhash_t's 
to  allocating only XFS_QM_HASHSIZE *bytes* - quite a lot smaller!  Then when 
we  converted hsize "back" to nr of elements (the division line) hsize went 
to 0. This was  leading to oopses when running any quota tests on the Fedora 8
test  kernel, but the problem has been there for almost a year.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.22-rc4/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/xfs/quota/xfs_qm.c
+++ linux-2.6.22-rc4/fs/xfs/quota/xfs_qm.c
@@ -117,7 +117,8 @@ xfs_Gqm_init(void)
 	 * Initialize the dquot hash tables.
 	 */
 	udqhash = kmem_zalloc_greedy(&hsize,
-				     XFS_QM_HASHSIZE_LOW, XFS_QM_HASHSIZE_HIGH,
+				     XFS_QM_HASHSIZE_LOW * sizeof(xfs_dqhash_t),
+				     XFS_QM_HASHSIZE_HIGH * sizeof(xfs_dqhash_t),
 				     KM_SLEEP | KM_MAYFAIL | KM_LARGE);
 	gdqhash = kmem_zalloc(hsize, KM_SLEEP | KM_LARGE);
 	hsize /= sizeof(xfs_dqhash_t);
