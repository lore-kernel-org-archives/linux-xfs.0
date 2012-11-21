Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALM7mEn101406 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 16:07:48 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bNnsgeQpWjJy97sX for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 14:09:58 -0800 (PST)
Date: Thu, 22 Nov 2012 09:09:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121121220950.GR2591@dastard>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
	<20121120202038.GF2591@dastard> <50ABF54E.6070508@redhat.com>
	<20121120222215.GH2591@dastard> <50ACF289.2080901@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50ACF289.2080901@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Nov 21, 2012 at 10:26:01AM -0500, Brian Foster wrote:
> On 11/20/2012 05:22 PM, Dave Chinner wrote:
> > On Tue, Nov 20, 2012 at 04:25:34PM -0500, Brian Foster wrote:
> >> Otherwise, unless I'm mistaken it sounds like we can use the existing
> >> eofblocks scan on user/group EDQUOT situations.
> > 
> > That we can. And for the project case, it's a simply and extra flag
> > and a call to filemap_flush() to do an async writeback before
> > trimming the specualtive preallocation.
> 
> This makes sense generally. I'll need to dig further into this code to
> wrap my head around it. If my current understanding is correct, it
> sounds like we could do the same thing in general, non-quota ENOSPC
> handling, right? E.g., an unfiltered eofblocks scan (plus the flush bit)
> followed by a retry, rather than a complete flush of all dirty inodes.

Possibly, though we can also have dirty inodes that don't have
speculative prealloc (e.g. hole filling writes) and we really need to
flush them at ENOSPC, too. In general, I think the real ENOSPC case
needs the big hammer because we have to reclaim every last piece of
unnecessary reservation as possible to allow anything to proceed.
Porject quota ENOSPC isn't such a problem here, as there's still
other free space in the filesystem that allow normal operation to
take place...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
