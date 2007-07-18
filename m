Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 18:43:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6I1hGbm030107
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 18:43:18 -0700
Message-ID: <469D7035.2020507@sandeen.net>
Date: Tue, 17 Jul 2007 20:43:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Allocating inodes from a single block
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org>
In-Reply-To: <20070717201921.GA26309@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Michael Nishimoto <miken@agami.com>, xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Tue, Jul 17, 2007 at 11:11:50AM -0700, Michael Nishimoto wrote:
> 
>> Filesystem free space becomes fragmented over time.  It's possible
>> for total free space to be a decent size and still not have a chunk
>> large enough to allocate new inodes.
> 
> by default there is a restriction that indoes shouldn't consume more
> that 25% of the total space
> 
> see the mkfs.xfs man-page for details, search for 'maxpct'
> 
> for existing filesystems you can use xfs_db to rewrite this value

The problem is that inodes are allocated in "clusters" of blocks.

If your free blocks aren't such that they can form a cluster, I think
you're out of luck when trying to allocate new inodes if your existing
clusters are full.

-Eric
