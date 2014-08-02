Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 848DE7F51
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 06:24:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20DB8AC002
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 04:24:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FeNN8W37nGdS5mF1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Aug 2014 04:24:15 -0700 (PDT)
Date: Sat, 2 Aug 2014 07:24:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: flush both inodes in xfs_swap_extents
Message-ID: <20140802112404.GA36014@bfoster.bfoster>
References: <1406787128-11897-1-git-send-email-david@fromorbit.com>
	<1406787128-11897-3-git-send-email-david@fromorbit.com>
	<20140801124401.GA3582@laptop.bfoster>
	<20140802031931.GS20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140802031931.GS20518@dastard>
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
Cc: xfs@oss.sgi.com

On Sat, Aug 02, 2014 at 01:19:31PM +1000, Dave Chinner wrote:
> On Fri, Aug 01, 2014 at 08:44:02AM -0400, Brian Foster wrote:
> > On Thu, Jul 31, 2014 at 04:12:08PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We need to treat both inodes identically from a page cache point of
> > > view when prepareing them for extent swapping. We don't do this
> > > right now - we assume that one of the inodes empty, because that's
> > > what xfs_fsr currently does. Remove this assumption from the code.
> > > 
> > > While factoring out the flushing and related checks, move the
> > > transactions reservation to immeidately after the flushes so that we
> > > don't need to pick up and then drop the ilock to do the transaction
> > > reservation. There are no issues with aborting the transaction it if
> > > the checks fail before we join the inodes to the transaction and
> > > dirty them, so this is a safe change to make.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Both of these looked fine to me, but I couldn't apply this one to
> > for-next or master...
> 
> It's actually in my working branch, which means it's based on
> 3.16-rc5 + random-outside-xfs-patches + for-next + verifier fixes +
> sb discombobulation and then this patch set. I didn't check that it
> applied directly against for-next - do you want me to rebase and
> resend it?
> 

Ok, no worries. I was just trying to compile test and verify that
nothing was unexpected with the patch as posted. I'm good as long we get
some lead team for testing and whatnot when this gets merged to a dev.
branch. :)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
