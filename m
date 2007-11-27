Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 14:05:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lARM5ZPd016305
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 14:05:37 -0800
Date: Wed, 28 Nov 2007 09:05:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS performance problems on Linux x86_64
Message-ID: <20071127220536.GL119954183@sgi.com>
References: <474C8A05.3020604@e-626.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474C8A05.3020604@e-626.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Tue, Nov 27, 2007 at 10:20:05PM +0100, Johan Andersson wrote:
> Hi!
> 
> I am using Gentoo Linux on XFS root filesystem on a number of machines, 
> where some are P4 based i686, and some new are Intel Core 2 Duo based 
> x86_64 based.
> When the new x86_64 based machines were put into service, we noticed 
> that they are extremely slow on file io. I have now created two test 
> partitions, each 5G in size, on the same disk. One is xfs and one is 
> ext3, both filesystems created with default options. My simple test is 
> to rsync our local portage tree to the 5G partition:
> =====================================================================
> tmpc-masv2 xfs # time rsync -r --delete rsync://devsrv/portage portage
> 
> real    5m55.037s
> user    0m1.291s
> sys     0m10.352s
> 
> ======================================================================
> tmpc-masv2 ext3 # time rsync -r --delete rsync://devsrv/portage portage
> 
> real    0m28.943s
> user    0m1.095s
> sys     0m5.384s
> 
> I have repeated this a number of times to make sure caching on the 
> server does not interfere, with about the same results every time.
> 
> Any idea why XFS appears to be 12 times slower than ext3 on the 64-bit 
> machine?

# mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4 <dev>
# mount -o logbsize=256k <dev> <mtpt>

And if you don't care about filsystem corruption on power loss:

# mount -o logbsize=256k,nobarrier <dev> <mtpt>

Those mkfs values (except for log size) will be hte defaults in the next
release of xfsprogs.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
