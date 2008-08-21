Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 10:06:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LH6Hoh032755
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:06:17 -0700
Received: from emh03.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A8103BCC03
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:07:37 -0700 (PDT)
Received: from emh03.mail.saunalahti.fi (emh03.mail.saunalahti.fi [62.142.5.109]) by cuda.sgi.com with ESMTP id AQV4zSItXDYh2ye8 for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:07:37 -0700 (PDT)
Date: Thu, 21 Aug 2008 20:10:08 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <20080821082532.GE5706@disturbed>
Message-ID: <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
 <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed>
 <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed>
 <20080821060418.GC5706@disturbed> <20080821082532.GE5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Thu, 21 Aug 2008, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > 
> > One thing I just found out - my old *laptop* is 4-5x faster than the
> > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > if the long delays in dispatch is caused by an interaction with CTQ
> > but I can't change it on the cciss raid controllers. Are you using
> > ctq/ncq on your machine?  

It's a laptop and has NCQ. It makes no difference if NCQ is enabled or 
disabled. The problem seems to be XFS only.

> > If so, can you reduce the depth to something less than 4 and see what 
> > difference that makes?
> 
> Just to point out - this is not a new problem - I can reproduce
> it on 2.6.24 as well as 2.6.26. Likewise, my laptop shows XFS
> being faster than ext3 on both 2.6.24 and 2.6.26. So the difference
> is something related to the disk subsystem on the server....

XFS definitely stalls somewhere: stats show virtually no CPU usage and no 
time spent waiting for IO. No file system produces similar output.

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 3146180   7848 600868    0    0     0  4128  790  549  0  2 98  0
 0  0      0 3145200   7848 601524    0    0     0  2372  766  516  0  2 98  0
 1  0      0 3144328   7848 602260    0    0     0  2924  792  542  1  2 98  0
 0  1      0 3143824   7856 602664    0    0     0  4116  732  426  0  2 53 45
 1  0      0 3143068   7856 603136    0    0     0  4676  756  534  0  3 95  1
 0  0      0 3142652   7856 603540    0    0     0  6577  756  436  0  0 100  0
 0  0      0 3141952   7856 604100    0    0     0  5840  764  498  1  3 96  0
 0  0      0 3141424   7856 604544    0    0     0  4752  761  386  0  0 99  0
 0  0      0 3140860   7856 604916    0    0     0  6477  785  495  0  1 98  0
 0  0      0 3139980   7856 605468    0    0     0  2840  743  370  1  2 97  0
 0  0      0 3138464   7856 606884    0    0     0  4902  795  421  0  4 96  0
 0  0      0 3137636   7856 607696    0    0     0  4364  739  395  0  1 99  0
 0  0      0 3136520   7856 608220    0    0     0  6160  774  566  0  2 97  0

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
