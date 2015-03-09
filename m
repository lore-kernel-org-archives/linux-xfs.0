Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 607807F4E
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 15:13:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A2B28F8066
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 13:13:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id M3uuEOHjmSrevSNp for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 13:13:18 -0700 (PDT)
Message-ID: <54FDFEDC.5090106@sandeen.net>
Date: Mon, 09 Mar 2015 16:13:16 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond
	dir size
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
To: Rui Gomes <rgomes@rvx.is>, xfs-oss <xfs@oss.sgi.com>

When process_sf_dir2() is trying to salvage entries in a corrupted
short form directory, it may attempt to shorten the last entry in
the dir if it extends beyond the directory size.

However, if the name already starts past the dir size, no amount
of name-shortening will make it fit, but the code doesn't realize
this.  The namelen variable comes out to be negative, and things
go downhill from there, resulting in a segfault when we try to
memmove a negative number of bytes.

If no amount of name-shortening can make the last dir entry fit
in the dir size, simply junk the entry.

Reported by: Rui Gomes <rgomes@rvx.is>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This adds a bit more spaghetti to an existing pot, but I think
it clearly fixes the problem; I might try to rework these cases
to coalesce some of the code.

(I also wonder about the tradeoff between shortening entries and
increasing the dir size, but for now I'm just following the
direction the repair code already takes).

diff --git a/repair/dir2.c b/repair/dir2.c
index 6b8964d..308808d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -911,6 +911,20 @@ _("zero length entry in shortform dir %" PRIu64 ""),
 				namelen = ino_dir_size -
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
+				/* Entry name starts past size of dir; junk it */
+				if (namelen <= 0) {
+					do_warn(
+_("start of last entry name overflows space left in in shortform dir %" PRIu64 ", "),
+						ino);
+					if (!no_modify)
+						do_warn(
+						_("junking entry #%d\n"), i);
+					else
+						do_warn(
+						_("would junk entry #%d\n"), i);
+					break;
+				}
+				/* Ok, truncate this entry to end of dir */
 				do_warn(
 _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
