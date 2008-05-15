Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 15:28:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4FMRl3r013983
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 15:27:50 -0700
Date: Fri, 16 May 2008 08:27:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.26-rc1: possible circular locking dependency with xfs filesystem
Message-ID: <20080515222753.GV155679365@sgi.com>
References: <a4423d670805101005x113c4813w2b95c1fb535cf080@mail.gmail.com> <4825DF71.1030209@linux.vnet.ibm.com> <48266C77.3040102@linux.vnet.ibm.com> <20080511231002.GN103491721@sgi.com> <a4423d670805151045k4d2f9459geaeeff7418957487@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670805151045k4d2f9459geaeeff7418957487@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David Chinner <dgc@sgi.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, pvp-lsts@fs.ru.acad.bg, kernel-testers@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, xfs@oss.sgi.com

On Thu, May 15, 2008 at 09:45:55PM +0400, Alexander Beregalov wrote:
> 2008/5/12 David Chinner <dgc@sgi.com>:
> > On Sun, May 11, 2008 at 09:18:07AM +0530, Kamalesh Babulal wrote:
> >> Kamalesh Babulal wrote:
> >> > Adding the cc to kernel-list, Ingo Molnar and Peter Zijlstra
> >> >
> >> > Alexander Beregalov wrote:
> >> >> [ INFO: possible circular locking dependency detected ]
> >> >> 2.6.26-rc1-00279-g28a4acb #13
> >> >> -------------------------------------------------------
> >> >> nfsd/3087 is trying to acquire lock:
> >> >>  (iprune_mutex){--..}, at: [<c016f947>] shrink_icache_memory+0x38/0x19b
> >> >>
> >> >> but task is already holding lock:
> >> >>  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0210b83>] xfs_ilock+0xa2/0xd6

[snip]

> > Oh, yeah, that. Direct inode reclaim through memory pressure.
> >
> > Effectively memory reclaim inverts locking order w.r.t. iprune_mutex
> > when it recurses into the filesystem. False positive - can never
> > cause a deadlock on XFS. Can't be solved from the XFS side of things
> > without effectively turning off lockdep checking for xfs inode
> > locking.
> Yes, it is not a deadlock, but machine hangs for few seconds.
> It still happens about once a day for me. Every kernel report looks
> similar to the above.

That hang is just memory reclaim running, I think you'll find.
It can take some time for reclaim to find pages to use, and meanwhile
everything in the machine will back up behind it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
