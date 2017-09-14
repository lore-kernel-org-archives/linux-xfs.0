Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:43462 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdINOKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 10:10:04 -0400
Received: by mail-io0-f169.google.com with SMTP id k101so750201iod.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 07:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
References: <20170912153820.GA5000@linux.intel.com> <20170912234729.GW10621@dastard>
 <20170913144215.GA12395@linux.intel.com> <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard> <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard> <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
 <x49a81xeakx.fsf@segfault.boston.devel.redhat.com> <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Sep 2017 07:10:02 -0700
Message-ID: <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Thu, Sep 14, 2017 at 6:16 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Thu, Sep 14, 2017 at 08:19:58AM -0400, Jeff Moyer wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>> > On Wed, Sep 13, 2017 at 5:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
>> >>> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >>> > /me shrugs
>> >>> >
>> >>> > I just don't like the concept of using tracepoints to as a
>> >>> > definitive diagnostic test for something working because it'll break
>> >>> > when the kernel implementation and tracepoints change. So while we
>> >>> > can probe for perf being present, we can't probe whether the
>> >>> > tracepoint we need behaves as the test expects it to...
>> >>>
>> >>> That concern makes sense.
>> >>>
>> >>> We handle that it a crude way in the libnvdimm unit tests by hard
>> >>> coding a required minimum kernel version and rolling a test forward to
>> >>> depend on a new kernel when assumptions about the kernel-internals
>> >>> change. The tests also inject out-of-tree kernel modules that let us
>> >>> go after specific kernel internal behavior. With this approach we
>> >>> don't end up creating userspace ABI since the test explicitly loads
>> >>> out-of-tree modules.
>> >>
>> >> That's horrible. OT, but how are distros or anyone backporting
>> >> libnvdimm fixes and features supposed to test their kernels work
>> >> correctly with such a test harness?
>> >
>> > The upstream kernel version for the test to assume can be overridden
>> > by an environment variable. It has worked well so far for me when I'm
>> > using it it to test backports, but I don't have much in the way of
>> > third-party feedback.
>>
>> It sucks.  :-)  What we really want is to depend on a feature being
>> available, not on a kernel version.  We did discuss this a while ago.
>> Let me go dig it up...
>>   https://lists.01.org/pipermail/linux-nvdimm/2017-March/009253.html
>>
>> We never came to any real conclusion on a good way forward, though.
>
> I think I already said this before [1], but can't we make a "features"
> sysfs/debugfs attribute with one bit set for each feature implemented? This
> definitively would help when running the test-suite on a backport.
>
> [1] https://lists.01.org/pipermail/linux-nvdimm/2016-March/004963.html

What discouraged me from going that route in the past is the busy work
of tracking / syncing these new debugfs feature gate flags across 2
source repositories. If we want to stop depending on kernel version in
the test suite over time I think the only sane way to manage that
tight integration is to get ndctl into the kernel tree proper.

...but please say a bit more about the actual pain points with the
current environment variable approach. You want to be able to have a
debugfs directory that has something like:

/featureA
/featureB
/featureC
/fixX
/fixY
/fixZ
/quirkQ

...where, depending on backport priorities, a subset of those may not
exist? Does having the test suite in the kernel tree help or hurt what
you're trying to do?
