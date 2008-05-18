Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 06:18:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4IDI7nh031853
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:18:09 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75F07184B67
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:18:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 4FOxnIFsWmOMuf4s for <xfs@oss.sgi.com>; Sun, 18 May 2008 06:18:56 -0700 (PDT)
Date: Sun, 18 May 2008 09:18:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080518131855.GA1383@infradead.org>
References: <20080516222755.3e557c00@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516222755.3e557c00@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Fri, May 16, 2008 at 10:27:55PM +0200, Emmanuel Florac wrote:
> cluster1:/proc/sys/fs# xfs_db -r -c 'freesp -s -a 0' /dev/vg0/lv0
>    from      to extents  blocks    pct
>       1       1       5       5  71.43
>       2       3       1       2  28.57
> total free extents 6
> total free blocks 7
> average free extent size 1.16667
> 
> 7 blocks free? But there are 9 TB of free space! 

The -a 0 means you're only looking at the first AG, which given the
history of the filesystem has a fair chance to be full.  To get the
summary for all AG do a

	xfs_db -r -c 'freesp -s' /dev/vg0/lv0

No idea yet on what could cause your problem, sorry.

> The only significant thing I see is that the FS is really close to 16
> TB of allocated data (15.7TB). I tried mounting it with "inode64"
> option with no more loving.

Did you remount it with that option as in mount -o remount or did you
completely unmount it and mount it again?  Unfortunately none of the
xfs-specific mount options can be reset with remount yet, and it doesn't
return an error either (both are added to my todo list now)
