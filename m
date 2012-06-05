Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55BjNEk078702 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 06:45:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DBBrhLbwCJdOgWf5 for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 04:45:20 -0700 (PDT)
Date: Tue, 5 Jun 2012 21:45:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: using extsize cause corruption with multi buffer
	page.
Message-ID: <20120605114516.GM4347@dastard>
References: <20120601192207.D6DE99F997@arenaud-laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120601192207.D6DE99F997@arenaud-laptop>
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 01, 2012 at 03:18:26PM -0400, Alain Renaud wrote:
>   This mod make sure that buffer in a xfs_ioend are all in the
> same extent. This is actually similar to what is done in
> xfs_convert_page() already.
> 
> This solve the problem of having multiple extent in one page.

You need to describe how the change fixes the problem, not state
that it does.

i.e. a fix is no good if you can't explain *why* it fixes the bug.

> With the current kernel if we have a page that look like this:
> buffer  content
> 0       empty  b_state = 0
> 1       DATA   b_state = 0x1023
> 2       DATA   b_state = 0x1023
> 3       empty  b_state = 0
> 4       empty  b_state = 0
> 5       DATA   b_state = 0x1023
> 6       DATA   b_state = 0x1023
> 7       empty  b_state = 0
> 
> 
> We endup with buffer 1-4 been tag as real and 5-EOF tag as unwritten.
> Instead of 1-2 real, 3-4 unwritten, 5-6 real, 7-EOF unwritten.

Actaully, the buffer state is correct - it's the ioend construction
that appears wrong and that leads to conversion being incorrect.
Indeed, if you look at my previous email about the test case you'll
see that the in-memory state is correct before the unmount....

As it is, the patch changes the way the new_ioend variable works -
it's supposed to be set only if we have to map a new extent. That
is, if we currently don't have a valid extent we need a new ioend
when we map the new extent. The correct way to create a new extent
is to mark the current imap as invalid so we have to do a new
lookup....

> @@ -985,6 +986,7 @@ xfs_vm_writepage(
>  				ASSERT(buffer_mapped(bh));
>  				imap_valid = 0;
>  			}
> +			new_ioend = 1;
>  			continue;
>  		}

This is the real change of logic, and indicates where the bug
potentially lies. The same fix can be accomplished simply by
replacing all your changes with this:

@@ -981,10 +981,9 @@ xfs_vm_writepage(
                                imap_valid = 0;
                        }
                } else {
-                       if (PageUptodate(page)) {
+                       if (PageUptodate(page))
                                ASSERT(buffer_mapped(bh));
-                               imap_valid = 0;
-                       }
+                       imap_valid = 0;
                        continue;
                }

But this still doesn't explain what the problem actually is. All it
indicates is that we have a buffer that is mapped but not up to date
on a page that is also not up to date. What we need to do is
understand why this is happening, and if changing this logic is the
correct fix that won't have any unintended side effects.

So let's try to understand this a bit better. First of all, are
extent size hints necessary to trigger this? With this change:

- xfs_io -f -c "extsize `expr $pgsize \* 10`" \
+ xfs_io -f -c "resvsp 0 `expr $pgsize \* 10`" \

I find that the same corruption occurs, so this is an unwritten
extent problem, not an extent size hint issue. So now we have a much
wider scope than initially indicated.

So, next question: what part does the truncate play, if any? So I
comment out the truncate, and it appears that it has no effect on
the result of the test. OK, lets drop that completely.

Ok, that leaves us with a test case that is kind of similar to part
4 of test 194, but with the initial condition of a prealocated
region rather than an allocated block. And test 194 doesn't check
the state after a unmount/mount cycle so even if it did have a
preallocated initial state, it wouldn't detect this problem.  IOWs,
we have a whole new class of corner cases that we don't currently
exercise. Alain, your test is going need some more work...

Alright, so lets look at why we fail to handle this case in
writeback properly.

  xfs_io-2498  xfs_writepage:        dev 253:16 ino 0x23 pgoff 0x1000 size 0x1e00 offset 0 delalloc 0 unwritten 1
  xfs_io-2498  xfs_map_blocks_found: dev 253:16 ino 0x23 size 0x0 offset 0x1200 count 512 type  startoff 0x0 startblock 48 blockcount 0x50
kworker/0:15   xfs_unwritten_convert: dev 253:16 ino 0x23 isize 0x1e00 disize 0x0 offset 0x1200 count 2048

Ah, there's why it fails to handle the case correctly - the
unwritten extent is a single map and hence if we won't do another
lookup because it spans the entire page already. Hence if imap_valid
is not cleared, we'll never look it up again and set new_ioend.

If the page is marked uptodate, then that means all the buffers have
been correctly initialised and should all be marked up to date.
Hence I'm not sure that the existing logic there is actually
possible to hit. We know the buffer is not uptodate, and we use
generic_write_end, which calls __block_commit_write(), and that only
calls SetPageUptodate() when all the buffers are uptodate.

Indeed, if the buffer is not uptodate, then it means we didn't
complete the write on it and it does not have valid data in it, so
regardless of the page state we should not write it. That means we
must always skip it and that means we always need a new ioend in
this case. hence we should always clear imap_valid in this case.
Hence i think the above hunk is the right fix for the problem.

Alain, can you check my logic, run it through your tests and if it
works, respin the patch with this info in the commit message and a
comment in the code indicating why we need to clear imap_valid
unconditionally there?

Cheers,

Dave.


That means, I think, that the logic in the current code is just
plain wrong. xfs_convert_page() aborts on pages and buffers that are
both not uptodate, so they get handled by xfs_vm_writepage(). This
particular branch we are looking at there is the the
!buffer_uptodate() branch.



What your change does is this:
> -- 
> 1.7.4.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
