Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 18:42:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C1frWt029925
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 18:41:55 -0700
Date: Tue, 12 Jun 2007 11:41:46 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070612014146.GJ86004887@sgi.com>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se> <20070611073559.GA26257@tuatara.stupidest.org> <1181551409.19145.57.camel@gentoo-johan.transmode.se> <20070611090138.GA28907@tuatara.stupidest.org> <1181553356.19145.65.camel@gentoo-johan.transmode.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181553356.19145.65.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: Chris Wedgwood <cw@f00f.org>, xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 11:15:56AM +0200, Johan Andersson wrote:
> On Mon, 2007-06-11 at 02:01 -0700, Chris Wedgwood wrote:
> > using "find .... xfs_fsr" you get temporary files in the same AG as
> > the file your are defragmenting, avoiding the spreading out effect,
> > but this might not be the least-defragmented file you can get
> > 
> > what's really needed is an attempt to find space near the original
> > file if possible and if not then an option to try harder looking in
> > other AGs
> This is exactly what the simple but ugly patch I attached achieves by
> looking up the filename of the inode it defrags when doing a full file
> system defrag. And it works well, except that it spends a lot of time
> finding that file name. As I said, a better option would be if you could
> tell XFS in what AG you want extents for a newly created file to place
> it's extents in. 

Yup. That would be nice. We've got the basis of doing allocation policies
with the filestreams code - an arbitrary blob of data associated with
an inode that influences the allocation decision. Userspace driven
allocation hints are more complex and require subtler hooks in the
allocation path, though....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
