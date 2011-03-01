Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21MoVrt222970 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 16:50:31 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103012253.p21MrHwt014849@stout.americas.sgi.com>
Date: Tue, 01 Mar 2011 16:53:17 -0600
Subject: [PATCH] xfstests: drop "Mount point match" from 028 and 047
	golden output
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Bill's latest update to xfsdump dropped a line of output that served
no real purpose.  This change updates the golden output for the two
tests that included that line of output.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 028.out |    1 -
 047.out |    1 -
 2 files changed, 2 deletions(-)

Index: b/028.out
===================================================================
--- a/028.out
+++ b/028.out
@@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/U
        /var/xfsdump/inventory/UUID.InvIndex
          Checking access for
           /var/xfsdump/inventory/UUID.StObj
-          Mount point match
             Session 0: HOSTNAME:SCRATCH_MNT
 -------------------------------------------------
 Pruning this matching entry:
Index: b/047.out
===================================================================
--- a/047.out
+++ b/047.out
@@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/U
        /var/xfsdump/inventory/UUID.InvIndex
          Checking access for
           /var/xfsdump/inventory/UUID.StObj
-          Mount point match
             Session 0: HOSTNAME:SCRATCH_MNT
 -------------------------------------------------
 An entry matching the mount point/time is :

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
