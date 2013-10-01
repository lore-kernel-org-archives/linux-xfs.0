Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 500EA7F72
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 11:30:57 -0500 (CDT)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C625BAC013
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 09:30:53 -0700 (PDT)
Message-ID: <524AF8C3.8020904@sgi.com>
Date: Tue, 1 Oct 2013 11:30:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfsdump: add locks around the inventory put
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

From: Phil White <cerise-xfs@l.armory.com>

Add locks around the inventory put to prevent inventory
corruption.

Signed-off-by: Phil White <cerise-xfs@l.armory.com>

diff --git a/dump/content.c b/dump/content.c
index ac19021..b8977bb 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -2550,8 +2550,11 @@ decision_more:
  				       scwhdrp->cih_startpt.sp_offset );
  			}

-			/* already thread-safe, don't need to lock
+			/* Supposedly already thread-safe, according to the
+			 * previous revisions, but corruption of inventory
+			 * objects can occur.
  			 */
  			 */
+			lock();
  			ok = inv_put_mediafile( inv_stmt,
  						&mwhdrp->mh_mediaid,
  						mwhdrp->mh_medialabel,
@@ -2565,6 +2568,7 @@ decision_more:
  						&&
  						! empty_mediafile,
  						BOOL_FALSE );
+			unlock();
  			if ( ! ok ) {
  				mlog( MLOG_NORMAL, _(
  				      "inventory media file put failed\n") );

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
