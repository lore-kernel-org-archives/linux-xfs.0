Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211A6C43334
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 22:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiFXWy6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 18:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiFXWy5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 18:54:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBEB457AB;
        Fri, 24 Jun 2022 15:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jEdDDZc0ENpCVOv0wcwtsTkb8sZL0vFROAXT6s2ZCME=; b=o01vfCjH+mrIa1/jh8oEGdbFsC
        S7AMyT68olrXWiAUzGX4/qf/fg98NQerf8jfYvTfhFzb+if7PmYJy7P44rdpzk5wSHlZOkExHyYAo
        LdhrQo1t6MdDHINLivjFZSi5bt4E7d2hV9m95wi5kufhtdKrBWKTkNQm3BMKybiDNCse8ZmB/jhzv
        k1JrDCXZgz53Y/Lomu/fn4bamTfnzjHA5jX9gnsQRf1Gd4Cw3M+caVBfUH0AANRTVyYdC8yyXMDuQ
        GgIELT8QI0o2VSnGMoJI4Eprri454SngoFVLkcP7x7rbS7wzp5Aq2MoOWgrz8MUT5MOEYFuRpLxvf
        0Yu/MEEw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o4sCK-0043Rx-JW; Fri, 24 Jun 2022 22:54:44 +0000
Date:   Fri, 24 Jun 2022 15:54:44 -0700
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
Message-ID: <YrZAtOqQERpYbBXg@bombadil.infradead.org>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrJdLhHBsolF83Rq@bombadil.infradead.org>
 <YrONPrBgopZQ2EUj@mit.edu>
 <YrTboFa4usTuCqUb@bombadil.infradead.org>
 <YrVMZ7/rJn11HH92@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrVMZ7/rJn11HH92@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 24, 2022 at 01:32:23AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 23, 2022 at 02:31:12PM -0700, Luis Chamberlain wrote:
> > 
> > To be clear, you seem to suggest gce-xfstests is a VM native solution.
> > I'd also like to clarify that kdevops supports native VMs, cloud and
> > baremetal. With kdevops you pick your bringup method.
> 
> Yes, that was my point.  Because gce-xfstests is a VM native solution,
> it has some advantages, such as the ability to take advantage of the
> fact that it's trivially easy to start up multiple cloud VM's which
> can run in parallel --- and then the VM's shut themselves down once
> they are done running the test, which saves cost and is more
> efficient.

Perhaps I am not understanding what you are suggesting with a VM native
solution. What do you mean by that? A full KVM VM inside the cloud?

Anyway, kdevops has support to bring up whatever type of node you want
in the clouds providers: GCE, AWS, Azure, and OpenStack and even custom
OpenStack solutions. That could be a VM or a high end bare metal node.
It does this by using terraform and providing the variability through
kconfig.

The initial 'make bringup' brings nodes up, and then all work runs on
each in parallel for fstests as you run 'make fstests-baseline'. At the
end you just run 'make destroy'.

> It is *because* that we are a VM-native solution that we can optimize
> in certain ways because we don't have to also support a bare metal
> setup.  So yes, the fact that kdevops also supports bare metal is
> certainly granted.  That that kind of flexibility is an advantage for
> kdevops, certainly; but being able to fully take advantage of the
> unqiue attributes of cloud VM's can also be a good thing.

Yes, agreed. That is why I focused on technology that would support
all cloud providers, not just one.

I had not touched code for AWS code for example in 2 years, I just
went and tried a bringup and it worked in 10 minutes, most of the time
was getting my .aws/credentials file set up with information from the
website.

> > kdevops started as an effort for kernel development and filesystems
> > testing. It is why the initial guest configuration was to use 8 GiB
> > of RAM and 4 vcpus, that suffices to do local builds / development.
> > I always did kernel development on guests back in the day still do
> > to this day.
> 
> For kvm-xfstests, the default RAM size for the VM is 2GB.  One of the
> reasons why I was interested in low-memory configurations is because
> ext4 is often used in smaller devices (such as embedded systesm and
> mobile handsets) --- and running in memory constrained environments
> can turn up bugs that otherwise are much harder to reproduce on a
> system with more memory.

Yes, I agree. We started with 8 GiB. Long ago while at SUSE I tried 2GiB
and ran into the xfs/074 issue of requiring more due to xfs_scratch.
Then later Amir ran into snags with xfs/084 and generic/627 due to the
OOMs. So in terms of XFS to avoid OOMs with just the tests we need 3GiB.

