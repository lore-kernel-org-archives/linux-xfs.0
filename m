Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAIHXKuU190789 for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 11:33:21 -0600
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 1678C16DB3E3
	for <xfs@oss.sgi.com>; Fri, 18 Nov 2011 09:33:19 -0800 (PST)
Received: from nm20-vm0.bullet.mail.sp2.yahoo.com
	(nm20-vm0.bullet.mail.sp2.yahoo.com [98.139.91.218]) by
	cuda.sgi.com with SMTP id ymCYjt5EisPQOPiv for
	<xfs@oss.sgi.com>; Fri, 18 Nov 2011 09:33:19 -0800 (PST)
From: Peter Kimball <peterakimball@yahoo.com>
Subject: inode64 readiness testing
Date: Fri, 18 Nov 2011 12:33:16 -0500
Message-Id: <501A7AEB-6708-4181-AAE2-D145DC23B938@yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1244.3)
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
To: xfs@oss.sgi.com

Hi folks,

We've got some large XFS volumes that should probably be using the inode64 mount option, but aren't yet.  Before I go making irrevocable changes, I wanted to run my testing procedure by you to make sure I've actually tested what I think I tested.  These volumes will be shared via NFS, which is not your problem but seems to be a troublemaker.

I created a blank 1GB disk image, created an XFS filesystem on that image, and mounted it on a loopback device using the ino64 flag.  

I wrote a bunch of data to the filesystem (lots of small files), approximately 600MB.

At this point, I think I have a filesystem in which inodes use 64-bit addresses, even if the actual address value would fit in 32 bits.  I would expect any program that can't handle 64-bit addresses to barf when trying to access any data on the filesystem.

I then unmounted the filesystem and re-mounted it using the inode64 flag, just like it would be mounted in production.

I then verified that the programs I cared about (mostly NFS clients) could read all of the data I had written.  I also made sure they could write to the filesystem.

Since I haven't seen any read/write failures at this point, I feel I'm ready to sign off that we're ready to start using the inode64 flag.  Did I properly create files using 64-bit inodes?  Did I read from the filesystem in such a way that I would know if my readers were unable to handle 64-bit inodes?  Is there anything I should test that I haven't?

Thanks for all your hard work on this most useful project!
Peter



ps: not sure it makes a difference, this is on Centos 5.3 (2.6.18-128.el5), so I'm not entirely certain which XFS bugs/features have been folded in by the maintainers...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
