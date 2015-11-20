Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 625207F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 08:26:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EC146AC001
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 06:26:31 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id 1fX7Ef6DtWMFHLez
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2015 06:26:30 -0800 (PST)
Received: by wmec201 with SMTP id c201so23242579wme.1
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 06:26:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151120005843.GP14311@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAFLxGvx9x-4gnCQh7203G72Jy+EULbMnGTK=2r3ko=Yy9FB7Wg@mail.gmail.com>
	<20151120005843.GP14311@dastard>
Date: Fri, 20 Nov 2015 16:26:28 +0200
Message-ID: <CAE1zotLw-vCz2qF4JmXEYFF_yPbkhQ2HEEYxMwvdRbhKRCaxTw@mail.gmail.com>
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
Cc: Richard Weinberger <richard.weinberger@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 2:58 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Nov 20, 2015 at 12:54:02AM +0100, Richard Weinberger wrote:
>> On Fri, Nov 20, 2015 at 12:24 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
>> >> Naive implementation for non-mmu architectures: allocate physically
>> >> contiguous xfs buffers with alloc_pages. Terribly inefficient with
>> >> memory and fragmentation on high I/O loads but it may be good enough
>> >> for basic usage (which most non-mmu architectures will need).
>> >
>> > Can you please explain why you want to use XFS on low end, basic
>> > non-MMU devices? XFS is a high performance, enterprise/HPC level
>> > filesystem - it's not a filesystem designed for small IoT level
>> > devices - so I'm struggling to see why we'd want to expend any
>> > effort to make XFS work on such devices....
>>
>> The use case is the Linux Kernel Library:
>> https://lkml.org/lkml/2015/11/3/706
>>
>> Using LKL and fuse you can mount any kernel filesystem using fuse
>> as non-root.
>
> IOWs, because we said no to unprivileged mounts, instead the
> proposal is to linking all the kernel code into userspace so you can
> do unprivielged mounts that way?
>

LKL's goal is to make it easy for various applications to reuse Linux
kernel code instead of re-implementing it. Mounting filesystem images
is just one of the applications.

> IOWs, you get to say "it secure because it's in userspace" and leave
> us filesystem people with all the shit that comes with allowing
> users to mount random untrusted filesystem images using code that
> was never designed to allow that to happen?
>

It is already possible to mount arbitrary filesystem images in
userspace using VMs . LKL doesn't change that, it just reduces the
amount of dependencies you need to do so.

Could you expand of what burden does this use-case put on fs
developers? I am sure that, if needed, we can put restrictions in LKL
to avoid that.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
