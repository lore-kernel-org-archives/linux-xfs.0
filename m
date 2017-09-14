Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:43100 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdINBYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 21:24:12 -0400
Received: by mail-io0-f179.google.com with SMTP id k101so11432539iod.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2017 18:24:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914004038.GZ10621@dastard>
References: <20170908152805.GA16646@linux.intel.com> <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard> <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard> <20170913144215.GA12395@linux.intel.com>
 <20170913220108.GX10621@dastard> <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard> <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Sep 2017 18:24:10 -0700
Message-ID: <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Sep 13, 2017 at 5:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
>> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > /me shrugs
>> >
>> > I just don't like the concept of using tracepoints to as a
>> > definitive diagnostic test for something working because it'll break
>> > when the kernel implementation and tracepoints change. So while we
>> > can probe for perf being present, we can't probe whether the
>> > tracepoint we need behaves as the test expects it to...
>>
>> That concern makes sense.
>>
>> We handle that it a crude way in the libnvdimm unit tests by hard
>> coding a required minimum kernel version and rolling a test forward to
>> depend on a new kernel when assumptions about the kernel-internals
>> change. The tests also inject out-of-tree kernel modules that let us
>> go after specific kernel internal behavior. With this approach we
>> don't end up creating userspace ABI since the test explicitly loads
>> out-of-tree modules.
>
> That's horrible. OT, but how are distros or anyone backporting
> libnvdimm fixes and features supposed to test their kernels work
> correctly with such a test harness?

The upstream kernel version for the test to assume can be overridden
by an environment variable. It has worked well so far for me when I'm
using it it to test backports, but I don't have much in the way of
third-party feedback.
