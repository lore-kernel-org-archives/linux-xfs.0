Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 286587F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 12:36:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1BCA58F8050
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 10:35:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DDODYvH1pm1gOsD0 for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 10:35:58 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s15IZvpH004374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 5 Feb 2014 13:35:57 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s15IZupJ016253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 5 Feb 2014 13:35:56 -0500
Message-ID: <52F2848B.5070704@redhat.com>
Date: Wed, 05 Feb 2014 12:35:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: initialize "valid" bitmap in randholes.c
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

Failures were reported in xfs/008 on s390; dchinner suggested that
perhaps the uninitialized "valid" bitmap was behaving differently on
that platform, and sure enough, this patch fixes things up.

TBH, I'm not sure why using an uninitialized bitmap worked at
all, ever, anywhere...?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/randholes.c b/src/randholes.c
index 5ad602e..ee5b6b6 100644
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -437,6 +437,7 @@ main(int argc, char *argv[])
 		perror("malloc");
 		return 1;
 	}
+	memset(valid, 0, size);
 
 	/* Lots of arguments affect how we open the file */
 	oflags = test ? O_RDONLY : O_RDWR|O_CREAT;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
