Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 02:16:40 -0700 (PDT)
Received: from stitch.e-626.net (60.153.216.81.static.spa.siw.siwnet.net [81.216.153.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5B9GZWt027817
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 02:16:37 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Johan Andersson <johan@e-626.net>
In-Reply-To: <20070611090138.GA28907@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070611073559.GA26257@tuatara.stupidest.org>
	 <1181551409.19145.57.camel@gentoo-johan.transmode.se>
	 <20070611090138.GA28907@tuatara.stupidest.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 11:15:56 +0200
Message-Id: <1181553356.19145.65.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On Mon, 2007-06-11 at 02:01 -0700, Chris Wedgwood wrote:
> using "find .... xfs_fsr" you get temporary files in the same AG as
> the file your are defragmenting, avoiding the spreading out effect,
> but this might not be the least-defragmented file you can get
> 
> what's really needed is an attempt to find space near the original
> file if possible and if not then an option to try harder looking in
> other AGs
This is exactly what the simple but ugly patch I attached achieves by
looking up the filename of the inode it defrags when doing a full file
system defrag. And it works well, except that it spends a lot of time
finding that file name. As I said, a better option would be if you could
tell XFS in what AG you want extents for a newly created file to place
it's extents in. 

/Johan Andersson
