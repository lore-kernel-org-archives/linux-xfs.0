Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JHdeKi131872 for <xfs@OSS.SGI.com>; Tue, 19 Jun 2012 12:39:41 -0500
Received: from sabi.co.UK (rm-pr-sg-07.server.shotgunsoftware.com
	[74.50.53.135]) by cuda.sgi.com with ESMTP id XpYgTzudKskoKT1m
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@OSS.SGI.com>; Tue, 19 Jun 2012 10:39:39 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1Sh1na-0003Kw-Sy
	for <xfs@OSS.SGI.com>; Tue, 19 Jun 2012 18:00:38 +0100
MIME-Version: 1.0
Message-ID: <20448.45134.65748.440592@tree.ty.sabi.co.UK>
Date: Tue, 19 Jun 2012 18:00:38 +0100
Subject: Re: Recommendation on XFS Filesystem Creation, Lefthand P4500, iSCSI ?
In-Reply-To: <4FE050C2.8060601@fiton.is>
References: <4FE050C2.8060601@fiton.is>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> We recently purchased HP Lefthand 4500 G2 24TB iSCSI SAN Box.
> [ ... ] HP DL380 G7 with 24GB in RAM [ ... ]

> I need to create a 7TB volume at the start, and grow it in
> near future.

Why start small and grow? What's the point? Usually "grow" has
no problems, but any restructuring operation (on RAID or
filetrees) is a dangerous moment. Begging for trouble.

> Are there any recommendation on creating that XFS volume ?

Ideally create multiple small volumes over time and assign
different sets of users to them. For better 'fsck' and safety if
anything.

> Particularly regarding iSCSI and that big ?

Hopefully you won't be creating a single 24TB RAID6 set, but
that kind of (euphemism) strategy seems to be standard.

I would not configure the volumes exported by the iSCSI server
as sparse/thin, but in that case using 'discard' should help.

As an obvious note, but just to be sure, you will be running a
64b OS. But still be careful about stack overflows. You are
using 'netatalk' and Samba which are user-level services, so
those won't impact the kernel stack, but DM/LVM and NFS would.
A pity as the only good use of DM would be to create a snapshot
volume for "frozen" state backups. But it should still work,
after all 64b kernels have a larger kernel stack frame.

Then the major issue: backups. How are you going to create at
least 3-4 backups copies of your filetree(s)? Interesting issue.

> This server will act as a fileserver for 50+ machines serving
> request with netatalk and samba.

If you have performance requirements ideally the server will be
dual homed on an iSCSI-only *physical* (not VLAN) network and a
distinct user network (with different NICs). Tuning the Linux
IP/TCP parameters might help a fair bit too, and a 10Gb network
would be a big improvement over a 1Gb one, and short range 10Gb
cards are quite affordable (I particularly like Myri cards, but
the Dell Broadcom ones are also good).

> Surely I will need to use inode64 option. Right ?

Yes (IIRC it will soon become the default), as recommended in
http://www.spinics.net/lists/xfs/msg11455.html; as it says,
'inode64' has a secondary effect on allocation, which usually
helps, and in your case I think it does; anyhow with filetrees
much above 1TiB (with 512B sectors) it is hard to avoid
'inode64'.

But perhaps other most important point is to ensure that 'su=' and 'sw='
are set appropriately as you are using parity RAID. Usually the
'mkfs.xfs' asks the Linux kernel for geometry details, which
usually works when the RAID set is provided by MD or DM, but in
your case probably the RAID geometry will not be available from
the iSCSI layer, so probably you need to specify it manually.

Consider whether to enable barriers, and the answer is probably
yes (if supported), unless you have a really reliable storage
chains with battery backups and a very reliable kernel too.

Dramatically reducing the number of "dirty" pages in the page
cache usually is rather important too. It might be of benefit to
set the elevator to "noop".

Probably a sector size of 4096 is also a good idea, and on
recent storage system this is always true where possible.
Having jumbo frames enabled on your network (the iSCSI facing
one) would probably help a fair bit, regardless of sector size.

If you use lots of ACLs (common for fileservers) consider having
a larger-than-usual inode size, which also helps if you expect
to have large extent maps (very huge files or very fragmented
ones, for example mail archives). I personally tend to have
2048B inodes, but that is an arguable choice.

If you have a very reliable storage chain and high rates of file
creation and deletion you may want an external journal, but
probably your iSCSI host adapter has enough BBU backed cache
that it is not necessary. You may want to disable delayed
logging to reduce the vulnerability window otherwise.

PS I have adeptad here a number of hints about setting up XFS
   (and other types) of filetrees taken from:
   http://www.sabi.co.uk/Notes/linuxFS.html#fsHintsXFS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
