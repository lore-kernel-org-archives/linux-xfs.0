Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1RBRrnQ002980 for <xfs@oss.sgi.com>; Sat, 27 Feb 2010 05:27:54 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E4851D02AB8
	for <xfs@oss.sgi.com>; Sat, 27 Feb 2010 03:29:17 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id zJ233LlCU2NTDhvT for
	<xfs@oss.sgi.com>; Sat, 27 Feb 2010 03:29:17 -0800 (PST)
Date: Sat, 27 Feb 2010 06:29:17 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Small change for mkfs.xfs?
Message-ID: <alpine.DEB.2.00.1002270628120.17433@p34.internal.lan>
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

# mkfs.xfs /dev/md0
mkfs.xfs: /dev/md0 appears to contain an existing filesystem (ext3).
mkfs.xfs: Use the -f option to force overwrite.

This occurs if the filesystem is ext4.  Need to differentiate between the 
two FS if possible?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
