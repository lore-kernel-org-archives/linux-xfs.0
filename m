Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06Fccjh027687 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 09:38:38 -0600
Date: Fri, 6 Jan 2012 09:38:35 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2] xfs: fix endian conversion issue in discard code
Message-ID: <20120106153835.GL5063@sgi.com>
References: <1324426062-21505-1-git-send-email-david@fromorbit.com>
	<1324426062-21505-3-git-send-email-david@fromorbit.com>
	<20111221043638.GR29840@sgi.com>
	<20120106151254.GA11417@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120106151254.GA11417@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 06, 2012 at 10:12:54AM -0500, Christoph Hellwig wrote:
> On Tue, Dec 20, 2011 at 10:36:38PM -0600, Ben Myers wrote:
> > On Wed, Dec 21, 2011 at 11:07:42AM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When finding the longest extent in an AG, we read the value directly
> > > out of the AGF buffer without endian conversion. This will give an
> > > incorrect length, resulting in FITRIM operations potentially not
> > > trimming everything that it should.
> > 
> > Looks good to me.
> > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Reviewed-by: Ben Myers <bpm@sgi.com>
> 
> This is a pretty serious thing, can you send it to Linus as soon as
> he takes the current pull request?

yep.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
