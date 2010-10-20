Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KCGj3Z063777 for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 07:16:46 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18C921E7ED90
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 05:17:57 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 19AbDgG30ZzhEzxi
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 05:17:57 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8Xc8-00079k-9j
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 13:17:52 +0100
MIME-Version: 1.0
Message-ID: <19646.56812.894677.232093@tree.ty.sabi.co.uk>
Date: Wed, 20 Oct 2010 13:17:48 +0100
Subject: Re: Performance degeneration issues
In-Reply-To: <1eca-4cbd9f00-19-5fdb7300@218342653>
References: <1eca-4cbd9f00-19-5fdb7300@218342653>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... random IO on a collection of 6 million of 2K files
degrades from 8000/s to 200/s ... ]

>> What's the layout of you storage? how many disks, size, etc.
>> How much RAM, number of CPUs in your server?

Perhaps the question above is a diplomatic way of hinting
something different.

The "op" is complaining that they want 8000 (logical) IOPS,
which they have observed with purely sequential patterns and
write caching at load time, but they are only getting 200
(logical) IOPS on a sustained basis at database access time.

The goal seems therefore to be that they want 8000 (logical)
IOPS even in the worst case scenario (1 physical IOPS per
logical IOPS).

The question to the "op" is then whether you are sure that your
storage layer can deliver a bit more than 8000 (physical) IOPS
and thus the filesystem can abstract it into something that
gives you the required 8000 (logical) IOPS.

All this in the case where your application really requires 8000
(physical) IOPS from the storage layer, which is a very high
target, especially as it seems that your current storage layer
peaks around 200 (physical) IOPS.

> With the SANs I checked if they are under heavy load (they are
> not).

What does "load" mean here? Does it mean tranfer rate or IOPS?

> Of those VMs only I is situated in an environment where there
> is load from other VMs.

VMs usually are not a good idea for IO intensive loads...
However the combination of VM, SAN and file systems used as
small records DBMSes seems popular, as each choice has the same
root source.

> It isn't really a sorting algorithm. Every file has 3 elements
> that can be used to categorise it. So the actual sorting
> amounts to a linear search (read) for those elements and a
> move/copy&delete (after possible creation of 4 directories in
> which to sort/categorise). [categorisation is done in this
> pattern: /<unique id>/<year>/fixed/(a|b)]

Ahh, the usual ridiculous "file systems are the optimal DBMS for
collections of small random records" delusion, with the bizarre
additional delusion that changing directory entries amounts to
"actual sorting".

> All of which show the same issues. So my reasoning was either
> hardware or FS. But seeing as the degeneration als happens
> with the SANs I thought it might be more of a FS specific
> issue.

Great insight! Couldn't it be that you have misdesigned and
miscoded your application in a demented way on the wrong storage
layer so that it scales very badly, and that you have been
fooled by tests that "worked well" at a much smaller scale?
Surely not. :-)

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
