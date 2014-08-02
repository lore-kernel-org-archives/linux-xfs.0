Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EE70B7F51
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 22:19:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B26EAC005
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 20:19:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y7M9aZ5ih2T9fPgB for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 20:19:49 -0700 (PDT)
Date: Sat, 2 Aug 2014 13:19:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: flush both inodes in xfs_swap_extents
Message-ID: <20140802031931.GS20518@dastard>
References: <1406787128-11897-1-git-send-email-david@fromorbit.com>
	<1406787128-11897-3-git-send-email-david@fromorbit.com>
	<20140801124401.GA3582@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140801124401.GA3582@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2014 at 08:44:02AM -0400, Brian Foster wrote:
> On Thu, Jul 31, 2014 at 04:12:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We need to treat both inodes identically from a page cache point of
> > view when prepareing them for extent swapping. We don't do this
> > right now - we assume that one of the inodes empty, because that's
> > what xfs_fsr currently does. Remove this assumption from the code.
> > 
> > While factoring out the flushing and related checks, move the
> > transactions reservation to immeidately after the flushes so that we
> > don't need to pick up and then drop the ilock to do the transaction
> > reservation. There are no issues with aborting the transaction it if
> > the checks fail before we join the inodes to the transaction and
> > dirty them, so this is a safe change to make.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Both of these looked fine to me, but I couldn't apply this one to
> for-next or master...

It's actually in my working branch, which means it's based on
3.16-rc5 + random-outside-xfs-patches + for-next + verifier fixes +
sb discombobulation and then this patch set. I didn't check that it
applied directly against for-next - do you want me to rebase and
resend it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
