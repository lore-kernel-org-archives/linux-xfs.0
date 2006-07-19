Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 16:00:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6JMxmDW007848
	for <xfs@oss.sgi.com>; Wed, 19 Jul 2006 15:59:59 -0700
Date: Thu, 20 Jul 2006 08:59:04 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS breakage in 2.6.18-rc1
Message-ID: <20060720085904.E1947140@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153304468.3706.4.camel@localhost>; from lkml@metanurb.dk on Wed, Jul 19, 2006 at 12:21:08PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Torsten Landschoff <torsten@debian.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 19, 2006 at 12:21:08PM +0200, Kasper Sandberg wrote:
> On Wed, 2006-07-19 at 08:57 +1000, Nathan Scott wrote:
> > On Wed, Jul 19, 2006 at 12:29:41AM +0200, Torsten Landschoff wrote:
> > > Hi friends, 
> > 
> > Hi Torsten,
> > 
> > > I upgraded to 2.6.18-rc1 on sunday, with the following results (taken
> > > from my /var/log/kern.log), which ultimately led me to reinstall my 
> > > system:
> > > 
> > > Jul 17 07:33:53 pulsar kernel: xfs_da_do_buf: bno 16777216
> > > Jul 17 07:33:53 pulsar kernel: dir: inode 54526538
> > 
> > I suspect you had some residual directory corruption from using the
> > 2.6.17 XFS (which is known to have a lurking dir2 corruption issue,
> > fixed in the latest -stable point release).
> This has me very worried.
> 
> i just upgraded to .18-rc1-git5 when it came out, i used .17-rc3 before.
> does this mean my .17-rc3 may have corrupted my filesystem?
> 
> what action do you suggest i do now?

The odds are decent that you're unaffected.  You can check your filesystem
using xfs_check or xfs_repair -n and these will give you a good indication
as to whether further action is required.

cheers.

-- 
Nathan
