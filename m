Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751958AbeF1BpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jun 2018 21:45:08 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Message-ID: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
Date: Wed, 27 Jun 2018 20:45:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, Linux API <linux-api@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Zhibin Li <zhibli@redhat.com>

mmap(2) says the syscall will return EINVAL if "flags contained neither
MAP_PRIVATE or MAP_SHARED, or contained both of these values."
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
However, commit 
1c972597 ("mm: introduce MAP_SHARED_VALIDATE ...")
introduced a new flag, MAP_SHARED_VALIDATE, with a value of 0x3,
which is indistinguishable from (MAP_SHARED|MAP_PRIVATE).

Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
passes without error, which is a regression.

I'm not sure of the best way out of this, other than to change the
API description to say that MAP_SHARED_VALIDATE is only allowed in
combination with "new" flags, and reject it if it's used only with
flags contained in LEGACY_MAP_MASK.

This will require the mmap(2) manpage to enumerate which flags don't
require validation, as well, so the user knows when to use the
VALIDATE flag.

I'm not super happy with this, because it also means that code
which explicitly asks for mmap(MAP_SHARED|MAP_PRIVATE|MAP_SYNC) will
also pass, but I'm not sure there's anything to do about that.

Reported-by: Zhibin Li <zhibli@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mm/mmap.c b/mm/mmap.c
index d1eb87ef4b1a..b1dc84466365 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1440,6 +1440,16 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
 			return -EOVERFLOW;
+		/*
+		 * MAP_SHARED_VALIDATE is indistinguishable from
+		 * (MAP_SHARED|MAP_PRIVATE) which must return -EINVAL.
+		 * If the flags contain MAP_SHARED_VALIDATE and none of the
+		 * non-legacy flags, the user gets EINVAL.
+		 */
+		if (((flags & MAP_SHARED_VALIDATE) == MAP_SHARED_VALIDATE) &&
+		    !(flags & ~LEGACY_MAP_MASK)) {
+			return -EINVAL;
+		}
 
 		flags_mask = LEGACY_MAP_MASK | file->f_op->mmap_supported_flags;
 

