Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4JL8Nq251972 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 13:21:09 -0600
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6144A304048
	for <xfs@oss.sgi.com>; Tue,  4 Dec 2012 11:23:29 -0800 (PST)
Date: Tue, 4 Dec 2012 12:44:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Don't flush inodes when project quota exceeded
Message-ID: <20121204184459.GN27055@sgi.com>
References: <1352766973-14197-1-git-send-email-jack@suse.cz>
	<20121119213913.GB29498@quack.suse.cz>
	<20121120161511.GE27055@sgi.com>
	<20121120170354.GF1408@quack.suse.cz>
	<20121120202038.GF2591@dastard> <50ABF54E.6070508@redhat.com>
	<20121120222215.GH2591@dastard> <50ACF289.2080901@redhat.com>
	<20121121220950.GR2591@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121121220950.GR2591@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Hey Dave,

On Thu, Nov 22, 2012 at 09:09:50AM +1100, Dave Chinner wrote:
> On Wed, Nov 21, 2012 at 10:26:01AM -0500, Brian Foster wrote:
> > On 11/20/2012 05:22 PM, Dave Chinner wrote:
> > > On Tue, Nov 20, 2012 at 04:25:34PM -0500, Brian Foster wrote:
> > >> Otherwise, unless I'm mistaken it sounds like we can use the existing
> > >> eofblocks scan on user/group EDQUOT situations.
> > > 
> > > That we can. And for the project case, it's a simply and extra flag
> > > and a call to filemap_flush() to do an async writeback before
> > > trimming the specualtive preallocation.
> > 
> > This makes sense generally. I'll need to dig further into this code to
> > wrap my head around it. If my current understanding is correct, it
> > sounds like we could do the same thing in general, non-quota ENOSPC
> > handling, right? E.g., an unfiltered eofblocks scan (plus the flush bit)
> > followed by a retry, rather than a complete flush of all dirty inodes.
> 
> Possibly, though we can also have dirty inodes that don't have
> speculative prealloc (e.g. hole filling writes) and we really need to
> flush them at ENOSPC, too. In general, I think the real ENOSPC case
> needs the big hammer because we have to reclaim every last piece of
> unnecessary reservation as possible to allow anything to proceed.
> Porject quota ENOSPC isn't such a problem here, as there's still
> other free space in the filesystem that allow normal operation to
> take place...

Tossing away all of our remedial action in the project quota ENOSPC case to
work around an nfs client issue strikes me as the wrong thing to do.  I doesn't
look like this is what you're suggesting but I just want to see if we're on the
same page.

It seems to me that project quota ENOSPC has basically the same issues as with
the real ENOSPC case, but it only needs to be targeted at inodes that affect
the quota in question.  The flush and trimming should still be done, otherwise
once project quota ENOSPC is hit there is no way for the nfs client to clear up
the situation... we just need to target only inodes that affect the quota where we
hit limits instead of all inodes.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
