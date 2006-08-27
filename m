Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 13:51:59 -0700 (PDT)
Received: from zenon.apartia.fr (zenon.apartia.fr [82.66.93.83])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7RKppDW030674
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 13:51:52 -0700
Received: from styx.apartia.fr (styx.apartia.fr [10.0.3.109])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "styx.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by zenon.apartia.fr (Postfix) with ESMTP id 42FB0F332BA03
	for <xfs@oss.sgi.com>; Sun, 27 Aug 2006 22:51:20 +0200 (CEST)
Date: Sun, 27 Aug 2006 22:51:19 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
Message-ID: <20060827205119.GA10325@apartia.fr>
References: <20060827072810.GA4098@apartia.fr> <20060827204222.GB12065@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060827204222.GB12065@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Sun, Aug 27, 2006 at 01:42:22PM -0700, Chris Wedgwood wrote:
> On Sun, Aug 27, 2006 at 09:28:10AM +0200, Louis-David Mitterrand wrote:
> 
> > 	xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
> 
> Not enough memory, try adding swap space if that's possible?  (BTW,
> how much memory do you have in this case?)

I had 2GB RAM and a 300GB swap partition and was monitoring memory 
consumption with "top": it never went over 3BG before failing.

With the 2.7.x version of xfs_repair found on a live CD distro, memory 
consumption never exceeds 1GB on the same filesystem. Why has the 2.8.11 
version become so greedy?
