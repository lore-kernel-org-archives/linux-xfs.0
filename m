Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55055 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932340AbdJZS1j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:27:39 -0400
Date: Thu, 26 Oct 2017 12:32:17 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] xfsprogs: Issue smaller discards at mkfs
Message-ID: <20171026183216.GA27317@localhost.localdomain>
References: <20171026144131.26885-1-keith.busch@intel.com>
 <20171026162518.GW5483@magnolia>
 <3ad1751a-a4df-b0ee-d2c5-d1ac4deb5b46@sandeen.net>
 <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d50ca3b-0b27-8ac1-c102-9ea656f3f926@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 01:01:29PM -0500, Eric Sandeen wrote:
> On 10/26/17 12:49 PM, Eric Sandeen wrote:
> > Yeah, lots of devices are unhappy with large discards.  And yeah, in the
> > end I think this papers over a kernel and/or hardware problem.
> > 
> > But sometimes we do that, if only to keep things working reasonably
> > well with older kernels or hardware that'll never get fixed...
> > 
> > (TBH sometimes I regret putting mkfs-time discard in by default in the
> > first place.)
> 
> I think I left this on a too-positive note.  It seems pretty clear that there
> is no way to fix all of userspace to not issue "too big" discards, when
> "too big" isn't even well-defined, or specified by anything at all.

Yeah, I totally get this proposal is just a bandaid, and other user
space programs may suffer when used with devices behaving this way. XFS
is just very popular, so it's frequently reported as problematic against
large capacity devices.
 
> I'm not wise in the ways of queueing and throttling, but from my naiive
> perspective, it seems like something to be fixed in the kernel, or if it
> can't, export some new "maximum discard request size" which can be trusted?

The problem isn't really that a discard sent to the device was "too
big". It's that "too many" are issued at the same time, and there isn't
a way for a driver to limit the number of outstanding discards without
affecting read/write.
