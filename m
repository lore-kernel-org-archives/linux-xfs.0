Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6AC347CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 18:27:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6A30AC002
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 16:27:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QJS0o7pg9nbHG101 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 16:27:10 -0700 (PDT)
Date: Tue, 23 Aug 2016 16:26:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: kill __uint*_t and __int*_t
Message-ID: <20160823232640.GG8268@birch.djwong.org>
References: <20160807173835.GA20839@nyan> <20160809083332.GA1489@infradead.org>
	<20160823223500.GZ19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160823223500.GZ19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Felix Janda <felix.janda@posteo.de>, xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 08:35:00AM +1000, Dave Chinner wrote:
> On Tue, Aug 09, 2016 at 01:33:32AM -0700, Christoph Hellwig wrote:
> > On Sun, Aug 07, 2016 at 07:38:35PM +0200, Felix Janda wrote:
> > > Replace them by the more widely used uint*_t and int*_t.
> > > 
> > > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > > ---
> > > This patch is essentially a global
> > > 'sed -i "s/__\(u*\)int\([0-9]*\)_t/\1int\2_t/"'. The only other changes
> > > are whitespace changes and removing the now unecessary type definitions.
> > > 
> > > Running 'sed "s/^.//"' on the patch might be useful for checking that
> > > I didn't mess up the indentation.
> > 
> > If everyone is fine using (u)int*_t over s*/u* this looks good.  I'd
> > have a slight preference for s*/u* as in the rest of the kernel, but
> > either way getting rid of our crazy __ types is a good thing.
> 
> Don't really care that much. I'd prefer (marginally) to go with the
> (u)int*_t types as userspace then doesn't need a set of typedefs in
> the platform headers to support the kernel specific types in libxfs
> code....

I don't mind moving from __uintXX_t to uintXX_t so long as the changes
land in the kernel and xfsprogs at the same time.

Basically, I use stgit with my kernel/xfsprogs git repos to maintain the
stack of patches that go to the mailing lists.  Right now the libxfs
code in both are nearly identical, so it's very easy to jump to the
middle of the stack, make a change, and send it to the other git repo.
This becomes much more painful if I have to edit a diff as it jumps
between repos so that they apply and build.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
