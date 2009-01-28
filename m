Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SBS4Ba121535 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 05:28:05 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3C2C1879C26
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 03:27:21 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id Yh7x9HD8y9qt6CNV for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 03:27:21 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id 8A7D043750
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 22:27:11 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id sioRDUQw9oCbsJse for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 22:27:11 +1100 (EST)
Received: from [192.168.0.100] (c220-239-214-222.fernt2.vic.optusnet.com.au
	[220.239.214.222])
	by postoffice.aconex.com (Postfix) with ESMTP id 6AC4392C34E
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 22:27:11 +1100 (EST)
Subject: [PATCH] remove remaining unused-but-installed headers
From: Nathan Scott <nscott@aconex.com>
Content-Type: multipart/mixed; boundary="=-qB9B6w3hUWsxtKqMYSOZ"
Date: Wed, 28 Jan 2009 22:24:03 +1100
Message-Id: <1233141843.4584.40.camel@verge.scott.net.au>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--=-qB9B6w3hUWsxtKqMYSOZ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Looks like Barry missed a few headers... or at least, I can't
find anything outside xfsprogs that uses these anymore.  But,
no sane reason we should be installing these in /usr/include/
disk on everyone's systems - build can get 'em out of its own
include/ directory already.

cheers.

--
Nathan

--=-qB9B6w3hUWsxtKqMYSOZ
Content-Disposition: attachment; filename=disk.patch
Content-Type: text/x-patch; name=disk.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/include/Makefile b/include/Makefile
index 0403536..07076cc 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -29,9 +29,9 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_imap.h xfs_inode.h xfs_inode_item.h xfs_inum.h \
 	xfs_log.h xfs_log_priv.h xfs_log_recover.h xfs_metadump.h \
 	xfs_mount.h xfs_quota.h xfs_rtalloc.h xfs_sb.h \
-	xfs_trans.h xfs_trans_space.h xfs_types.h
+	xfs_trans.h xfs_trans_space.h xfs_types.h xfs_dfrag.h
 
-HFILES = handle.h jdm.h xqm.h xfs.h xfs_dfrag.h xfs_fs.h
+HFILES = handle.h jdm.h xqm.h xfs.h xfs_fs.h
 HFILES += $(PKG_PLATFORM).h
 PHFILES = darwin.h freebsd.h irix.h linux.h
 DKHFILES = volume.h fstyp.h dvh.h
@@ -51,8 +51,6 @@ install-dev: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
 	$(INSTALL) -m 644 platform_defs.h $(PKG_INC_DIR)
-	$(INSTALL) -m 755 -d $(DK_INC_DIR)
-	$(INSTALL) -m 644 $(DKHFILES) $(DK_INC_DIR)
 
 install-qa: install-dev
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)

--=-qB9B6w3hUWsxtKqMYSOZ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-qB9B6w3hUWsxtKqMYSOZ--
