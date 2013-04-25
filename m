Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F4BE29DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4C268F8033
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 09:13:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yIfcnPv7du2VpWEK for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 09:13:06 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7D16463C59BC
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 11:13:06 -0500 (CDT)
Message-ID: <51795612.3080806@sandeen.net>
Date: Thu, 25 Apr 2013 11:13:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: xfs: fallback to vmalloc for large buffers in
	xfs_compat_attrlist_by_handle
References: <515CB2C1.1050109@tlinx.org> <20130404035237.GA12011@dastard>
	<515D0A09.5030808@sandeen.net>
In-Reply-To: <515D0A09.5030808@sandeen.net>
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

Shamelessly copied from dchinner's:
ad650f5b xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
    
xfsdump uses a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Add a fallback to vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

This was done for xfs_attrlist_by_handle but
xfs_compat_attrlist_by_handle (the 32-bit version) needs the same
attention.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 63b8fc4..c0c6625 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -373,9 +373,12 @@ xfs_compat_attrlist_by_handle(
 		return PTR_ERR(dentry);
 
 	error = -ENOMEM;
-	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
-	if (!kbuf)
-		goto out_dput;
+	kbuf = kmem_zalloc(al_hreq.buflen, KM_SLEEP | KM_MAYFAIL);
+	if (!kbuf) {
+		kbuf = kmem_zalloc_large(al_hreq.buflen);
+		if (!kbuf)
+			goto out_dput;
+	}
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
@@ -387,7 +390,10 @@ xfs_compat_attrlist_by_handle(
 		error = -EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	if (is_vmalloc_addr(kbuf))
+		kmem_free_large(kbuf);
+	else
+		kmem_free(kbuf);
  out_dput:
 	dput(dentry);
 	return error;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
