Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 15:09:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5NM9PQv012227
	for <linux-xfs@oss.sgi.com>; Mon, 23 Jun 2008 15:09:25 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AEF926BF3C
	for <linux-xfs@oss.sgi.com>; Mon, 23 Jun 2008 15:10:23 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 0mlFfu8gLWMSDi8y for <linux-xfs@oss.sgi.com>; Mon, 23 Jun 2008 15:10:23 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS mkfs/mount options (w/ better results this time)
Date: Tue, 24 Jun 2008 00:10:20 +0200
References: <574409.56108.qm@web34506.mail.mud.yahoo.com> <200806232350.22161.Martin@lichtvoll.de> (sfid-20080623_235557_453472_F9CE4644)
In-Reply-To: <200806232350.22161.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240010.20950.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: MusicMan529@yahoo.com

Am Montag 23 Juni 2008 schrieb Martin Steigerwald:
> Am Montag 23 Juni 2008 schrieb Mark:
> > I ran a round of tests using 5 threads, to resemble 1 runnable and 1
> > waiting on each CPU, plus 1 more waiting. In other words, lightly
> > overloaded. XFS was the clear winner, with 378 MB/sec using the
> > "noop" scheduler. The "deadline" scheduler was a close second, with
> > 371 MB/sec.
> >
> > Here was the first twist: The completely fair queueing (CFQ)
> > scheduler seriously impeded XFS performance, so badly that even
> > "noop" out-performed it when the CPU was running at 40% clock.
>
> [...]
>
> > I re-ran all tests with 20 threads, to simulate severe process I/O
> > overloading. Even on my 2-CPU system, XFS scaled somewhat, achieving
> > 403 MB/sec with "deadline" and 401 MB/sec with "anticipatory." CFQ
> > didn't hurt the throughput as much this time, but it still came in
> > last (263 MB/sec).
>
> Thats interesting. I was curious and thus switched from cfq to deadline
> scheduler during parallel I/O workload on my ThinkPad T42 (aptitude
> upgrade / kmail receiving mails from POP3 account).
>
> It subjectively feeled way faster with deadline. I always wondered
> about the slowness of my ThinkPad T42 at massive parallel I/O. Now it
> feels a lot more responsive. Its as if I bought a new super-seek
> harddisk or what (compared to before).

It feels like I have a completely different system. Not only on massive 
parallel I/O. Starting OpenOffice... starting KDE apps... deadline seems 
to outperform cfq regarding subjectively perceived desktop performance to 
no end. That difference is absolutely astonishing for me. My ThinkPad 
*flies* compared to before.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
