Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n75N7HRt013199
	for <linux-xfs@oss.sgi.com>; Wed, 5 Aug 2009 18:07:18 -0500
Received: from ciao.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A39F33AAE1A
	for <linux-xfs@oss.sgi.com>; Wed,  5 Aug 2009 16:08:07 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2]) by cuda.sgi.com
	with ESMTP id Zk4laLYo7e5Yyta7 for <linux-xfs@oss.sgi.com>;
	Wed, 05 Aug 2009 16:08:07 -0700 (PDT)
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MYpaT-00085P-Lp
	for linux-xfs@oss.sgi.com; Wed, 05 Aug 2009 23:08:01 +0000
Received: from adsl-71-147-53-109.dsl.emhril.sbcglobal.net ([71.147.53.109])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 05 Aug 2009 23:08:01 +0000
Received: from kononov by adsl-71-147-53-109.dsl.emhril.sbcglobal.net with
	local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 05 Aug 2009 23:08:01 +0000
From: Roman Kononov <kononov@ftml.net>
Subject: Re: failed assertion related to realtime section
Date: Wed, 05 Aug 2009 18:07:50 -0500
Message-ID: <4A7A10C6.8030504@ftml.net>
References: <h3gd94$clb$1@ger.gmane.org> <4A790380.7060805@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4A790380.7060805@sandeen.net>
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
To: linux-xfs@oss.sgi.com

Eric Sandeen wrote:
> While realtime should probably work and not oops (!) I'm curious what
> your use-case for realtime is?

In my setup I need mostly sequential read/write access to a number of 
huge files (>1GB) as well as small ones. My 16-disk system, providing 
1GB/s of sequential access data rate, chokes when file fragments are 
smaller than ~32MB. Using 32MB extents of the regular data section 
helps, but fragmentation still develops. I hope (maybe I am wrong) that 
the realtime section with its fixed extents eliminates the fragmentation 
issue.

Roman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
