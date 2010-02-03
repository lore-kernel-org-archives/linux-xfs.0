Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13MYQwJ248469 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:34:26 -0600
Subject: Re: xfstests: 219: fix awk filter for duplicate users
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100203205151.GA11337@infradead.org>
References: <1265226844.2848.27.camel@doink1>
	<20100203205151.GA11337@infradead.org>
Date: Wed, 03 Feb 2010 16:35:32 -0600
Message-ID: <1265236532.2585.0.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-02-03 at 15:51 -0500, Christoph Hellwig wrote:
> On Wed, Feb 03, 2010 at 01:54:04PM -0600, Alex Elder wrote:
> > The filter I added for removing duplicate users from the
> > output of repquota didn't do the job very well.  This
> > fixes that, making it so the first time a user is seen
> > its line is printed, not thereafter.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > ---
> >  219 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: b/219
> > ===================================================================
> > --- a/219
> > +++ b/219
> > @@ -86,7 +86,7 @@ test_accounting()
> >         done
> > 
> >         repquota -$type -s -n $SCRATCH_MNT  | grep -v "^#0" |
> > filter_scratch |
> > -       awk '/^#/ { if (! seen[$1]) { seen[$1]++; next; } } { print }'
> > +       awk '/^#/ { if (seen[$1]) next; seen[$1]++; } } { print; }'
> 
> The patch seems whitespace damages, and there's a "}" too many in
> the added line.  After fixing that up 219 passes again for me.
> 
> So more or less:
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I copy and pasted the wrong thing into my e-mail.
Sorry about that.  I will fix both the white space
and the curly brace before commit.  Thanks for
the review.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
