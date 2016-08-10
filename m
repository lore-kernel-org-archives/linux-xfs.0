Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1AE697CA3
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 05:56:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B66468F8039
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2016 03:56:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nuOXRN55Ln0LqB9N for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2016 03:56:42 -0700 (PDT)
Date: Wed, 10 Aug 2016 20:56:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question on migrating data between PVs in xfs
Message-ID: <20160810105639.GR16044@dastard>
References: <20160809145046.GB5583@ic> <20160809223503.GJ19025@dastard>
	<20160810092313.GA16193@ic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160810092313.GA16193@ic>
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
To: Wei Lin <lin.wei15@imperial.ac.uk>
Cc: xfs@oss.sgi.com

Hi Wei,

Please keep the discussion on the list unless there's good reason
not to. I've readded the list cc...

On Wed, Aug 10, 2016 at 10:23:14AM +0100, Wei Lin wrote:
> Hi Dave,
> 
> Thank you very much for the reply. Comment inline.
> 
> On 16-08-10 08:35:03, Dave Chinner wrote:
> > On Tue, Aug 09, 2016 at 03:50:47PM +0100, Wei Lin wrote:
> > > Hi there,
> > > 
> > > I am working on an xfs based project and want to modify the allocation
> > > algorithm, which is quite involved. I am wondering if anyone could help
> > > with this.
> > > 
> > > The high level goal is to create xfs agains multiple physical volumes,
> > > allow user to specify the target PV for files, and migrate files
> > > automatically.
> > 
> > So, essentially tiered storage with automatic migration. Can you
> > describe the storage layout and setup you are thinking of using and
> > how that will map to a single XFS filesystem so we have a better
> > idea of what you are thinking of?
> > 
> Yes, but the migration is triggerd by user specifying a device, instead
> of kernel monitoring the usage pattern.

That's not migration - that's an allocation policy. Migration means
moving data at rest to a different physical location, such as via a
HSM, automatic teiring or defragmentation. Deciding where to write
when the first data is written is the job of the filesystem
allocator, so what you are describing here is user-controlled
allocation policy.

> By "PV" I meant physical volumes of LVM. Currently I have two physical
> volumes, one based on two SSDs and the other six HDDs.

That's what I thought, but you still need to describe everything in
full rather than assume the reader understands your abbreviations.

> The XFS was
> created as follows:
> 
> mdadm --create /dev/md1  --raid-devices=2 --level=10 -p f2 --bitmap=internal --assume-clean /dev/nvme?n1
> mdadm --create /dev/md2  --raid-devices=6 --level=5 --bitmap=internal --assume-clean /dev/sd[c-h]
> pvcreate /dev/md1
> pvcreate /dev/md2
> vgcreate researchvg /dev/md1 /dev/md2
> lvcreate -n hsd -l 100%FREE researchvg
> mkfs.xfs -L HSD -l internal,lazy-count=1,size=128m /dev/mapper/researchvg-hsd

It's a linear concatenation of multiple separate block devices,
so the physical boundaries are hidden from the filesystem by the
LVM layer.

Have you lookd at using dm-cache instead of modifying the
filesystem?

> > > I plan to implement the user interface with extended attributes, but am
> > > now stuck with the allocation/migration part. Is there a way to make xfs
> > > respect the attribute, i.e. only allocate blocks/extents from the target
> > > PV specified by user?
> > 
> > Define "PV".
> > 
> > XFS separates allocation by allocation group - it has no concept of
> > underlying physical device layout. If I understand what you , you have
> > multiple "physical volumes" set up in a single block device (somehow
> > - please describe!) and now you want to control how data is
> > allocated to those underlying volumes, right?
> 
> I thought about storing the mapping between the physical volumes and the
> logical volume in a special file, probably including metainfo like IOPS,
> access time as well. And consulting this file on the fly to determine if
> the allocated extent is within the target device.

How does the filesystem determine whether an allocated extent is on
a specific device when it has no knowledge of the underlying
physical device boundaries?

> > So what you're asking about is how to define and implement user
> > controlled allocation policies, right? Sorta like this old
> > prototype I was working on years ago?
> > 
> > http://oss.sgi.com/archives/xfs/2009-02/msg00250.html
> > 
> > And some more info from a later discussion:
> > 
> > http://oss.sgi.com/archives/xfs/2013-01/msg00611.html
> > 
> > And maybe in conjunction with this, which added groupings of AGs
> > together to form independent regions of "physical separation" that
> > the allocator could then be made aware of:
> > 
> > http://oss.sgi.com/archives/xfs/2009-02/msg00253.html
> 
> I am not sure if allocation(s) group would be a good unit of "physical
> separation".

There is no other construct in XFS designed for that purpose.

> Since the underlying physical devices (thus the physical
> volumes) have quite different characteristics, physical volumes seem
> naturally a good choice.

XFS knows nothing about those boundaries - you have to tell it where
the boundaries are. e.g. size your allocation groups to fit the
smallest physical boundary you have, then assign a different policy
to the user of that allocation group. THat's the point of the patch
set that allowed mkfs to define sets of AGs that lay in specific
domains so that the allocator could target them based on the
requirements supplied from the user in the allocation policy (which was
the first patch set I pointed to).

> On the other hand an allocation group may span
> multiple physical volumes, providing quite different QoS. This is why I
> planned to let users specify target "PV" instead of target allocation
> group. Any ideas?

Go read the code in the patches I pointed to first - they answer
both the questions you are asking right now as these were the
problems that I was looking to solve all that time ago. They will
also answer many questions you haven't yet realised you need to
ask, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
