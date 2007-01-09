Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 23:57:06 -0800 (PST)
Received: from fallback.mail.elte.hu (fallback.mail.elte.hu [157.181.151.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l097uwqw016475
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 23:57:01 -0800
Received: from mx2.mail.elte.hu ([157.181.151.9])
	by fallback.mail.elte.hu with esmtp (Exim)
	id 1H4Ak5-00074g-52
	from <mingo@elte.hu>
	for <xfs@oss.sgi.com>; Tue, 09 Jan 2007 07:45:53 +0100
Date: Tue, 9 Jan 2007 07:41:13 +0100
From: Ingo Molnar <mingo@elte.hu>
Subject: Re: xfs_file_ioctl / xfs_freeze: BUG: warning at kernel/mutex-debug.c:80/debug_mutex_unlock()
Message-ID: <20070109064113.GB5569@elte.hu>
References: <20070104001420.GA32440@m.safari.iki.fi> <20070107213734.GS44411608@melbourne.sgi.com> <20070108155636.a68dce33.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070108155636.a68dce33.akpm@osdl.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@osdl.org>
Cc: David Chinner <dgc@sgi.com>, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Arjan van de Ven <arjan@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>


* Andrew Morton <akpm@osdl.org> wrote:

> > Revert bd_mount_mutex back to a semaphore so that xfs_freeze -f 
> > /mnt/newtest; xfs_freeze -u /mnt/newtest works safely and doesn't 
> > produce lockdep warnings.
> 
> Sad.  The alternative would be to implement 
> mutex_unlock_dont_warn_if_a_different_task_did_it().  Ingo?  Possible?

i'd like to avoid it as much as i'd like to avoid having to add 
spin_unlock_dont_warn_if_a_different_task_did_it(). Unlocking by a 
different task is usually a sign of messy locking and bugs lurking. Is 
it really true that XFS's use of bd_mount_mutex is safe and justified?

	Ingo
