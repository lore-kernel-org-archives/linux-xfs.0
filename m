Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 14:01:44 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6HL1abm003239
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 14:01:40 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6HL1D8q009018
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 14:01:15 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6HL1bBQ000551
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 14:01:37 -0700
Message-ID: <469D2E46.8080003@agami.com>
Date: Tue, 17 Jul 2007 14:01:58 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: Allocating inodes from a single block
References: <469D0666.6040908@agami.com> <20070717201921.GA26309@tuatara.stupidest.org>
In-Reply-To: <20070717201921.GA26309@tuatara.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Tue, Jul 17, 2007 at 11:11:50AM -0700, Michael Nishimoto wrote:
> 
>  > Filesystem free space becomes fragmented over time.  It's possible
>  > for total free space to be a decent size and still not have a chunk
>  > large enough to allocate new inodes.
> 
> by default there is a restriction that indoes shouldn't consume more
> that 25% of the total space
> 
> see the mkfs.xfs man-page for details, search for 'maxpct'
> 
> for existing filesystems you can use xfs_db to rewrite this value

I do know about the 25% restriction, but that isn't what I'm talking
about.  I'm not suggesting to fillup a filesystem 100% with
inodes.

Imagine a case where only 2-3% of the space is inodes but that 94%
of the total space was filled.  If the remaining 6% of space is
highly fragmented, then no new inodes can be allocated.  The dialloc
code couldn't find 8 contiguous blocks.

    Mike
