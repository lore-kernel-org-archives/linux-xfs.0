Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMGS9ZX254415 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 10:28:09 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 334C51476303
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:30:06 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id HYl4fNjSZIjxNFAK for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:30:06 -0800 (PST)
Date: Wed, 22 Dec 2010 11:30:05 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

Is there anyone currently using this in production?
How much ram is needed when you fsck with a many files on such a volume?
Dave Chinner reported 5.5g or so is needed for ~43TB with no inodes.
Any recent issues/bugs one needs to be aware of?
Is inode64 recommended on a 64-bit system?
Any specific 64-bit tweaks/etc for a large 43TiB FS?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
