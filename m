Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 03:39:57 -0700 (PDT)
Received: from stitch.e-626.net (60.153.216.81.static.spa.siw.siwnet.net [81.216.153.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5BAdqWt017548
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 03:39:53 -0700
Subject: Re: xfs_fsr allocation group optimization
From: Johan Andersson <johan@e-626.net>
In-Reply-To: <20070611094133.GA31108@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
	 <20070611073559.GA26257@tuatara.stupidest.org>
	 <1181551409.19145.57.camel@gentoo-johan.transmode.se>
	 <20070611090138.GA28907@tuatara.stupidest.org>
	 <1181553356.19145.65.camel@gentoo-johan.transmode.se>
	 <20070611094133.GA31108@tuatara.stupidest.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 12:39:13 +0200
Message-Id: <1181558353.19145.76.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On Mon, 2007-06-11 at 02:41 -0700, Chris Wedgwood wrote:
> On Mon, Jun 11, 2007 at 11:15:56AM +0200, Johan Andersson wrote:
> 
> > This is exactly what the simple but ugly patch I attached achieves
> > by looking up the filename of the inode it defrags when doing a full
> > file system defrag. And it works well, except that it spends a lot
> > of time finding that file name. As I said, a better option would be
> > if you could tell XFS in what AG you want extents for a newly
> > created file to place it's extents in.
> 
> AGs can be large, you really want to say 'allocate near ...'

Yes, absolutely, if that was possible. But with the current XFS, at
least we can place it in the same AG. In the way xfs_fsr operates now,
in almost all user space, I don't see any good way to tell XFS where to
place the extents, other than creating the temporary file in the same
directory as the original file.

My question is really, is there a better way than "find -xdev -inum" to
find what file points to a given inode? It would solve our immediate
problem with xfs_fsr destroying locality of files, while still
optimising the file system properly.

/Johan Andersson
