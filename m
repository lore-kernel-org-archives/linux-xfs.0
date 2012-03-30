Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UG2tD5137787 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 11:02:58 -0500
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id GVujPTzWlhI9tyCR for
	<xfs@oss.sgi.com>; Fri, 30 Mar 2012 09:02:52 -0700 (PDT)
Subject: Re: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
In-Reply-To: <20120327101750.GA5091@dastard>
References: <1330539626.7615.73.camel@utemp.mieszkanie>
	<20120302104348.GA22230@infradead.org>
	<1330774627.32457.24.camel@utemp.mieszkanie>
	<20120303114413.GA18748@infradead.org>
	<1330983612.28645.18.camel@utemp.mieszkanie>
	<20120306203020.GG3592@dastard>
	<1331233817.20679.18.camel@utemp.mieszkanie>
	<1332777925.14696.194.camel@utemp.mieszkanie>
	<20120327032843.GV5091@dastard>  <20120327101750.GA5091@dastard>
Date: Fri, 30 Mar 2012 18:02:41 +0200
Message-ID: <1333123361.30824.19.camel@utemp.mieszkanie>
Mime-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, 2012-03-27 at 21:17 +1100, Dave Chinner wrote:
Hello,

My kernel config - http://pastebin.com/QvqFVWUw

Mount options (/proc/mounts):
/dev/vda2 / xfs rw,noatime,attr2,noquota 0 0

> Can you run your test with this patch while running a trace for the
> new xfs_buf_*broken events to verify you are hitting that code and
> that it doesn't trigger EIO problems anymore?

I've applied this patch to linus/v3.3 kernel. There is no more I/O
errors but xfsdump still hangs.

Trace recorded just after hung up:
# tracer: nop
#
# entries-in-buffer/entries-written: 78/78   #P:1
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
         xfsdump-1534  [000] .... 28544.651904: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651908: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651910: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651911: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651912: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651914: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651915: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651916: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651918: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651919: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651921: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651923: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651924: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651926: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651927: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651928: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651930: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651931: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651932: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651934: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651935: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651937: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651939: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651940: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651941: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651942: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651943: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651945: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651946: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651947: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651949: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651950: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651951: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651953: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651955: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651956: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651958: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651960: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651962: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651963: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651964: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651965: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.651966: xfs_buf_get_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 1 pincount 0 lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|DONT_BLOCK caller xfs_buf_read
         xfsdump-1534  [000] .... 28544.661785: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.661788: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.663330: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.667218: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.671297: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.675416: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.682188: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.683811: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.687418: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.693069: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.695414: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.699315: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.703417: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.707416: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.711416: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.715338: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.719413: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.723412: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.727410: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 28544.731408: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get

Later, this lines keep repeating, there is no more xfs_buf_get_broken: entries in trace file:

    xfsaild/vda2-156   [000] .... 29791.119322: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|TRYLOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 29791.119332: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 29791.123296: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get
    xfsaild/vda2-156   [000] .... 29791.123306: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|TRYLOCK|DONT_BLOCK caller xfs_buf_get
    xfsaild/vda2-156   [000] .... 29791.127341: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|TRYLOCK|DONT_BLOCK caller xfs_buf_get
         xfsdump-1534  [000] .... 29791.127351: xfs_buf_find_broken: dev 254:2 bno 0xffffffffffffffff len 0x2000 hold 2 pincount 0 lock 0 flags READ|LOCK|DONT_BLOCK caller xfs_buf_get

Regards,
Rafal Kupka

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
