Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E2DC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 21:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbiFYVOm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jun 2022 17:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiFYVOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jun 2022 17:14:42 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C737013DFB;
        Sat, 25 Jun 2022 14:14:40 -0700 (PDT)
Received: from letrec.thunk.org (c-24-1-67-28.hsd1.il.comcast.net [24.1.67.28])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25PLEH4X009312
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Jun 2022 17:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1656191661; bh=LRIkBUv889bL15Zq2DCYsX/cJde6yqFPpsya1BF+JU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Xo2925hem9NbHuMKvUNLJ8nsRZwcBDaM7YZ8Mz0Ai00GJXbs0+hsH+XS1QPeW3ESv
         3EZn7qca5KhsL3Cs31tj2xYjhI3KP/sqpFl22ZX4TS+L6YrQ5mOGQDbF4yEj3uaxP0
         wWDrt1P7XnGgloqt8FgRfxOwN9AxnFdJfCKfOAiLf8dU2PaYQTF9TpS/myagzI1rWQ
         ODX3u/teKiAuFTcTAvy6+hR3bnaOr/3H0w9+GVsWyhcg7fnJ9hBaGtv8/YbPkY/ISx
         +Jz+V5usE1HPBKrJmmZQKN/iKtqtz9XmIKu27OMDcKA7qObfYw0Yrn4usVCHa3HMOO
         1IitMZqvTNE1A==
Received: by letrec.thunk.org (Postfix, from userid 15806)
        id 507E08C3689; Sat, 25 Jun 2022 17:14:17 -0400 (EDT)
Date:   Sat, 25 Jun 2022 17:14:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <Yrd6qTZ4cJuakD6s@mit.edu>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <YrZxPlTQ9f/BvnkJ@mit.edu>
 <YrdY0h3z0Rcw36AJ@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrdY0h3z0Rcw36AJ@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 25, 2022 at 11:49:54AM -0700, Luis Chamberlain wrote:
> You are optimizing usage for GCE. That makes sense.

This particular usage model is not unique to GCE.  A very similar
thing can be done using Microsoft Azure, Amazon Web Services and
Oracle Cloud Services.  And I've talked to some folks who might be
interested in taking the Test Appliance that is currently built for
use with KVM, Android, and GCE, and extending it to support other
Cloud infrastructures.  So the concept of these optimizations are not
unique to GCE, which is why I've been calling this approach "cloud
native".

Perhaps one other difference is that I make the test appliance images
available, so people don't *have* to build them from scratch.  They
can just download the qcow2 image from:

    https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

And for GCE, there is the public image project, xfstests-cloud, just
like there are public images for debian in the debian-cloud project,
for Fedora in the fedora-cloud project, etc.  Of course, for full GPL
compliance, how to build these images from source is fully available,
which is why the images are carefully tagged so all of the git commit
versions and the automated scripts used to build the image are fully
available for anyone who wants to replicate the build.  *BUT*, they
don't have to build the test environment if they are just getting
started.

One of the things which I am trying to do is to make the "out of box"
experience as simple as possible, which means I don't want to force
users to build the test appliance or run "make bringup" if they don't
have to.   

Of course, someone who is doing xfstests development will need to
learn how to build their own test appliance.  But for someone who is
just getting started, the goal is to make the learning curve as flat
as possible.

One of the other things that was important design principles for me
was I didn't want to require that the VM's have networking access, nor
did I want to require users to be able to have to run random scripts
via sudo or as root.  (Some of this was because of corporate security
requirements at the time.)  This also had the benefit that I'm not
asing the user to set up ssh keys if they are using kvm-xfstests, but
instead rely on the serial console.

> The goal behind kdevops was to use technology which can *enable* any
> optimizations in a cloud agnostic way.

Fair enough.  My goal for kvm-xfstests and gce-xfstests was to make
developer velocity the primary goal.  Portability to different cloud
systems took a back seat.  I don't apologize for this, since over the
many years that I've been personally using {kvm,gce}-xfstests, the
fact that I can use my native kernel development environment, and have
the test environment pluck the kernel straight out of my build tree,
has paid for itself many times over.

