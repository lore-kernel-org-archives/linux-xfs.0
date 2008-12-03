Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3La9Rf020579 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 15:36:12 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F624164C267
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 13:36:05 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	DHTDBWqNHFJcRm3K for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2008 13:36:05 -0800 (PST)
Date: Thu, 4 Dec 2008 08:30:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081203213028.GW18236@disturbed>
References: <200812021949.55463.arekm@maven.pl>
	<20081203032013.GS18236@disturbed>
	<200812031406.41882.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812031406.41882.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 02:06:41PM +0100, Arkadiusz Miskiewicz wrote:
> On Wednesday 03 of December 2008, Dave Chinner wrote:
> > On Tue, Dec 02, 2008 at 07:49:55PM +0100, Arkadiusz Miskiewicz wrote:
> > > Hello,
> > >
> > > I'm trying to use xfs project quota on kernel 2.6.27.7 (vanilla, no
> > > additional patches), x86_64 UP machine (SMP kernel).
> > >
> > > Now some processes that are using /home/users/arekm/rpm are hanging in
> > > D-state like:
.....
> [arekm@farm ~]$ zgrep LOCKDEP /proc/config.gz
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKDEP=y
> # CONFIG_DEBUG_LOCKDEP is not set
> 
> I don't see anything strictly lockdep related in dmesg so it doesn't seem to 
> be triggered.

Which implies there is something with a lock held that is blocked
elsewhere...

> D-state lock is also happening if I drop usrquota,prjquota, reboot and retry 
> the test. I assume something was written on disk that triggers the problem.

Unlikely - locking doesn't generally get stuck due to on disk
corruption. Are there any other blocked processes in the machine?
i.e. what is the entire output of 'echo w > /proc/sysrq-trigger'?
Are there any other signs of general unwellness (e.g. a CPU running
at 100% when it shouldn't be)?

> Note that now I'm testing on a second machine (UP i686, SMP kernel), so this 
> isn't unique problem.

Can you identify the inode that the unlinkis hanging on and get
an xfs_db dump of the contents of that inode? Also a dump of the
parent directory inode would be useful, too.

FWIW, if you are seeing this on two hosts, can you try to build
a reproducable test case using a minimal data set and a simple
set of commands? If you can do this and supply us with a
xfs_metadump image of the filesystem plus the commands to reproduce
the problem we'll be able to find the problem pretty quickly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
