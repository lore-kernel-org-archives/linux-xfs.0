Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5294B7CA0
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 20:00:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25DF8304059
	for <xfs@oss.sgi.com>; Fri, 16 Sep 2016 18:00:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h5vEd1K21pCUxaOW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Sep 2016 18:00:43 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_io: allow chattr & chproj on foreign filesystems
Message-ID: <e1471cdf-9f83-91d1-9e93-f3877baeccb5@redhat.com>
Date: Fri, 16 Sep 2016 20:00:39 -0500
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

Now that FS_IOC_FSSETXATTR is a generic vfs call, these
functions can be used on non-xfs filesystems, and this is
needed for generic project quota testing.

(not all flags are valid on all filesystems.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/attr.c b/io/attr.c
index 0186b1d..d1962f3 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -340,7 +340,7 @@ attr_init(void)
 	chattr_cmd.args = _("[-R|-D] [+/-"CHATTR_XFLAG_LIST"]");
 	chattr_cmd.argmin = 1;
 	chattr_cmd.argmax = -1;
-	chattr_cmd.flags = CMD_NOMAP_OK;
+	chattr_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	chattr_cmd.oneline =
 		_("change extended inode flags on the currently open file");
 	chattr_cmd.help = chattr_help;
diff --git a/io/open.c b/io/open.c
index a5d465a..3eaa013 100644
--- a/io/open.c
+++ b/io/open.c
@@ -929,7 +929,7 @@ open_init(void)
 	chproj_cmd.args = _("[-D | -R] projid");
 	chproj_cmd.argmin = 1;
 	chproj_cmd.argmax = -1;
-	chproj_cmd.flags = CMD_NOMAP_OK;
+	chproj_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	chproj_cmd.oneline =
 		_("change project identifier on the currently open file");
 	chproj_cmd.help = chproj_help;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
