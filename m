Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36160 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933106AbdCaQ1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 12:27:25 -0400
Date: Fri, 31 Mar 2017 09:27:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfstests: Add first statx test
Message-ID: <20170331162723.GA1693@infradead.org>
References: <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

This only compiles with warnings for me:

stat_test.c: In function 'main':
stat_test.c:557:3: warning: 'sval' may be used uninitialized in this function [-Wmaybe-uninitialized]
   check(sval == scheck,
   ^
stat_test.c:451:20: note: 'sval' was declared here
  long long scheck, sval;
                    ^
stat_test.c:542:3: warning: 'uval' may be used uninitialized in this function [-Wmaybe-uninitialized]
   check(uval == ucheck,
   ^
stat_test.c:450:29: note: 'uval' was declared here
  unsigned long long ucheck, uval;
                             ^

And running it then fails for me on Debian stable:


--- tests/generic/420.out	2017-03-31 16:24:11.643845876 +0000
+++ /root/xfstests/results//generic/420.out.bad	2017-03-31 16:26:23.820512545 +0000
@@ -8,4 +8,10 @@
 20+0 records out
 Test statx on a symlink
 Test statx on an AF_UNIX socket
+nc: invalid option -- 'U'
+/bin/nc: invalid option -- 'U'
+nc -h for helpnc -h for help
+
+/mnt/test/420-sock: No such file or directory
 Test a hard link to a file
+/mnt/test/420-sock: No such file or directory
