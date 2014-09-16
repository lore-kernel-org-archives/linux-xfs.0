Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC1FB7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 16:30:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F1CAAC008
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 14:30:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dEdX1kMTaKJ6vBoz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 14:30:43 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8GLUgAc013982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:30:42 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8GLUfi1004047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:30:41 -0400
Message-ID: <5418AC01.30006@redhat.com>
Date: Tue, 16 Sep 2014 16:30:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: validate & fix inode CRCs
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

xfs_repair doesn't ever check an inode's CRC, so it never repairs
them.  If the root inode or realtime inodes have bad crcs, the
fs won't even mount and can't be fixed (without using xfs_db).

It's fairly straightforward to just test the inode CRC before
we do any other checking or modification of the inode, once we
get past the "verify only" phase of process_dinode_int();
just mark it dirty if it's wrong and needs to be re-written.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

forgive the gratuitous big honkin' comment line, but
process_dinode_int is so long, I thought the visual delimiter was
useful.  ;)

diff --git a/repair/dinode.c b/repair/dinode.c
index 8891e84..27c0da6 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2524,6 +2524,30 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	if (verify_mode)
 		return retval;
 
+	/* =========== END OF VERIFY MODE =================== */
+
+	/*
+	 * We'd really like to know if the CRC is bad before we
+	 * go fixing anything; that way we have some hint about
+	 * bit-rot vs bugs.  Also, any changes will invalidate the
+	 * existing CRC, so this is the only valid point to test it.
+	 *
+	 * Of course if we make any modifications after this, the
+	 * inode gets rewritten, and CRC is updated automagically.
+	 */
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		ASSERT(!verify_mode);
+		if(!xfs_verify_cksum((char *)dino, mp->m_sb.sb_inodesize,
+                		XFS_DINODE_CRC_OFF)) {
+			do_warn(_("bad CRC for inode %" PRIu64), lino);
+			if (!no_modify) {
+				do_warn(_(", will rewrite\n"));
+				*dirty = 1;
+			} else
+				do_warn(_(", would rewrite\n"));
+		}
+	}
+
 	/*
 	 * clear the next unlinked field if necessary on a good
 	 * inode only during phase 4 -- when checking for inodes


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
