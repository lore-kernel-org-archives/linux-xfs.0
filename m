Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8685A7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 13:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 152AEAC002
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 11:00:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZZyGOnjmB2AcaNBt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 11:00:07 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KI066B006440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 14:00:06 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7KI05Zj028059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 14:00:06 -0400
Message-ID: <53F4E229.3010607@redhat.com>
Date: Wed, 20 Aug 2014 13:00:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH RESEND] xfsprogs: add supported file attributes to xfs.5
	manpage
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

The chattr(1) manpage now refers users to filesystem-specific
manpages for details on supported attributes, so add those to
xfs.5.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I thought I had sent this already, but I guess not...

(and now resending to xfs@ not linux-xfs@ in hopes that this
one gets through...)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index 5e47c4c..3214455 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -1,6 +1,6 @@
 .TH xfs 5
 .SH NAME
-xfs \- layout and mount options for the XFS filesystem
+xfs \- layout, mount options, and supported file attributes for the XFS filesystem
 .SH DESCRIPTION
 An XFS filesystem can reside on a regular disk partition or on a
 logical volume.
@@ -302,7 +302,27 @@ namespace is on stable storage. This is useful in HA setups
 where failover must not result in clients seeing
 inconsistent namespace presentation during or after a
 failover event.
+.SH FILE ATTRIBUTES
+The XFS filesystem supports setting the following file
+attributes on Linux systems using the
+.BR chattr (1)
+utility:
+.sp
+.BR a " - append only"
+.sp
+.BR A " - no atime updates"
+.sp
+.BR d " - no dump"
+.sp
+.BR i " - immutable"
+.sp
+.BR S " - synchronous updates"
+.sp
+For descriptions of these attribute flags, please refer to the
+.BR chattr (1)
+man page.
 .SH SEE ALSO
+.BR chattr (1),
 .BR xfsctl (3),
 .BR mount (8),
 .BR mkfs.xfs (8),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
