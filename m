Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34539 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033352AbdDTQmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 12:42:35 -0400
Date: Thu, 20 Apr 2017 09:41:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: kill __uint*_t and __int*_t
Message-ID: <20170420164144.GB23371@birch.djwong.org>
References: <20160807173835.GA20839@nyan>
 <20160809083332.GA1489@infradead.org>
 <20160823223500.GZ19025@dastard>
 <20160823232640.GG8268@birch.djwong.org>
 <20160824210749.GB25162@nyan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160824210749.GB25162@nyan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Felix Janda <felix.janda@posteo.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

[change to new linux-xfs list]

On Wed, Aug 24, 2016 at 11:07:49PM +0200, Felix Janda wrote:
> Darrick J. Wong wrote:
> > On Wed, Aug 24, 2016 at 08:35:00AM +1000, Dave Chinner wrote:
> > > On Tue, Aug 09, 2016 at 01:33:32AM -0700, Christoph Hellwig wrote:
> > > > On Sun, Aug 07, 2016 at 07:38:35PM +0200, Felix Janda wrote:
> > > > > Replace them by the more widely used uint*_t and int*_t.
> > > > > 
> > > > > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > > > > ---
> > > > > This patch is essentially a global
> > > > > 'sed -i "s/__\(u*\)int\([0-9]*\)_t/\1int\2_t/"'. The only other changes
> > > > > are whitespace changes and removing the now unecessary type definitions.
> > > > > 
> > > > > Running 'sed "s/^.//"' on the patch might be useful for checking that
> > > > > I didn't mess up the indentation.
> > > > 
> > > > If everyone is fine using (u)int*_t over s*/u* this looks good.  I'd
> > > > have a slight preference for s*/u* as in the rest of the kernel, but
> > > > either way getting rid of our crazy __ types is a good thing.
> > > 
> > > Don't really care that much. I'd prefer (marginally) to go with the
> > > (u)int*_t types as userspace then doesn't need a set of typedefs in
> > > the platform headers to support the kernel specific types in libxfs
> > > code....
> > 
> > I don't mind moving from __uintXX_t to uintXX_t so long as the changes
> > land in the kernel and xfsprogs at the same time.
> 
> When everyone is ok with the changes, I'll prepare patches for both of
> them.

Hmm... perhaps it is time to revisit this, now that reflink has landed?

--D

> 
> --Felix
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
