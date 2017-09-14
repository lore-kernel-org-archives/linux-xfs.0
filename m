Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:61291
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbdINAk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 20:40:58 -0400
Date: Thu, 14 Sep 2017 10:40:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170914004038.GZ10621@dastard>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
> > /me shrugs
> >
> > I just don't like the concept of using tracepoints to as a
> > definitive diagnostic test for something working because it'll break
> > when the kernel implementation and tracepoints change. So while we
> > can probe for perf being present, we can't probe whether the
> > tracepoint we need behaves as the test expects it to...
> 
> That concern makes sense.
> 
> We handle that it a crude way in the libnvdimm unit tests by hard
> coding a required minimum kernel version and rolling a test forward to
> depend on a new kernel when assumptions about the kernel-internals
> change. The tests also inject out-of-tree kernel modules that let us
> go after specific kernel internal behavior. With this approach we
> don't end up creating userspace ABI since the test explicitly loads
> out-of-tree modules.

That's horrible. OT, but how are distros or anyone backporting
libnvdimm fixes and features supposed to test their kernels work
correctly with such a test harness?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
