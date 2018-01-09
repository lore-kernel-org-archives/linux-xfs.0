Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbeAIGUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 01:20:32 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24976356D4
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2018 06:20:32 +0000 (UTC)
Received: from dhcp-13-208.nay.redhat.com (dhcp-13-208.nay.redhat.com [10.66.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6136E620A5
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2018 06:20:31 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] db/print: bad character cause illegal memory access
Date: Tue,  9 Jan 2018 14:20:27 +0800
Message-Id: <20180109062027.4570-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_db can print specified field values, likes:
  # xfs_db -c "inode $inum" -c "print core.nblocks" $dev

But when we give it some bad chararcters, the 'print' command will
crash:

  # xfs_db -r -c "inode 67211167" -c "print core.*" /dev/mapper/rhel-root
  bad character in field *
  *** Error in `xfs_db': free(): invalid pointer: 0x00007fa116e937b8 ***
  ...
  (crash messages)
  ...
  # xfs_db -r -c "inode 67211167" -c "print core.\"" /dev/mapper/rhel-root
  missing closing quote
  *** Error in `xfs_db': free(): invalid pointer: 0x00007f6e8e3c37b8 ***
  ...
  (crash messages)
  ...

The reason is xfs_db call ftok_free() to free ftok_t list, but
flist_split() forgets to set the tail to NULL. That cause ftok_free()
trys to free illegal memory address.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 db/flist.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/db/flist.c b/db/flist.c
index e11acbfc..1a875b95 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -371,11 +371,14 @@ flist_split(
 	v = xmalloc(sizeof(*v));
 	v->tok = NULL;
 	while (*s) {
+		v = xrealloc(v, (nv + 1) * sizeof(*v));
 		/* need to add string handling */
 		if (*s == '\"') {
 			s++; /* skip first quote */
 			if ((a = strrchr(s, '\"')) == NULL) {
 				dbprintf(_("missing closing quote %s\n"), s);
+				v[nv].tok = NULL;
+				v[nv].tokty = TT_END;
 				ftok_free(v);
 				return NULL;
 			}
@@ -393,19 +396,21 @@ flist_split(
 			t = puncttypes[a - punctchars];
 		} else {
 			dbprintf(_("bad character in field %s\n"), s);
+			v[nv].tok = NULL;
+			v[nv].tokty = TT_END;
 			ftok_free(v);
 			return NULL;
 		}
 		a = xmalloc(l + 1);
 		strncpy(a, s, l);
 		a[l] = '\0';
-		v = xrealloc(v, (nv + 2) * sizeof(*v));
 		v[nv].tok = a;
 		v[nv].tokty = t;
 		nv++;
 		s += l + tailskip;
 		tailskip = 0;
 	}
+	v = xrealloc(v, (nv + 1) * sizeof(*v));
 	v[nv].tok = NULL;
 	v[nv].tokty = TT_END;
 	return v;
-- 
2.13.6

