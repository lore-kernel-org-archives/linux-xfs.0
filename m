Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 15:34:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m22NYT6j020544
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 15:34:32 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E63F63E3AA
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 15:34:57 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id ZYz48CG7zGnCKmqG for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 15:34:57 -0800 (PST)
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <47C89303.7070902@thebarn.com>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
	 <1204166101.13569.102.camel@edge.scott.net.au>
	 <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net>
	 <47C89303.7070902@thebarn.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:34:55 +1100
Message-Id: <1204500895.10190.3.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 2008-02-29 at 17:19 -0600, Russell Cattelan wrote:
> 
> > I thought about that; xfs *could* stick someting in /proc/fs/xfs
> with
> > supported features or somesuch.
> >
> > But, the kernel you mkfs under isn't necessarily the one you're
> going to
> > need to fall back to tomorrow, though...
> >
> >   
> True but at least it could make a bit of a intelligent decision.
> and maybe a warning for a while about potentially incompatible flags. 

Might also be a good idea to require -f to force a mkfs of a filesystem
which the kernel doesn't support.

Would be good to get blocksize > pagesize into this scheme too btw, and
unfortunately that one isn't a superblock flag) - so this scheme might
need to go beyond those flags, if anyone decides to implement it.

cheers.

-- 
Nathan
