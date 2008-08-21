Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 10:30:02 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LHTwvw002380
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:29:59 -0700
Received: from emh01.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69DE71A20C91
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:31:17 -0700 (PDT)
Received: from emh01.mail.saunalahti.fi (emh01.mail.saunalahti.fi [62.142.5.107]) by cuda.sgi.com with ESMTP id N8Y6JDXyySqF4ECJ for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 10:31:17 -0700 (PDT)
Date: Thu, 21 Aug 2008 20:33:50 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
Message-ID: <Pine.LNX.4.61.0808212031050.4532@dhcppc2>
References: <20080820004326.519405a2.akpm@linux-foundation.org>
 <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2>
 <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed>
 <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed>
 <20080821060418.GC5706@disturbed> <20080821082532.GE5706@disturbed>
 <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Thu, 21 Aug 2008, Szabolcs Szakacsits wrote:
> On Thu, 21 Aug 2008, Dave Chinner wrote:
> > On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> > > 
> > > One thing I just found out - my old *laptop* is 4-5x faster than the
> > > 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> > > if the long delays in dispatch is caused by an interaction with CTQ
> > > but I can't change it on the cciss raid controllers. Are you using
> > > ctq/ncq on your machine?  
> 
> It's a laptop and has NCQ. It makes no difference if NCQ is enabled or 
> disabled. The problem seems to be XFS only.

The 'nobarrier' mount option made a big improvement:

                    MB/s    Runtime (s)
                   -----    -----------
  btrfs unstable   17.09        572
  ext3             13.24        877
  btrfs 0.16       12.33        793
  nilfs2 2nd+ runs 11.29        674
  ntfs-3g           8.55        865
  reiserfs          8.38        966
  xfs nobarrier     7.89        949
  nilfs2 1st run    4.95       3800
  xfs               1.88       3901

	Szaka
 
-- 
NTFS-3G:  http://ntfs-3g.org
