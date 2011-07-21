Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LNq6al049991 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 18:52:07 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD267EEDEF3
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:52:05 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id E7RHtA4nKtWRj65x for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 16:52:05 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH XFSTESTS 1/3] configure.in: Declare a requirement for at least
	autoconf 2.50
Date: Thu, 21 Jul 2011 19:52:02 -0400
Message-Id: <1311292324-4348-1-git-send-email-tytso@mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>

On Debian/Ubuntu systems, if autoconf version 2.13 is installed,
autoconf will try to automatically figure out whether autoconf 2.13 or
something more modern is required (since the autoconf maintainers,
curses be upon them, didn't bother to maintain compatibility between
autoconf 2.13 and 2.50).  Unfortunately, the hueristics aren't
perfect, and although the configure.in file looks superficially like
it will be compatible with autoconf 2.13, it isn't.  You will end up
with a number of very subtle compilation failures if you use autoconf
2.13.

So declare a requirement for autoconf 2.50 using AC_PREREQ(2.50).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 45b7fd1..c697b4f 100644
--- a/configure.in
+++ b/configure.in
@@ -1,4 +1,5 @@
 AC_INIT(src/xfsctl.c)
+AC_PREREQ(2.50)
 AC_PACKAGE_GLOBALS(xfstests)
 AC_PACKAGE_UTILITIES(xfstests)
 
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
