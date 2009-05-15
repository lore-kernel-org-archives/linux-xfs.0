Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FMBHDk070845 for <xfs@oss.sgi.com>; Fri, 15 May 2009 17:11:17 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02F9019CE873
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 15:11:25 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ijBksjPygR7uZXac for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 15:11:25 -0700 (PDT)
Message-ID: <4A0DE88C.2040401@sandeen.net>
Date: Fri, 15 May 2009 17:11:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs:  add fallocate command to xfs_io
References: <4A077195.3070708@sandeen.net>	<20090515171324.GA14804@infradead.org>	<20090515172711.GA23630@infradead.org>
	<4A0DB97F.4020201@sandeen.net>
In-Reply-To: <4A0DB97F.4020201@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Fri, May 15, 2009 at 01:13:24PM -0400, Christoph Hellwig wrote:
>>> On Sun, May 10, 2009 at 07:30:13PM -0500, Eric Sandeen wrote:
>>>> Based on Dave's earlier patch, but now we have an fallocate
>>>> glibc call... this also adds autoconf magic and a manpage 
>>>> update.
>>>>
>>>> (hopefully not too #ifdef-heavy....)
>>> Looks good to me and seems to work.
>> Actually that was spoken too fast.  On my Debian -testing system it
>> detects fallocate as available because <linux/falloc.h> exists, but the
>> glibc doesn't actually support a falloc(3) yet.  So either the detection
>> needs to be improved or we need to use the raw syscall.
> 
> Ok, I think I know how to make the detection work better, I'll fix that up.

oh, hrm.  It's already doing what I thought was sufficient but it won't
link will it:
(from m4/package_libcdev.m4)

+#
+# Check if we have a fallocate libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_FALLOCATE],
+  [ AC_MSG_CHECKING([for fallocate])
+    AC_TRY_COMPILE([
+#include <linux/falloc.h>
+    ], [
+         fallocate(0, 0, 0, 0);
+    ], have_fallocate=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fallocate)
+  ])


Instead of above does this work better?

(just change AC_TRY_COMPILE to AC_TRY_LINK)

AC_DEFUN([AC_HAVE_FALLOCATE],
  [ AC_MSG_CHECKING([for fallocate])
    AC_TRY_LINK([
#include <linux/falloc.h>
    ], [
         fallocate(0, 0, 0, 0);
    ], have_fallocate=yes
       AC_MSG_RESULT(yes),
       AC_MSG_RESULT(no))
    AC_SUBST(have_fallocate)
  ])

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
