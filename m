Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42H9jwc241416 for <xfs@oss.sgi.com>; Mon, 2 May 2011 12:09:45 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F276F1649661
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 10:13:19 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 5Ya4rPUpH28lp3GL for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 10:13:19 -0700 (PDT)
Date: Mon, 2 May 2011 19:13:23 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS/Linux Sanity check
Message-ID: <20110502191323.417ef644@harpe.intellique.com>
In-Reply-To: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Paul Anderson <pha@umich.edu>
Cc: xfs@oss.sgi.com

Le Mon, 2 May 2011 11:47:48 -0400
Paul Anderson <pha@umich.edu> =E9crivait:

> We are deploying five Dell 810s, 192GiB RAM, 12 core, each with three
> LSI 9200-8E SAS controllers, and three SuperMicro 847 45 drive bay
> cabinets with enterprise grade 2TB drives.

I have very little experience with these RAID coontrollers. However I
have a 9212 4i4e (same card generation and same chipset) in test, and so
far I must say it looks like _utter_ _crap_. The performance is abysmal
(it's been busy rebuilding a 20TB array for... 6 days!); the server
regularly freezes and crashes without any reason (it's a pure dev
system with virtually zero load and zero IO); and there were lots of
filesystem corruptions. I'm running a 2.6.32.25 64 bits plain vanilla
kernel that poses no problem whatsoever with any other configuration.
 =

> In isolated testing, I see around 5GiBytes/second raw (135 parallel dd
> reads), and with a benchmark test of 10 simultaneous 64GiByte dd
> commands, I can see just shy of 2 GiBytes/second reading, and around
> 1.4GiBytes/second writing through XFS.   The benchmark is crude, but
> fairly representative of our expected use.

I don't understand why there's such a gap between the raw and XFS
performance. Generally XFS gives 90% performance or more of raw
performance.
 =

> md apparently does not support barriers, so we are badly exposed in
> that manner, I know.  As a test, I disabled write cache on all drives,
> performance dropped by 30% or so, but since md is apparently the
> problem, barriers still didn't work.

Frankly, I'd stay away from md at this array size. I'm pretty sure
you're exploring uncharted territory here. =


> Ideally, I'd firstly be able to find informed opinions about how I can
> improve this arrangement - we are mildly flexible on RAID controllers,
> very flexible on versions of Linux, etc, and can try other OS's as a
> last resort (but the leading contender here would be "something"
> running ZFS, and though I love ZFS, it really didn't seem to work well
> for our needs).

I can't yet be sure because I plan more testing with this card, but I'd
ditch the LSI controllers for LSI/3Ware or Adaptec (or Areca
eventually), and stay away from md RAID and use hardware RAID. I'm an
hardware RAID freak, but... hardware RAID allows proper write cache,
for a start (because it has BBUs). =


-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
