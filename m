Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 625AA7CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 03:21:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2448F8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 01:21:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KFPDKTJ8AQfY23gl for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2016 01:21:26 -0700 (PDT)
Date: Tue, 6 Sep 2016 18:20:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [INFO] xfs: kernel debugging with trace_printk()
Message-ID: <20160906082045.GJ30056@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Hi folks,

I learnt something today that made my life immediately better:
trace_printk(). After I discovered it, Darrick mentioned on #xfs
that he didn't know about it either, hence I figured I should send
an email to the list so that everyone working with XFS knows about
it....

Yes, this community service starts with me admitting I am a heavy
user of printk() for debugging code, and I'm about to go cold
turkey.

"Me Ugg, Caveman. Big Club mine. Hit Stuff Hard. Fix It Good."

But, really, everyone does the same thing - anyone what says they
don't is lying. :P

You all know the drill: add a printk, recompile, test, see what gets
output on the console, go back to step one. It starts like this:

Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.

Then if there's lots of output, you turn off the console output with
'dmesg -n X' and look at the output in /var/log/messages instead, or
directly run dmesg to see it. You spend time wading through reams of
output.

Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.

Then you start going mad because the code runs so slow and it's
extremely hard to correlate with other diagnostic information (such
as trace events) that you're also using to try work out what is
going on. And then you end up adding so much debug that it turns
into a heisenbug and you think you're going insane...

Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.

And, finally, when you think you've fixed the problem, you remove
the debug printk()s and find the problem is still there....

Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.
Eat, sleep, printk(), repeat.

So, avoid the existential crisis and the hard liquor and drugs:
use trace_printk() and `trace-cmd record -e printk` to maintain your
sanity!

(You all know about trace-cmd, right?)

The name makes it obvious: it's printk() for trace events which lets
you add custom output to the trace event stream. It even
automatically adds the function the trace_printk is located in to
the output, so it's easy to identify and filter.

For example, I'm trying to debug a new extent list interval tree
index, and so I need to see all the existing extent list trace
points, and also see fine grained debug on the tree operations to
work out where it's going wrong. I'm running tests that push tens of
thousands of extents into the tree, so there's a /lot/ of debug.


I don't want to write tracepoints yet, because I don't know what I
need, and tracepoints are a pain to write. So, I've ended up with
code like this:

.....
	/* check the lookaside cache first */
	if (ext->last_hdr &&
	    idx >= ext->last_hdr->idx &&
	    idx < ext->last_hdr->idx + ext->last_hdr->count) {
		hdr = ext->last_hdr;
		trace_printk("lookaside found %p, idx %d, count %d, end %d",
			hdr, hdr->idx, hdr->count, hdr->end);
		return hdr;
	}

	trace_printk("find idx %d", idx);
	while (node) {
		struct xfs_iext_hdr *rbhdr =
			rb_entry(node, struct xfs_iext_hdr, rb);

	trace_printk("find rbhdr %p, idx %d, count %d, end %d",
		rbhdr, rbhdr->idx, rbhdr->count, rbhdr->end);

		if (node->rb_left &&
		    idx < interval_end(node->rb_left)) {
			/* continue searching left */
			node = node->rb_left;
.....

And when I run a workload and trace it via something like this:

# trace-cmd record -e xfs_iext\* -e xfs_alloc\* -e xfs_bun\* -e xfs_bmap\* -e xfs_iomap\* -e xfs_file\* -e printk

I end up with an event report that looks like this from generic/017.
It runs for *4-5 seconds* before assert failing, and this is at the
end of about /1.5GB/ of diagnostic trace report output:

          xfs_io-11186 [004]    97.303199: bprint:               xfs_iext_find_extbuf: lookaside found 0xffff880239cff000, idx 631, count 253, end 885
          xfs_io-11186 [004]    97.303203: bprint:               xfs_iext_find_extbuf: find idx 884
          xfs_io-11186 [004]    97.303203: bprint:               xfs_iext_find_extbuf: find rbhdr 0xffff8808395e4000, idx 1390, count 253, end 4740
          xfs_io-11186 [004]    97.303205: bprint:               xfs_iext_find_extbuf: find rbhdr 0xffff880239c6a000, idx 379, count 252, end 1390
       trace-cmd-4840  [004]    97.303227: bprint:               xfs_iext_find_extbuf: lookaside found 0xffff880139d94000, idx 0, count 2, end 2
       trace-cmd-4840  [004]    97.303233: bprint:               xfs_iext_find_extbuf: lookaside found 0xffff880139d94000, idx 0, count 2, end 2
       trace-cmd-4840  [004]    97.303234: bprint:               xfs_iext_find_extbuf: lookaside found 0xffff880139d94000, idx 0, count 2, end 2
       trace-cmd-4840  [004]    97.303237: xfs_file_buffered_write: dev 253:32 ino 0x1b2a8 size 0x51000 offset 0xf6c000 count 0x1000
       trace-cmd-4840  [004]    97.303238: bprint:               xfs_iext_bno_to_ext: lookaside found 0xffff880139d94000 idx 0, count 2, end 2 offset 3948
       trace-cmd-4840  [004]    97.303239: bprint:               xfs_iext_find_extbuf: lookaside found 0xffff880139d94000, idx 0, count 2, end 2
       trace-cmd-4840  [004]    97.303240: xfs_iomap_found:      dev 253:32 ino 0x1b2a8 size 0x51000 offset 0xf6c000 count 4096 type  startoff 0x70 startblock 4503599627239444 blockcount 0xf80
          xfs_io-11186 [004]    97.303254: bprint:               xfs_iext_find_extbuf: find rbhdr 0xffff880239cf8000, idx 884, count 253, end 1390
          xfs_io-11186 [004]    97.303255: bprint:               xfs_iext_find_extbuf: find rbhdr 0xffff880239cff000, idx 631, count 253, end 885
          xfs_io-11186 [004]    97.303256: bprint:               xfs_iext_find_extbuf: found 0xffff880239cff000, idx 631, count 253, end 885
          xfs_io-11186 [004]    97.303269: console:              [   97.303261] XFS: Assertion failed: idx - hdr->idx < hdr->count, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 451

Oh, did I mention that kernel console output also shows up in
the trace? And that, by default, tracing stops when a oops or BUG()
is triggered? So the last event in the trace is the ASSERT() failure
that I'm trying to debug....

>From the above, I can clearly see that idx = 884, hdr->idx = 631,
and hdr->count = 253. And 884 - 631 < 253 is clearly false - there's
an off by one somewhere in the new code....

IOWs, I have all my debug printk statements, all the XFS events and
the assert failure all in the one event trace and so it's trivial to
work out why the assert failed. No more guessing!

But the best bit is still to come: When you are not tracing, the
debug trace_printk()s have zero overhead - the code runs like they
aren't there. No more recompiling to add/remove debug printks for
test runs. And with event triggers you can also control your debug
trace_printk output dynamically when specific tracepoints are
encountered.....

Enjoy!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
