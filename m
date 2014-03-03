Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9988C29DF7
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 19:03:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DF8BAC002
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 17:03:24 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CBveUQGixFC89x3E for <xfs@oss.sgi.com>;
	Sun, 02 Mar 2014 17:03:23 -0800 (PST)
Date: Mon, 3 Mar 2014 12:03:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check all buffers in xfs_check_page_type()
Message-ID: <20140303010318.GG13647@dastard>
References: <1393615369-41882-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393615369-41882-1-git-send-email-bfoster@redhat.com>
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

On Fri, Feb 28, 2014 at 02:22:49PM -0500, Brian Foster wrote:
> xfs_aops_discard_page() was introduced in the following commit:
> 
>   xfs: truncate delalloc extents when IO fails in writeback
> 
> ... to clean up left over delalloc ranges after I/O failure in
> ->writepage(). generic/224 tests for this scenario and occasionally
> reproduces panics on sub-4k blocksize filesystems.
> 
> The cause of this is failure to clean up the delalloc range on a
> page where the first buffer does not match one of the expected
> states of xfs_check_page_type(). If a buffer is not unwritten,
> delayed or dirty&mapped, xfs_check_page_type() stops and
> immediately returns 0.
> 
> The stress test of generic/224 creates a scenario where the first
> several buffers of a page with delayed buffers are mapped&uptodate
> and some subsequent buffer is delayed. If the ->writepage() happens
> to fail for this page, xfs_aops_discard_page() incorrectly skips
> the entire page.
> 
> Modify xfs_aops_discard_page() to iterate all of the page buffers
> to ensure a delayed buffer does not go undetected.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> The only other caller to xfs_check_page_type() is xfs_convert_page(). I
> think this is safe with respect to that codepath, given the additional
> imap checks therein and whatnot, but thoughts appreciated.

Just to close the loop ifor everyone else on the IRC discussion
Brian and I had - removing the break statement is likely to cause
problems with xfs_convert_page().

What xfs_convert_page() assumes is that xfs_check_page_type() will
return true iff the first iand subsequent buffers on the page match
the given type and can be written back.  Skipping over buffers that
have unknown contents is incorrect behaviour - if the first buffer
on the page is unmapped, then it should break and return false.

However, xfs_aops_discard_page() requires it to check all buffers on
the page for delalloc state so that we can punch them correctly, and
so breaking out at the first unwriteable buffer is a bug.

Hence to fix this, we need to change the way xfs_convert_page()
works. It needs to stop processing buffesr in it's main loop
whenever "done" gets set so that it stops at the same point that
xfs_check_page_type() stops checking the buffers on the page. Once
that is done, then we can modify xfs_check_page_type() to return
true when it finds the first buffer of a given type on the page
or false if it finds an unmapped buffer and we are looking for
IO_DELALLOC....

And it needs a decent set of comments, too :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
