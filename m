Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F4C97F37
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 17:51:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1BD5AC002
	for <xfs@oss.sgi.com>; Mon, 24 Jun 2013 15:51:19 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id INNsoUIh7td6I22M (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Jun 2013 15:51:18 -0700 (PDT)
Subject: Bug#713994: XFS repair
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.713994.B713994.137211409414191@bugs.debian.org>
Date: Tue, 25 Jun 2013 08:47:53 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20130624224753.GW29338@dastard>
References: <CAMjbrKp164a2CU2SPn94NGP+urwKUCtGz2vKyt6snSWaYdHebA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMjbrKp164a2CU2SPn94NGP+urwKUCtGz2vKyt6snSWaYdHebA@mail.gmail.com>
Reply-To: Dave Chinner <david@fromorbit.com>, 713994@bugs.debian.org
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
To: Wes Deviers <yhetti@gmail.com>, 713994@bugs.debian.org

On Mon, Jun 24, 2013 at 12:43:55PM -0400, Wes Deviers wrote:
> Update:
> 
> xfs_repair has fixed the problem:
> 
> root@ashdbtrk-s008-02:/home/wdeviers# xfs_check /dev/vg0/mysql
> agf_freeblks 327676, counted 655100 in ag 4
> agf_longest 327676, counted 655100 in ag 4
> block 12/1 expected type unknown got btbno
> block 12/4 expected type unknown got free2
> ...
> block 12/45268 expected type unknown got free2
> block 12/45269 expected type unknown got free2
> block 12/45270 expected type unknown got free2
> block 12/45271 expected type unknown got free2
> block 12/45272 expected type unknown got free2
> block 12/45273 expected type unknown got free2
> block 12/45274 expected type unknown got free2
> block 12/45275 expected type unknown got free2
> 
> root@ashdbtrk-s008-02:/home/wdeviers# xfs_repair /dev/vg0/mysql
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> primary/secondary superblock 4 conflict - AG superblock geometry info
> conflicts with filesystem geometry
> bad sequence # 12 for agf 4
> bad length 327680 for agf 4, should be 655104
> bad sequence # 12 for agi 4
> bad length # 327680 for agi 4, should be 655104
> reset bad sb for ag 4
> reset bad agf for ag 4
> reset bad agi for ag 4
> sb_fdblocks 28836636, counted 28509212

The AG headers for AG #4 have been overwritten with header from a
different AG# (12 instead of 4) that has a different length (327680
instead of 655104).  The sequence number mismatch is why the runtime
errors are being thrown

However, the superblock for AG 4 has the wrong geometry and that's
indicative of it belonging to some other filesystem. i.e. a
misdirected write. I'd be taking a careful look at your storage,
because misdirected writes are evil and *extremely hard* to diagnose
without specialised equipment...

Anyway, you're running an old, old kernel (2.6.32-5-amd64) and
xfsprogs, so unless you can reproduce this reliably on a couple of
different types of hardware with a more recent kernel and xfsprogs,
we aren't really going to be able to do anything about your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
