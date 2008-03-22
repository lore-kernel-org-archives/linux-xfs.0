Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Mar 2008 03:05:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2MA5eAS006731
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 03:05:41 -0700
Received: from mx1.wp.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEC096D3D28
	for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 03:06:12 -0700 (PDT)
Received: from mx1.wp.pl (mx1.wp.pl [212.77.101.5]) by cuda.sgi.com with ESMTP id 8pXTaoeHBhyiyTT5 for <xfs@oss.sgi.com>; Sat, 22 Mar 2008 03:06:12 -0700 (PDT)
From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: BUG: xfs on linux lvm - lvconvert random hungs when doing i/o
Date: Sat, 22 Mar 2008 11:20:41 +0100
References: <200803211520.16398.stf_xl@wp.pl> <20080321174556.GA5433@josefsipek.net>
In-Reply-To: <20080321174556.GA5433@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221120.42144.stf_xl@wp.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Friday 21 March 2008, Josef 'Jeff' Sipek wrote:
> On Fri, Mar 21, 2008 at 03:20:16PM +0100, Stanislaw Gruszka wrote:
> 
> Interesting, I've noticed similar hang (based on my un-expert inspection of
> your backtraces) which went away as suddenly as it appeared. I wasn't making
> snapshots or any other LVM operation at the time. It just happened - logs
> didn't contain anything.

What I showed in traces is real deadlock, processes will stay in this state
as long as machine power off or end of the world, nothing will up semaphores.

Making snapshot when there is pending I/O on volume take much more
time compering when there is no load, propably because of locks contention,
which is problem by itself.  However in most cases processes unlock
after some time. For me making snapshot take few seconds without I/O
and something between 1 - 3 minutes with I/O . However, as I told before,
in very rare cases making snapshot with I/O on xfs volume take forever.

Stanislaw Gruszka
