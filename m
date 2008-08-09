Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Aug 2008 12:57:52 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m79JvoQn013588
	for <xfs@oss.sgi.com>; Sat, 9 Aug 2008 12:57:50 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD6D11BC22FA
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2008 12:59:06 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2gfjLh3FMIru0K9Y for <xfs@oss.sgi.com>; Sat, 09 Aug 2008 12:59:06 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m79Jx8IF009056
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 9 Aug 2008 21:59:08 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m79Jx8sq009054
	for xfs@oss.sgi.com; Sat, 9 Aug 2008 21:59:08 +0200
Date: Sat, 9 Aug 2008 21:59:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] tiny nametest.c warning fixes
Message-ID: <20080809195908.GA9005@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Include ctype.h for toupper/tolower and remove an unused variable.


Signed-off-by: Christoph Hellwig <hch@lst.de>

--- xfstests/src/nametest.c	24 Jun 2008 16:29:51 -0000	1.8
+++ xfstests/src/nametest.c	9 Aug 2008 19:55:37 -0000
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <ctype.h>
 #include "global.h"
 
 /*
@@ -308,7 +309,6 @@ main(int argc, char *argv[])
 char *get_name(struct info *ip)
 {
 	static char path[PATH_MAX];
-	int i;
 	char *p;
 
 	if (!mixcase)
