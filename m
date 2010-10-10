Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9A83xan251033 for <xfs@oss.sgi.com>; Sun, 10 Oct 2010 03:03:59 -0500
Date: Sun, 10 Oct 2010 04:05:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Fix some file permission.
Message-ID: <20101010080502.GA6674@infradead.org>
References: <4CAE483F.1020608@sgi.com> <1286660111.5392.6.camel@doink>
	<20101010015723.GM4681@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101010015723.GM4681@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Alain Renaud <arenaud@sgi.com>, Alex Elder <aelder@sgi.com>

On Sun, Oct 10, 2010 at 12:57:23PM +1100, Dave Chinner wrote:
> > This looks good to me but I'd like a second opinion,
> > to make sure there's no reason any of these should
> > be non-executable.
> 
> I don't think it matters. Consistency is good, though, and we've
> taken patches like this in the past.

Yeah.  Btw, I'm not sure git-am can apply the mode changes from a patch,
in the worst case you might have to do the chmod calls manually.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
