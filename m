Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BFD07F61
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 11:14:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07241AC00B
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:14:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CdVSXSZyckpehcXJ for
	<xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:14:48 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rACHElDF007750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:14:47 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rACHEkn9004413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 12:14:46 -0500
Message-ID: <52826206.3080106@redhat.com>
Date: Tue, 12 Nov 2013 11:14:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: suggest reboot after dangerous repair
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

If a "dangerous" repair (repair of a readonly mounted fs)
has been done, suggest an immediate reboot upon completion.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

TBH, I don't know how "dangerous" dangerous is.  Is this
still required?

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 820e7a2..9e1a774 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -884,6 +884,11 @@ _("Note - stripe unit (%d) and width (%d) fields have been reset.\n"
 	if (verbose)
 		summary_report();
 	do_log(_("done\n"));
+
+	if (dangerously && !no_modify)
+		do_warn(
+_("Repair of readonly mount complete.  Immediate reboot encouraged.\n"));
+
 	pftrace_done();
 
 	return (0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
