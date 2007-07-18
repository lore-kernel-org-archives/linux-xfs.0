Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 09:53:03 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IGqqbm025571
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 09:52:54 -0700
Date: Wed, 18 Jul 2007 12:42:01 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: XFS -git changes and Linux-VServer patch porting
Message-ID: <20070718164201.GA2668@filer.fsl.cs.sunysb.edu>
References: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44c5fdf0707180649h778f017dlb532c3ba224944b2@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Jul 18, 2007 at 03:49:07PM +0200, Radoslaw Szkodzinski wrote:
> Linux-VServer patch adds 2 new flags: barrier and iunlink.
> With recent changes in -git (filestreams), XFS now lacks di_flags bits
> to add these.
> iunlink flag adds Copy-on-Write semantics to hard links, while barrier
> flag signifies a filesystem barrier no virtual context can pass.
> 
> I'd like to know how to possibly resolve this problem w/o negatively
> impacting performance (especially of iunlink) or changing on-disc
> format in an incompatible way, as well as being more future-proof.

A while back, I mentioned that it would be nice to have a whiteout inode
flag (I've since changed my mind) but the answer I got from Dave Chinner,
et. al., was to use xattrs.

Josef 'Jeff' Sipek.

-- 
If I have trouble installing Linux, something is wrong. Very wrong.
		- Linus Torvalds
