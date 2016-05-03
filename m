Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B391F7CEF
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 20:26:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1871BAC001
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:26:52 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id kOphxJXLBVXL6IYp for
	<xfs@oss.sgi.com>; Mon, 02 May 2016 18:26:48 -0700 (PDT)
From: "Rudoff, Andy" <andy.rudoff@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Tue, 3 May 2016 01:26:46 +0000
Message-ID: <D26BCF92-ED25-4ACA-9CC8-7B1C05A1D5FC@intel.com>
References: <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard> <1461628381.1421.24.camel@intel.com>
	<20160426004155.GF18496@dastard>
	<x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jfUVXoge5D+cBY1Ph=t60165sp6sF_QFZUbFv+cNcdHg@mail.gmail.com>
	<20160503004226.GR26977@dastard>
In-Reply-To: <20160503004226.GR26977@dastard>
Content-Language: en-US
Content-ID: <0AF4EB11DD0E4F4EBC00F7351C1A2029@intel.com>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>


>> The takeaway is that msync() is 9-10x slower than userspace cache management.
>
>An alternative viewpoint: that flushing clean cachelines is
>extremely expensive on Intel CPUs. ;)
>
>i.e. Same numbers, different analysis from a different PoV, and
>that gives a *completely different conclusion*.
>
>Think about it for the moment. The hardware inefficiency being
>demonstrated could be fixed/optimised in the next hardware product
>cycle(s) and so will eventually go away. OTOH, we'll be stuck with
>whatever programming model we come up with for the next 30-40 years,
>and we'll never be able to fix flaws in it because applications will
>be depending on them. Do we really want to be stuck with a pmem
>model that is designed around the flaws and deficiencies of ~1st
>generation hardware?

Hi Dave,

Not sure I agree with your completely different conclusion.  (Not sure
I completely disagree either, but please let me raise some practical
points.)

First of all, let's say you're completely right and flushing clean
cache lines is extremely expensive.  So your solution is to wait for
the chip to be fixed?  Remember the model we're putting forward (which
we're working on documenting, because I fully agree with the lack of
documentation point you keep raising) requires the application to ASK
for the file system's permission before assuming flushing from user space
to persistence is allowed.  So that doesn't stick us with 30-40 years of
a flawed model.  I don't think the model is wrong, having spent lots of
research time on it, but if I'm full of crap, all we have to do is stop
telling the app that flushing from user space is allowed and it must go
back to using msync().  This is my understanding of what Dan suggested
at LSF and this is what I'm currently writing up.  By the way, the NVM
Libraries already contain the logic to ask if flushing from user space
is allowed, falling back to msync() if not.  Currently those libraries
check for DAX mappings.  But the points you raised about metadata changes
happening during page faults made us realize we have to ask the file
system to opt-in to allowing user space flushing, so that's what we're
changing the library to do.  See, we are listening :-)

Anyway, I doubt that flushing a clean cache line is extremely expensive.
Remember the code is building transactions to maintain a consistent
in-memory data structure in the face of sudden failure like powerloss.
So it is using the flushes to create store barriers, but not the block-
based store barriers we're used to in the storage world, but cache-line-
sized store barriers (usually multiples of cache lines, but most commonly
smaller than 4k of them).  So I think when you turn a cache line flush
into an msync(), you're seeing some dirty stuff get flushed before it
is time to flush it.  I'm not sure though, but certainly we could spend
more time testing & measuring.

More importantly, I think it is interesting to decide what we want the
pmem programming model to be long-term.  I think we want applications to
just map pmem, do normal stores to it, and assume they are persistent.
This is quite different from the 30-year-old POSIX Model where msync()
is required.  But I think it is cleaner, easier to understand, and less
error-prone.  So why doesn't it work that way right now?  Because we're
finding it impractical.  Using write-through caching for pmem simply
doesn't perform well, and depending on the platform to flush the CPU
caches on shutdown/powerfail is not practical yet.  But I think the day
will come when it is practical.

So given that long-term target, the idea is for an application to ask if
the msync() calls are required, or if just flushing the CPU caches is
sufficient for persistence.  Then, we're also adding an ACPI property
that allows SW to discover if the caches are flushed automatically
on shutdown/powerloss.  Initially that will only be true for custom
platforms, but hopefully it can be available more broadly in the future.
The result will be that the programming model gets simpler as more and
more hardware requires less explicit flushing.

Now I'll go back to writing up the big picture for this programming
model so I can ask you for comments on that as well...


-andy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