If I had to push test/debug kernel code to a public git tree just so
the test VM can pull donwn the code and build it in the test VM a
second time --- I'd say, "no thank you, absolutely not."  Having to do
this would slow me down, and as I said, developer velocity is king.  I
want to be able to save a patch from my mail user agent, apply the
patch, and then give the code a test, *without* having to interact
with a public git tree.

Maybe you can do that with kdevops --- but it's not at all obvious
how.  With kvm-xfstests, I have a quickstart doc which gives
instructions, and then it's just a matter of running the command
"kvm-xfstests smoke" or "kvm-xfstests shell" from the developer's
kernel tree.  No muss, no fuss, no dirty dishes....

> In fact since vagrant images are also just tarballs with qcow2 files,
> I do wonder if they can be also leveraged for cloud deployments. Or if
> the inverse is true, if your qcow2 images can be used for vagrant
> purposes as well. 

Well, my qcow2 images don't come with ssh keys, since they are
optimized to be launched from the kvm-xfstests script, where the tests
to be run are passed in via the boot command line:

% kvm-xfstests smoke --no-action
Detected kbuild config; using /build/ext4-4.14 for kernel
Using kernel /build/ext4-4.14/arch/x86/boot/bzImage
Networking disabled.
Would execute:
         ionice -n 5 /usr/bin/kvm -boot order=c -net none -machine type=pc,accel=kvm:tcg \
	 -cpu host -drive file=/usr/projects/xfstests-bld/build-64/test-appliance/root_fs.img,if=virtio,snapshot=on \
	 ....
	-gdb tcp:localhost:7499 --kernel /build/ext4-4.14/arch/x86/boot/bzImage \
	--append "quiet loglevel=0 root=/dev/vda console=ttyS0,115200 nokaslr fstestcfg=4k fstestset=-g,quick fstestopt=aex fstesttz=America/New_York fstesttyp=ext4 fstestapi=1.5 orig_cmdline=c21va2UgLS1uby1hY3Rpb24="

The boot command line options "fstestcfg=4k", "fstestset=-g,quick",
"fstesttyp=ext4", etc. is how the test appliance knows which tests to
run.  So that means *all* the developer needs to do is to type command
"kvm-xfstests smoke".

(By the way, it's a simple config option in ~/.config/kvm-xfstests if
you are a btrfs or xfs developer, and you want the default file system
type to be btrfs or xfs.  Of course you can explicitly specify a test
config if you are an ext4 developer and,, you want to test how a test
runs on xfs: "kvm-xfstests -c xfs/4k generic/223".)

There's no need to set up ssh keys, push the kernel to a public git
tree, ssh into the test VM, yadda, yadda, yadda.  Just one single
command line and you're *done*.

This is what I meant by the fact that kvm-xfstests is optimized for a
file system developer's workflow, which I claim is very different from
what a QA department might want.  I added that capability to
gce-xfstests later, but it's very separate from the very simple
command lines for a file system developer.  If I want the lightweight
test manager to watch a git tree, and to kick off a build whenever a
branch changes, and then run a set of tests, I can do that, but that's
a *very* different command and a very different use case, and I've
optimized for that separately:

    gce-xfstests ltm -c ext4/all -g auto --repo ext4.dev --watch dev

This is what I call the QA department's workflow.  Which is also
totally valid.  But I believe in optimizing for each workflow
separately, and being somewhat opinionated in my choices.

For example, the test appliance uses Debian.  Period.  And that's
because I didn't see the point of investing time in making that be
flexible.  My test infrastructure is optimized for a ***kernel***
developer, and from that perspective, the distro for the test
environment is totally irrelevant.

I understand that if you are working for SuSE, then maybe you would
want to insist on a test environment based on OpenSuSE, or if you're
working for Red Hat, you'd want to use Fedora.  If so, then
kvm-xfstests is not for you.  I'd much rather optimize for a *kernel*
developer, not a Linux distribution's QA department.  They can use
kdevops if they want, for that use case.  :-)

Cheers,

							- Ted
