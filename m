Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFNSBxO016430
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 17:28:12 -0600
Received: from carme.pld-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32CED23137
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 15:28:09 -0800 (PST)
Received: from carme.pld-linux.org (carme.pld-linux.org [193.239.45.140]) by
	cuda.sgi.com with ESMTP id GmvIdOtuRasv3dbs for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 15:28:09 -0800 (PST)
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: [PATCH] xfs_quota: Warn if specified non-zero quota will be round
	down to zero.
Date: Tue, 16 Dec 2008 00:27:37 +0100
Message-Id: <1229383657-45951-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1722845568108133009=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

--===============1722845568108133009==

User specified quota limit is internally converted to "basic blocks"
unit (512 bytes in size). Quota value will be silently converted
to zero when user enters any value lower than 512 bytes.

Warn in such case:

: # ./xfs_quota -x -c "limit -u bsoft=431 12000" /home
: xfs_quota: Warning: `431' in quota blocks is 0 (unlimited).
---
 xfsprogs/po/pl.po     |    5 +++++
 xfsprogs/quota/edit.c |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/xfsprogs/po/pl.po b/xfsprogs/po/pl.po
index b4e1d76..d13184b 100644
--- a/xfsprogs/po/pl.po
+++ b/xfsprogs/po/pl.po
@@ -3670,6 +3670,11 @@ msgstr "%s: nieprawid
 msgid "%s: invalid project name: %s\n"
 msgstr "%s: nieprawid³owa nazwa projektu: %s\n"
 
+#: ../quota/edit.c:237
+#, c-format
+msgid "%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"
+msgstr "%s: Uwaga: `%s' w blokach quoty oznacza 0 (nieograniczone).\n"
+
 #: ../quota/edit.c:318
 #, c-format
 msgid "%s: unrecognised argument %s\n"
diff --git a/xfsprogs/quota/edit.c b/xfsprogs/quota/edit.c
index 15c72c4..ce7f7e9 100644
--- a/xfsprogs/quota/edit.c
+++ b/xfsprogs/quota/edit.c
@@ -233,6 +233,8 @@ extractb(
 		s = string + length + 1;
 		v = (__uint64_t)cvtnum(blocksize, sectorsize, s);
 		*value = v >> 9;	/* syscalls use basic blocks */
+		if (v > 0 && *value == 0)
+			fprintf(stderr, _("%s: Warning: `%s' in quota blocks is 0 (unlimited).\n"), progname, s);
 		return 1;
 	}
 	return 0;
-- 
1.6.0.5


--===============1722845568108133009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1722845568108133009==--
