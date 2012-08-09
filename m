Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79NSjkT238776 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 18:28:45 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9Vyma5LKdHzyoOjE for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 16:28:43 -0700 (PDT)
Date: Fri, 10 Aug 2012 09:28:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 2/4] xfs: Introduce a new function to find the desired
	type of offset from page cache
Message-ID: <20120809232840.GB2877@dastard>
References: <501B6B6F.2090101@oracle.com>
 <5023CC01.3060201@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5023CC01.3060201@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: jeff.liu@oracle.com, xfs@oss.sgi.com

On Thu, Aug 09, 2012 at 09:41:05AM -0500, Mark Tinguely wrote:
.....
> >+
> >+		/*
> >+		 * At lease we found one page.  If this is the first time we
> >+		 * step into the loop, and if the first page index offset is
> >+		 * greater than the given search offset, a hole was found.
> >+		 */
> >+		if (type == HOLE_OFF&&  lastoff == startoff&&
> >+		    lastoff<  page_offset(pvec.pages[0])) {
> >+			found = true;
> >+			break;
> >+		}
> 
> I played with the code and appreciate the trickiness of the startoff.
> I this can be refined a bit more. see below.
> 
> >+
> >+		for (i = 0; i<  nr_pages; i++) {
> >+			struct page	*page = pvec.pages[i];
> >+			loff_t		b_offset;
> >+
> >+			/*
> >+			 * Page index is out of range, searching done.
> >+			 * If the current offset is not reaches the end
> >+			 * of the specified search range, there should
> >+			 * be a hole between them.
> >+			 */
> >+			if (page->index>  end) {
> >+				if (type == HOLE_OFF&&  lastoff<  endoff) {
> >+					*offset = lastoff;
> >+					found = true;
> >+				}
> >+				goto out;
> >+			}
> 
> Before we take the lock, we can check to see if the page starts
> later than expected (a hole). The pre-loop start check can be
> removed and something like the follow added:

Really, we don't need to be that tricky or smart. This is not a
performance critical operation, so we don't need to optimise away
page locks, especially when the risk of getting it wrong is
compromising data integrity...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
