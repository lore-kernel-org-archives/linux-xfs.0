Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN2CQPW012303
	for <linux-xfs@oss.sgi.com>; Thu, 22 Nov 2012 20:12:27 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id iknAcoGCmT4vdg09 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 22 Nov 2012 18:14:37 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Tbin0-0004HK-4o
	for linux-xfs@oss.sgi.com; Fri, 23 Nov 2012 03:14:46 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 03:14:46 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 23 Nov 2012 03:14:46 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: high load and xfsaild in d
Date: Thu, 22 Nov 2012 18:13:48 -0800
Message-ID: <sn23o9xkh3.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hello all,

I recently deployed a new CentOS 6.3 file server, and soon after I
noticed that the load was consistenly at around 4, even with no obvious
activity.  After checking around a bit, the only unusual thing I could
find is that the xfsaild threads are all consistently in D state:

root      1744  0.0  0.0      0     0 ?        D    Nov16   7:46 [xfsaild/dm-2]
root      1756  0.0  0.0      0     0 ?        D    Nov16   7:44 [xfsaild/dm-1]
root      1759  0.0  0.0      0     0 ?        D    Nov16   7:57 [xfsaild/dm-3]
root      1762  0.0  0.0      0     0 ?        D    Nov16   5:59 [xfsaild/dm-0]

On another CentOS 6.2 box, I don't see this symptom; the xfsaild threads
are all in S state.  I checked around for many other things that I'd
normally expect to be pegging the load, but didn't find anything out of
the ordinary.  (See
https://groups.google.com/group/comp.os.linux.misc/browse_thread/thread/c9b2a1d60eb25fac
for more details.)

The new box is an up to date CentOS 6.3 box with the stock kernel:

Linux xxxxxxxx 2.6.32-279.14.1.el6.x86_64 #1 SMP Tue Nov 6 23:43:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

The storage backends are a software RAID1 (three of the filesystems) and
a 3ware 9750-backed 11-disk RAID6.  I don't have any unusual mount
options, and the filesystems were created with mkfs.xfs with no options.

I searched the web and the list archives, and did find some issues with
xfsaild, but they all either seemed out of date (one thread mentioned
that an issue would be fixed in 2.6.30) or with more complicated
symptoms (other processes hanging in D state).  But this server seems
perfectly fine from what I can tell; I've noticed no performance issues
either in informal observations or with actual measured read/write
speeds, and the smbd and nfsd processes are all generally in S, so they
are not waiting on IO.

The big question is, is this actually a problem, or is it nothing to
worry about?  If it's a problem, is it in XFS, or if not, what other
steps can I take to try to determine the root cause?

Thanks,

--keith

-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
