Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3F4067F4E
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 05:49:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28CAA304043
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 03:49:57 -0700 (PDT)
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id bjgxOqJ1CfabMNQp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Apr 2014 03:49:55 -0700 (PDT)
Received: by mail-ee0-f53.google.com with SMTP id b57so6410434eek.40
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2014 03:49:54 -0700 (PDT)
Date: Mon, 14 Apr 2014 12:49:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [xfstests PATCH] renameat2 syscall: turn EEXIST into ENOTEMPTY
Message-ID: <20140414104953.GE10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

From: Miklos Szeredi <mszeredi@suse.cz>

XFS is returning EEXIST rather than ENOTEMPTY for several of
these rename tests. The rename man page says this about the errors:

       ENOTEMPTY or EEXIST
              newpath is a nonempty directory, that is, contains
              entries other than "." and "..".

Which implies that both errors are valid and so the test should pass
in either case.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 src/renameat2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/src/renameat2.c
+++ b/src/renameat2.c
@@ -88,6 +88,15 @@ int main(int argc, char *argv[])
 			else
 				return 0;
 		}
+		/*
+		 * Turn EEXIST into ENOTEMPTY.  E.g. XFS uses EEXIST, and that
+		 * is also accepted by the standards.
+		 *
+		 * This applies only to plain rename (flags == 0).
+		 */
+		if (!flags && errno == EEXIST)
+			errno = ENOTEMPTY;
+
 		perror("");
 		return 1;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
