Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Jul 2006 12:48:44 -0700 (PDT)
Received: from smtp102.sbc.mail.mud.yahoo.com (smtp102.sbc.mail.mud.yahoo.com [68.142.198.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6VJiGDW012659
	for <xfs@oss.sgi.com>; Mon, 31 Jul 2006 12:48:27 -0700
Date: Mon, 31 Jul 2006 12:43:46 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Where are superblocks stored?
Message-ID: <20060731194346.GA27291@tuatara.stupidest.org>
References: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A9A4FCBC06324F8BFE956A551B58E0056A4CA3@mail01dn.adic.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rishi Malik <rishi.malik@adic.com>
Cc: xfs@oss.sgi.com

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
