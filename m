Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 14:49:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5NLnRqK009603
	for <linux-xfs@oss.sgi.com>; Mon, 23 Jun 2008 14:49:27 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS mkfs/mount options (w/ better results this time)
Date: Mon, 23 Jun 2008 23:50:20 +0200
References: <574409.56108.qm@web34506.mail.mud.yahoo.com> (sfid-20080623_221540_467113_1C5A2C42)
In-Reply-To: <574409.56108.qm@web34506.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232350.22161.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, MusicMan529@yahoo.com

Am Montag 23 Juni 2008 schrieb Mark:

> I ran a round of tests using 5 threads, to resemble 1 runnable and 1
> waiting on each CPU, plus 1 more waiting. In other words, lightly
> overloaded. XFS was the clear winner, with 378 MB/sec using the "noop"
> scheduler. The "deadline" scheduler was a close second, with 371
> MB/sec.
>
> Here was the first twist: The completely fair queueing (CFQ) scheduler
> seriously impeded XFS performance, so badly that even "noop"
> out-performed it when the CPU was running at 40% clock.


[...]

> I re-ran all tests with 20 threads, to simulate severe process I/O
> overloading. Even on my 2-CPU system, XFS scaled somewhat, achieving
> 403 MB/sec with "deadline" and 401 MB/sec with "anticipatory." CFQ
> didn't hurt the throughput as much this time, but it still came in last
> (263 MB/sec).

Thats interesting. I was curious and thus switched from cfq to deadline 
scheduler during parallel I/O workload on my ThinkPad T42 (aptitude 
upgrade / kmail receiving mails from POP3 account).

It subjectively feeled way faster with deadline. I always wondered about 
the slowness of my ThinkPad T42 at massive parallel I/O. Now it feels a 
lot more responsive. Its as if I bought a new super-seek harddisk or what 
(compared to before).

I think I will try deadline for some days at least, also on my ThinkPad 
T23 and on my workstation at work.

No objective performance measurements yet. ;) And not much time for them 
either.

Have I/O schedulers been tested against different filesystems before? 
Maybe the default I/O scheduler cfq isn't the best one for XFS, but only 
for ext3?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
