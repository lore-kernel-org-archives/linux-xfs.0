Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60EC57F59
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31157304039
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QqLqk3hOiJ4w3n8y for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 08/13] xfs_repair: remove last-entry hack in process_sf_dir2
Date: Tue, 17 Mar 2015 15:33:10 -0500
Message-Id: <1426624395-8258-9-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/dir2.c |   47 ++++++++++++-----------------------------------
 1 files changed, 12 insertions(+), 35 deletions(-)

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
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
