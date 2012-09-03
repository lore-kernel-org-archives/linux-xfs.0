Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835gfe2149488 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:42:41 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ei3u0chiwJYCvnxG for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:43:37 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:43:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5.2: moving files from xfs/disk -> nfs:
	radix_tree_lookup_slot+0xe/0x10
Message-ID: <20120903054327.GZ15292@dastard>
References: <CAO9zADzH7mG3Kp1EQ-0MtTE2CdyLmuz9jsaijgTXLSJ9rZ9tiw@mail.gmail.com>
	<20120901231338.GE6896@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901231338.GE6896@infradead.org>
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
Cc: xfs@oss.sgi.com, linux-m@kvack.org, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 07:13:38PM -0400, Christoph Hellwig wrote:
> I'd suspect it's something with the actual radix tree code, Ccing
> linux-mm in case they know more.

I don't think it has anything to do with the radix tree code....

> On Mon, Aug 27, 2012 at 11:00:10AM -0400, Justin Piszcz wrote:
> > Hi,
> > 
> > Moving ~276GB of files (mainly large backups) and everything has
> > seemed to lockup on the client moving data to the server, it is still
> > in this state..
.....

> > [75716.705720] Call Trace:
> > [75716.705729]  [<ffffffff812dcaee>] ? radix_tree_lookup_slot+0xe/0x10

It's just a symbol that was found in the stack. The real trace is
this:

> > [75716.705747]  [<ffffffff815a3d04>] schedule+0x24/0x70
> > [75716.705751]  [<ffffffff815a2549>] schedule_timeout+0x1a9/0x210
> > [75716.705764]  [<ffffffff815a3420>] wait_for_common+0xc0/0x150
> > [75716.705773]  [<ffffffff815a3d78>] wait_for_completion+0x18/0x20
> > [75716.705777]  [<ffffffff810dfa47>] writeback_inodes_sb_nr+0x77/0xa0
> > [75716.705785]  [<ffffffff810dfa99>] writeback_inodes_sb+0x29/0x40
> > [75716.705788]  [<ffffffff810e3407>] __sync_filesystem+0x47/0x90
> > [75716.705791]  [<ffffffff810e346b>] sync_one_sb+0x1b/0x20
> > [75716.705795]  [<ffffffff810bea71>] iterate_supers+0xe1/0xf0
> > [75716.705798]  [<ffffffff810e355b>] sys_sync+0x2b/0x60
> > [75716.705802]  [<ffffffff815a53a6>] system_call_fastpath+0x1a/0x1f
> > [75836.701197] INFO: task sync:8790 blocked for more than 120 seconds.

Which simply says that writeback of the dirty data at the time of
the sync call has taken longer than 120s.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
