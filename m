Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D7387F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 18:16:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0114C304032
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 16:16:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fxqobfq6U3cxAHOT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 16:16:50 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4DNGnqf010365
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 13 May 2015 19:16:49 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4DNGmrp011283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 19:16:49 -0400
Message-ID: <5553DB60.6060907@redhat.com>
Date: Wed, 13 May 2015 18:16:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't cast string literals
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

The commit:

a9273ca5 xfs: convert attr to use unsigned names

added these (unsigned char *) casts, but then the _SIZE macros
return "7" - size of a pointer minus one - not the length of
the string.  This is harmless in the kernel, because the _SIZE
macros are not used, but as we sync up with userspace, this will
matter.

I don't think the cast is necessary; i.e. assigning the string
literal to an unsigned char *, or passing it to a function
expecting an unsigned char *, should be ok, right?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I can send the xfsprogs version if you like, if this passes
muster ;)

(the other option is to cast it back to a (char *) in the sizeof
but then things are just getting weird IMHO...)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4daaa66..ff22a4d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1453,8 +1453,8 @@ struct xfs_acl {
 		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
 
 /* On-disk XFS extended attribute names */
-#define SGI_ACL_FILE		(unsigned char *)"SGI_ACL_FILE"
-#define SGI_ACL_DEFAULT		(unsigned char *)"SGI_ACL_DEFAULT"
+#define SGI_ACL_FILE		"SGI_ACL_FILE"
+#define SGI_ACL_DEFAULT		"SGI_ACL_DEFAULT"
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
