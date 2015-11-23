Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FD7E7F37
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 15:46:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FFCB8F8035
	for <xfs@oss.sgi.com>; Mon, 23 Nov 2015 13:46:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	W8nvdqRAte1EoXXq for <xfs@oss.sgi.com>;
	Mon, 23 Nov 2015 13:46:33 -0800 (PST)
Date: Tue, 24 Nov 2015 08:46:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: support for non-mmu architectures
Message-ID: <20151123214619.GG26718@dastard>
References: <1447800381-20167-1-git-send-email-octavian.purdila@intel.com>
	<20151119232455.GM14311@dastard>
	<CAE1zot+sqVnrothFX9e9y95RV435EnK5J4P40Rk+MQEwg4RJ=Q@mail.gmail.com>
	<20151120210833.GB26718@dastard>
	<CAE1zotKF8nqhuC70ERBWb_h58JWTJmz+YBXxeu9zhjhe61fNiA@mail.gmail.com>
	<20151122224450.GD26718@dastard>
	<CAE1zotLy5xEdjeoJaEZWtNYdehfXV+Mb2mQjMh2k5VdNd6B1GA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAE1zotLy5xEdjeoJaEZWtNYdehfXV+Mb2mQjMh2k5VdNd6B1GA@mail.gmail.com>
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

On Mon, Nov 23, 2015 at 03:41:49AM +0200, Octavian Purdila wrote:
> On Mon, Nov 23, 2015 at 12:44 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Nov 21, 2015 at 12:26:47AM +0200, Octavian Purdila wrote:
> >> On Fri, Nov 20, 2015 at 11:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > On Fri, Nov 20, 2015 at 03:43:20PM +0200, Octavian Purdila wrote:
> >> >> On Fri, Nov 20, 2015 at 1:24 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> > On Wed, Nov 18, 2015 at 12:46:21AM +0200, Octavian Purdila wrote:
> >> >> >> Naive implementation for non-mmu architectures: allocate physically
> >> >> >> contiguous xfs buffers with alloc_pages. Terribly inefficient with
> >> >> >> memory and fragmentation on high I/O loads but it may be good enough
> >> >> >> for basic usage (which most non-mmu architectures will need).
> >> >> >
> >> >> > Can you please explain why you want to use XFS on low end, basic
> >> >> > non-MMU devices? XFS is a high performance, enterprise/HPC level
> >> >> > filesystem - it's not a filesystem designed for small IoT level
> >> >> > devices - so I'm struggling to see why we'd want to expend any
> >> >> > effort to make XFS work on such devices....
> >> >> >
> >> >>
> >> >> Hi David,
> >> >>
> >> >> Yes XFS as the main fs on this type of devices does not make sense,
> >> >> but does it hurt to be able to perform basic operation on XFS from
> >> >> these devices? Perhaps accessing an external medium formatted with
> >> >> XFS?
> >> >>
> >> >> Another example is accessing VM images that are formatted with XFS.
> >> >> Currently we can do that with tools like libguestfs that use a VM in
> >> >> the background. I am working on a lighter solution for that where we
> >> >> compile the Linux kernel as a library [1]. This allows access to the
> >> >> filesystem without the need to use a full VM.
> >> >
> >> > That's hardly a "lighter solution"
> >> >
> >> > I'm kinda tired of the ongoing "hack random shit" approach to
> >> > container development.
> >>
> >> Since apparently there is a container devs hunting party going on
> >> right now, let me quickly confess that LKL has nothing to do with
> >> (them be damned) containers :)
> >>
> >> On a more serious note, LKL was not developed for containers or to try
> >> to circumvent privileged mounts. It was developed to allow the Linux
> >> kernel code to be reused in things like simple tools that allows one
> >> to modify a filesystem image.
> >
> > Anything tool that modifies an XFS filesystem that is not directly
> > maintained by the XFS developers voids any kind of support we can
> > supply. Just like the fact we don't support tainted kernels because
> > the 3rd party binary code is unknowable (and usually crap), having
> > the kernel code linked with random 3rd party userspace application
> > code is completely unsupportable by us.
> >
> 
> Perhaps tainting the kernel is a solution when running unknown
> applications linked with LKL.

It's not the *kernel* that is the problem - it is LKL that is the
tainted code!

> I would argue that applications that are maintained together with LKL
> (e.g. lklfuse in tools/lkl) should not taint the kernel because those
> applications will be under the control of kernel developers.

