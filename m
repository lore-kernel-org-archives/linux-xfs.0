Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D07247F37
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 16:26:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C415B304043
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 14:26:51 -0800 (PST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id HCbKtM5hEL1M1lCR
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Nov 2015 14:26:48 -0800 (PST)
Received: by wmvv187 with SMTP id v187so90982043wmv.1
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 14:26:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151120210833.GB26718@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAE1zot+sqVnrothFX9e9y95RV435EnK5J4P40Rk+MQEwg4RJ=Q@mail.gmail.com>
	<20151120210833.GB26718@dastard>
Date: Sat, 21 Nov 2015 00:26:47 +0200
Message-ID: <CAE1zotKF8nqhuC70ERBWb_h58JWTJmz+YBXxeu9zhjhe61fNiA@mail.gmail.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Nov 20, 2015 at 11:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Nov 20, 2015 at 03:43:20PM +0200, Octavian Purdila wrote:
>> On Fri, Nov 20, 2015 at 1:24 AM, Dave Chinner <david@fromorbit.com> wrote:
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
>> >
>>
>> Hi David,
>>
>> Yes XFS as the main fs on this type of devices does not make sense,
>> but does it hurt to be able to perform basic operation on XFS from
>> these devices? Perhaps accessing an external medium formatted with
>> XFS?
>>
>> Another example is accessing VM images that are formatted with XFS.
>> Currently we can do that with tools like libguestfs that use a VM in
>> the background. I am working on a lighter solution for that where we
>> compile the Linux kernel as a library [1]. This allows access to the
>> filesystem without the need to use a full VM.
>
> That's hardly a "lighter solution"
>
> I'm kinda tired of the ongoing "hack random shit" approach to
> container development.

Since apparently there is a container devs hunting party going on
right now, let me quickly confess that LKL has nothing to do with
(them be damned) containers :)

On a more serious note, LKL was not developed for containers or to try
to circumvent privileged mounts. It was developed to allow the Linux
kernel code to be reused in things like simple tools that allows one
to modify a filesystem image.

> If you need a XFS-FUSE module to allow safe
> userspace access to XFS fielsystems then maybe, just maybe, it makes
> sense to ask the XFS developers how to best go about providing a
> reliable, up-to-date, tested, maintained and supported XFS-FUSE
> module?
>
> IOWs, a "lighter solution" is to use the libxfs code base that we
> already maintain across kernel and userspace in the xfsprogs package
> and write a FUSE wrapper around that. That, immediately, will give
> you full read-only access to XFS filesystem images via FUSE. Then we
> (the XFS developers) can test the XFS-FUSE module under normal
> development conditions as we modify the xfsprogs code base (e.g. via
> xfstests) and ensure we always release a working, up-to-date FUSE
> wrapper with each xfsprogs release.
>
> And then once a proper read-only FUSE wrapper has been written, then
> we can discuss what is necessary to enable write access via porting
> the necessary parts of the kernel code across to the userspace
> libxfs codebase and hooking them up to the FUSE API...
>
> Hmmm?
>

What about ext4, vfat, btrfs and other filesystems? Also why duplicate
the whole thing if you could reuse it?

>> And a final example is linking the bootloader code with LKL to access
>> the filesystem. This has a hard requirement on non-mmu.
>
> No way. We *can't* support filesystems that have had bootloaders
> make arbitrary changes to the filesystem without the knowlege of the
> OS that *owns the filesystem*. Similarly, we cannot support random
> applications that internally mount and modify filesystem images in
> ways we can't see, control, test or simulate.  Sure, they use the
> kernel code, but that doesn't stop them from doing stupid shit that
> could corrupt the filesystem image. So, no, we are not going to
> support giving random applications direct access to XFS filesystem
> images, even via LKL.
>

LKL only exports the Linux kernel system calls and nothing else to
applications. Because of that, there should not be any loss of control
or visibility to the XFS fs driver.

>> So, IMHO there are usecases for using XFS on non-mmu architectures. I
>> think it all boils down to: is the patch simple enough to not put an
>> unreasonable maintenance burden on developers?
>
> Look at it this way: a user tries to mount their
> XFS-on-LKL-on-FUSE, XFS throughs a memory allocation deadlock
> warning because of a high order allocation during mount failing
> (i.e. due to the vmalloc no-mmu hacks).
>
> Who has to spend effort to find out why the error is being thrown?
> It's not the FUSE developers. It's not the LKL developers. XFS is
> going to be blamed, because it's an XFS error message, and it will
> be up to the XFS developers to /prove/ that it's not an XFS problem.
> And then google will find these complaints about XFS causing all
> sorts of problems, and we're back to the bad old days of everyone
> blaming XFS for shortcomings and problems in other code we have no
> control over..
>
> I really don't see how using LKL to give userspace access to XFS
> filesystems is a better solution than actually writing a proper,
> supported XFS-FUSE module. LKL is so full of compromises that it's
> going to be unworkable and unsupportable in practice...
>

Could you elaborate on some of these issues?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
