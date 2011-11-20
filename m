Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKJAqnu173985 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 13:10:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A1C916291F9
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 11:10:50 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	N0kesKfWZFvghhvS for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 11:10:50 -0800 (PST)
Date: Sun, 20 Nov 2011 14:10:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inode64 readiness testing
Message-ID: <20111120191050.GB11957@infradead.org>
References: <501A7AEB-6708-4181-AAE2-D145DC23B938@yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <501A7AEB-6708-4181-AAE2-D145DC23B938@yahoo.com>
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
To: Peter Kimball <peterakimball@yahoo.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 18, 2011 at 12:33:16PM -0500, Peter Kimball wrote:
> I created a blank 1GB disk image, created an XFS filesystem on that image, and mounted it on a loopback device using the ino64 flag.  
> 
> I wrote a bunch of data to the filesystem (lots of small files), approximately 600MB.
> 
> At this point, I think I have a filesystem in which inodes use 64-bit addresses, even if the actual address value would fit in 32 bits.  I would expect any program that can't handle 64-bit addresses to barf when trying to access any data on the filesystem.

You will never not see 64-bit inodes on a filesystem that small ever.
Try to create a (sparse) 10TB loop image, and create some deep
directories in it.  This should create some larger inodes number for
you if you had it mounted with the inode64 flag.  You can verify that
by checking that the inode number returned from the stat systsem call
or from ls -i is larger than 32 bits.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
