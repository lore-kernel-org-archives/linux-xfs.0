Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B8647CB1
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DEE3304051
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 21:39:42 -0700 (PDT)
Received: from mail-oi0-f51.google.com (mail-oi0-f51.google.com
	[209.85.218.51]) by cuda.sgi.com with ESMTP id Pz6Q8mPZG7SsE33c
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 31 Jul 2016 21:39:40 -0700 (PDT)
Received: by mail-oi0-f51.google.com with SMTP id w18so177883414oiw.3
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 21:39:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160801040737.GJ16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
	<20160727211039.GA20278@linux.intel.com>
	<20160727221949.GU16044@dastard> <20160728081033.GC4094@quack2.suse.cz>
	<20160729022152.GZ16044@dastard>
	<CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
	<20160730001249.GE16044@dastard>
	<CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com>
	<20160801014645.GI16044@dastard> <86k2g15gh8.fsf@hiro.keithp.com>
	<20160801040737.GJ16044@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 31 Jul 2016 21:39:38 -0700
Message-ID: <CAPcyv4jN5OvbPMA07w0vjBCBrGH-j2YsCjfvB3b6S6JJ_zUA=Q@mail.gmail.com>
Subject: Re: Subtle races between DAX mmap fault and write path
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
To: Dave Chinner <david@fromorbit.com>
Cc: Keith Packard <keithp@keithp.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Sun, Jul 31, 2016 at 9:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Jul 31, 2016 at 08:13:23PM -0700, Keith Packard wrote:
>> Dave Chinner <david@fromorbit.com> writes:
>>
>> > So we'd see that from the point of view of a torn single sector
>> > write. Ok, so we better limit DAX to CRC enabled filesystems to
>> > ensure these sorts of events are always caught by the filesystem.
>>
>> Which is the same lack of guarantee that we already get on rotating
>> media. Flash media seems to work harder to provide sector atomicity; I
>> guess that's a feature?
>
> No, that's not the case. Existing sector based storage guarantees
> atomic sector writes - rotating or solid state. I haven't seen one a
> corruption caused by a torn sector write in 15 years.  BTT layer was
> written for pmem to provide this guarantee, but you can't use DAX
> through that layer.
>
> In XFS, the only place we really care about torn sector writes in
> the journal - we have CRCs there to detect such problems and CRC
> enabled filesystems will prevent recovery of checkpoints containing
> torn writes. Non-CRC enable filesystems just warn and continue on
> their merry way (compatibility reasons - older kernels don't emit
> CRCs in log writes), so we really do need to restrict DAX to CRC
> enabled filesystems.
>
>> The alternative is to hide metadata behind a translation layer, and
>> while that can be done for lame file systems,
>
> No. These "lame" filesystems just need to use their existing
> metadata buffering layer to hide this and the journalling subsystem
> should protects against torn metadata writes.
>
>> I'd like to see the raw
>> hardware capabilities exposed and then make free software that
>> constructs a reliable system on top of that.
>
> Not as easy as it sounds.  A couple of weeks ago I tried converting
> the XFS journal to use DAX to avoid the IO layer and resultant
> memcpy(), and I found out that there's a major problem with using
> DAX for metadata access on existing filesystems: pmem is not
> physically contiguous. I found that out the hard way - the ramdisk
> is DAX capable, but each 4k page ithat is allocated to it has a
> different memory address.
>
> Filesystems are designed around the fact that the block address
> space they are working with is contiguous - that sector N and sector
> N+1 can be accessed in the same IO. This is not true for
> direct access of pmem - while the sectors might be logically
> contiguous, the physical memory that is directly accessed is not.
> i.e. when we cross a page boundary, the next page could be on a
> different node, on a different device (e.g.  RAID0), etc.
> Traditional remapping devices (i.e. DM, md, etc) hide the physical
> discontiguities from the filesystem - the present a contiguous LBA
> and remap/split/combine under the covers where the filesystem is not
> aware of it at all.
>
> The reason this is important is that if the filesystem has metadata
> constructs larger than a single page it can't use DAX to access them
> as a single object because they may lay across a physical
> discontiguity in the memory map.  Filesystems aren't usually exposed
> to this - sectors of a block device are indexed by "Logical Block
> Address" for good reason - the LBA address space is supposed to hide
> the physical layout of the storage from the layer above the block
> device.
>
> OTOH, DAX directly exposes the physical layout to the filesytem.
> And because it's DAX-based pmem and not cached struct pages, we
> can't run vm_map_ram() to virtually map the range we need to see as
> a contiguous range, as we do in XFS for large objects such as directory
> blocks and log buffers. For other large objects such as inode
> clusters, we can directly map each page as the objects within the
> clusters are page aligned and never overlap page boundaries, but
> that only works for inode and dquot buffers. Hence DAX as it stands
> makes it extremely difficult to "retrofit" DAX into all aspects of
> existing fileystems because exposing physical discontiguities breaks
> code that assumes they don't exist.

On this specific point about page remapping, the administrator can
configure struct pages for pmem and you can detect whether they are
present in the filesystem with pfn_t_has_page().  I.e. you could
require pages be present for XFS, if that helps...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
