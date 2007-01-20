Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 19 Jan 2007 19:45:46 -0800 (PST)
Received: from smtp108.sbc.mail.mud.yahoo.com (smtp108.sbc.mail.mud.yahoo.com [68.142.198.207])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0K3jdqw017043
	for <xfs@oss.sgi.com>; Fri, 19 Jan 2007 19:45:41 -0800
Date: Fri, 19 Jan 2007 19:44:43 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: EXTENT BOUNDARIES
Message-ID: <20070120034443.GA27654@tuatara.stupidest.org>
References: <45B137CA.3020206@ampex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B137CA.3020206@ampex.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Les Oxley <les@ampex.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 19, 2007 at 01:27:38PM -0800, Les Oxley wrote:

> We are looking into running XFS on a 3TB FLASH MEMORY MODULE.

neat, you need to send me some of those

does it wear level and do other clever stuff?  most conventional flash
storage devices don't last long with journalling filesystems...

> We have a question regarding the extent boundaries.  See the
> attached PowerPoint drawing, xfs.ppt We are running Linux.

you're asking linux people to read a powerpoint file?  :-)

you might have better luck with something else

> Our media is 3 million contiguous 4KB blocks.

That's not 3TB, surely it's < 12GB?

> We would like to define an extent size of 1MB and this tracks the
> erasure block size of the flash memory, and that greatly improves
> perfomance. We are trying to understand where XFS places the extent
> boundaries with reference to the contiguous block sequence.  Is this
> deterministic as indicated in the drawing ? That is, are the extent
> boundaries on 256 block boundaries.

i didn't open the powerpoint file, so i migth not be answering this
very well...

extent boundaries do not have to be on any boundary

you can tweak mkfs.xfs to affect where AGs start, is that of value to
you?

now, there are also rt volumes which can have larger extents so those
might be of value to you, but you would still need somewhere for the
metadata
