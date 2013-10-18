Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 651567F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 13:14:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7D7DAC003
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:14:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id eUz1sAOb92fnGU3n
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 11:14:09 -0700 (PDT)
Message-ID: <52617A76.10601@hardwarefreak.com>
Date: Fri, 18 Oct 2013 13:14:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Input on Potential XFs-based Design
References: <20131018035746.GA31020@esri.com>
In-Reply-To: <20131018035746.GA31020@esri.com>
Reply-To: stan@hardwarefreak.com
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
To: Ray Van Dolson <rvandolson@esri.com>, xfs@oss.sgi.com

On 10/17/2013 10:57 PM, Ray Van Dolson wrote:

> Am considering going with XFS for a project requiring a fair amount of
> parallel (SMB network-sourced) throughput along with capacity.

GIS application I see.

> We'll have ~10 writers outputing sequential data in the form of
> 300MB-3GB files via SMB v2.x (via Samba -- the writers will be running
> Windows).  Needing approximately 100TB of usable space (we'll likely
> only fill up to 70TB at any given time).  Also will be using 3-4TB 7.2K
> drives in Dell hardware (R series server attached to either JBODs or an
> MD3K controller) and probably use RHEL6 as our base (yes, reaching out
> to Red Hat for advice as well).

Parity RAID seems suitable and cost effective for a streaming write
workload free of RMW OPs.  Will these 0.3-300GB files be written in one
shot or will they be appended over time?  The answer will dictate
whether stripe alignment will benefit the workload, or if you must rely
on the RAID controller to optimize writeback.

> Each "writer" will likely have 10GbE connections.  I've rarely seen a

A writer is a process, not a host.  Please provide a better description
of the hardware/network architecture, as it may make/break your
throughput goals.  For now I'm assuming a single 10 GbE interface in
each client host, and x2 in the server.  If the client hosts will have
two bonded NICs, please state so, as that will change the game.

> single SMB TCP connection get more than ~2-3Gbps -- even with jumbo

Multiple SMB streams between two hosts can saturate a single link.

> frames on, so am looking to do a 2x10GbE LACP link on the XFS server
> side to hopefully be able to handle the bulk of the traffic.

Neither LACP nor any Linux bonding mode can perform receive load
balancing at the server with client initiated connections.  Mode
balance-alb can perform receive load balancing, but only on connections
established outbound, and only to multiple client host IPs, not a client
IP of a bonded interface.  IIRC, SMB connections are always initiated by
the client, so no bonding method will work in this scenario.

So for this architecture you must forget bonding the server interfaces.
 Simply bind consecutive IP addresses to the two 10 GbE interfaces,
configure source based routing, and create a static host entry on each
client.  I.e. with 10 clients hosts, 5 hosts point to one server IP, 5
point to the other.  You must forgo link/NIC failover, but you get the
bandwidth of both server interfaces.

> XFS sounds like the right option for us given its strength with
> parallel writes, but have a few questions that are likely important for
> us to understand the ansswers for prior to moving forward:
> 
> (1) XFS Allocation Groups.  My understanding is that XFS will write
> files within a common directory using a single allocation group.

Not "using" an AG.  Each directory physically resides within an AG.
Directories are placed in the AGs round robin fashion as each new dir is
created.

> Writes to files in different directories will go to another allocation
> group.  

...will go into the AG in which the directory resides.

> These allocation groups can be aligned with my individual LUNs,

They can be.  Usually this requires thoughtful manual configuration
during mkfs.  But whether you would do this depends on the physical
nature of the array(s) backing the LUNs.

> so if I plan out where my files are being written to I stand the best
> chance of getting maximum throughput.

Again, it depends on the physical nature of the LUNs.

> Right now, the software generating the output just throws everything in
> the same top-level directory.  Likely a trivial thing to change, but
> it's another team completely, so I'm wondering if I'll still be able to
> take advantage of XFs's parallelization and multiple allocatoin groups
> even if all my writes are streaming to files which live under the same
> parent directory.

With a single directory, only if the filesystem resides on a single
striped array, or possibly a nested striped array.

> (2) RAID design.  I'm looking for max throughput, and although writes
> from each "writer" should be sequential, all of these streams hitting
> at once I guess could be considered random reads.  I'm debating with

No, random writes.  And this is only from the perspective of the head
actuator on each drive.

> going either with Linux MD RAID striping a whole slew of 4-disk RAID10
> LUNS presented by either our PERC RAID cards or by an MD3K head unit.
> Another approach would be MD striping HW RAID5/RAID6 with enough RAID
> groups to drive max throughput and get a bit mor capcity...

We need to know more about the application, and from the above it's
clear you do as well.  The workload drives the storage stack design.
Always.  It is absolutely critical to know the application's write
behavior, and its target path limitations in this case.  You need to
answer these questions, for yourself, and for others assisting:

How many instances of the application execute per virtual machine, or
per physical host?

Is this a monolithic application with many write threads, or many
instances of a monolithic application with a single write thread?  If
the latter, how many instances per VM, and/or per physical host?

Is the file path configurable per write thread, or only per application
instance?

If the target directory can't be changed per thread or per instance, can
the target drive letter be changed?

What size are the application's write IOs?

You've mentioned writes, but not reads.  What is the read workload of
this ~70TB of data you're writing?  Surely some other application is
reading it at some point.  Is it reading while the others are writing?

The answer to each of these questions influences, or completely changes,
the storage stack architecture that is required to meet your needs.

> (3) Log Device.  Considering using a couple of SSD's in the head unit
> as a dedicated log device.  The files we're writing are fairly big and
> there's not too many of them, so this may not be needed (fewer metadata
> operatoins) but also may not hurt.

Probably not needed, especially if you have BBWC.

> Other approaches would be some sort of an appliance (more costly) or
> using Windows (maybe better SMB performance, but unsure if I would want
> to test NTFS much larger than 20TB).

> Also not sure how RAM hungry XFS is.  Stuffing as much in as I can
> probably won't hurt things (this is what we do for ZFS), but any rule
> of thumb here?  

XFS is simply a filesystem driver within the Linux kernel.  Its memory
footprint is miniscule.  In this file server application all of your RAM
will get eaten by buffer cache.  The xfs_repair user space tool can eat
many GB when repairing a large (metadata) or badly broken filesystem.
But with this workload you have very little metadata.  Even with 70TB of
files you could probably get by with 4-8GB RAM.  Given most standard x86
servers ship w/8-16GB or more these days I'd say you're covered.

ZFS is a completely different beast and is much more than a traditional
filesystem.  It maintains a very large cache structure used by its non
traditional features.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
