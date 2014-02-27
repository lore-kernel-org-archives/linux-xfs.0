Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1D427F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:16:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1C258F804C
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:16:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RdtzoHgQ5JmbaHej for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:16:52 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1RKGoYF018377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:16:51 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1RKGnN4032443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:16:50 -0500
Message-ID: <530F9D31.5070103@redhat.com>
Date: Thu, 27 Feb 2014 14:16:49 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: add missing break in O_TMPFILE case
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

Coverity spotted this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I assume that -T isn't supposed to imply -x?)

diff --git a/io/init.c b/io/init.c
index fd1a52f..1e2690e 100644
--- a/io/init.c
+++ b/io/init.c
@@ -181,6 +181,7 @@ init(
 			break;
 		case 'T':
 			flags |= IO_TMPFILE;
+			break;
 		case 'x':
 			expert = 1;
 			break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
