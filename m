Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4PBlMK3138577 for <xfs@oss.sgi.com>; Wed, 25 May 2011 06:47:22 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9020A1657F30
	for <xfs@oss.sgi.com>; Wed, 25 May 2011 04:47:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dDrE7yECwJRxgOeY for
	<xfs@oss.sgi.com>; Wed, 25 May 2011 04:47:21 -0700 (PDT)
Date: Wed, 25 May 2011 13:47:15 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: automatically running fstrim
In-Reply-To: <BANLkTi=8CX_rjWHFEjt5JO5oScdKoZopww@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1105251335280.4667@dhcp-27-109.brq.redhat.com>
References: <4DDBE293.8030203@philkarn.net>
	<alpine.LFD.2.00.1105251155120.4667@dhcp-27-109.brq.redhat.com>
	<BANLkTi=8CX_rjWHFEjt5JO5oScdKoZopww@mail.gmail.com>
MIME-Version: 1.0
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
To: karn@ka9q.net
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, 25 May 2011, Phil Karn wrote:

> Thanks. My problem is that I've been running some workloads that can gobble
> up the SSD erased page pool rather quickly. It's a Perl script feeding a
> large number of email messages to procmail, one at a time. I think this
> creates and deletes a lot of temporary files. While XFS delayed allocation
> normally keeps such files from going to disk, I think procmail defeats this
> with fsync() to keep mail from ever being lost.
> 
> So I've simply been running fstrim by hand a lot so I don't have a repeat of
> the system lockup I had a few days ago that I am pretty sure was due to my
> OCZ Revo drive not handling garbage collection very gracefully.
> 
> Phil
> 

Interesting, system lockup really ? I have never seen problems like this
and I have been doing a lot of SSD testing. Looks like that the drive is
really crappy :), have you tried to look up for firmware update ?

Anyway, if running fstrim more often solves the problem, it is fine. But
I wonder if the other approach (periodic discard) would do better in
this case (it might not since the files are really small and are
unlinked often). Unfortunately xfs does not have this support yet, but
other filesystems do (ext4,btrfs,...) so if you like you might try one
of those and mount it with -o discard mount option. What it does is,
that it will send a TRIM for every range of freed filesystem blocks.

Generally, in its current state it comes with quite big performance
loss (that's why we have fstrim), but in you case it might be actually
more convenient than running fstrim all the time. Also it is handled
automatically and the only think needed is to pass the "-i discard"
mount option.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
