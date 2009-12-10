Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBAM1K26119155 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 16:01:20 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01457194BA6A
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:01:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AW6dELUAbrau9DXa for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 14:01:54 -0800 (PST)
Received: from int-mx05.intmail.prod.int.phx2.redhat.com
	(int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBAM1rvc023298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:01:53 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBAM1paj028616
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:01:53 -0500
Message-ID: <4B216FCF.5010108@sandeen.net>
Date: Thu, 10 Dec 2009 16:01:51 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: update bmap help text
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Trivial addition of missing argument help text.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/io/bmap.c b/io/bmap.c
index f79cf8c..5c4cf48 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -43,6 +43,9 @@ bmap_help(void)
 " -a -- prints the attribute fork map instead of the data fork.\n"
 " -d -- suppresses a DMAPI read event, offline portions shown as holes.\n"
 " -l -- also displays the length of each extent in 512-byte blocks.\n"
+" -n -- query n extents.\n"
+" -p -- obtain all unwritten extents as well (w/ -v show which are unwritten.\n"
+" -v -- Verbose information, specify ag info.  Show flags legend on 2nd -v\n"
 " Note: the bmap for non-regular files can be obtained provided the file\n"
 " was opened appropriately (in particular, must be opened read-only).\n"
 "\n"));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