> Separating the kernel build system from the test VM's means that the
> build can take place on a really powerful machine (either my desktop
> with 48 cores and gobs and gobs of memory, or a build VM if you are
> using the Lightweight Test Manager's Kernel Compilation Service) so
> builds go much faster.  And then, of course, we can then launch a
> dozen VM's, one for each test config.  If you force the build to be
> done on the test VM, then you either give up parallelism, or you waste
> time by building the kernel N times on N test VM's.

The build is done once but I agree this can be optimized for kdevops.

Right now in kdevops the git clone and build of the kernel does take
place on each guest, and that requires at least 3 GiB of RAM. Shallow
git clone support was added as option to help here but the ideal thing
will be to just build locally or perhaps as you suggest dedicated build
VM.

> And in the case of the android-xfstests, which communicates with a
> phone or tablet over a debugging serial cable and Android's fastboot
> protocol, of *course* it would be insane to want to build the kernel
> on the system under test!
> 
> So I've ***always*** done the kernel build on a machine or VM separate
> from the System Under Test.  At least for my use cases, it just makes
> a heck of a lot more sense.

Support for this will be added to kdevops.

> And that's fine.  I'm *not* trying to convince everyone that my test
> infrastructure everyone should standardize on.  Which quite frankly, I
> sometimes think you have been evangelizing.  I believe very strongly
> that the choice of test infrastructures is a personal choice, which is
> heavily dependent on each developer's workflow, and trying to get
> everyone to standardize on a single test infrastructure is likely
> going to work as well as trying to get everyone to standardize on a
> single text editor.

What I think we *should* standardize on is at least configurations
for testing. And now the dialog of how / if we track / share failures
is also important.

What runner you use is up to you.

> (Although obviously emacs is the one true editor.  :-)
> 
> > Sure, the TODO item on the URL seemed to indicate there was a desire to
> > find a better place to put failures.
> 
> I'm not convinced the "better place" is expunge files.  I suspect it
> may need to be some kind of database.  Darrick tells me that he stores
> his test results in a postgres database.  (Which is way better than
> what I'm doing which is an mbox file and using mail search tools.)
> 
> Currently, Leah is using flat text files for the XFS 5.15 stable
> backports effort, plus some tools that parse and analyze those text
> files.

Where does not matter yet, what I'd like to refocus on is *if* sharing
is desirable by folks. We can discuss *how* and *where* if we do think
it is worth to share.

If folks would like to evaluate this I'd encourage to do so perhaps
after a specific distro release moving forward, and to not backtrack.

But for stable kernels I'd imagine it may be easier to see value in
sharing.

> I'll also note that the number of baseline kernel versions is much
> smaller if you are primarily testing an enterprise Linux distribution,
> such as SLES.

Much smaller than what? Android? If so then perhaps. Just recall that
Enterprise supports kernels for at least 10 years.

> And if you are working with stable kernels, you can
> probably get away with having updating the baseline for each LTS
> kernel every so often.  But for upstream kernels development the
> number of kernel versions for which a developer might want to track
> flaky percentages and far greater, and will need to be updated at
> least once every kernel development cycle, and possibly more
> frequently than that.  Which is why I'm not entirely sure a flat text
> file, such as an expunge file, is really the right answer.  I can
> completely understand why Darrick is using a Postgres database.
> 
> So there is clearly more thought and design required here, in my
> opinion.

Sure, let's talk about it, *if* we do find it valuable to share.
kdevops already has stuff in a format which is consistent, that
can change or be ported. We first just need to decide if we want
to as a community share.

The flakyness annotations are important too, and we have a thread
about that, which I have to go and get back to at some point.

> > That is not a goal, the goal is allow variability! And share results
> > in the most efficient way.
> 
> Sure, but are expunge files the most efficient way to "share results"?

There are three things we want to do if we are going to talk about
sharing results:

a) Consuming expunges so check.sh for the Node Under Test (NUT) can expand
   on the expunges given a criteria (flakyness, crash requirements)

b) Sharing updates to expunges per kernel / distro / runner / node-config
   and making patches to this easy.

c) Making updates for failures easy to read for a developer / community.
   These would be in the form of an email or results file for a test
   run through some sort of kernel-ci.

Let's start with a):

We can adopt runners to use anything. My gut tells me postgres is
a bit large unless we need socket communication. I can think of two
ways to go here then. Perhaps others have some other ideas?

1) We go lightweight on the db, maybe sqlite3 ? And embrace the same
   postgres db schema as used by Darrick if he sees value in sharing
   this. If we do this I think it does't make sense to *require*
   sqlite3 on the NUT (nodes), for many reasons, so parsing the db
   on the host to a flat file to be used by the node does seem
   ideal.

2) Keep postgres and provide a REST api for queries from the host to
   this server so it can then construct a flat file / directory
   interpreation of expunges for the nodes under test (NUT).

Given the minimum requirements desirable on the NUTs I think in the end
a flat file hierarchy is nice so to not incur some new dependency on
them.

Determinism is important for tests though so snapshotting a reflection
interpretion of expunges at a specific point in time is also important.
So the database would need to be versioned per updates, so a test is
checkpointed against a specific version of the expunge db.

