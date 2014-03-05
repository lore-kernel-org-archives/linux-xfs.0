Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 778917F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 17:21:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6D05AC00B
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 15:21:30 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0QaPFi0G17C7emF4 for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 15:21:28 -0800 (PST)
Date: Thu, 6 Mar 2014 10:18:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: xfs_check_page_type buffer checks need help
Message-ID: <20140305231807.GJ6851@dastard>
References: <1393981893-2497-1-git-send-email-david@fromorbit.com>
	<1393981893-2497-2-git-send-email-david@fromorbit.com>
	<20140305220819.GC55736@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140305220819.GC55736@bfoster.bfoster>
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

On Wed, Mar 05, 2014 at 05:08:20PM -0500, Brian Foster wrote:
> On Wed, Mar 05, 2014 at 12:11:32PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_aops_discard_page() was introduced in the following commit:
> > 
> >   xfs: truncate delalloc extents when IO fails in writeback
> > 
> > ... to clean up left over delalloc ranges after I/O failure in
> > ->writepage(). generic/224 tests for this scenario and occasionally
> > reproduces panics on sub-4k blocksize filesystems.
> > 
> > The cause of this is failure to clean up the delalloc range on a
> > page where the first buffer does not match one of the expected
> > states of xfs_check_page_type(). If a buffer is not unwritten,
> > delayed or dirty&mapped, xfs_check_page_type() stops and
> > immediately returns 0.
....
> > @@ -777,6 +795,7 @@ xfs_convert_page(
> >  			count++;
> >  		} else {
> >  			done = 1;
> > +			break;
> >  		}
> >  	} while (offset += len, (bh = bh->b_this_page) != head);
> > 
> 
> The next couple lines after the loop are:
> 
> 	if (uptodate && bh == head)
> 		SetPageUptodate(page);
> 
> Now that we can break out of the loop, the "bh == head" part of that
> check might not necessarily mean what it used to mean. The uptodate
> variable is initialized to 1 and we reset to 0 the moment we encounter a
> !uptodate buffer. Do you think it's possible to get here on the first
> buffer of the page, without having reset 'uptodate,'  and potentially
> incorrectly set the page uptodate?

Good question :)

I don't think this can happen because if the first buffer on the
page can't be written, xfs_check_page_type() will return false and
we won't get to the loop. By definition, buffer_unwritten() implies
buffer_uptodate(), as does buffer_delay() and buffer_dirty(). Hence
any of the types that will return acceptible will have the first
buffer uptodate.

As for the other breaks in the loop - the initial imap_valid check
ensures we have a map that covers the entire region of the page that
needs writing, and we know that offset < end_offset for the first
buffer on the page. Hence none of the loop breaks will trigger on
the first buffer, and so the above code should not trigger.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
