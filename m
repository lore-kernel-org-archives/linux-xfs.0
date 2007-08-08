Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 06:17:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l78DHHbm010303
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 06:17:21 -0700
Date: Wed, 8 Aug 2007 23:17:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: qa 166 failure on f8 kernel
Message-ID: <20070808131713.GR52011508@sgi.com>
References: <46B91EBA.10407@sandeen.net> <20070808025615.GH52011508@sgi.com> <46B9316A.40508@sandeen.net> <20070808040804.GJ52011508@sgi.com> <20070808131319.GA11451@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808131319.GA11451@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 08, 2007 at 02:13:19PM +0100, Christoph Hellwig wrote:
> On Wed, Aug 08, 2007 at 02:08:04PM +1000, David Chinner wrote:
> > On Tue, Aug 07, 2007 at 09:58:50PM -0500, Eric Sandeen wrote:
> > > yeah, figured it had something to do w/ the ia64 weenies when I saw the
> > > 32 vs. 8, factor of 4 ... fine, fine, my bad.  :)
> > 
> > No, not your bad. Mine if anyones because I wrote the test.
> 
> Ia64 supports 4k, 8k, 16k and 64k base pagesize.  Time to add a little
> script to make the pagesize random for your kernel builds?

Interesting idea. Definitely worth considering for the randomised
mkfs/mount option config QA runs we already do....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
