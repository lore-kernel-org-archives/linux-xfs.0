Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88FCcZ4042758 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 10:12:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 207C51E60C98
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 08:13:22 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	jwd8MiDDYDq8ybYy for <xfs@oss.sgi.com>;
	Wed, 08 Sep 2010 08:13:22 -0700 (PDT)
Received: from dastard (unverified [121.44.127.68])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	38590441-1927428
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 00:43:20 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OtMKj-0003z9-Ir
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:09 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OtMKc-0007TM-8a
	for xfs@oss.sgi.com; Thu, 09 Sep 2010 01:13:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC] [PATCH 0/4] Replace buffer cache hash with rbtrees
Date: Thu,  9 Sep 2010 01:12:54 +1000
Message-Id: <1283958778-28610-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch series cleans up several unconventional buffer uses to
avoid using cached buffers, and then converts the buffer cache
indexing to use a set of per-ag rbtrees rather than a hash. This
version show no performance degradation on my 1.1TB filesystem under
parallel create and unlink compared to the existing enlarged hash
cache. In both cases _xfs_buf_find() is consuming 5-6% of the entire
CPU time of the workload.

This patchset is needed to prepare for moving away from using the
page cache as the backing cache and instead maintaining a LRU of
cached buffers. This is necessary because on larger filesystems
we are completely unable to maintain the working set of metadata
buffers hot in cache as we cannot control page cache reclaim. It
means that we need to be able to hold a lot more buffers in memory
than we currently do and as such the hash based indexing needs
replacing first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
