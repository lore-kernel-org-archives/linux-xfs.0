Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 934E37F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 08:09:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0BBA2AC001
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 06:09:09 -0800 (PST)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id PolXt9sfW6cIzNoY
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2015 06:09:07 -0800 (PST)
Received: by wmww144 with SMTP id w144so22499477wmw.0
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 06:09:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151119233547.GN14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119155525.GB13055@bfoster.bfoster>
	<20151119233547.GN14311@dastard>
Date: Fri, 20 Nov 2015 16:09:06 +0200
Message-ID: <CAE1zotJE1-qkHnSrJ068-7D5a5vYRr9cSy-MfXy4DjJ8d+YekQ@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
From: Octavian Purdila <octavian.purdila@intel.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 20, 2015 at 1:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Nov 19, 2015 at 10:55:25AM -0500, Brian Foster wrote:
>> On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
>> > Naive implementation for non-mmu architectures: allocate physically
>> > contiguous xfs buffers with alloc_pages. Terribly inefficient with
>> > memory and fragmentation on high I/O loads but it may be good enough
>> > for basic usage (which most non-mmu architectures will need).
>> >
>> > This patch was tested with lklfuse [1] and basic operations seems to
>> > work even with 16MB allocated for LKL.
>> >
>> > [1] https://github.com/lkl/linux
>> >
>> > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>> > ---
>>
>> Interesting, though this makes me wonder why we couldn't have a new
>> _XBF_VMEM (for example) buffer type that uses vmalloc(). I'm not
>> familiar with mmu-less context, but I see that mm/nommu.c has a
>> __vmalloc() interface that looks like it ultimately translates into an
>> alloc_pages() call. Would that accomplish what this patch is currently
>> trying to do?
>
> vmalloc is always a last resort.  vmalloc space on 32 bit systems is
> extremely limited and it is easy to exhaust with XFS.

Doesn't vm_map_ram use the same space as vmalloc?

>
> Also, vmalloc limits the control we have over allocation context
> (e.g. the hoops we jump through in kmem_alloc_large() to maintain
> GFP_NOFS contexts), so just using vmalloc doesn't make things much
> simpler from an XFS perspective.
>

I have zero experience with XFS, sorry if I ask obvious questions.
AFAICS there are no memalloc_noio_save() hoops in the page allocation
part, just in the vm_map_ram part. Could we preserve the
memalloc_noio_save() part and use vmalloc instead of vm_map_ram?

>> I ask because it seems like that would help clean up the code a bit, for
>> one. It might also facilitate some degree of testing of the XFS bits
>> (even if utilized sparingly in DEBUG mode if it weren't suitable enough
>> for generic/mmu use). We currently allocate and map the buffer pages
>> separately and I'm not sure if there's any particular reasons for doing
>> that outside of some congestion handling in the allocation code and
>> XBF_UNMAPPED buffers, the latter probably being irrelevant for nommu.
>> Any other thoughts on that?
>
> We could probably clean the code up more (the allocation logic
> is now largely a historic relic) but I'm not convinced yet that we
> should be spending any time trying to specifically support mmu-less
> hardware.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
