Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q49JAM9q122336 for <xfs@oss.sgi.com>; Wed, 9 May 2012 14:10:22 -0500
Date: Wed, 9 May 2012 14:14:13 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 6/3] xfs: make largest supported offset less shouty
Message-ID: <20120509191413.GO16881@sgi.com>
References: <1335519922-14371-1-git-send-email-david@fromorbit.com>
	<20120429125729.GU9541@dastard> <20120508181540.GN16881@sgi.com>
	<20120508224330.GK5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120508224330.GK5091@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, May 09, 2012 at 08:43:30AM +1000, Dave Chinner wrote:
> On Tue, May 08, 2012 at 01:15:40PM -0500, Ben Myers wrote:
> > On Sun, Apr 29, 2012 at 10:57:29PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > XFS_MAXIOFFSET() is just a simple macro that resolves to
> > > mp->m_maxioffset. It doesn't need to exist, and it just makes the
> > > code unnecessarily loud and shouty.
> > > 
> > > Make it quiet and easy to read.
> > 
> > Yep, looks good.
> > 
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> I've got new versions that use s_maxbytes whih I need to post....

Ok, I'll hold off on this one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
