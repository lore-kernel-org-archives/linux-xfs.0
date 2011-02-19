Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1J9xnwx013578 for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 03:59:49 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E88CE1498C13
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 02:02:30 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 1IUqTcpMGq2BuCUM for
	<xfs@oss.sgi.com>; Sat, 19 Feb 2011 02:02:30 -0800 (PST)
Date: Sat, 19 Feb 2011 11:02:07 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: External log size limitations
Message-ID: <20110219100207.GA24537@citd.de>
References: <4D5C1D77.1060000@spinpro.com> <20110217003233.GH13052@dastard>
	<4D5E8FAD.9080802@spinpro.com> <4D5ECEC5.2020701@hardwarefreak.com>
	<4D5ED70B.7030504@spinpro.com> <4D5F3EBF.3030309@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D5F3EBF.3030309@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 18.02.2011 21:53, Stan Hoeppner wrote:
> Fist, sorry for the length.  I can tend to get windy talking shop. :)
> 
> Andrew Klaassen put forth on 2/18/2011 2:31 PM:
> 
> > It's IBM and LSI gear, so I'm crossing my fingers that a Linux install
> > will be relatively painless.
> 
> Ahh, good.  At least, so far it seems so. ;)
> 
> > I thought that the filesystem block size was still limited to the kernel
> > page size, which is 4K on x86 systems.
> > 
> > http://oss.sgi.com/projects/xfs/
> > 
> > "The maximum filesystem block size is the page size of the kernel, which
> > is 4K on x86 architecture."
> > 
> > Is this no longer true?  It would be awesome news if it wasn't.
> 
> My mistake.  It would appear you are limited to the page size, which, as
> I mentioned, is still 8 KiB for most distros.

You confuse that with STACK-size.

The page-size is, and has always been, 4 KiB (on X86).

The only exception are the Huge-Pages and while i 'grep'ped for 
Huge-pages i found this nice little paragraph in:
Documentation/vm/hugetlbpage.txt (Current git version on it's way to 2.6.38)

- snip -
The intent of this file is to give a brief summary of hugetlbpage support in
the Linux kernel.  This support is built on top of multiple page size support
that is provided by most modern architectures.  For example, i386
architecture supports 4K and 4M (2M in PAE mode) page sizes, ia64
architecture supports multiple page sizes 4K, 8K, 64K, 256K, 1M, 4M, 16M,
256M and ppc64 supports 4K and 16M.  A TLB is a cache of virtual-to-physical
translations.  Typically this is a very scarce resource on processor.
Operating systems try to make best use of limited number of TLB resources.
This optimization is more critical now as bigger and bigger physical memories
(several GBs) are more readily available.
- snip -






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
