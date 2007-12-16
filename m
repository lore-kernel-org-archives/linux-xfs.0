Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Dec 2007 20:35:55 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBG4ZmBF018656
	for <xfs@oss.sgi.com>; Sat, 15 Dec 2007 20:35:51 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5865A115D7F2
	for <xfs@oss.sgi.com>; Sat, 15 Dec 2007 20:35:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id m3WCXpqWdN0sm5Kj for <xfs@oss.sgi.com>; Sat, 15 Dec 2007 20:35:58 -0800 (PST)
Message-ID: <4764AB08.7040608@sandeen.net>
Date: Sat, 15 Dec 2007 22:35:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fedora 8.0.1 XFS Tune on HW RAID for Max Write Throughput?
References: <1197653927.3841.1226620089@webmail.messagingengine.com>
In-Reply-To: <1197653927.3841.1226620089@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alex Madarasz <List.XFS@madalexlists.nospammail.net>
Cc: xfs@oss.sgi.com

Alex Madarasz wrote:
> We're building a new Fedora 8.0.1 Linux system to stream data from a
> 250Msps ADC to disk, and want to start tuning the system configuration
> for maximum XFS write performance.  To date, without any significant
> effort at tuning our Fedora 7 dev system, we're seeing 250MBps write
> with 8-bit samples and ~ 300MBps write with 16-bit samples. We want to
> push the tuning as far as we can go with this architecture before we
> start looking at other hardware options.  Looking at various other
> tuning pages on the Web finds few that are interested in maxing out
> sequential writes to very large arrays while using SAS HW RAID with big
> fast SAS drives too.

...

> XFS Tuning Options?
> 
> - HW RAID0:
>   - Array/logical disk HW RAID stripe size?

At any rate you'll want to match xfs's geometry with the raid geometry.

>   - Cache enabled (some reports that cache s/b turned off?)?

If it's battery-backed cache, leave it on, and disable barriers in xfs
(it's a mount option)

>   - xfs mkfs / mount options?

David mentioned these before as a generic place to start:

# mkfs.xfs -f -l lazy-count=1,version=2,size=128m -i attr=2 -d agcount=4
<dev>
# mount -o logbsize=256k <dev> <mtpt>

and that those would be upcoming new defaults for mkfs.

4 ags may not be what you want for a ~2T filesystem.

> - External Log?
>   - How big a partition on the E200i?
>   - mkfs / mount options?

not sure if an external log would be beneficial or not.

I'm sure others will have more concrete suggestions.  It might be
interesting to post any performance you're getting which does not meet
your expectations...

-Eric

> 
> ...?
> 
> Thanks for any tips,
> 
