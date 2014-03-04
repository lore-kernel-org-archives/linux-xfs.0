Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F40AC7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 23:25:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D3EEF304043
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 21:25:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qnzHyzfFAqKhHmiH for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 21:25:47 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s245Pjx7022305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2014 00:25:46 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s245Piri016857
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2014 00:25:45 -0500
Message-ID: <531563D8.2070007@redhat.com>
Date: Mon, 03 Mar 2014 23:25:44 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: memset proper length in resvtest.c
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

sizeof(pointer) is not very relevant; sizeof(*pointer)
is a bit more so.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/resvtest.c b/src/resvtest.c
index 037d9ea..a07f503 100644
--- a/src/resvtest.c
+++ b/src/resvtest.c
@@ -73,7 +73,7 @@ main(int argc, char **argv)
 		perror("open");
 		exit(1);
 	}
-	memset(writebuffer, 'A', sizeof(writebuffer));
+	memset(writebuffer, 'A', sizeof(*writebuffer));
 
 	unlink(filename);
 	writefd = open(filename, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
