Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48395 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750999AbdIMOmR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Sep 2017 10:42:17 -0400
Date: Wed, 13 Sep 2017 08:42:15 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170913144215.GA12395@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
 <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170912234729.GW10621@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 09:47:29AM +1000, Dave Chinner wrote:

<>

> I think similar concerns exist with using perf, too....

I though that using perf addressed both concerns?

> > > So what happens when the user is already tracing the test to
> > > find a bug and the test turns all their tracing off?

By using perf we isolate our tracing from whatever other tracing is happening
in the system.  So, unlike the case where we were messing with a system-wide
ftrace knob, we run perf on our executable, and someone else can run perf on
their executable, and they don't collide.

> > > Regardless of this screwing up developer bug triage, do we really
> > > want to add a dependency on kernel tracing into the test harness?

Yep, you're right that this adds a dependency on perf.  But unfortunately,
without using either perf or ftrace, I don't know of a way to detect whether
or not DAX is actually being used.  Can you think of another way?

I tried to do this correctly and just skip the test with _notrun if perf isn't
available on the host system.  This is the same thing that happens if you are
missing other dependencies for a test (some other command (chacl, getfattr,
setfattr) not present, quota tools not installed, required users not present,
etc).
