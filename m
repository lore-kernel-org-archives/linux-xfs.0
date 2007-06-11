Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 08:58:34 -0700 (PDT)
Received: from smtp121.sbc.mail.re3.yahoo.com (smtp121.sbc.mail.re3.yahoo.com [66.196.96.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5BFwQWt028272
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 08:58:29 -0700
Date: Mon, 11 Jun 2007 08:58:24 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070611155824.GA12668@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070611073559.GA26257@tuatara.stupidest.org> <1181551409.19145.57.camel@gentoo-johan.transmode.se> <20070611090138.GA28907@tuatara.stupidest.org> <1181553356.19145.65.camel@gentoo-johan.transmode.se> <20070611094133.GA31108@tuatara.stupidest.org> <1181558353.19145.76.camel@gentoo-johan.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181558353.19145.76.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 12:39:13PM +0200, Johan Andersson wrote:

> In the way xfs_fsr operates now, in almost all user space, I don't
> see any good way to tell XFS where to place the extents, other than
> creating the temporary file in the same directory as the original
> file.

Exactly.

> My question is really, is there a better way than "find -xdev -inum"
> to find what file points to a given inode?

You can build then entire tree in-core using bulkstat and readdir,
doing the bulkstat first means you can try to optimize the order you
do the readdirs in somewhat.
