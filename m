Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 12:52:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HJqgX9020794
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 12:52:46 -0700
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B4BEFBC149
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 12:53:14 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id U8pmh1Q4BCSv8MG9 for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 12:53:14 -0700 (PDT)
Date: Mon, 17 Mar 2008 15:53:13 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080317195313.GB16500@josefsipek.net>
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DEB930.7020108@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 17, 2008 at 01:32:16PM -0500, Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> 
> > Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
> > structure member alignment :)
> 
> Very.  ;)
> 
> Tossing packed at all the ondisk stuctures bloats things badly on ia64.
> 
> cvs/linux-2.6-xfs> wc -l before.dis
> 166688 before.dis
> cvs/linux-2.6-xfs> wc -l after.dis
> 182294 after.dis
> 
> That's +15606 lines.
 
I'm not done yet! :-P

First of all, the patch I showed you actually breaks a few things that I
still need to fix.

Second, I need to find out whether all the affected structures are always
aligned on some boundary (probably 4 or 8 byte). If there indeed is some
alignment, there might be a way to reduce those 15k extra lines to something
a whole lot less - I hope.

Josef 'Jeff' Sipek.

-- 
A CRAY is the only computer that runs an endless loop in just 4 hours...
