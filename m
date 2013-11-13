Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 666037F63
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:51:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 296C0304043
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:51:48 -0800 (PST)
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id S7xk8KWvVmIzUSeG for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 08:51:46 -0800 (PST)
Subject: Re: Files not touched in weeks got truncated after a crash
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <2662179.4mj0dgORXu@r008>
References: <2662179.4mj0dgORXu@r008>
Date: Wed, 13 Nov 2013 16:51:44 +0000
Message-Id: <1384361504.4299.132.camel@localhost.localdomain>
Mime-Version: 1.0
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
To: Guido Winkelmann <guido@ambient-entertainment.de>
Cc: xfs@oss.sgi.com


On Wed, 2013-11-13 at 17:36 +0100, Guido Winkelmann wrote:
> Hi,
> 
> We are having some trouble with one of our fileservers using XFS (on linux). 
> Yesterday, one of the external RAIDs on the server failed. Of course, it is 
> unavoidable that some data would get lost from the fileserver in such an 
> event, however, we lost a lot more files than would seem reasonable. In 
> particular, we lost a number of files that had not been written to (but had 
> been been read from, in some cases) in several weeks.
> 
> The data loss manifested itself through files being truncated to length 0 or 
> to some other size short of what they should be. (We happen to have an 
> external database that keeps track of that.)
> 
> The fileserver is based on CentOS 6.3 with kernel version 
> 2.6.32-279.9.1.el6.x86_64. It has got several external RAIDs in the 100 TB 
> range, connected via FibreChannel.
> 
> In case it matters: The server's primary role is as a samba server servicing a 
> large number of Windows XP and Windows 7 machines.
> 
> We had already been trying to reduce the possible impact of a hardware failure 
> by setting a few tunables in /etc/sysctl.conf to try and make the kernel not 
> keep dirty buffers around too long:
> 
> vm.dirty_background_bytes = 536870912
> vm.dirty_bytes = 134217728
> vm.dirty_writeback_centisecs = 500
> vm.dirty_expire_centisecs = 3000
> 
> and by issuing a sync from cron every 15 minutes:
> 
> 0,15,30,45 * * * * /bin/sync
> 
> Unfortunately, I seem to be unable so far to reproduce the issue on a smaller 
> system - and I cannot exactly just walk up to the in-production fileserver and 
> rip out yet another array just to see what happens...
> 
> This leaves me with a few questions:
> 
> Why did we lose so much data through the crash?
> 
> Why did not even a sync every 15 minutes prevent further damage?
> 
> What can we do to prevent this from happening again in the future?
> 
> Regards,
> 
> 	Guido

Syncing won't protect you from hardware failures.

Without more details about what happened to the external RAID and what
you did to recover it's impossible to answer your question.

--
Roger



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
