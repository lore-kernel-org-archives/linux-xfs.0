Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 04:23:42 -0700 (PDT)
Received: from pqueuea.post.tele.dk (pqueuea.post.tele.dk [193.162.153.9])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JBN7DW022094
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 04:23:08 -0700
Received: from pfepc.post.tele.dk (pfepc.post.tele.dk [195.41.46.237])
	by pqueuea.post.tele.dk (Postfix) with ESMTP id 1A39537601E
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 12:21:13 +0200 (CEST)
Subject: Re: XFS breakage in 2.6.18-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
In-Reply-To: <20060719085731.C1935136@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy>
	 <20060719085731.C1935136@wobbly.melbourne.sgi.com>
Content-Type: text/plain
Date: Wed, 19 Jul 2006 12:21:08 +0200
Message-Id: <1153304468.3706.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2006-07-19 at 08:57 +1000, Nathan Scott wrote:
> On Wed, Jul 19, 2006 at 12:29:41AM +0200, Torsten Landschoff wrote:
> > Hi friends, 
> 
> Hi Torsten,
> 
> > I upgraded to 2.6.18-rc1 on sunday, with the following results (taken
> > from my /var/log/kern.log), which ultimately led me to reinstall my 
> > system:
> > 
> > Jul 17 07:33:53 pulsar kernel: xfs_da_do_buf: bno 16777216
> > Jul 17 07:33:53 pulsar kernel: dir: inode 54526538
> 
> I suspect you had some residual directory corruption from using the
> 2.6.17 XFS (which is known to have a lurking dir2 corruption issue,
> fixed in the latest -stable point release).
This has me very worried.

i just upgraded to .18-rc1-git5 when it came out, i used .17-rc3 before.
does this mean my .17-rc3 may have corrupted my filesystem?

what action do you suggest i do now?

> 
> > of programs fail in mysterious ways. I tried to recover using xfs_repair
> > but I feel that my partition is thorougly borked. Of course no data was 
> > lost due to backups but still I'd like this bug to be fixed ;-)
> 
> 2.6.18-rc1 should be fine (contains the corruption fix).  Did you
> mkfs and restore?  Or at least get a full repair run?  If you did,
> and you still see issues in .18-rc1, please let me know asap.
> 
> thanks.
> 
