Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82JqX3m041639 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 14:52:43 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64BD841E799
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 12:53:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9vl1NYZVjxhromt4 for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 12:53:08 -0700 (PDT)
Message-ID: <4A9ECD20.9090201@sandeen.net>
Date: Wed, 02 Sep 2009 14:53:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Structure needs cleaning? (take #2)
References: <20090902152245.b2969883.rumi_ml@rtfm.hu>	<4A9E81AD.70003@sandeen.net>
	<20090902213441.470b439c.rumi_ml@rtfm.hu>
In-Reply-To: <20090902213441.470b439c.rumi_ml@rtfm.hu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: RUMI Szabolcs <rumi_ml@rtfm.hu>
Cc: xfs@oss.sgi.com

RUMI Szabolcs wrote:
> Hi!
> 
> Well, what could be the reason? I mean, there was no hardware failure,
> no crash, no reboot, no errors in the disk's SMART error log, no nothing.
> What I did was that I've extracted and deleted the rather huge OpenOffice
> source tree several times (sometimes with overwriting) and finally it
> ended up with these undeletable files and xfs errors. Is it considered
> normal for xfs to get messed up like that under such load?

No, not normal.

It found the text "0xAAAA0000,6,0x" on disk in an area where it expected
to find valid filesystem metadata.

Corruption could come from anywhere - an xfs bug, some other bug, bad
memory, bad cables, neon death rays from space, writing directly to the
disk, who knows.  Awfully hard to track down a one-off occurrence like
this, I'm afraid.

> Thanks,
> Sab
> 
> 
> 
> The xfs_repair output and xfs_info output is included below:
> 
> # xfs_repair -v /dev/sda10

...

> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 3
>         - agno = 4
>         - agno = 5
>         - agno = 6
>         - agno = 7
> leaf block 8388608 for directory inode 4051737 bad header
> rebuilding directory inode 4051737
> leaf block 8388608 for directory inode 4053318 bad header
> rebuilding directory inode 4053318

...

above is the problem, properly found & repaired.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
