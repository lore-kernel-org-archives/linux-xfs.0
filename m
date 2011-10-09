Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NC0NC130659 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:12:00 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B4FBB1C79D31
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:11:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	x1KvXB5ek3uV5ChV for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:11:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD2XB-0003au-US
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD2XB-0002vV-Fz
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5, v2] repair: sector size and blkmap fixes
Date: Mon, 10 Oct 2011 10:11:45 +1100
Message-Id: <1318201910-11144-1-git-send-email-david@fromorbit.com>
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

Hi Alex,

Here's the fixes I posted a few days ago with all the review
comments fixed up.

Version 2:
- fixed typos in sector size comments
- fixed setting default sector size so that the ioctl doesn't wipe
  it out
- separate out prefetch valgrind error fix.
- separate out large blkmap allocation caching fix
- separate out handling of blkmap memory allocation failure during a
  grow to avoid a buffer overrun situation when moving extents
  around in the array
- avoid modifying blkmap->naexts when allocation fails.
- separate extent count overflow checking in blkmap allocation and
  growing
- use #if BITS_PER_LONG == 32
- Introduce BLKMAP_NEXTS_MAX and use it unconditionally rather than
  open code it and only include the check on 32 bit builds
- add checking for negative extent counts to avoid grow overflows
  past INT_MAX going undetected.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
