Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD29D7F50
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 22:30:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6863FAC002
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 20:30:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8gXwCmzhW5eHVb5H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 20:30:37 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 53277B66AB
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 03:30:37 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t743Uato012493
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 3 Aug 2015 23:30:37 -0400
Message-ID: <55C031DC.6050404@redhat.com>
Date: Mon, 03 Aug 2015 20:30:36 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_fsr: Fix parentheses around truth value
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

Someone in the distant past must have responded to gcc's
warning about parentheses around assignment used as a truth
value by changing:

	while (ret = func() == 0)
to:
	while ((ret = func() == 0))

While this shuts up gcc, it doesn't yield the proper result.
If func () returns 0, func == 0 is true, and ret is assigned
a value of 1.

This does keep the while loop going, but it's a very strange
way to go about it, and may someday yield confusing results.

Fix this as:

	while ((ret = func()) == 0)

so that ret gets the function return value as expected.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b46ad1f..b384565 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -716,7 +716,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 	tmp_init(mntdir);
 
 	while ((ret = xfs_bulkstat(fsfd,
-				&lastino, GRABSZ, &buf[0], &buflenout) == 0)) {
+				&lastino, GRABSZ, &buf[0], &buflenout)) == 0) {
 		xfs_bstat_t *p;
 		xfs_bstat_t *endp;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
