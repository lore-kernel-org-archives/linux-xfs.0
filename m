Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 889E87F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 15:08:26 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7712230405F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 13:08:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WqkAuOqEys6JQbcf for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 13:08:22 -0800 (PST)
Message-ID: <54F77445.3010809@sandeen.net>
Date: Wed, 04 Mar 2015 15:08:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs: fix NULL pointer dereference in
	xfs_filestream_lookup_ag()
References: <54F61641.1010708@redhat.com>
In-Reply-To: <54F61641.1010708@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>
Cc: Adrien Nader <adrien@notk.org>

If xfs_filestream_get_parent() fails, we have a null pip,
goto out, and attempt to IRELE(NULL).  This causes a null
pointer dereference and BUG().

Fix this by directly returning NULLAGNUMBER in this case.

Reported-by: Adrien Nader <adrien@notk.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: skip the goto, because Dave doesn't like it.  ;)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index a2e86e8..8f9f854 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -322,7 +322,7 @@ xfs_filestream_lookup_ag(
 
 	pip = xfs_filestream_get_parent(ip);
 	if (!pip)
-		goto out;
+		return NULLAGNUMBER;
 
 	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
 	if (mru) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