If we come to some sort of consensus then this code for parsing an
expunge set can be used from directly on fstests's check script, so the
interpreation and use can be done in one place for all test runners.
We also have additional criteria which we may want for the expunges.
For instance, if we had flakyness percentage annotated somehow then
fstests's check could be passed an argument to only include expunges
given a certain flakyness level of some sort, or for example only
include expunges for tests which are known to crash.

Generating the files from a db is nice. But what gains do we have
with using a db then?

Now let's move on to b) sharing the expunges and sending patches for
updates. I think sending a patch against a flat file reads a lot easier
except for the comments / flakyness levels / crash consideration / and
artifacts. For kdevop's purposes this reads well today as we don't
upload artifacts anywhere and just refer to them on github gists as best
effort / optional. There is no convention yet on expression of flakyness
but some tests do mention "failure rate" in one way or another.

So we want to evaluate if we want to share not only expunges but other
meta data associated to why a new test can be expunged or removed:

 * flakyness percentage
 * cause a kernel crash?
 * bogus test?
 * expunged due to a slew of a tons of other reasons, some of them maybe
   categorized and shared, some of them not

And do we want to share artifacts? If so how? Perhaps an optional URL,
with another component describing what it is, gist, or a tarball, etc.

Then for the last part c) making failures easy to read to a developer
let's review what could be done. I gather gce-xfstests explains the
xunit results summary. Right now kdevop's kernel-ci stuff just sends
an email with the same but also a diff to the expunge file hierarchy
augmented for the target kernel directory being tested. The developer
would just go and edit the line with meta data as a comment, but that
is just because we lack a structure for it. If we strive to share
an expunge list I think it would be wise to consider structure for
this metadata.

Perhaps:

<test> # <crashes>|<flayness-percent-as-fraction>|<fs-skip-reason>|<artifact-type>|<artifact-dir-url>|<comments>

Where:

test:                         xfs/123 or btrfs/234
crashes:                      can be either Y or N
flayness-percent-as-percentage: 80%
fs-skip-reason:               can be an enum to represent a series of 
                              fs specific reasons why a test may not be
			      applicable or should be skipped
artifact-type:                optional, if present the type of artifact,
                              can be enum to represent a gist test
			      description, or a tarball
artifact-dir-url:             optional, path to the artifact
comments:                     additional comments

All the above considered, a) b) and c), yes I think a flat file
model works well as an option. I'd love to hear other's feedback.

> If we have a huge amount of variability, such that we have a large
> number of directories with different test configs and different
> hardware configs, each with different expunge files, I'm not sure how
> useful that actually is.

*If* you want to share I think it would be useful.

At least kdevops uses a flat file model with no artifacts, just the
expunges and comments, and over time it has been very useful, even to be
able to review historic issues on older kernels by simply using
something like 'git grep xfs/123' gives me a quick sense of history of
issues of a test.

> Are we expecting users to do a "git clone",
> and then start browsing all of these different expunge files by hand?

If we want to extend fstests check script to look for this, it could
be an optional directory and an arugment could be pased to check so
to enable its hunt for it, so that if passed it would look for the
runner / kernel / host-type. For instance today we already have
a function on initialization for the check script which looks for
the fstests' config file as follows:

known_hosts()
{
	[ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs

	[ -f /etc/xfsqa.config ] && export HOST_OPTIONS=/etc/xfsqa.config
	[ -f $HOST_CONFIG_DIR/$HOST ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST
	[ -f $HOST_CONFIG_DIR/$HOST.config ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST.config
}

We could have something similar look for an expugne directory of say
say --expunge-auto-look and that could be something like:

process_expunge_dir()
{
	[ "$HOST_EXPUNGE_DIR" ] || HOST_EXPUNGE_DIR=`pwd`/expunges

	[ -d /etc/fstests/expunges/$HOST ] && export HOST_EXPUNGES=/etc/fstests/expunges/$HOST
	[ -d $HOST_EXPUNGE_DIR/$HOST ] && export HOST_EXPUNGES=$HOST_EXPUNGE_DIR/$HOST
}

The runner could be specified, and the host-type

./check --runner <gce-xfstests|kdevops|whatever> --host-type <kvm-8vcpus-2gb>

And so we can have it look for these directory and if any of these are used
processed (commulative):

  * HOST_EXPUNGES/any/$fstype/                       - regardless of kernel, host type and runner
  * HOST_EXPUNGES/$kernel/$fstype/any                - common between runners for any host type
  * HOST_EXPUNGES/$kernel/$fstype/$hostype           - common between runners for a host type
  * HOST_EXPUNGES/$kernel/$fstype/$hostype/$runner   - only present for the runner

The aggregate set of expugnes are used.

Additional criteria could be passed to check so to ensure that only
certain expunges that meet the criteria are used to skip tests for the
run, provided we can agree on some metatdata for that.

> It might perhaps be useful to get a bit more clarity about how we
> expect the shared results would be used, because that might drive some
> of the design decisions about the best way to store these "results".

Sure.

  Luis
