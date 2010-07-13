Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6D7mTnp076881 for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 02:48:29 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDA3715BA004
	for <xfs@oss.sgi.com>; Tue, 13 Jul 2010 00:51:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Bueg7VUgHPTBmRVw for <xfs@oss.sgi.com>;
	Tue, 13 Jul 2010 00:51:23 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] Graceful failures for XFS on an unconfigured loop device
Date: Tue, 13 Jul 2010 17:50:48 +1000
Message-Id: <1279007450-10457-1-git-send-email-david@fromorbit.com>
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
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org

Run:

# mount -t xfs /dev/loop0 /mnt

on a freshly booted system and it won't like you anymore. This series fixes
the broken XFS error handling for dispatch errors on synchronous reads that
causes a hang, and then patches the panic it uncovers. With these two patches,
the mount fails gracefully.

The modification to blkdev_issue_flush is probably not the right place to check
for a valid q->make_request_fn. This just patches around the problem in the
simplest way possible. There's probably a better way to fix it - personally I'd
prefer that we don't even get to mounting a filesystem on an unconfigured loop
device...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
