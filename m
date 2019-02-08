Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36101 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfBHUGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 15:06:45 -0500
Date: Fri, 8 Feb 2019 12:06:40 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190208200640.GK11489@garbanzo.do-not-panic.com>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190206040559.GA4119@sasha-vm>
 <20190206215454.GG14116@dastard>
 <20190208060620.GA31898@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190208060620.GA31898@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Fri, Feb 08, 2019 at 01:06:20AM -0500, Sasha Levin wrote:
> On Thu, Feb 07, 2019 at 08:54:54AM +1100, Dave Chinner wrote:
> > On Tue, Feb 05, 2019 at 11:05:59PM -0500, Sasha Levin wrote:
> > > On Wed, Feb 06, 2019 at 09:06:55AM +1100, Dave Chinner wrote:
> > > >On Mon, Feb 04, 2019 at 08:54:17AM -0800, Luis Chamberlain wrote:
> > > >>Kernel stable team,
> > > >>
> > > >>here is a v2 respin of my XFS stable patches for v4.19.y. The only
> > > >>change in this series is adding the upstream commit to the commit log,
> > > >>and I've now also Cc'd stable@vger.kernel.org as well. No other issues
> > > >>were spotted or raised with this series.
> > > >>
> > > >>Reviews, questions, or rants are greatly appreciated.
> > > >
> > > >Test results?
> > > >
> > > >The set of changes look fine themselves, but as always, the proof is
> > > >in the testing...
> > > 
> > > Luis noted on v1 that it passes through his oscheck test suite, and I
> > > noted that I haven't seen any regression with the xfstests scripts I
> > > have.
> > > 
> > > What sort of data are you looking for beyond "we didn't see a
> > > regression"?
> > 
> > Nothing special, just a summary of what was tested so we have some
> > visibility of whether the testing covered the proposed changes
> > sufficiently.  i.e. something like:
> > 
> > 	Patchset was run through ltp and the fstests "auto" group
> > 	with the following configs:
> > 
> > 	- mkfs/mount defaults
> > 	- -m reflink=1,rmapbt=1
> > 	- -b size=1k
> > 	- -m crc=0
> > 	....
> > 
> > 	No new regressions were reported.
> > 
> > 
> > Really, all I'm looking for is a bit more context for the review
> > process - nobody remembers what configs other people test. However,
> > it's important in reviewing a backport to know whether a backport to
> > a fix, say, a bug in the rmap code actually got exercised by the
> > tests on an rmap enabled filesystem...
> 
> Sure! Below are the various configs this was run against.

To be clear, that was Sasha's own effort. I just replied with my own
set of test and results against the baseline to confirm no regressions
were found.

My tests run on 8-core kvm vms with 8 GiB of RAM, and qcow2 images which
reside on an XFS partition mounted on nvme drives on the hypervisor, the
hypervisor runs CentOS 7, on 3.10.0-862.3.2.el7.x86_64.

For the guest I use different qcow2 images. One is 100 GiB and is used
to expose a disk to the guest so it can use it where to store the files
use dfor the SCRATCH_DEV_POOL. For the SCRATCH_DEV_POOL I use loopback devices,
using files created on the guest's own /media/truncated/ partition,
using the 100 GiB partition. I end up with 8 loopback devices to test
for then:

SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11"

The loopback devices are setup using my oscheck's $(./gendisks.sh -d)
script.

Since Sasha seems to have a system rigged for testing XFS what I could
do is collaborate with Sasha to consolidate our sections for testing and
also have both of our systems run all tests to at least have two
different test systems confirming no regressions. That is, if Sasha
is up or that. Otherwise I'll continue with whatever rig I can get
my hands on each time I test.

I have an expunge list, and he has his own, we need to consolidate that
as well with time.

Since some tests have a failure rate which is not 1 -- ie, it doesn't
fail 100% of the time, I am considering adding a *spinner tester* for each
test which runs each test 1000 times and records when if first fails.
It assumes that if you can run a test 1000 times, we really don't have
it as an expunge. If there is a better term for failure rate let's use
it, just not familiar, but I'm sure this nomenclature must exist.

A curious thing I noted was that the ppc64le bug didn't actually fail
for me as a straight forward test. That is, I had to *first* manually
mkfs.xfs with the big block specification for the partition used for
TEST_DEV and then also the first device in SCRATCH_DEV_POOL with big
block. Only after I did this and then run the test did I get with 100%
failure rate the ability to trigger the failure.

It has me wondering how many other test may fail if we did the same.

  Luis
