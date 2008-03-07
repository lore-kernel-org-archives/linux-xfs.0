Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 14:35:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m27MYnut007756
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 14:34:52 -0800
Date: Sat, 8 Mar 2008 09:35:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: pdflush hang on xlog_grant_log_space()
Message-ID: <20080307223510.GM155407@sgi.com>
References: <47D062AF.80501@steelbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D062AF.80501@steelbox.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kris Kersey <kkersey@steelbox.com>
Cc: xfs@oss.sgi.com, Bill Vaughan <billv@steelbox.com>

On Thu, Mar 06, 2008 at 04:31:27PM -0500, Kris Kersey wrote:
> Hello,
> 
> I'm working on a NAS product and we're currently having lock-ups that
> seem to be hanging in XFS code.  We're running a NAS that has 1024 NFSD
> threads accessing three RAID mounts.  All three mounts are running XFS
> file systems.  Lately we've had random lockups on these boxes and I am
> now running a kernel with KDB built-in.
> 
> The lock-up takes the form of all NFSD threads in D state with one out
> of three pdflush threads in D state.  The assumption can be made that
> all NFSD threads are waiting on the one pdflush thread to complete.  So
> two times now when an NAS has gotten in this state I have accessed KDB
> and ran a stack trace on the pdflush thread.  Both times the thread was
> stuck on xlog_grant_log_space+0xdb.

Try bumping XFS_TRANS_PUSH_AIL_RESTARTS to a much larger number and
seeing if the problem goes away....

Alternatively, that restart hack is backed by a "watchdog" timeout
in 2.6.25-rc1, so if that is the cause of the problem perhaps the
latest -rcX kernel will prevent the hang?

BTW, you can get all the traces of D state threads through the sysrq
interface, so you don't need to drop into kdb to get this.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
