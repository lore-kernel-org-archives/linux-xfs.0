Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 17:18:11 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH1I4na007464
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:18:08 -0800
Received: from out3.smtp.messagingengine.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 376E81168A3B
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:18:16 -0800 (PST)
Received: from out3.smtp.messagingengine.com (out3.smtp.messagingengine.com [66.111.4.27]) by cuda.sgi.com with ESMTP id jkE0M1118TCvpqOS for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 17:18:16 -0800 (PST)
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id C65F97DAA6
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 20:17:44 -0500 (EST)
Message-Id: <1197854264.9694.1226902133@webmail.messagingengine.com>
From: "Alex Madarasz" <List@madalexlists.nospammail.net>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1197653927.3841.1226620089@webmail.messagingengine.com>
   <4764AB08.7040608@sandeen.net>
Subject: Re: Fedora 8.0.1 XFS Tune on HW RAID for Max Write Throughput?
In-Reply-To: <4764AB08.7040608@sandeen.net>
Reply-To: List@madalexlists.nospammail.net
Date: Sun, 16 Dec 2007 20:17:44 -0500
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


On Sat, 15 Dec 2007 22:35:20 -0600, "Eric Sandeen"
<sandeen@sandeen.net> said:
> Alex Madarasz wrote:
> > We're building a new Fedora 8.0.1 Linux system to stream data from a
> > 250Msps ADC to disk, and want to start tuning the system
> > configuration for maximum XFS write performance.  To date, without
> > any significant effort at tuning our Fedora 7 dev system, we're
> > seeing 250MBps write with 8-bit samples and ~ 300MBps write with 16-
> > bit samples. We want to push the tuning as far as we can go with
> > this architecture before we start looking at other hardware options.
> > Looking at various other tuning pages on the Web finds few that are
> > interested in maxing out sequential writes to very large arrays
> > while using SAS HW RAID with big fast SAS drives too.
> ...
>
> > XFS Tuning Options?
> >
> > - HW RAID0:
> >   - Array/logical disk HW RAID stripe size?
>
> At any rate you'll want to match xfs's geometry with the raid
> geometry.

The HP P400 stripe size defaults to 128K and can go up to 256K (and down
to 64K, 32K, ...). Any reason, with big sequential XFS write loads, I 
shouldn't just max it out at 256K and move on?

I understand Linux XFS block size is limited to 4KiB max on Intel 32-bit
architectures ... including PAE? 


> >   - Cache enabled (some reports that cache s/b turned off?)?
>
> If it's battery-backed cache, leave it on, and disable barriers in xfs
> (it's a mount option)

It is indeed 512M of HP Battery-Backed Write Cache (BBWC).


> >   - xfs mkfs / mount options?
>
> David mentioned these before as a generic place to start:
>
> # mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d
> # agcount=4
> <dev>
> # mount -o logbsize=256k <dev> <mtpt>
>
> and that those would be upcoming new defaults for mkfs.
> 
> 4 ags may not be what you want for a ~2T filesystem.


> > - External Log?
> >   - How big a partition on the E200i?
> >   - mkfs / mount options?
>
> not sure if an external log would be beneficial or not.
