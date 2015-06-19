Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 094397F4E
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 11:41:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBBD4304032
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2015 09:41:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id P0GtXttyUSuvqa4k for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2015 09:41:02 -0700 (PDT)
Message-ID: <5584461D.3000008@sandeen.net>
Date: Fri, 19 Jun 2015 11:41:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_repair: automatically enable -f (file) mode when needed
References: <5583383D.4070906@redhat.com>
In-Reply-To: <5583383D.4070906@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

If we specify "-f" to xfs_repair, it recognizes that it's working
on a file, and if the underlying filesystem sector size differs
such that direct IO won't work, it disables direct IO.

It's odd, though, that we'd need to specify this, and the failure
is non-obvious:

# xfs_repair /mnt/test/foo.img
Phase 1 - find and verify superblock...
xfs_repair: read failed: Invalid argument

I see no advantage to requiring the administrator to jump through
this hoop; why not just detect that it's a file, and move on?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: don't check statbuf if stat fails, thanks Brian :)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 834697a..2d376be 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -573,6 +573,18 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
+	/* -f forces this, but let's be nice and autodetect it, as well. */
+	if (!isa_file) {
+		int		fd = libxfs_device_to_fd(x.ddev);
+		struct stat64	statbuf;
+
+		if (fstat64(fd, &statbuf) < 0)
+			do_warn(_("%s: couldn't stat \"%s\"\n"),
+				progname, fs_name);
+		else if (S_ISREG(statbuf.st_mode))
+			isa_file = 1;
+	}
+
 	/*
 	 * if the sector size of the filesystem we are trying to repair is
 	 * smaller than that of the underlying filesystem (i.e. we are repairing


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
