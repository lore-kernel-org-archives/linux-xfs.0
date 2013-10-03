Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 576657F50
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 18:11:49 -0500 (CDT)
Message-ID: <524DF9AE.7050102@sgi.com>
Date: Thu, 3 Oct 2013 18:11:42 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [PATCH V2] xfsdump: handle large, wholly-sparse files
References: <524AF8AE.5030300@sgi.com>
In-Reply-To: <524AF8AE.5030300@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>

In restore_extent_group(), we loop over all extent headers for an inode
in the stream, and add up the cumulatively restored size, accounting
for both HOLE and DATA records and advancing restoredsz as we go.

But for a wholly-sparse file, we have no HOLE header, only
a LAST header, and restoredsz remains at 0.

This makes it look like it's a partially-restored file, split
across streams because the final restoredsz for this stream is
less than the file size, and we go to partial_reg(), which
allocates one slot in persp->a.parrest[] for this inode.  But
we've also called partial_reg() with offset/sz of 0/0, which is
less than the file size so this inode never looks "done."
  Normally partial_check2() would clear the persp->a.parrest[]
slot in the array when the file is fully restored, but in
this case, that is never satisfied.  So all stream slots
get filled as we encounter more inodes like this, and we
eventually get:

"partial_reg: Out of records. Extend attrs applied early."

Fix this by recognizing that if we hit a LAST header with
no restoredsz set (i.e. the LAST header is the only header),
set restoredsz to EOF (bstatp->bs_size) to indicate that
restoration of this file is complete, skip the call to
partial_reg(), and all is well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Rich Johnston <rjohnston@sgi.com>

---
Test will be submitted later.

Change History

Original patch  "[PATCH] xfsrestore: fix multi stream support"
- Patch rename, fixes to code and commit messages by sandeen.
- Additional changes by rjohnston
V2
- Remove changes by rjohnston.

---
  restore/content.c |    5 +++++
  1 file changed, 5 insertions(+), 0 deletions(-)

Index: b/restore/content.c
===================================================================
--- a/restore/content.c
+++ b/restore/content.c
@@ -7516,6 +7516,11 @@ restore_extent_group( drive_t *drivep,
  		 * we are done.
  		 */
  		if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
+			/* For a wholly sparse file, there is no HOLE
+			 * record; advance restoredsz to EOF.
+			 */
+			if (!restoredsz)
+				restoredsz = bstatp->bs_size;
  			break;
  		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
