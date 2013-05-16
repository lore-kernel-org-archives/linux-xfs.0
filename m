Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F34157F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 22:56:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B941D8F8064
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 20:56:55 -0700 (PDT)
Received: from chinook.cae-engineering.hu (chinook.cae-engineering.hu
	[213.165.74.136]) by cuda.sgi.com with ESMTP id
	Fnn4Wt3JiKOnxLpy for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 20:56:53 -0700 (PDT)
Date: Thu, 16 May 2013 05:56:51 +0200
From: Andras Korn <korn-xfs@elan.rulez.org>
Subject: Re: wishlist: xfs_repair should detect files with too small sizes
Message-ID: <20130516035651.GH17261@hellgate>
References: <20130514215550.GK17260@hellgate> <20130515004736.GM29466@dastard>
	<20130515080355.GL17260@hellgate> <20130515214105.GZ24635@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130515214105.GZ24635@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, May 16, 2013 at 07:41:05AM +1000, Dave Chinner wrote:

> > OK, thinking about it I realise there doesn't appear to be a good way of
> > preventing the problem, but I'm still not sure some heuristic couldn't be
> > invented to detect and partially remedy it after the fact.
> 
> Trying to remedy it in xfs_repair does more harm than good. What
> happens now allows recovery of data if the inode size was wrong. If
> we remove the blocks beyond EOF, we lose that ability and hence make
> unrecoverable data loss more likely in common failure scenarios.

That's clear (xfs_repair not freeing up the space is what allowed me to
recover the data). I meant "remedy" as in _either_ increase the inode size
OR free up the extra space. Perhaps xfs_db could be extended to do this?

Of course, increasing the size as stored in the inode can add garbage (at
the very least, binary zeroes) to the end of files, but if the data would
otherwise have been lost, this is probably still preferable. I can even
imagine an xfs_db command that increases file size up to the last non-zero
data byte in the allocated space.

-- 
                     Andras Korn <korn at elan.rulez.org>
                    No wanna work. Wanna bang on keyboard.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
