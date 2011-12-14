Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEKWnnq228850 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 14:32:50 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 804271F4C9B0
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 12:32:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4PXImx7HyFcQEIIz for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 12:32:46 -0800 (PST)
Date: Thu, 15 Dec 2011 07:32:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs-trace-ilock-more
Message-ID: <20111214203243.GN3179@dastard>
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de> <4EE8F7F0.7070207@suse.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE8F7F0.7070207@suse.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeff Mahoney <jeffm@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 02:24:32PM -0500, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 12/14/2011 01:27 PM, Mark Fasheh wrote:
> > Hey Christoph,
> > 
> > On Tue, Dec 13, 2011 at 09:40:40PM -0500, Christoph Hellwig wrote:
> >> Can you explain the story behid this patch in SLES11SP1?
> > 
> > We were looking at some performance issues and needed a bit more
> > information on the amount of time spent in ilock. I can give you
> > more specifics if you want, I just have to dig up the e-mails (it's
> > been a while).
> 
> That's pretty much the explanation. With heavy reader load, buffered
> writes were stalling for 80 ms and sometimes longer. I suspected it
> was contention on the ilock and the tracing with that patch
> demonstrated a delay there. Since we were chasing a similar issue at
> another site, it seemed worthwhile to just keep it around. We're still
> tracking down the cause. I'm not sure if more recent kernels have the
> same issue as there's been quite a lot of churn.

I'm not surprised - there's nothing really guaranteeing bound shared
vs exclusive access to the ilock. It's all down to the read/write
bias of the rwsem - readers will hold off the writer for some time.
Still, it would be nice to see a trace from such a holdoff to
confirm this is actually the case...

FWIW, if you have an app that requires concurrent, low latency reads
and writes to the same file, that's what the XFS Direct IO was
designed for - in most cases the iolock is taken in shared mode for
both read and write, and so such hold-offs don't generally happen...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
