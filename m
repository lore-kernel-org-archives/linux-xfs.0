Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p057YLUb123401 for <xfs@oss.sgi.com>; Wed, 5 Jan 2011 01:34:22 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BC541D0E628
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 23:36:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	aCRkiiyMzyFn4bRV for <xfs@oss.sgi.com>;
	Tue, 04 Jan 2011 23:36:28 -0800 (PST)
Date: Wed, 5 Jan 2011 18:36:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20110105073625.GA8322@dastard>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-6-git-send-email-david@fromorbit.com>
	<1294192495.2485.726.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294192495.2485.726.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 07:54:55PM -0600, Alex Elder wrote:
> On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The current xfs_file_aio_write code is a mess of locking shenanigans
> > to handle the different locking requirements of buffered and direct
> > IO. Start to clean this up by disentangling the direct IO path from
> > the mess.
> 
> All good, very good.  But I'm not sure why you cut
> out the code that backed off to buffered I/O if
> generic_file_direct_write() returns an error.
> (You gave no explanation.)

Oh, I thought I put one in there. It's simple, though - XFS handles
all allocation cases in the direct IO code and never returns a
result that will require falling back to the buffered IO path.  It
is basically a code path that has been unused for years and all it
does is make the logic much more complex to understand.

I'll add that to the commit message....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
