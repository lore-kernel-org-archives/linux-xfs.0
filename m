Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 13:19:04 -0700 (PDT)
Received: from MAIL01HQ.adic.com (mail01hq.adic.com [63.81.117.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6VKISDW016863
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 13:18:49 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Where are superblocks stored?
Date: Mon, 31 Jul 2006 14:17:01 -0600
Message-ID: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA5@mail01dn.adic.com>
From: "Rishi Malik" <rishi.malik@adic.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Peter, Chris, thanks for the replies! I'm aware of the problems with
journaling filesystems on CF. I didn't design the system though! :) 

We're using 4096 size blocks for XFS. I think the logical block size in
linux is 512b, not 100% sure though. 

Thanks for letting me know the journal is there. I think you're right
about that killing the flash. 

I appreciate the help,

Rishi Malik

-----Original Message-----
From: Chris Wedgwood [mailto:cw@f00f.org] 
Sent: Monday, July 31, 2006 1:44 PM
To: Rishi Malik
Cc: xfs@oss.sgi.com
Subject: Re: Where are superblocks stored?

On Mon, Jul 31, 2006 at 09:23:27AM -0600, Rishi Malik wrote:

> I'm investigating some compact flash failures we've had. We run XFS
> on the CF.

Generally, a journalling filesystem is a very *bad* idea for
compactflash.

> I've been getting a lot of I/O errors around logical block
> 543080. These are 512MB compact flash cards, and I think that block
> puts it at about halfway through the CF.

Probably the journal, by default it ends up being about midway in the
volume.

> I know the I/O errors indicate an error at a lower level then
> XFS. What I'm wondering, is if there's a superblock stored there?

There are superblocks for each AG staring at block 0 (xfs_info or
xfs_db will show you how large he AGs are).

> Maybe we're hammering that area a lot, and because of other problems
> with the card, we're getting these errors.

You've killed your flash with journal updates is my guess.  Use a
different filesystem.



-----Original Message-----
From: Peter Grandi [mailto:pg_xfs@xfs.for.sabi.co.UK] 
Sent: Monday, July 31, 2006 11:48 AM
To: Rishi Malik
Subject: Re: Where are superblocks stored?


> Hi All, I'm investigating some compact flash failures we've
> had. We run XFS on the CF. I've been getting a lot of I/O
> errors around logical block 543080. These are 512MB compact
> flash cards, [ ... ]

That is a [euphemism alert!] very creative combination, and
perhaps I would not wholeheartedly suggest its use.

As to the errors, does <logical block> mean 512B sectors, 1024B
blocks or 4096B blocks? (consider carefully the implications...)
