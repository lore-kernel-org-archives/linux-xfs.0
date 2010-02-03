Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Hn79g237935 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 11:49:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C20321C9DE79
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 09:50:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bH7lx58rpevhwmqG for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 09:50:15 -0800 (PST)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13HoEPV005226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 12:50:14 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13HoDHI026860
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 12:50:13 -0500
Message-ID: <4B69B755.2030008@sandeen.net>
Date: Wed, 03 Feb 2010 11:50:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] increase readdir buffer size
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

While doing some testing of readdir perf a while back,
I noticed that the buffer size we're using internally is
smaller than what glibc gives us by default.  Upping this
size helped a bit, and seems safe.

glibc's __alloc_dir() does:

  const size_t default_allocation = (4 * BUFSIZ < sizeof (struct dirent64)
                                     ? sizeof (struct dirent64) : 4 * BUFSIZ);
  const size_t small_allocation = (BUFSIZ < sizeof (struct dirent64)
                                   ? sizeof (struct dirent64) : BUFSIZ);
  size_t allocation = default_allocation;
#ifdef _STATBUF_ST_BLKSIZE
  if (statp != NULL && default_allocation < statp->st_blksize)
    allocation = statp->st_blksize;
#endif

and

#define _G_BUFSIZ 8192
#define _IO_BUFSIZ _G_BUFSIZ
# define BUFSIZ _IO_BUFSIZ

so the default buffer is 4 * 8192 = 32768
(except in the unlikely case of blocks > 32k....)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index e4caeb2..44bcc67 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -203,9 +203,9 @@ xfs_file_readdir(
 	 *
 	 * Try to give it an estimate that's good enough, maybe at some
 	 * point we can change the ->readdir prototype to include the
-	 * buffer size.
+	 * buffer size.  For now we use the current glibc buffer size.
 	 */
-	bufsize = (size_t)min_t(loff_t, PAGE_SIZE, ip->i_d.di_size);
+	bufsize = (size_t)min_t(loff_t, 32768, ip->i_d.di_size);
 
 	error = xfs_readdir(ip, dirent, bufsize,
 				(xfs_off_t *)&filp->f_pos, filldir);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
