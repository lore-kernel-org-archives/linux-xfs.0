Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C881D7F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 09:32:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9558E30405F
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 07:32:03 -0800 (PST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id f5FOfFwgwEHucGRe
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2015 07:32:01 -0800 (PST)
Received: by wmww144 with SMTP id w144so25669738wmw.0
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 07:32:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151120152412.GC60886@bfoster.bfoster>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
	<20151120005843.GP14311@dastard>
	<CAE1zotLw-vCz2qF4JmXEYFF_yPbkhQ2HEEYxMwvdRbhKRCaxTw@mail.gmail.com>
	<20151120152412.GC60886@bfoster.bfoster>
Date: Fri, 20 Nov 2015 17:31:59 +0200
Message-ID: <CAE1zotK1Gjb_gzDjU_dnQoYQnP4azvsDtzi6f=RANH-wDOKhSA@mail.gmail.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 5:24 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Fri, Nov 20, 2015 at 04:26:28PM +0200, Octavian Purdila wrote:
>> On Fri, Nov 20, 2015 at 2:58 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Fri, Nov 20, 2015 at 12:54:02AM +0100, Richard Weinberger wrote:
>> >> On Fri, Nov 20, 2015 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
>> >> >> Naive implementation for non-mmu architectures: allocate physically
>> >> >> contiguous xfs buffers with alloc_pages. Terribly inefficient with
>> >> >> memory and fragmentation on high I/O loads but it may be good enough
>> >> >> for basic usage (which most non-mmu architectures will need).
>> >> >
>> >> > Can you please explain why you want to use XFS on low end, basic
>> >> > non-MMU devices? XFS is a high performance, enterprise/HPC level
>> >> > filesystem - it's not a filesystem designed for small IoT level
>> >> > devices - so I'm struggling to see why we'd want to expend any
>> >> > effort to make XFS work on such devices....
>> >>
>> >> The use case is the Linux Kernel Library:
>> >> https://lkml.org/lkml/2015/11/3/706
>> >>
>> >> Using LKL and fuse you can mount any kernel filesystem using fuse
>> >> as non-root.
>> >
>> > IOWs, because we said no to unprivileged mounts, instead the
>> > proposal is to linking all the kernel code into userspace so you can
>> > do unprivielged mounts that way?
>> >
>>
>> LKL's goal is to make it easy for various applications to reuse Linux
>> kernel code instead of re-implementing it. Mounting filesystem images
>> is just one of the applications.
>>
>> > IOWs, you get to say "it secure because it's in userspace" and leave
>> > us filesystem people with all the shit that comes with allowing
>> > users to mount random untrusted filesystem images using code that
>> > was never designed to allow that to happen?
>> >
>>
>> It is already possible to mount arbitrary filesystem images in
>> userspace using VMs . LKL doesn't change that, it just reduces the
>> amount of dependencies you need to do so.
>>
>
> Perhaps a dumb question, but I'm not quite putting 2+2 together here.
> When I see nommu, I'm generally thinking hardware characteristics, but
> we're talking about a userspace kernel library here. So can you
> elaborate on how this relates to nommu? Does this library emulate kernel
> mechanisms in userspace via nommu mode or something of that nature?
>

LKL is currently implemented as a virtual non-mmu architecture. That
makes it simpler and it will also allow us to support environments
where it is not possible to emulate paging (e.g.  bootloaders).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
