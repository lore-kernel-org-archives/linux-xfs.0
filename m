Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 03:08:22 -0700 (PDT)
Received: from smtp120.sbc.mail.re3.yahoo.com (smtp120.sbc.mail.re3.yahoo.com [66.196.96.93])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5BA8HWt008547
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 03:08:19 -0700
Date: Mon, 11 Jun 2007 02:41:33 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070611094133.GA31108@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070611073559.GA26257@tuatara.stupidest.org> <1181551409.19145.57.camel@gentoo-johan.transmode.se> <20070611090138.GA28907@tuatara.stupidest.org> <1181553356.19145.65.camel@gentoo-johan.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181553356.19145.65.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 11:15:56AM +0200, Johan Andersson wrote:

> This is exactly what the simple but ugly patch I attached achieves
> by looking up the filename of the inode it defrags when doing a full
> file system defrag. And it works well, except that it spends a lot
> of time finding that file name. As I said, a better option would be
> if you could tell XFS in what AG you want extents for a newly
> created file to place it's extents in.

AGs can be large, you really want to say 'allocate near ...'
