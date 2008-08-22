Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Aug 2008 05:40:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7MCeeO7024938
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:40:40 -0700
Received: from emh06.mail.saunalahti.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AC821253B1B
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:41:58 -0700 (PDT)
Received: from emh06.mail.saunalahti.fi (emh06.mail.saunalahti.fi [62.142.5.116]) by cuda.sgi.com with ESMTP id w1uOgfPpgLFUxBbb for <xfs@oss.sgi.com>; Fri, 22 Aug 2008 05:41:58 -0700 (PDT)
Date: Fri, 22 Aug 2008 15:44:29 +0300 (MET DST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous
 snapshotting file system)
In-Reply-To: <20080822022459.GL5706@disturbed>
Message-ID: <Pine.LNX.4.61.0808221519000.4532@dhcppc2>
References: <200808201613.AA00212@capsicum.lab.ntt.co.jp>
 <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org>
 <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net>
 <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed>
 <20080821082532.GE5706@disturbed> <Pine.LNX.4.61.0808211447060.4532@dhcppc2>
 <Pine.LNX.4.61.0808212031050.4532@dhcppc2> <20080822022459.GL5706@disturbed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Fri, 22 Aug 2008, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 08:33:50PM +0300, Szabolcs Szakacsits wrote:
>
> > The 'nobarrier' mount option made a big improvement:
> 
> INteresting. Barriers make only a little difference on my laptop;
> 10-20% slower. But yes, barriers will have this effect on XFS.
> 
> If you've got NCQ, then you'd do better to turn off write caching
> on the drive, turn off barriers and use NCQ to give you back the
> performance that the write cache used to. That is, of course,
> assuming the NCQ implementation doesn't suck....

Write cache off, nobarrier and AHCI NCQ lowered the XFS result:

                               MB/s    Runtime (s)
                              -----    -----------
  btrfs unstable              17.09        572
  ext3                        13.24        877
  btrfs 0.16                  12.33        793
  ntfs-3g unstable            11.52        673
  nilfs2 2nd+ runs            11.29        674
  reiserfs                     8.38        966
  xfs nobarrier                7.89        949
  nilfs2 1st run               4.95       3800
  xfs nobarrier, ncq, wc off   3.81       1973
  xfs                          1.88       3901

	Szaka

-- 
NTFS-3G:  http://ntfs-3g.org
