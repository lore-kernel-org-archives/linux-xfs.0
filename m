Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADABC43334
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 18:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiFYSuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jun 2022 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiFYSuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jun 2022 14:50:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEF0FD3B;
        Sat, 25 Jun 2022 11:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dxiSuEDqNQpQfdu0h+/s1zt9hZCxMuSdfyQntiOukqc=; b=QI7ySEnrUl1qZdgscIxUUw5elG
        5ljNtwLs2zuslYId3bQHrdJagxYT+jWW0pYFgnE/cIShkecb47b3I7Jlvdfod5ASuUAtXeqsnEE5+
        xt8X/iwsAGETAgr/0bRD5tj1up5UNWHQ844x5fnfgrrP2woUaFF6/Kqz8n/T6ucKqqaezz9S09isy
        AS8yGklsqX+9NrA8haCSsR/Gqjha+2PqaVMhQ9XKIhNWDEOiMva5BQRWJzi+w9asfT0EXkNTcR84R
        5kkTNc4EVpFKveMUCu9rIes2XQefxydUgZf+JM5t0txUoYgZHgewdzkcVH6byCQsQp2vlTdrbjuBB
        3kA5SIRQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o5Aqw-007HSk-PF; Sat, 25 Jun 2022 18:49:54 +0000
Date:   Sat, 25 Jun 2022 11:49:54 -0700
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
Message-ID: <YrdY0h3z0Rcw36AJ@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
 <YrZAtOqQERpYbBXg@bombadil.infradead.org>
 <YrZxPlTQ9f/BvnkJ@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrZxPlTQ9f/BvnkJ@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 24, 2022 at 10:21:50PM -0400, Theodore Ts'o wrote:
> On Fri, Jun 24, 2022 at 03:54:44PM -0700, Luis Chamberlain wrote:
> > 
> > Perhaps I am not understanding what you are suggesting with a VM native
> > solution. What do you mean by that? A full KVM VM inside the cloud?
> 
> "Cloud native" is the better way to put things.  Cloud VM's
> are designed to be ephemeral, so the concept of "node bringup" really
> doesn't enter into the picture.
> 
> When I run the "build-appliance" command, this creates a test
> appliance image.  Which is to say, we create a root file system image,
> and then "freeze" it into a VM image.

So this seems to build an image from a base distro image. Is that right?
And it would seem your goal is to store that image then after so it can
be re-used.

> For kvm-xfstests this is a qcow image which is run in snapshot mode,
> which means that if any changes is made to the root file system, those
> changes disappear when the VM exits.

Sure, so you use one built image once, makes sense.

You are optimizing usage for GCE. That makes sense. The goal behind
kdevops was to use technology which can *enable* any optimizations in
a cloud agnostic way. What APIs become public is up to the cloud
provider, and one cloud agnostic way to manage cloud solutions using
open source tools is with terraform and so that is used today. If an API
is not yet avilable through terraform kdevops could simply use whatever
cloud tool for additional hooks. But having the ability to ramp up
regardless of cloud provider was extremely important to me from the
beginning.

Optimizing is certainly possible, always :)

Likewise, if you using local virtualized, we can save vagrant images
in the vagrant cloud, if we wanted, which would allow pre-built setups
saved:

https://app.vagrantup.com/boxes/search

That could reduce speed for when doing bringup for local KVM /
Virtualbox guests.

In fact since vagrant images are also just tarballs with qcow2 files,
I do wonder if they can be also leveraged for cloud deployments. Or if
the inverse is true, if your qcow2 images can be used for vagrant
purposes as well. If you're curious:

https://github.com/linux-kdevops/kdevops/blob/master/docs/custom-vagrant-boxes.md

What approach you use is up to you. From a Linux distribution perspective
being able to do reproducible builds was important too, and so that is
why a lot of effort was put to ensure how you cook up a final state from
an initial distro release was supported.

> I can very quickly have over 100 test VM's running in parallel, and as
> the tests complete, they are automatically shutdown and destroyed ----
> which means that we don't store state in the VM.  Instead the state is
> stored in a Google Cloud Storage (Amazon S3) bucket, with e-mail sent
> with a summary of results.

Using cloud object storage is certainly nice if you can afford it. I
think it is valuable, but likewise should be optional. And so with
kdevops support is welcomed should someone want to do that. And so
what you describe is not impossible with kdevops it is just not done
today, but could be enabled.

> VM's can get started much more quickly than "make bringup", since
> we're not running puppet or ansible to configure each node.

You can easily just use pre-built images as well instead of doing
the build from a base distro release, just as you could use custom
vagrant images for local KVM guests.

The usage of ansible to *build* fstests and install can be done once
too and that image saved, exported, etc, and then re-used. The kernel
config I maintain on kdevops has been tested to work on local KVM
virtualization setups, but also all supported cloud providers as well.

So I think there is certainly value in learning from the ways you 
optimizing cloud usage for GCE and generalizing that for *any* cloud
provider.

The steps to get to *build* an image from a base distro release is
glanced over but that alone takes effort and is made pretty well
distro agnostic within kdevops too.

> In contrast, I can just run "gce-xfstests ls-results" to see all of
> the results that has been saved to GCS, and I can fetch a particular
> test result to my laptop via a single command: "gce-xfstests
> get-results tytso-20220624210238".  No need to ssh to a host node, and
> then ssh to the kdevops test node, yadda, yadda, yadda --- and if you
> run "make destroy" you lose all of the test result history on that node,
> right?

Actually all the *.bad, *.dmesg as well as final xunit results for all
nodes for failed tests is copied over locally to the host which is
running kdevops. Xunit files are also merged to represent a final full set
of results too. So no not destroyed. If you wanted to keep all files even
for non-failed stuff we can add that as a new Kconfig bool.

Support for stashing results into object storage sure would be nice, agreed.

> See the difference?

Yes you have optimized usage of GCE. Good stuff, lots to learn from that effort!
Thanks for sharing the details!

  Luis
