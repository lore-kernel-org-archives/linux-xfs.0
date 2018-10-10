Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:13578 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbeJKEv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 00:51:26 -0400
Date: Thu, 11 Oct 2018 08:27:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfsprogs: document changes for 4.19.0-rc0
Message-ID: <20181010212720.GK6311@dastard>
References: <20181010071023.6765-1-david@fromorbit.com>
 <20181010071023.6765-2-david@fromorbit.com>
 <fb999fa8-0a0e-f63a-5082-0520de2fcef7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb999fa8-0a0e-f63a-5082-0520de2fcef7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 08:46:59AM -0500, Eric Sandeen wrote:
> On 10/10/18 2:10 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because 'make deb' breaks without them.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Ugh, sorry about that, still not used to build systems that break on unchangelogged git tags ...
> 
> 
> (that is the trigger, right?  the tag?)

No, it has nothing to do with git. The trigger is the package version
set in VERSION and/or configure.ac not matching the documentation,
which means it is in inconsistent state....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
