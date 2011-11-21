Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALKk7RW020303 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 14:46:07 -0600
Received: from nm24.bullet.mail.bf1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id A1CA82686A4
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 12:46:06 -0800 (PST)
Received: from nm24.bullet.mail.bf1.yahoo.com (nm24.bullet.mail.bf1.yahoo.com
	[98.139.212.183]) by cuda.sgi.com with SMTP id g1oTdEbvdmC3xUMf
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 12:46:06 -0800 (PST)
Mime-Version: 1.0 (Apple Message framework v1244.3)
Subject: Re: inode64 readiness testing
From: Peter Kimball <peterakimball@yahoo.com>
In-Reply-To: <20111120191050.GB11957@infradead.org>
Date: Mon, 21 Nov 2011 15:46:04 -0500
Message-Id: <C5842F44-178B-403C-9C07-BA475B16DE75@yahoo.com>
References: <501A7AEB-6708-4181-AAE2-D145DC23B938@yahoo.com>
	<20111120191050.GB11957@infradead.org>
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


On Nov 20, 2011, at 2:10 PM, Christoph Hellwig wrote:

> On Fri, Nov 18, 2011 at 12:33:16PM -0500, Peter Kimball wrote:
>> I created a blank 1GB disk image, created an XFS filesystem on that image, and mounted it on a loopback device using the ino64 flag.  
>> 
>> I wrote a bunch of data to the filesystem (lots of small files), approximately 600MB.
>> 
>> At this point, I think I have a filesystem in which inodes use 64-bit addresses, even if the actual address value would fit in 32 bits.  I would expect any program that can't handle 64-bit addresses to barf when trying to access any data on the filesystem.
> 
> You will never not see 64-bit inodes on a filesystem that small ever.
> Try to create a (sparse) 10TB loop image, and create some deep
> directories in it.  This should create some larger inodes number for
> you if you had it mounted with the inode64 flag.  You can verify that
> by checking that the inode number returned from the stat systsem call
> or from ls -i is larger than 32 bits.
> 

Thank you for that guide, Christoph.  I followed your directions and the directory tree I created included some >32-bit inode numbers so I was able to successfully test all of our NFS clients.

>From what I'd read, I thought that the ino64 mount option would do the work for me (bring 32-bit inode numbers into 64-bit range), apparently that is not the case.  This method worked great, hopefully the next person to search can find this happy thread.

Many thanks,
Peter
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
