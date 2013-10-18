Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C964E7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95305304066
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:59:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0R4wGl0ToItzEQfR for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:59:37 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9IHxb1x015813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:59:37 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r9IHxaDU021298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:59:36 -0400
Message-ID: <52617708.9000206@redhat.com>
Date: Fri, 18 Oct 2013 12:59:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: add d_type when moving files to lost+found
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

When we move disconnected inodes to lost+found, they aren't
assigned a dtype.  Fix this by just setting XFS_DIR3_FT_UNKNOWN
for now.  If the files are moved out of lost+found, the type
will be properly set at that time.

When repair gains more type knowledge we could use xfs_mode_to_ftype[]
to set the proper type when moved, but right now it's not a big
deal; UNKNOWN will suffice for files in lost+found, and prevents
us from using an uninitialized value.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/phase6.c b/repair/phase6.c
index f84bdc0..41f6bfc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1041,6 +1041,8 @@ mv_orphanage(
 	xname.name = fname;
 	xname.len = snprintf((char *)fname, sizeof(fname), "%llu",
 				(unsigned long long)ino);
+	/* XXX use xfs_mode_to_ftype[] when userspace gains it */
+	xname.type = XFS_DIR3_FT_UNKNOWN;
 
 	err = libxfs_iget(mp, NULL, orphanage_ino, 0, &orphanage_ip, 0);
 	if (err)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
