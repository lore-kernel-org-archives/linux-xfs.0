Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D0CC37F4E
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 21:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BFAF1304032
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 19:30:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lIqbTH1GHQziFhEJ for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 19:30:22 -0700 (PDT)
Date: Mon, 14 Apr 2014 12:30:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] renameat2 syscall: check plain rename
Message-ID: <20140414023020.GJ27694@dastard>
References: <1397231517-4641-1-git-send-email-miklos@szeredi.hu>
	<1397231517-4641-2-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397231517-4641-2-git-send-email-miklos@szeredi.hu>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@suse.cz>, xfs@oss.sgi.com

On Fri, Apr 11, 2014 at 05:51:55PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Check with zero flags.  This is what rename(2) and renameat(2) now call, so
> this actually tests the behavior of these syscalls as well.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Miklos, this test fails on XFS with the following diff:

$ diff -u tests/generic/023.out /home/dave/src/xfstests-dev/results//generic/023.out.bad
--- tests/generic/023.out       2014-04-14 10:44:22.000000000 +1000
+++ /home/dave/src/xfstests-dev/results//generic/023.out.bad    2014-04-14 12:00:23.000000000 +1000
@@ -18,12 +18,12 @@
 samedir  dire/regu -> Not a directory
 samedir  dire/symb -> Not a directory
 samedir  dire/dire -> none/dire.
-samedir  dire/tree -> Directory not empty
+samedir  dire/tree -> File exists
 samedir  tree/none -> none/tree.
 samedir  tree/regu -> Not a directory
 samedir  tree/symb -> Not a directory
 samedir  tree/dire -> none/tree.
-samedir  tree/tree -> Directory not empty
+samedir  tree/tree -> File exists
 crossdir none/none -> No such file or directory
 crossdir none/regu -> No such file or directory
 crossdir none/symb -> No such file or directory
@@ -43,9 +43,9 @@
 crossdir dire/regu -> Not a directory
 crossdir dire/symb -> Not a directory
 crossdir dire/dire -> none/dire.
-crossdir dire/tree -> Directory not empty
+crossdir dire/tree -> File exists
 crossdir tree/none -> none/tree.
 crossdir tree/regu -> Not a directory
 crossdir tree/symb -> Not a directory
 crossdir tree/dire -> none/tree.
-crossdir tree/tree -> Directory not empty
+crossdir tree/tree -> File exists

IOWs, XFS is returning EEXIST rather than ENOTEMPTY for several of
these rename tests. The rename man page says this about the errors:

       ENOTEMPTY or EEXIST
              newpath is a nonempty directory, that is, contains
	      entries other than "." and "..".

Which implies that both errors are valid and so the test should pass
in either case. Can you send a patch to handle these
different-but-valid error returns?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
