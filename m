Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:50307 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbeKTHzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 02:55:07 -0500
Date: Tue, 20 Nov 2018 08:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] xfstests: add copy/dedupe/clone to fsx/fsstress
Message-ID: <20181119212931.GJ19305@dastard>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <20181119052251.GQ2279@dhcp-12-117.nay.redhat.com>
 <20181119104547.GR2279@dhcp-12-117.nay.redhat.com>
 <20181119163809.GX4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119163809.GX4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 19, 2018 at 08:38:09AM -0800, Darrick J. Wong wrote:
> On Mon, Nov 19, 2018 at 06:45:47PM +0800, Zorro Lang wrote:
> > On Mon, Nov 19, 2018 at 01:22:52PM +0800, Zorro Lang wrote:
> > > On Tue, Nov 13, 2018 at 03:39:37PM -0800, Darrick J. Wong wrote:
> > > > Hi all,
> > > > 
> > > > This series adds to fsx support for FICLONERANGE, FIDEDUPERANGE, and
> > > > copy_file_range.  It adds to fsstress support for copy_file_range.
> > > > There are known failures in 4.20-rc2, particularly with copy_file_range,
> > > > so these patches provide a fstests base for everyone to start/continue
> > > > looking for bugs.
> > > 
> > > Hi Darrick,
> > > 
> > > Your patches triggered 2 new failures on g/091 and g/263, refer to [1]. I can't
> > > reproduce these failures on original xfstests [2]. I saw you were talking about g/091
> > > in #xfs. Are these two failures same issue?
> 
> Most probably.  Dave and I are still digging through all the new
> failures that show up in g/091, g/263, and g/127 once clonerange starts
> happening.

Yup, there's lots of bugs in the code that fsx now exercises. These
tests will now fail until we get the fixes into the upstream kernel.

And, really, even when these tests pass (as they do on my machines
now) fsx still fails. I have at least 4 different failures which
occur at between 350k and 5m ops that I can reproduce. These tests
only run about 10-100k ops, so they don't trip over the bugs I
haven't found and fixed yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
