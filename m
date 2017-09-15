Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34476 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdIORjH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 13:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <20170915091845.pmp3wer5lwx2xhjz@linux-x5ow.site>
References: <20170913144215.GA12395@linux.intel.com> <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard> <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
 <20170914004038.GZ10621@dastard> <CAPcyv4iNcnq9sJVLeju-3Ua+XYfTscOb9iiWDS5yB768WJTOXQ@mail.gmail.com>
 <x49a81xeakx.fsf@segfault.boston.devel.redhat.com> <20170914131638.qxbzeocvrkhjcjcu@linux-x5ow.site>
 <CAPcyv4j4GUjQBa7ePUGLuHjZcf3G+0suvc7r6wmgGM_G_L5Gcw@mail.gmail.com> <20170915091845.pmp3wer5lwx2xhjz@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Sep 2017 10:39:05 -0700
Message-ID: <CAA9_cmdrV13OgnRxpd0W9yYGBm4XP=fdTHDZvCBk4YR7gt8M5g@mail.gmail.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Sep 15, 2017 at 2:18 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Thu, Sep 14, 2017 at 07:10:02AM -0700, Dan Williams wrote:
>> What discouraged me from going that route in the past is the busy work
>> of tracking / syncing these new debugfs feature gate flags across 2
>> source repositories. If we want to stop depending on kernel version in
>> the test suite over time I think the only sane way to manage that
>> tight integration is to get ndctl into the kernel tree proper.
>>
>> ...but please say a bit more about the actual pain points with the
>> current environment variable approach.
>
> This means the person which executes the test-suite has to know on which
> feature level (upstream kernel version) the downstream kernel is, I can't
> demand such knowledge from QA.

Ok, that makes sense. The libnvdimm unit test suite needs to grow up
into something QA can run and not require developers with internals
knowledge.

>
>> You want to be able to have a debugfs directory that has something like:
>>
>> /featureA
>> /featureB
>> /featureC
>> /fixX
>> /fixY
>> /fixZ
>> /quirkQ
>>
>> ...where, depending on backport priorities, a subset of those may not
>> exist?
>
> Yes, I thought of a bitmask in one (or two files but a file per feature is OK)
> as well. The idea is borrowed from Daniel Vetter's "Bothing up ioctl()s" blog
> entry [1]:
> "Have a clear way for userspace to figure out whether your new ioctl or ioctl
> extension is supported on a given kernel. If you can't rely on old kernels
> rejecting the new flags/modes or ioctls (since doing that was botched in the
> past) then you need a driver feature flag or revision number somewhere."
>

Yes, but what we're worried about in the libnvdimm/nfit_test case is
internals behind sysfs interfaces. But point taken, we can at least
use the presence of certain attributes to gate tests. However, it does
mean we lose the tests for when an attribute is missing due to an
incomplete backport.
