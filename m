Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 04:50:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RBnphb012996
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:49:52 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34F6F54AD1F
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:49:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id vMMoLBRlwF19wA2b for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 04:49:49 -0700 (PDT)
Date: Mon, 27 Oct 2008 22:49:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081027114945.GE4985@disturbed>
References: <4905A3FB.6080709@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4905A3FB.6080709@aei.mpg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 12:20:27PM +0100, Carsten Aulbert wrote:
> Hi all,
> 
> I have not found it in the archive, thus my question to all:
> 
> Along the lines of this doc
> http://smartmontools.sourceforge.net/BadBlockHowTo.txt
> 
> I would like to find out if that's also possible for XFS, i.e. I have a
> disk which tells me, that there is a problem with LBA x and I identify
> that this block is within the range of a largish XFS file system.
> 
> Now, I would like to identify the file which is possibly broken and
> repair it if I can without taking the machine down for hours running the
> manufacturers DOS tools. With simple ext[23] this is possible, but I'm
> not getting anywhere with reading xfs_db and xfs_ncheck man pages to get
> there.
> 
> Anyone here with a brief recipe I can get along with?

Use xfs_bmap to find the location on disk of the extents in each
file. Recurse over the filesystem until you find the file that owns
the block that went bad.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
