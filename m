Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 21:14:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m195DdfO001507
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 21:13:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FDE65B9DE5
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 21:14:02 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id l7RVu0CwNpDMavqs for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 21:14:02 -0800 (PST)
Message-ID: <47AD367A.8080804@sandeen.net>
Date: Fri, 08 Feb 2008 23:13:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] fix up out of tree builds (mainline only)
References: <20080208022705.0DB1058C4C11@chook.melbourne.sgi.com> <47AD284F.7080603@sandeen.net>
In-Reply-To: <47AD284F.7080603@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

kernel.org git tree "port" of:

Fix up xfs out-of-tree builds. (a.k.a. external modules)

Change -I include directives to find headers in the out-of-tree spot.
This allows a directory containing only xfs files to be built as:

  # make -C /path/to/kernel M=`pwd`

Signed-off-by: Eric Sandeen <sandeen@sandeen.net <mailto:sandeen@sandeen.net>>
Merge of xfs-linux-melb:xfs-kern:29878a by kenmcd.

  fix up out-of-tree xfs builds.


Index: linux-2.6/fs/xfs/Makefile
===================================================================
--- linux-2.6.orig/fs/xfs/Makefile
+++ linux-2.6/fs/xfs/Makefile
@@ -16,7 +16,7 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
-EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char
+EXTRA_CFLAGS +=	 -I$(src) -I$(src)/linux-2.6 -funsigned-char
 
 XFS_LINUX := linux-2.6
 
