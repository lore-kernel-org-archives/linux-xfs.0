Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FEC17F37
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2015 16:45:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B5CDAC001
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2015 14:45:08 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rQgyONIyu7krdESB for <xfs@oss.sgi.com>;
	Sun, 22 Nov 2015 14:45:04 -0800 (PST)
Date: Mon, 23 Nov 2015 09:44:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151122224450.GD26718@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAE1zot+sqVnrothFX9e9y95RV435EnK5J4P40Rk+MQEwg4RJ=Q@mail.gmail.com>
	<20151120210833.GB26718@dastard>
	<CAE1zotKF8nqhuC70ERBWb_h58JWTJmz+YBXxeu9zhjhe61fNiA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAE1zotKF8nqhuC70ERBWb_h58JWTJmz+YBXxeu9zhjhe61fNiA@mail.gmail.com>
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
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Sat, Nov 21, 2015 at 12:26:47AM +0200, Octavian Purdila wrote:
> On Fri, Nov 20, 2015 at 11:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Nov 20, 2015 at 03:43:20PM +0200, Octavian Purdila wrote:
> >> On Fri, Nov 20, 2015 at 1:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> >> >> Naive implementation for non-mmu architectures: allocate physically
> >> >> contiguous xfs buffers with alloc_pages. Terribly inefficient with
> >> >> memory and fragmentation on high I/O loads but it may be good enough
> >> >> for basic usage (which most non-mmu architectures will need).
> >> >
> >> > Can you please explain why you want to use XFS on low end, basic
> >> > non-MMU devices? XFS is a high performance, enterprise/HPC level
> >> > filesystem - it's not a filesystem designed for small IoT level
> >> > devices - so I'm struggling to see why we'd want to expend any
> >> > effort to make XFS work on such devices....
> >> >
> >>
> >> Hi David,
> >>
> >> Yes XFS as the main fs on this type of devices does not make sense,
> >> but does it hurt to be able to perform basic operation on XFS from
> >> these devices? Perhaps accessing an external medium formatted with
> >> XFS?
> >>
> >> Another example is accessing VM images that are formatted with XFS.
> >> Currently we can do that with tools like libguestfs that use a VM in
> >> the background. I am working on a lighter solution for that where we
> >> compile the Linux kernel as a library [1]. This allows access to the
> >> filesystem without the need to use a full VM.
> >
> > That's hardly a "lighter solution"
> >
> > I'm kinda tired of the ongoing "hack random shit" approach to
> > container development.
> 
> Since apparently there is a container devs hunting party going on
> right now, let me quickly confess that LKL has nothing to do with
> (them be damned) containers :)
> 
> On a more serious note, LKL was not developed for containers or to try
> to circumvent privileged mounts. It was developed to allow the Linux
> kernel code to be reused in things like simple tools that allows one
> to modify a filesystem image.

Anything tool that modifies an XFS filesystem that is not directly
maintained by the XFS developers voids any kind of support we can
supply. Just like the fact we don't support tainted kernels because
the 3rd party binary code is unknowable (and usually crap), having
the kernel code linked with random 3rd party userspace application
code is completely unsupportable by us.

Remember that with most kernel code a bug just results in a panic
and reboot, and everything just continues on again after the system
comes up again. In contrast, a bug in the storage code can cause
*persistent damage* that can cause data loss or corruption that
cannot be fixed without data loss of some kind.

Ultimately, as the maintainer I'm responsible for XFS not eating our
users' data, and part of that responsibility involves telling people
who want to do daft things that "no, that's a *bad idea*".

> > If you need a XFS-FUSE module to allow safe
> > userspace access to XFS fielsystems then maybe, just maybe, it makes
> > sense to ask the XFS developers how to best go about providing a
> > reliable, up-to-date, tested, maintained and supported XFS-FUSE
> > module?
> >
> > IOWs, a "lighter solution" is to use the libxfs code base that we
> > already maintain across kernel and userspace in the xfsprogs package
> > and write a FUSE wrapper around that. That, immediately, will give
> > you full read-only access to XFS filesystem images via FUSE. Then we
> > (the XFS developers) can test the XFS-FUSE module under normal
> > development conditions as we modify the xfsprogs code base (e.g. via
> > xfstests) and ensure we always release a working, up-to-date FUSE
> > wrapper with each xfsprogs release.
> >
> > And then once a proper read-only FUSE wrapper has been written, then
> > we can discuss what is necessary to enable write access via porting
> > the necessary parts of the kernel code across to the userspace
> > libxfs codebase and hooking them up to the FUSE API...
> >
> > Hmmm?
> >
> 
> What about ext4, vfat, btrfs and other filesystems?

Ted has also raised exactly the same issues w.r.t. ext4.

> Also why duplicate
> the whole thing if you could reuse it?

Do you use a hammer when you need to tighten a screw? Yes, you can
"reuse a hammer" for this purpose, but there's going to be
collateral damage because using the screw outside it's original
design and architecture constraints presents a high risk of things
going wrong.

> >> And a final example is linking the bootloader code with LKL to access
> >> the filesystem. This has a hard requirement on non-mmu.
> >
> > No way. We *can't* support filesystems that have had bootloaders
> > make arbitrary changes to the filesystem without the knowlege of the
> > OS that *owns the filesystem*. Similarly, we cannot support random
> > applications that internally mount and modify filesystem images in
> > ways we can't see, control, test or simulate.  Sure, they use the
> > kernel code, but that doesn't stop them from doing stupid shit that
> > could corrupt the filesystem image. So, no, we are not going to
> > support giving random applications direct access to XFS filesystem
> > images, even via LKL.
> >
> 
> LKL only exports the Linux kernel system calls and nothing else to
> applications. Because of that, there should not be any loss of control
> or visibility to the XFS fs driver.

It runs in the same address space as the user application, yes? And
hence application bugs can cause the kernel code to malfunction,
yes?

> > I really don't see how using LKL to give userspace access to XFS
> > filesystems is a better solution than actually writing a proper,
> > supported XFS-FUSE module. LKL is so full of compromises that it's
> > going to be unworkable and unsupportable in practice...
> 
> Could you elaborate on some of these issues?

Start with "is a no-mmu architecture" and all the compromises that
means the kernel code needs to make, add a topping of "runs in the
same address space as the application", add a new flavour of kernel
binary taint and finish it off with "LKL linked applications will
never be tested by their developers over the full functionality the
LKL provides them with".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
