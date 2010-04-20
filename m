Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KNRASC072793 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 18:27:10 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5811E1B480E1
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 16:29:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	rpsajyIgVGMZXHRi for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 16:29:07 -0700 (PDT)
Date: Wed, 21 Apr 2010 09:29:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] writeback: tracing and wbc->nr_to_write fixes
Message-ID: <20100420232904.GA23541@dastard>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<4BCD97C8.6090406@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BCD97C8.6090406@rsk.demon.co.uk>
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
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 20, 2010 at 01:02:16PM +0100, Richard Kennedy wrote:
> On 20/04/10 03:41, Dave Chinner wrote:
> > This series contains the initial writeback tracing patches from
> > Jens, as well as the extensions I added to provide visibility into
> > writeback control structures as the are used by the writeback code.
> > The visibility given is sufficient to understand what is happening
> > in the writeback path - what path is writing data, what path is
> > blocking on congestion, etc, and to determine the differences in
> > behaviour for different sync modes and calling contexts. This
> > tracing really needs to be integrated into mainline so that anyone
> > can improve the tracing as they use it to track down problems
> > in our convoluted writeback paths.
> > 
> > The remaining patches are fixes to problems that the new tracing
> > highlighted.
> 
> Hi Dave,
> 
> Thanks for adding tracing to this, it will be really useful.
> 
> The fix to write_cache_pages looks really interesting, I'm going to test
> it on my machine. Maybe it should be a separate patch to get more
> visibility?

I don't see a big need to separate the series at this point. Once
there's been a review and testing we can decide how to push them
into mainline. IMO, the tracing is just as important as the bug
fixes....

> Ext4 also multiplies nr_to_write, so will that need fixing too?

No idea. I don't claim to understand ext4's convoluted delayed
allocation path and all it's constraints, so I guess you'd need to
ask the ext4 developers about that one. After all, with the tracing
they'd be able to see if there is a problem. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
