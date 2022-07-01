Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B01C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 23:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiGAXIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Jul 2022 19:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiGAXIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Jul 2022 19:08:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD3C1E3C3;
        Fri,  1 Jul 2022 16:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zDiCUv2JzaSw9XYKJuy9jzuUUopnNOaPEHa7MWH5U10=; b=Oz1wPL3UQxn3lduIRHskT/2dGW
        6MC9uVsSqXe9wOiv/uApVgMkcDOYySydkyChMNd1jFKzecOMTZkI/dlDqhaQQd4D1sMScno6aZhlE
        Q7R4EMnDzppAQO6f4TShrwPtP9Da8mK+yBELWocyjOOD4JvEYicEbE3oVKcpW0BoRyMWkaJ+lz2Fg
        mZZkHqfnK3z+LvJCZ9B/uMU3vWiivz1vk63bB7EpIPpZTEYO9swvkiMw2PaFziwqFI7qErJMtstC5
        CUAtgEIk5/sAiMlA6K4RRdCWeOHT0cleGqKorGh71LC0XXXZPBsXNQCw48FpczkMcv4FfTLXT5gZ8
        9N8sqJyw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7PkZ-007N4x-Q8; Fri, 01 Jul 2022 23:08:35 +0000
Date:   Fri, 1 Jul 2022 16:08:35 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
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
Message-ID: <Yr9+c8SyBe04VXpS@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <YrZxPlTQ9f/BvnkJ@mit.edu>
 <YrdY0h3z0Rcw36AJ@bombadil.infradead.org>
 <Yrd6qTZ4cJuakD6s@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrd6qTZ4cJuakD6s@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 25, 2022 at 05:14:17PM -0400, Theodore Ts'o wrote:
> On Sat, Jun 25, 2022 at 11:49:54AM -0700, Luis Chamberlain wrote:
> > You are optimizing usage for GCE. That makes sense.
> 
> This particular usage model is not unique to GCE.  A very similar
> thing can be done using Microsoft Azure, Amazon Web Services and
> Oracle Cloud Services.  And I've talked to some folks who might be
> interested in taking the Test Appliance that is currently built for
> use with KVM, Android, and GCE, and extending it to support other
> Cloud infrastructures.  So the concept of these optimizations are not
> unique to GCE, which is why I've been calling this approach "cloud
> native".

I think we have similar goals. I'd like to eventually generalize
what you have done for enablement through *any* cloud.

And, I suspect this may not just be useful for kernel development too
and so there is value in that for other things.

> Perhaps one other difference is that I make the test appliance images
> available, so people don't *have* to build them from scratch.  They
> can just download the qcow2 image from:
> 
>     https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests

It may make sense for us to consider containers for some of this.

If a distro doesn't have one, for example, well then we just have
to do the build-it-all-step.

> And for GCE, there is the public image project, xfstests-cloud, just
> like there are public images for debian in the debian-cloud project,
> for Fedora in the fedora-cloud project, etc.  Of course, for full GPL
> compliance, how to build these images from source is fully available,
> which is why the images are carefully tagged so all of the git commit
> versions and the automated scripts used to build the image are fully
> available for anyone who wants to replicate the build.  *BUT*, they
> don't have to build the test environment if they are just getting
> started.
> 
> One of the things which I am trying to do is to make the "out of box"
> experience as simple as possible, which means I don't want to force
> users to build the test appliance or run "make bringup" if they don't
> have to.   

You are misunderstanding the goal with 'make bringup', if you already
have pre-built images you can use them and you have less to do. You
*don't* have to run 'make fstests' if you already have that set up.

'make bringup' just abstracts general initial stage nodes, whether on
cloud or local virt.

'make linux' however does get / build / install linux.

And for local virtualization there whedre vagrant images are used
one could enhance these further too. They are just compressed tarball
with a qcow2 file at least when libvirt is used. Since kdevops works off
of these, you can then also use pre-built images with all kernel/modules
need and even binaries. I've extended docs recently to help folks who wish
to optimize on that front:

https://github.com/linux-kdevops/kdevops/blob/master/docs/custom-vagrant-boxes.md

Each stage has its own reproducible builds aspect to it.

So if one *had* these enhanced vagrant images with kernels, one could
just skip the build stage and jump straight to testing after bringup.

I do wonder if we could share simiular qcow2 images for cloud testing
too and for vagrant. If we could... there is a pretty big win.

> Of course, someone who is doing xfstests development will need to
> learn how to build their own test appliance.  But for someone who is
> just getting started, the goal is to make the learning curve as flat
> as possible.

Yup.

> One of the other things that was important design principles for me
> was I didn't want to require that the VM's have networking access, nor
> did I want to require users to be able to have to run random scripts
> via sudo or as root.  (Some of this was because of corporate security
> requirements at the time.)  This also had the benefit that I'm not
> asing the user to set up ssh keys if they are using kvm-xfstests, but
> instead rely on the serial console.

Philosphy.

> > The goal behind kdevops was to use technology which can *enable* any
> > optimizations in a cloud agnostic way.
> 
> Fair enough.  My goal for kvm-xfstests and gce-xfstests was to make
> developer velocity the primary goal.  Portability to different cloud
> systems took a back seat.  I don't apologize for this, since over the
> many years that I've been personally using {kvm,gce}-xfstests, the
> fact that I can use my native kernel development environment, and have
> the test environment pluck the kernel straight out of my build tree,
> has paid for itself many times over.

Yes I realize that. No one typically has time to do that. Which is why
when I had my requirements from a prior $employer to do the tech do
something cloud agnostic, I decided it was tech best shared. It was not
easy.

> If I had to push test/debug kernel code to a public git tree just so
> the test VM can pull donwn the code and build it in the test VM a
> second time --- I'd say, "no thank you, absolutely not."  Having to do
> this would slow me down, and as I said, developer velocity is king.  I
> want to be able to save a patch from my mail user agent, apply the
> patch, and then give the code a test, *without* having to interact
> with a public git tree.

Every developer may have a different way to work and do Linux kernel
development.

> Maybe you can do that with kdevops --- but it's not at all obvious
> how.

The above just explained what you *don't* want to do, not what you want.
But you explained to me in private a while ago you expect to do local
test builds fast to guest.

I think you're just missing that the goal is to support variability
and enable that variability. If such variability is not supported
then its just a matter of adding a few kconfig options and then
adding support for it. So yes its possible and its a matter of
taking a bit of time to do that workflow. My kdev workflow was to
just work with large guests before, and use 'localmodconfig' kernels
which are very small, and so build time is fast, specially after the
first build. The other worklow I then supported was the distro world
one where we tested a "kernel of the day" which is a kernel on a repo
somewhere. So upgradng is just ensuring you have a repo and `zypper in`
the kernel, reboot and test.

To support the workflow you have I'd like to evaluate both a local virt
solution and cloud (for any cloud vendor). For local virt using 9p seems to
make sense. For cloud, not so sure.

I think we really digress from the subject at hand though. This
conversation is useful but it really is just noise to a lot of people.

  Luis
