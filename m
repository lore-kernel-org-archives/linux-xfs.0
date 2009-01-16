Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0GNDl1o007588 for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 17:13:47 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF2501BA4E15
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 15:13:38 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id OyOiFsWgVSSkJj4z for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2009 15:13:38 -0800 (PST)
Message-ID: <49710AA4.3000402@sandeen.net>
Date: Fri, 16 Jan 2009 16:31:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS without write barriers - safe on multipath device?
References: <8998fba30901161409m37058e10yc25e062fad425710@mail.gmail.com>
In-Reply-To: <8998fba30901161409m37058e10yc25e062fad425710@mail.gmail.com>
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
To: Adam Fried-Gintis <xfs@icosm.net>
Cc: xfs@oss.sgi.com

Adam Fried-Gintis wrote:
> Hi,
> I am just curious, if I see the warning that write barrier support is
> disabled when mounting an XFS filesystem through md multipath, does XFS have
> some OTHER provision for protecting the order of its writes to the
> underlying device, or is it unsafe to run with write back caching at that
> point? My underlying device is an active/active storage system - combined
> with the multipath driver, we are seeing metadata corruption on the
> filesystem, and I'm just trying to figure out if this is an invalid
> configuration to test or if the storage device is doing something wrong.

XFS needs to know that when the storage says a write is complete, that
it really is safe on disk.

You're ok w/o barriers if either:

a) you have no write cache, or
b) you know your write cache is guaranteed to hit the disks (UPS?)

Also, this only comes into play when the drives lose power and lose
their write cache.  If that's not happening to you, then your problem is
likely not related to barrier issues.

When you say active/active; do you have 2 hosts directly accessing the
same filesystem on a SAN?

-Eric

> Thanks!
> 
> ---
> Adam Fried-Gintis

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
