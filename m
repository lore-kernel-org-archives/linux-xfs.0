Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdINMUC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Sep 2017 08:20:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
References: <20170908152805.GA16646@linux.intel.com>
        <20170908212153.14880-1-ross.zwisler@linux.intel.com>
        <20170912064411.GR10621@dastard>
        <20170912153820.GA5000@linux.intel.com>
        <20170912234729.GW10621@dastard>
        <20170913144215.GA12395@linux.intel.com>
        <20170913220108.GX10621@dastard>
        <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
        <20170913233438.GY10621@dastard>
        <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
        <20170914004038.GZ10621@dastard>
        <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
Date: Thu, 14 Sep 2017 08:19:58 -0400
In-Reply-To: <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
        (Dan Williams's message of "Wed, 13 Sep 2017 18:24:10 -0700")
Message-ID: <x49a81xeakx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Dan Williams <dan.j.williams@intel.com> writes:

> On Wed, Sep 13, 2017 at 5:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
>>> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> > /me shrugs
>>> >
>>> > I just don't like the concept of using tracepoints to as a
>>> > definitive diagnostic test for something working because it'll break
>>> > when the kernel implementation and tracepoints change. So while we
>>> > can probe for perf being present, we can't probe whether the
>>> > tracepoint we need behaves as the test expects it to...
>>>
>>> That concern makes sense.
>>>
>>> We handle that it a crude way in the libnvdimm unit tests by hard
>>> coding a required minimum kernel version and rolling a test forward to
>>> depend on a new kernel when assumptions about the kernel-internals
>>> change. The tests also inject out-of-tree kernel modules that let us
>>> go after specific kernel internal behavior. With this approach we
>>> don't end up creating userspace ABI since the test explicitly loads
>>> out-of-tree modules.
>>
>> That's horrible. OT, but how are distros or anyone backporting
>> libnvdimm fixes and features supposed to test their kernels work
>> correctly with such a test harness?
>
> The upstream kernel version for the test to assume can be overridden
> by an environment variable. It has worked well so far for me when I'm
> using it it to test backports, but I don't have much in the way of
> third-party feedback.

It sucks.  :-)  What we really want is to depend on a feature being
available, not on a kernel version.  We did discuss this a while ago.
Let me go dig it up...
  https://lists.01.org/pipermail/linux-nvdimm/2017-March/009253.html

We never came to any real conclusion on a good way forward, though.

Cheers,
Jeff
