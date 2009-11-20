Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK5T56t116181 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 23:29:05 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A087C9E8F9
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 21:29:27 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id O92kfia7L0H86E7l for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2009 21:29:27 -0800 (PST)
Message-ID: <4B062936.30103@sandeen.net>
Date: Thu, 19 Nov 2009 23:29:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Improving XFS desktop performance?
References: <74fd948d0911191805m30c34b51m97c2a998dbe0bac3@mail.gmail.com>
In-Reply-To: <74fd948d0911191805m30c34b51m97c2a998dbe0bac3@mail.gmail.com>
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
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: xfs@oss.sgi.com

Pedro Ribeiro wrote:
> Hi all,
> 
> I've been using XFS since 2007 and I although I'm quite happy with its
> performance, I am always looking at ways to improve it.
> My usage is a regular desktop machine, for software development and
> web browsing.
> The main performance bottleneck I have is LUKS :-) However, I really
> like my data encrypted, so dissing it is not an option. Actually, I'm
> the xfs improvements discussed below I was able to get the performance
> hit to something like 10% - negligible for me.
> 
> So what I do is specify a 128m log on filesystem creation:
> mkfs.xfs -l size=128m /dev/mapper/target
> 
> And on /etc/fstab mount it as;
> /dev/mapper/target      noatime,logbufs=8,logbsize=256k

FWIW, 8 logbufs is default already.

> After the above, my delete speed improved drastically.
> 
> Searching around the net I was able to find that using "lazy-count=1"
> on mkfs would give a performance increase - how much would that be,
> enough for me to do a full backup, format with that option + 128m log
> and then restore all again?

You should be able to use xfs_admin to turn it on; see the man page
for that.

> And anything else you recommend?

In general, the defaults are optimal for generic use; unless you have
a specific use case that is suffering, it's hard to make recommendations
beyond the defaults....

...although we do keep talking about making lazy sb counters default.

-Eric

> Thanks for your time,
> Pedro
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
