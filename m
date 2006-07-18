Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 00:32:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6I7W2DW005962
	for <xfs@oss.sgi.com>; Tue, 18 Jul 2006 00:32:14 -0700
Date: Tue, 18 Jul 2006 17:31:22 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: XFS and write barrier
Message-ID: <20060718173122.B1914501@wobbly.melbourne.sgi.com>
References: <200607151248.56603.Martin@lichtvoll.de> <20060716173238.GD3417@free.net.ph>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060716173238.GD3417@free.net.ph>; from jijo@free.net.ph on Mon, Jul 17, 2006 at 01:32:38AM +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org

On Mon, Jul 17, 2006 at 01:32:38AM +0800, Federico Sevilla III wrote:
> On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> > I am currently gathering information to write an article about journal
> > filesystems with emphasis on write barrier functionality, how it
> > works, why journalling filesystems need write barrier and the current
> > implementation of write barrier support for different filesystems.
> 
> Cool! Would you by any chance have information on the interaction
> between journal filesystems with write barrier functionality, and
> software RAID (md)? Based on my experience with 2.6.17, XFS detects that
> the underlying software RAID 1 device does not support barriers and
> therefore disables that functionality.

Noone here seems to know, maybe Neil &| the other folks on linux-raid
can help us out with details on status of MD and write barriers?

cheers.

-- 
Nathan
