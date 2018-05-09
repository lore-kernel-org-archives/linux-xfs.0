Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38791 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934759AbeEILp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 07:45:58 -0400
Received: by mail-wm0-f47.google.com with SMTP id y189-v6so9011192wmc.3
        for <linux-xfs@vger.kernel.org>; Wed, 09 May 2018 04:45:58 -0700 (PDT)
Date: Wed, 9 May 2018 13:45:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: xfs_db and ASSERT fails dur type mismatch
Message-ID: <20180509114554.2slvfi3hqt4na6vy@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

Hey folks,

I've been thinking about different ways to fix those crashes on xfs_db due type
mismatch, based on the previous discussion and a chat I had with Eric on irc.

After thinking a bit more about it, I do think using unknown header types adds
unneeded extra complexity to the code, to achieve the same result as an extra
check on print_flist_1().

Adding an unknown type, will require a change to all types affected by this
issue. I am not sure if a single unknown type can be used for all metadata types
which is affected by this, but I think it requires an unknown type for each of
these metadata. Or at least an entry for an unknown header type (in case of of
the known ones are not found).

While, the crash caused by unrecognized metadata when using these types, can be
fixed by something like my original change.

I wrote a slightly different patch like this:

diff --git a/db/print.c b/db/print.c
index 0da36c27..f8a48281 100644
--- a/db/print.c
+++ b/db/print.c
@@ -160,9 +160,10 @@ print_flist_1(
                                        (f->flags & FLD_ARRAY) != 0);
                                if (neednl)
                                        dbprintf("\n");
-                       } else {
-                               ASSERT(fa->arg & FTARG_OKEMPTY);
+                       } else if (fa->arg & FTARG_OKEMPTY) {
                                dbprintf(_("(empty)\n"));
+                       } else {
+                               dbprintf(_("Unrecognized metadata or type mismatch\n"));
                        }
                }
                free_strvec(pfx);


This will still keep printing "(empty)" where it should be printed, or print out
a hint that something went wrong.

I honestly think this the best solution for these crashes, what you guys think?

Cheers


-- 
Carlos
