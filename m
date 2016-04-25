Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2ABC27CA1
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 18:43:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 989D3AC001
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 16:43:17 -0700 (PDT)
Received: from mail-oi0-f47.google.com (mail-oi0-f47.google.com
	[209.85.218.47]) by cuda.sgi.com with ESMTP id dM1kpNx53dqXynCC
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 16:43:14 -0700 (PDT)
Received: by mail-oi0-f47.google.com with SMTP id x201so193609347oif.3
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 16:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160425232552.GD18496@dastard>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard>
Date: Mon, 25 Apr 2016 16:43:14 -0700
Message-ID: <CAPcyv4i6iwm1iY2mQ5yRbYfRexQroUX_R0B-db4ROU837fratw@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "hch@infradead.org" <hch@infradead.org>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Mon, Apr 25, 2016 at 4:25 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Apr 25, 2016 at 05:14:36PM +0000, Verma, Vishal L wrote:
>> On Mon, 2016-04-25 at 01:31 -0700, hch@infradead.org wrote:
>> > On Sat, Apr 23, 2016 at 06:08:37PM +0000, Verma, Vishal L wrote:
>> > >
>> > > direct_IO might fail with -EINVAL due to misalignment, or -ENOMEM
>> > > due
>> > > to some allocation failing, and I thought we should return the
>> > > original
>> > > -EIO in such cases so that the application doesn't lose the
>> > > information
>> > > that the bad block is actually causing the error.
>> > EINVAL is a concern here.  Not due to the right error reported, but
>> > because it means your current scheme is fundamentally broken - we
>> > need to support I/O at any alignment for DAX I/O, and not fail due to
>> > alignbment concernes for a highly specific degraded case.
>> >
>> > I think this whole series need to go back to the drawing board as I
>> > don't think it can actually rely on using direct I/O as the EIO
>> > fallback.
>> >
>> Agreed that DAX I/O can happen with any size/alignment, but how else do
>> we send an IO through the driver without alignment restrictions? Also,
>> the granularity at which we store badblocks is 512B sectors, so it
>> seems natural that to clear such a sector, you'd expect to send a write
>> to the whole sector.
>>
>> The expected usage flow is:
>>
>> - Application hits EIO doing dax_IO or load/store io
>>
>> - It checks badblocks and discovers it's files have lost data
>
> Lots of hand-waving here. How does the application map a bad
> "sector" to a file without scanning the entire filesystem to find
> the owner of the bad sector?
>
>> - It write()s those sectors (possibly converted to file offsets using
>> fiemap)
>>     * This triggers the fallback path, but if the application is doing
>> this level of recovery, it will know the sector is bad, and write the
>> entire sector
>
> Where does the application find the data that was lost to be able to
> rewrite it?
>
>> - Or it replaces the entire file from backup also using write() (not
>> mmap+stores)
>>     * This just frees the fs block, and the next time the block is
>> reallocated by the fs, it will likely be zeroed first, and that will be
>> done through the driver and will clear errors
>
> There's an implicit assumption that applications will keep redundant
> copies of their data at the /application layer/ and be able to
> automatically repair it? And then there's the implicit assumption
> that it will unlink and free the entire file before writing a new
> copy, and that then assumes the the filesystem will zero blocks if
> they get reused to clear errors on that LBA sector mapping before
> they are accessible again to userspace..
>
> It seems to me that there are a number of assumptions being made
> across multiple layers here. Maybe I've missed something - can you
> point me to the design/architecture description so I can see how
> "app does data recovery itself" dance is supposed to work?
>

Maybe I missed something, but all these assumptions are already
present for typical block devices, i.e. sectors may go bad and a write
may make the sector usable again.  This patch series is extending that
out to the DAX-mmap case, but it's the same principle of "write to
clear error" that we live with in the block-I/O path.  What
clarification are you looking for beyond that point?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
