Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 82C467CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 17:36:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07922AC003
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 15:36:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z9G7r2ePKY8SXyKB for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2016 15:36:50 -0700 (PDT)
Date: Wed, 24 Aug 2016 08:35:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: kill __uint*_t and __int*_t
Message-ID: <20160823223500.GZ19025@dastard>
References: <20160807173835.GA20839@nyan> <20160809083332.GA1489@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160809083332.GA1489@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Felix Janda <felix.janda@posteo.de>, xfs@oss.sgi.com

On Tue, Aug 09, 2016 at 01:33:32AM -0700, Christoph Hellwig wrote:
> On Sun, Aug 07, 2016 at 07:38:35PM +0200, Felix Janda wrote:
> > Replace them by the more widely used uint*_t and int*_t.
> > 
> > Signed-off-by: Felix Janda <felix.janda@posteo.de>
> > ---
> > This patch is essentially a global
> > 'sed -i "s/__\(u*\)int\([0-9]*\)_t/\1int\2_t/"'. The only other changes
> > are whitespace changes and removing the now unecessary type definitions.
> > 
> > Running 'sed "s/^.//"' on the patch might be useful for checking that
> > I didn't mess up the indentation.
> 
> If everyone is fine using (u)int*_t over s*/u* this looks good.  I'd
> have a slight preference for s*/u* as in the rest of the kernel, but
> either way getting rid of our crazy __ types is a good thing.

Don't really care that much. I'd prefer (marginally) to go with the
(u)int*_t types as userspace then doesn't need a set of typedefs in
the platform headers to support the kernel specific types in libxfs
code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
