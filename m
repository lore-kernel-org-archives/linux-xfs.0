Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Aug 2006 19:00:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7P200DW001342
	for <xfs@oss.sgi.com>; Thu, 24 Aug 2006 19:00:16 -0700
Date: Fri, 25 Aug 2006 11:58:58 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: xfs bug in 2.6.17.9?
Message-ID: <20060825115858.A3029472@wobbly.melbourne.sgi.com>
References: <92b7ea0a0608240245v700f19dex6ecb688efcab657b@mail.gmail.com> <Pine.LNX.4.64.0608240942180.30908@p34.internal.lan> <1156463263.19666.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1156463263.19666.7.camel@localhost.localdomain>; from liste@jordet.net on Fri, Aug 25, 2006 at 01:47:43AM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stian Jordet <liste@jordet.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Fri, Aug 25, 2006 at 01:47:43AM +0200, Stian Jordet wrote:
> tor, 24,.08.2006 kl. 09.42 -0400, skrev Justin Piszcz:
> > Aug 24 09:22:09 buick kernel: xfs_da_do_buf: bno 16777216
> > 
> > That is the bug from 2.6.17 -> 2.6.17.6.
> > 
> > It was patched in 2.6.17.7, but I assume(?) if you never fixed your FS to 
> > begin with, you will still have the problem.  Read the XFS FAQ, and backup 
> > your data before you do that :)
> 
> As I just wrote to Martin, I did run a couple of those kernels. But even
> with updated xfsprogs I can't fix the errors... Is that "normal", or am
> I in deep trouble?

This is likely to be lost+found being recreated each time, its
normal if you don't do something about the lost+found files -
once those are renamed/removed, it should run cleanly.

cheers.

-- 
Nathan
