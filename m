Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8F7DA7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25D95AC001
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:57:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3zbyBHUpQhxUl0Mx for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:57:39 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9IHvcVi018612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:57:38 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9IHvbit024943
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:57:38 -0400
Message-ID: <52617691.8090101@redhat.com>
Date: Fri, 18 Oct 2013 12:57:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: Note projid32bit default change in mkfs.xfs manpage
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

As of xfsprogs 3.2.0, the projid32bit default changed from 0
to 1.  Document this.

When we document -m crc etc, we'll also need to note that 0 is
incompatible with crc=1.

Signed-off-by: Eric Sandeen <sandeen@redaht.com>
---

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 61122f0..99f7013 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -362,7 +362,8 @@ than version 2.6.16.
 This is used to enable 32bit quota project identifiers. The
 .I value
 is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
-If the value is omitted, 0 is assumed.
+If the value is omitted, 1 is assumed.  (This default changed
+in release version 3.2.0.)
 .RE
 .TP
 .BI \-l " log_section_options"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
