Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:40442 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDQMXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 08:23:55 -0400
Received: by mail-wr0-f169.google.com with SMTP id v60so31073591wrc.7
        for <linux-xfs@vger.kernel.org>; Tue, 17 Apr 2018 05:23:55 -0700 (PDT)
Received: from odin.usersys.redhat.com (ip-86-49-61-71.net.upcbroadband.cz. [86.49.61.71])
        by smtp.gmail.com with ESMTPSA id k30sm10931202wrf.1.2018.04.17.05.23.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Apr 2018 05:23:53 -0700 (PDT)
Date: Tue, 17 Apr 2018 14:23:51 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Assertion fails on xfs_db when setting erroneous type
Message-ID: <20180417122351.l4uxq6cx2wczjlsh@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

recently while playing with a FS image, I've hit an assertion in xfs_db:

xfs_db: print.c:164: print_flist_1: Assertion `fa->arg & 64' failed.
Aborted (core dumped)

The reason for this assert was that I tried to print a remote attr3 block, after
having set the block pointer to a random, no attr3 location.

I wonder if crashing xfs_db here is the right thing to do?


I've written a small workaround for it as below:


@@ -160,9 +160,10 @@ print_flist_1(
                                        (f->flags & FLD_ARRAY) != 0);
                                if (neednl)
                                        dbprintf("\n");
-                       } else {
-                               ASSERT(fa->arg & FTARG_OKEMPTY);
+                       } else if (fa->arg & FTARG_OKEMPTY) {
                                dbprintf(_("(empty)\n"));
+                       } else {
+                               dbprintf(_("Invalid arg\n"));
                        }
                }
                free_strvec(pfx);


I wonder if something like this makes sense or not? I'm still familiarizing
myself with xfs_db code, so I'm not sure if something as the small patch above
is a valid fix for it or not, but I believe exiting xfs_db just because somebody
tried to print a metadata block using a different type from the on-disk block
being read doesn't look like the right thing to do.

Comments?

Cheers

-- 
Carlos
