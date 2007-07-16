Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 06:05:19 -0700 (PDT)
Received: from mail.q-leap.de (ns1.q-leap.de [153.94.51.193])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GD5Dbm008249
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 06:05:15 -0700
From: Bernd Schubert <bs@q-leap.de>
Subject: Re: 3ware 9650 tips
Date: Mon, 16 Jul 2007 14:39:22 +0200
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <20070716024115.GJ12413810@sgi.com> <20070716122225.GB31489@sgi.com>
In-Reply-To: <20070716122225.GB31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161439.23159.bs@q-leap.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com

On Monday 16 July 2007 14:22:25 David Chinner wrote:
> You can see from the ext3 graph that it comes to a screeching halt
> every 5s (probably when pdflush runs) and at all other times the
> seek rate is >10,000 seeks/s. That's pretty bad for a brand new,
> empty filesystem and the only way it is sustained is the fact that
> the disks have their write caches turned on. ext4 will probably show
> better results, but I haven't got any of the tools installed to be
> able to test it....

I recently did some filesystem throuput tests, you may find it here

http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/lustre/performance/

ldiskfs is ext3+extents+mballoc+some-smaller-patches, so is almost ext4 
(delayed allocation is still missing, but the clusterfs/lustre people didn't 
port it and I'm afraid of hard to detect filesystem corruptions if I include 
it myself).

Write performance is still slower than with xfs and I'm really considering to 
try to use xfs in lustre.

Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
