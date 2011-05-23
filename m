Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NKZCul022402 for <xfs@oss.sgi.com>; Mon, 23 May 2011 15:35:13 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 929F0162A3C1
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 13:35:12 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id lVA53gNrUeqXuSQr for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 13:35:12 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4NKNfRW019749
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:23:41 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4NKZ6qf190618 for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:35:06 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4NKZ6N4001499
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:35:06 -0600
Message-ID: <4DDAC4EF.1050702@linux.vnet.ibm.com>
Date: Mon, 23 May 2011 13:34:55 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: xfsprogs: Fix for xfstest 252 hang on ext4
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
To: xfs-oss <xfs@oss.sgi.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>

Hi all,

While trying to add more punch hole tests to xfstest, I found that test 252 hangs on ext4 due to a loop in xfsprogs that does not exit.  XFS gets out of this loop because there is logic in the loop that looks for the last extent flag and breaks out.  But it looks like ext4 does not return a last extent when the file has a hole at the end.  I am not sure if this is the correct behavior or not, so I will copy the ext4 folks on this too.  Below is a copy of the fix for xfsprogs:

diff --git a/io/fiemap.c b/io/fiemap.c
index fa990cc..81fc92c 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -246,7 +246,7 @@ fiemap_f(
 		       flg_w, _("FLAGS"));
 	}
 
-	while (!last && ((cur_extent + 1) != max_extents)) {
+	while (!last && (cur_extent <= max_extents)) {
 		if (max_extents)
 			num_extents = min(num_extents,
 					  max_extents - (cur_extent + 1));


It looks like the loop enters with last=0, cur_extents=0, and max_extents = 0, and on the first iteration cur_extents get set to 2, so we dont see ((cur_extent + 1) == max_extents for a very long time.  I doubt the logic was meant to work that way, so this patch should fix it, but I wanted to make sure that the fiemap for ext4 is working as intended too.  Feed back appreciated!  Thx all!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
