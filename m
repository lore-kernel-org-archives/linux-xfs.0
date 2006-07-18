Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 02:00:24 -0700 (PDT)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6I8xxDW017752
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 02:00:00 -0700
From: Neil Brown <neilb@suse.de>
Date: Tue, 18 Jul 2006 18:58:56 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17596.41680.124148.595601@cse.unsw.edu.au>
Subject: Re: XFS and write barrier
In-Reply-To: message from Nathan Scott on Tuesday July 18
References: <200607151248.56603.Martin@lichtvoll.de>
	<20060716173238.GD3417@free.net.ph>
	<20060718173122.B1914501@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

On Tuesday July 18, nathans@sgi.com wrote:
> On Mon, Jul 17, 2006 at 01:32:38AM +0800, Federico Sevilla III wrote:
> > On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> > > I am currently gathering information to write an article about journal
> > > filesystems with emphasis on write barrier functionality, how it
> > > works, why journalling filesystems need write barrier and the current
> > > implementation of write barrier support for different filesystems.

"Journalling filesystems need write barrier" isn't really accurate.
They can make good use of write barrier if it is supported, and where
it isn't supported, they should use blkdev_issue_flush in combination
with regular submit/wait.

> > 
> > Cool! Would you by any chance have information on the interaction
> > between journal filesystems with write barrier functionality, and
> > software RAID (md)? Based on my experience with 2.6.17, XFS detects that
> > the underlying software RAID 1 device does not support barriers and
> > therefore disables that functionality.
> 
> Noone here seems to know, maybe Neil &| the other folks on linux-raid
> can help us out with details on status of MD and write barriers?

In 2.6.17, md/raid1 will detect if the underlying devices support
barriers and if they all do, it will accept barrier requests from the
filesystem and pass those requests down to all devices.

Other raid levels will reject all barrier requests.  Filesystems
should notice this and submit regular writes and wait for them to
complete (which they do) and call blk_issue_flush after the commit
block has been written (which I think few do).

At least, that is my understanding.

NeilBrown
