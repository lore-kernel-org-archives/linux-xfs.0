Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0D1C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 05:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiFXFcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 01:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXFck (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 01:32:40 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A965469257;
        Thu, 23 Jun 2022 22:32:38 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-118-63.bstnma.fios.verizon.net [173.48.118.63])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 25O5WNfp025626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 01:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1656048745; bh=uAKh3NUj4G1S3E0FBuW+i0JKjWjiL3EnZYYrNmT0gxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=WWh8EP1UjDs+hiniQbsL7wOwQg0rRaJfVJKEKaUrQLLmE93eWOoslEKwRyVtRUvY/
         6srxCFNJ8j88HD1P+e+2+fhsx8883EUZs8o+mC9+SZCLYwcQTuZkVTvHSP2AhmLi93
         7EpF/ewuzc/omb+Os/thcumaXVWbst7xYg8YTPmzjLtvf6eYKQ08nh5qkGJlzRVNP9
         vLWpar1aZpcMgXlGLgdkXNWC3z3ibEv2iyV9rYwwp9enzwK49idbVXtFfhJKEqZ6bc
         sxfpfA67X6EiuJdJ+XEVVNNDGbrOkP/EaEuydeNJNOIVlQFe0ef+qI2CPDawKcD8Mp
         0HMODNdLnNE2g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 122E415C42F6; Fri, 24 Jun 2022 01:32:23 -0400 (EDT)
Date:   Fri, 24 Jun 2022 01:32:23 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Chuck Lever <chuck.lever@oracle.com>, chandanrmail@gmail.com,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Pankaj Raghav <pankydev8@gmail.com>, linux-xfs@vger.kernel.org,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrVMZ7/rJn11HH92@mit.edu>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrTboFa4usTuCqUb@bombadil.infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 02:31:12PM -0700, Luis Chamberlain wrote:
> 
> To be clear, you seem to suggest gce-xfstests is a VM native solution.
> I'd also like to clarify that kdevops supports native VMs, cloud and
> baremetal. With kdevops you pick your bringup method.

Yes, that was my point.  Because gce-xfstests is a VM native solution,
it has some advantages, such as the ability to take advantage of the
fact that it's trivially easy to start up multiple cloud VM's which
can run in parallel --- and then the VM's shut themselves down once
they are done running the test, which saves cost and is more
efficient.

It is *because* that we are a VM-native solution that we can optimize
in certain ways because we don't have to also support a bare metal
setup.  So yes, the fact that kdevops also supports bare metal is
certainly granted.  That that kind of flexibility is an advantage for
kdevops, certainly; but being able to fully take advantage of the
unqiue attributes of cloud VM's can also be a good thing.

(I've already made offers to folks working at other cloud vendors that
if they are interested in adding support for other cloud systems
beyond GCE, I'm happy to work with them to enable the use of other
XXX-xfstests test-appliance runners.)

> kdevops started as an effort for kernel development and filesystems
> testing. It is why the initial guest configuration was to use 8 GiB
> of RAM and 4 vcpus, that suffices to do local builds / development.
> I always did kernel development on guests back in the day still do
> to this day.

For kvm-xfstests, the default RAM size for the VM is 2GB.  One of the
reasons why I was interested in low-memory configurations is because
ext4 is often used in smaller devices (such as embedded systesm and
mobile handsets) --- and running in memory constrained environments
can turn up bugs that otherwise are much harder to reproduce on a
system with more memory.

Separating the kernel build system from the test VM's means that the
build can take place on a really powerful machine (either my desktop
with 48 cores and gobs and gobs of memory, or a build VM if you are
using the Lightweight Test Manager's Kernel Compilation Service) so
builds go much faster.  And then, of course, we can then launch a
dozen VM's, one for each test config.  If you force the build to be
done on the test VM, then you either give up parallelism, or you waste
time by building the kernel N times on N test VM's.

And in the case of the android-xfstests, which communicates with a
phone or tablet over a debugging serial cable and Android's fastboot
protocol, of *course* it would be insane to want to build the kernel
on the system under test!

So I've ***always*** done the kernel build on a machine or VM separate
from the System Under Test.  At least for my use cases, it just makes
a heck of a lot more sense.

And that's fine.  I'm *not* trying to convince everyone that my test
infrastructure everyone should standardize on.  Which quite frankly, I
sometimes think you have been evangelizing.  I believe very strongly
that the choice of test infrastructures is a personal choice, which is
heavily dependent on each developer's workflow, and trying to get
everyone to standardize on a single test infrastructure is likely
going to work as well as trying to get everyone to standardize on a
single text editor.

(Although obviously emacs is the one true editor.  :-)

> Sure, the TODO item on the URL seemed to indicate there was a desire to
> find a better place to put failures.

I'm not convinced the "better place" is expunge files.  I suspect it
may need to be some kind of database.  Darrick tells me that he stores
his test results in a postgres database.  (Which is way better than
what I'm doing which is an mbox file and using mail search tools.)

Currently, Leah is using flat text files for the XFS 5.15 stable
backports effort, plus some tools that parse and analyze those text
files.

I'll also note that the number of baseline kernel versions is much
smaller if you are primarily testing an enterprise Linux distribution,
such as SLES.  And if you are working with stable kernels, you can
probably get away with having updating the baseline for each LTS
kernel every so often.  But for upstream kernels development the
number of kernel versions for which a developer might want to track
flaky percentages and far greater, and will need to be updated at
least once every kernel development cycle, and possibly more
frequently than that.  Which is why I'm not entirely sure a flat text
file, such as an expunge file, is really the right answer.  I can
completely understand why Darrick is using a Postgres database.

So there is clearly more thought and design required here, in my
opinion.

> That is not a goal, the goal is allow variability! And share results
> in the most efficient way.

Sure, but are expunge files the most efficient way to "share results"?
If we have a huge amount of variability, such that we have a large
number of directories with different test configs and different
hardware configs, each with different expunge files, I'm not sure how
useful that actually is.  Are we expecting users to do a "git clone",
and then start browsing all of these different expunge files by hand?

It might perhaps be useful to get a bit more clarity about how we
expect the shared results would be used, because that might drive some
of the design decisions about the best way to store these "results".

Cheers,

					- Ted