I completely disagree. Just because the code is in the kernel tree,
it doesn't mean it's controlled, reviewed, tested or maintained by
the relevant subsystem maintainers. If the subsystem maintainers are
not actively maintaining/testing those tools, then users can't
expect the subsystem maintainers to support them.


> I would
> also argue that mounting a filesystem read-only should not taint the
> kernel either.

LKL != kernel.

> >> >> And a final example is linking the bootloader code with LKL to access
> >> >> the filesystem. This has a hard requirement on non-mmu.
> >> >
> >> > No way. We *can't* support filesystems that have had bootloaders
> >> > make arbitrary changes to the filesystem without the knowlege of the
> >> > OS that *owns the filesystem*. Similarly, we cannot support random
> >> > applications that internally mount and modify filesystem images in
> >> > ways we can't see, control, test or simulate.  Sure, they use the
> >> > kernel code, but that doesn't stop them from doing stupid shit that
> >> > could corrupt the filesystem image. So, no, we are not going to
> >> > support giving random applications direct access to XFS filesystem
> >> > images, even via LKL.
> >> >
> >>
> >> LKL only exports the Linux kernel system calls and nothing else to
> >> applications. Because of that, there should not be any loss of control
> >> or visibility to the XFS fs driver.
> >
> > It runs in the same address space as the user application, yes? And
> > hence application bugs can cause the kernel code to malfunction,
> > yes?
> >
> 
> Most non-mmu architecture have the same issue and nevertheless non-mmu
> is still supported in Linux (including most filesystems).

That doesn't mean all subsystems in the kernel support users on
non-mmu systems.

> Also, filesystem code runs in the same address space with other kernel
> code and drivers and a bug anywhere in the kernel can cause filesystem
> code to malfunction.

Well, yes, but we have trust other kernel developers keep their ship
in good shape, too. But we don't trust *out of tree code* - that
taints the kernel and most upstream kernel developers will notice
such taints when there are weird errors being reported....

But you want to extend that trust to whatever random code gets
chucked into tools/lkl. I'm stretched far enough already having to
keep up with mm, VFS, locking and filesystem developments that I
don't have time to keep up with what LKL is doing or what
applications people are writing. You're not going to get subsystem
maintainers being able to find the time to review and test
applications that get stuffed into tools/lkl, so from that
perspective it's still a complete crapshoot.

> >> > I really don't see how using LKL to give userspace access to XFS
> >> > filesystems is a better solution than actually writing a proper,
> >> > supported XFS-FUSE module. LKL is so full of compromises that it's
> >> > going to be unworkable and unsupportable in practice...
> >>
> >> Could you elaborate on some of these issues?
> >
> > Start with "is a no-mmu architecture" and all the compromises that
> > means the kernel code needs to make,
> 
> I don't see non-mmu as a compromise. It is supported by Linux and most
> filesystems work fine on non-mmu architectures.

most != all.

XFS is unashamedly aimed and developed for high performance systems.
i.e. enterprise servers, HPC, fileservers, cloud storage
infrastructure, etc. IOWs, we don't even develop for desktop
machines, even though XFS performs adequately for most desktop
workloads.  We've never cared about non-mmu systems because of the
requirements we have on virtually mapped buffers and the fact they
don't exist in the target markets XFS aimed at. And, really, LKL
doesn't change that...

> LKL can be implemented
> as a mmu architecture. Having it as a non-mmu architecture has the
> advantages of allowing it to run in more constrained environments like
> bootloaders.

The OS owns the filesystem, not the bootloader. If the bootloader is
modifying filesystems (e.g. by running log recovery to mount the fs
internally to find the kernel/initrd files), then the boot loader
compromises the filesystem integrity. We don't not support such
configurations at all.


> > and finish it off with "LKL linked applications will
> > never be tested by their developers over the full functionality the
> > LKL provides them with".
> 
> You lost me here. Why does an application developer have to test the
> full functionality of a library it is linked with?

How much filesystem testing did you actually do with lklfuse? What
about load testing? Data integrity/crash/power fail and recovery
testing?  Scalability testing?  Or have you just assumed that it'll
all just work fine because the kernel fs developers test this stuff?

Yes, we've tested the kernel code along these lines *in kernel
space*. That doesn't mean that an LKL application that uses the
kernel functionality *in user space* will behave the same way or,
indeed, function correctly in adverse circumstances. Application
developers are not going to be aware of such issues, and they aren't
going to test for such situations - they are simply going to assume
"this works just fine" until it doesn't....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
