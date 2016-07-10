Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 941517CB4
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 18:48:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E672DAC002
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 16:48:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EzYgCk2scbOswN5e for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2016 16:48:40 -0700 (PDT)
Date: Mon, 11 Jul 2016 09:48:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs + 100TB+ storage + lots of small files + NFS
Message-ID: <20160710234801.GD1922@dastard>
References: <CACNifpXnSMcm6EfSjqLFPXXfqv7XWd4Yu_=UhqTcdn6-o+49Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACNifpXnSMcm6EfSjqLFPXXfqv7XWd4Yu_=UhqTcdn6-o+49Yw@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marcin Sura <mailing-lists@sura.pl>
Cc: xfs@oss.sgi.com

On Sat, Jul 09, 2016 at 01:14:37PM +0200, Marcin Sura wrote:
> Hi,
> 
> Friend of mine asked me about evaluation of XFS for their purposes.
> Currently I don't have physical access to their system, but here are the
> info I've got so far:
> 
> SAN:
> - physical storage is from FSC array, thin provisioned raid 6 volume,
> - volumes are 100TB+ in size
> - there are SSD disks in the array, which potentially can be used for
> journal
> - storage is connected to the host via 10GbE iSCSI
> 
> Host:
> - They are using CentOS6.5, with stock kernel 2.6.32-*

I'd suggest the NFS server should use a kernel/distro as recent as
possible. Doesn't affect client/application side OS choices, so
I would suggest, at minimum, you use a kernel that supports metadata
CRCs. You'll have hundreds of terabytes of data indexed by hundreds
of gigabytes of metadata, and you're going to want things like free
inode indexing to keep inode allocation as fast as possible as
counts build up to the hundreds of millions of inodes.

> - System uses all default values, no optimization has beed done
> - OS installed on SSD
> - Don't know exact details of CPU, but I assume some recent multicore CPU
> - Don't know amount of RAM installed, I assume 32GB+

With a peaky random read workload, you're going to want to cache
tens of millions of inodes in RAM to get performance out of the
machine. RAM is cheap compared to storage costs - I'd suggest
hundreds of GB of RAM in the server....

> NFS:
> - they are exporting filesystem via NFS to 10-20 clients (services), some
> VMs, some bare metal
> - clients are connected via 1GbE or 10GbE links
> 
> Workload:
> - they are storing tens or hundreds of millions of small files
> - files are not in single directory

How big are the directories?

> - files are undek 1K, usually 200 - 500 bytes
> - I assume, that some NFS clients constantly write files
> - some NFS clients initiates massive reads, millions of random files
> - those reads are on demand, but during peak hours there can be many of
> such requests

This sort of "efficiently indexing hundreds of millions of tiny
objects" workload is what databases were designed for, not
filesystems. Yes, you can use a filesystem for this sort of
workload, but IMO it's not the right tool for this job.

> So far they were using Ext4, after some basic test they observed 40%
> improvement in application counters. But I'm afraid that those tests were
> done in environment not even close to the production (not so big size of
> filesystem, not so much files).
> 
> I want to ask you what would be best mkfs.xfs settings for such setup.

How long is a piece of string?

Working out how to optimise storage to this sort of workload
requires an iterative measure/analyse/tweak approach. Anything else
is just guesswork. i.e. start with the defaults, then measure
performance, identify the bottlenecks in the system and then tweak
the appropriate knob to alleviate the bottleneck.

i.e. you may find that there are things you have to change in the
NFS server config to get it to scale before you even start looking
at XFS performance....

> I assume, that they should use inode64 mount option for such large
> filesystem with that amount of files, but I'm a bit worried about
> compatibility with NFS (default shipped with CentOS 6.5). I think inode32
> is totally out of scope here.

inode32 will not support hundreds of millions of inodes - you'll
ENOSPC the first AG long before that, and performance will be very
bad as all inode/directory allocation will single thread. And it
will only get worse as the inode count goes up.

As it is, inode64 will be fine for 64bit NFS clients. It's only 32
bit clients that have problems with 64 bit inode numbers, and even
then it is only a problem on older linux and non-linux clients.

> Also, do you know any benchmark which can be used to simulate such
> workload?

Test against your production workload. It's the only way to be sure
you are optimising the right things.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
