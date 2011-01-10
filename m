Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ALpxGW046742 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 15:52:00 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 676C32509E3
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:54:11 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id a6OjR5HZvpDc7E8X for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:54:11 -0800 (PST)
Date: Mon, 10 Jan 2011 22:53:51 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110110215351.GA26675@citd.de>
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
	<201101100857.53421@zmi.at> <20110110084122.GF28803@dastard>
	<20110110191757.GA25029@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110110191757.GA25029@infradead.org>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 10.01.2011 14:17, Christoph Hellwig wrote:
> On Mon, Jan 10, 2011 at 07:41:22PM +1100, Dave Chinner wrote:
> > On Mon, Jan 10, 2011 at 08:57:52AM +0100, Michael Monnerie wrote:
> > > On Montag, 10. Januar 2011 Dave Chinner wrote:
> > > > This patch uses 32-way threading which results in no noticable
> > > > slowdown on single SATA drives with NCQ, but results in ~10x
> > > > reduction in runtime on a 12 disk RAID-0 array.
> > > 
> > > Is the fixed 32-way number reasonable, or shouldn't that be "number of 
> > > available cpu cores"-way? Why threading when you have a single core cpu?
> > 
> > Sure, 32-way is reasonable on a single disk and CPU. Pretty much
> > every sata disk supports NCQ these days, and default to a depth of
> > 32, which means we can have 32 concurrent reads in progress at once.
> > Phase 2 is all synchronous IO, so the only way to hide the IO
> > latency is to queue work to multiple threads and switch between the
> > threadsto work on another queue when the current one blocks waiting
> > for IO.
> 
> The default queue depth for ATA NCQ actually is 31, not 32 for some odd
> reason.

AFAIR the original discussion it's because Depth 0 and 32 use the same 
value. And the knowledge that (HDD-)firmware tends to be buggy, so it 
was decided to stay on the safe side and not use "0/32".





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
