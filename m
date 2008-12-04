Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4JYkYg028350 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 13:34:47 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BD441BEFB6E
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 11:34:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id rX9vcF3VyE3SWQH2 for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 11:34:44 -0800 (PST)
Date: Thu, 4 Dec 2008 09:00:13 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Device loses barrier support (was: Fixed patch for simple barriers.)
In-Reply-To: <20081204100050.GN6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>
	<20081204100050.GN6703@one.firstfloor.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Cc: Andi Kleen <andi-suse@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>

On Thu, 4 Dec 2008, Andi Kleen wrote:

> On Thu, Dec 04, 2008 at 12:09:56AM -0500, Mikulas Patocka wrote:
> > 
> > BTW. how is this patch supposed to work with pvmove? I.e. you advertise to 
> > a filesystem that you support barriers, then the user runs pvmove and you 
> > drop barrier support while the filesystem is mounted - that will confuse 
> > the filesystem and maybe produce a data corruption. I wouldn't recommend 
> 
> File systems handle this generally. Also the pvmove itself will
> act as a barrier.
> 
> -Andi

How do you want to handle this?

Imagine:
the filesystem submits a 1st write request
the filesystem submits a 2nd write barrier request
the filesystem submits a 3rd write request

... time passes ...

the 1st write request ends with success
the 2nd write request ends with -EOPNOTSUPP
the 3rd write request ends with success

--- when you first see -EOPNOTSUPP, you have already corrupted filesystem 
(the 3rd write passed while the filesystem expected that it would be 
finished after the 2nd write) and you are in an interrupt context, where 
you can't reissue -EOPNOTSUPP request. So what do you want to do?


Possible ways how to solve it:

1) Wait synchronously for barriers, don't issue any other writes while 
barrier is pending.

- this basically supresses any performance advantage barriers could have. 
Ext3 is doing this.

- this solion is right. But if this is "the way it should be done", you 
could rip barriers from the kernel completely and replace them with a 
simple call to flush hardware cache. In this use scenario, they have no 
advantage over a simple call to flush cache.

2) Resubmit the failed -EOPNOTSUPP request from a thread.

- this is what XFS is doing. Bad for code complexity (there must be a 
special thread just to catch failed IOs). Also, it still produces 
corrupted filesystem for a brief period of time.

3) Fail barriers only synchronously? (so that the caller can detect 
missing barrier support before issuing other writes)

- unimplemntable in device mapper, if the device is suspended, it queues 
bios.

4) Disallow losing barrier support?

- for me it looks like a sensible solution.

Mikulas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
