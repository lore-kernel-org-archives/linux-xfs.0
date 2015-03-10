Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2FA47F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 16:11:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63C18304051
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 14:11:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wqarZGq7Hey98Hr3 for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 14:11:40 -0700 (PDT)
Received: from Liberator.local (unknown [40.139.179.11])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 28E6063C3A20
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 16:11:40 -0500 (CDT)
Message-ID: <54FF5E0A.5040800@sandeen.net>
Date: Tue, 10 Mar 2015 17:11:38 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs_repair: remove last-entry hack in process_sf_dir2
References: <54FF59DA.60700@sandeen.net>
In-Reply-To: <54FF59DA.60700@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

process_sf_dir2() tries to special-case the last entry in
a short form dir, and salvage it if the name length is wrong
by using the dir size as a clue to what the length should be.

However, this doesn't actually work; there is either a 32-bit
or 64-bit inode after the name, and with dirv3 there's a file
type in there as well.  Extending the name length to the dir
size means it overlaps these fields, which often have a 0 in
the top bits, and then namecheck() fails the result and junks
it anyway:

> entry #1 is zero length in shortform dir 67, resetting to 29
> entry contains illegal character in shortform dir 67
> junking entry "bbbbbbbbbbbbbbbbbbbbbbbb" in directory inode 67

And depending on the corruption, the current code will set
a new negative namelen if it turns out that the name itself
starts beyond dir size; it can't be shortened enough.

So, we could fix this up, and choose a new namelen such that
the xfs_dir2_ino8_t and/or xfs_dir2_ino8_t and/or file type
still fits at the end, but we really seem to be reaching the
point of diminishing returns.  The chances that nothing but
the name length is wrong, and that the remaining few
bytes at the end of the dir size are actually correct, seems
awfully small.

Therefore just remove this special case, which I think is
of questionable value.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index 5512e41..b1816f4 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -874,43 +874,20 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
 		}
 
 		if (bad_sfnamelen) {
+			do_warn(
+_("entry #%d %s in shortform dir %" PRIu64),
+				i, junkreason, ino);
+			if (!no_modify)
+				do_warn(_(", junking %d entries\n"),
+					num_entries - i);
+			else
+				do_warn(_(", would junk %d entries\n"),
+					num_entries - i);
 			/*
-			 * if we're really lucky, this is the last entry in
-			 * case we can use the dir size to set the namelen
-			 * value.  otherwise, forget it because we're not going
-			 * to be able to find the next entry.
+			 * don't process the rest of the directory,
+			 * break out of processing loop
 			 */
-			if (i == num_entries - 1)  {
-				namelen = ino_dir_size -
-					((__psint_t) &sfep->name[0] -
-					 (__psint_t) sfp);
-				if (!no_modify)  {
-					do_warn(
-_("entry #%d %s in shortform dir %" PRIu64 ", resetting to %d\n"),
-						i, junkreason, ino, namelen);
-					sfep->namelen = namelen;
-					*dino_dirty = 1;
-				} else  {
-					do_warn(
-_("entry #%d %s in shortform dir %" PRIu64 ", would set to %d\n"),
-						i, junkreason, ino, namelen);
-				}
-			} else  {
-				do_warn(
-_("entry #%d %s in shortform dir %" PRIu64),
-					i, junkreason, ino);
-				if (!no_modify)
-					do_warn(_(", junking %d entries\n"),
-						num_entries - i);
-				else
-					do_warn(_(", would junk %d entries\n"),
-						num_entries - i);
-				/*
-				 * don't process the rest of the directory,
-				 * break out of processing looop
-				 */
-				break;
-			}
+			break;
 		}
 
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
