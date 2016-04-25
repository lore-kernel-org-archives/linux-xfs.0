Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 26D1F7CA1
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 12:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 835BAAC001
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 10:21:47 -0700 (PDT)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com
	[209.85.218.54]) by cuda.sgi.com with ESMTP id tOLrOUNvTFlUES3O
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 10:21:45 -0700 (PDT)
Received: by mail-oi0-f54.google.com with SMTP id r78so183828937oie.0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 10:21:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461604476.3106.12.camel@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
Date: Mon, 25 Apr 2016 10:21:44 -0700
Message-ID: <CAPcyv4ijf=LDLytVRn_UptVVi5G=7r9bkTkkJHYgBF78tffh9w@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Mon, Apr 25, 2016 at 10:14 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Mon, 2016-04-25 at 01:31 -0700, hch@infradead.org wrote:
>> On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
>> >
>> > direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM
>> > due
>> > to some allocation failing, and I thought we should return the
>> > original
>> > -EIO in such cases so that the application doesn't lose the
>> > information
>> > that the bad block is actually causing the error.
>> EINVAL is a concern here.  Not due to the right error reported, but
>> because it means your current scheme is fundamentally broken - we
>> need to support I/O at any alignment for DAX I/O, and not fail due to
>> alignbment concernes for a highly specific degraded case.
>>
>> I think this whole series need to go back to the drawing board as I
>> don't think it can actually rely on using direct I/O as the EIO
>> fallback.
>>
> Agreed that DAX I/O can happen with any size/alignment, but how else do
> we send an IO through the driver without alignment restrictions? Also,
> the granularity at which we store badblocks is 512B sectors, so it
> seems natural that to clear such a sector, you'd expect to send a write
> to the whole sector.
>
> The expected usage flow is:
>
> - Application hits EIO doing dax_IO or load/store io
>
> - It checks badblocks and discovers it's files have lost data
>
> - It write()s those sectors (possibly converted to file offsets using
> fiemap)
>     * This triggers the fallback path, but if the application is doing
> this level of recovery, it will know the sector is bad, and write the
> entire sector
>
> - Or it replaces the entire file from backup also using write() (not
> mmap+stores)
>     * This just frees the fs block, and the next time the block is
> reallocated by the fs, it will likely be zeroed first, and that will be
> done through the driver and will clear errors
>
>
> I think if we want to keep allowing arbitrary alignments for the
> dax_do_io path, we'd need:
> 1. To represent badblocks at a finer granularity (likely cache lines)
> 2. To allow the driver to do IO to a *block device* at sub-sector
> granularity

3. Arrange for O_DIRECT to bypass dax_do_io(), and leave the
optimization only for the dax "buffered I/O" case.

4. Skip dax_do_io() entirely in the presence of errors

I think 3 is the most closely aligned with the typical block device
model.  In the typical case a buffered write may fail due to a
badblock read when filling the page cache, but an O_DIRECT write would
bypass the page cache and potentially clear the error / cause the
block to be reallocated internally to the drive.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
