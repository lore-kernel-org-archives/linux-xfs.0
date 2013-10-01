Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F27067F6A
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 11:30:35 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D10BB8F804C
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 09:30:32 -0700 (PDT)
Message-ID: <524AF8AE.5030300@sgi.com>
Date: Tue, 1 Oct 2013 11:30:38 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfsrestore: fix multi stream support
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

If no extents exist, there is no need to call partial_reg() because
there is no data to split up. Also remove the uneeded check in 
partial_reg() to detect if this is a multistream restore.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

diff --git a/restore/content.c b/restore/content.c
index 54d933c..ecbcf13 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7494,6 +7494,7 @@ restore_extent_group( drive_t *drivep,
  	extenthdr_t ehdr;
  	off64_t bytesread;
  	rv_t rv;
+	uint num_extents = 0; /* number of extents */

  	/* copy data extents from media to the file
  	 */
@@ -7518,6 +7519,7 @@ restore_extent_group( drive_t *drivep,
  		if ( ehdr.eh_type == EXTENTHDR_TYPE_LAST ) {
  			break;
  		}
+		num_extents++;

  		/* if its an ALIGNment extent, discard the extent.
  		 */
@@ -7572,7 +7574,7 @@ restore_extent_group( drive_t *drivep,
  	 * and certain extended inode flags. Register the portion
  	 * of the file completed here in the persistent state.
  	 */
-	if (bstatp->bs_size > restoredsz) {
+	if (num_extents && (bstatp->bs_size > restoredsz)) {
  		partial_reg(drivep->d_index,
  			    bstatp->bs_ino,
  			    bstatp->bs_size,
@@ -8959,9 +8961,6 @@ partial_reg( ix_t d_index,

  	endoffset = offset + sz;

-	if ( partialmax == 0 )
-		return;
-
  	pi_lock();

  	/* Search for a matching inode.  Gaps can exist so we must search

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
