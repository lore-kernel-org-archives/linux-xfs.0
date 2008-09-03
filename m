Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 07:10:45 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83EAdko000428
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 07:10:39 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34E291232E73
	for <xfs@oss.sgi.com>; Wed,  3 Sep 2008 07:12:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id qnxA5LxFLKh5A6jJ for <xfs@oss.sgi.com>; Wed, 03 Sep 2008 07:12:01 -0700 (PDT)
Message-ID: <48BE9B2F.30606@sandeen.net>
Date: Wed, 03 Sep 2008 09:11:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: Change mkfs.xfs to set primary superblock inodes in ALL
 secondaries
References: <op.ugv794p63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ugv794p63jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> One peculiarity of mkfs.xfs that no-one has yet been able to explain
> to me is that all the secondary superblocks do not contain the
> primary superblock's root inode, realtime inodes and quota inodes.
> 
> The root inode is stored in the middle and last AG as well to
> make things more unexpected.
> 
> The following makes all the secondaries the same as the primary
> (other than the global counters).

Also looks good to me.

I've always wondered, too, if writing a single backup superblock in the
last sector(s) of the device at mkfs/growfs time might be sane?

When the primary is corrupt you could quickly get the size of the
device, seek to the end, read on the last 1k boundary, see if it's a
superblock, and use that as the first easily-findable backup.

Just a thought :)

-Eric
