Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 20:34:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m234Y2f3009897
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 20:34:04 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5551F0381C
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2008 20:34:31 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id TRh6VWXj2n2TZkkv for <xfs@oss.sgi.com>; Sun, 02 Mar 2008 20:34:31 -0800 (PST)
Date: Sun, 2 Mar 2008 23:14:09 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
Message-ID: <20080303041409.GC13879@josefsipek.net>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com> <1204166101.13569.102.camel@edge.scott.net.au> <47C87775.2010007@thebarn.com> <47C89137.3070805@sandeen.net> <47C89303.7070902@thebarn.com> <1204500895.10190.3.camel@edge.scott.net.au> <47CB434B.4040005@sgi.com> <47CB4696.1030304@sgi.com> <20080303011559.GB13879@josefsipek.net> <47CB7702.5080905@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CB7702.5080905@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Mark Goodwin <markgw@sgi.com>, Timothy Shimmin <tes@sgi.com>, nscott@aconex.com, Russell Cattelan <cattelan@thebarn.com>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Mar 02, 2008 at 09:56:50PM -0600, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> > On Mon, Mar 03, 2008 at 11:30:14AM +1100, Mark Goodwin wrote:
> > ...
> >> Maybe I'm missing something, but if we export all the feature bits,
> >> both new and old, then (a) an old mkfs will continue to ignore them,
> >> and (b) future versions of mkfs will have all the information needed,
> >> but will need t be smart about how that information is used.
> > 
> > IMHO:
> > 
> > 1) mkfs should make a filesystem, the defaults should be conservative (say
> >    using features that have been around >1 year)
> 
> I suppose I have to agree, unfortunately that means most competetive
> benchmarks will be using sub-optimal mkfs's, but...
 
Benchmarks that use default mkfs options on xfs, but non-default on other
fs?

If you want, have a simple printf in mkfs that tells the user that he's not
using the latest and greatest features (e.g., lazy-count); that should be
enough to make it obvious that there're better options than the default.

> It's not like we're running mkfs.ext3 here... ;)  mkfs; mount will tell
> you quickly if there's a problem, won't it.  Adding complexity to mkfs
> might not make a lot of sense.

Exactly :)

Josef 'Jeff' Sipek.

-- 
I already backed up the [server] once, I can do it again.
		- a sysadmin threatening to do more frequent backups
