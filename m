Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16MpQBX171057 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 16:51:26 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3cK7B6aIOS5RAujU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 14:51:25 -0800 (PST)
Date: Mon, 6 Feb 2012 23:51:22 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Soft lockup problem
Message-ID: <20120206225122.GF24840@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
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
To: Gerard Saraber <gsaraber@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
> Greetings everyone,
> I've been having a bit of a problem since upgrading to the linux 3.x
> series, I have a machine that we're using as a NAS that runs various
> rsync processes (mostly at night), lately after a day or two, I will
> come in in the morning to a load average of 49, but the machine not
> really doing anything, when trying to run 'dstat' the command just
> hung with no output at all. there were no errors in the logs, or even
> anything that would vaguely point at anything I could work with.
> So needing to get the machine back to work I attempted to reboot it
> "shutdown -r now" on console... it gives a nice message saying it's
> going to reboot, but nothing ever happens.. the only way to reboot it
> is by using ctrl + alt + sysrq + b. after which the machine reboots
> and the raid array comes back clean.
> 
> I'm not sure how to troubleshoot this, any pointers would be appreciated.
> 
> I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
> options in the kernel debugging section:
> detect hard/soft lockups and detect hung tasks, maybe it'll give me
> something more to go on.
> 
> Some details about the machine:
> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
> together into a 23TB XFS filesystem.
> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded together.
  Hmm, might be some deadlock in the filesystem. Adding XFS guys to CC.
Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
