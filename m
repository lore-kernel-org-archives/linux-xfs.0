Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2C5FF7CA6
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 20:37:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0F588F8035
	for <xfs@oss.sgi.com>; Sun, 21 Feb 2016 18:37:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	M0Qk0Hl2AfDxad3V for <xfs@oss.sgi.com>;
	Sun, 21 Feb 2016 18:24:53 -0800 (PST)
Date: Mon, 22 Feb 2016 13:24:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: recovering corrupt filesystem after raid failure
Message-ID: <20160222022439.GE14668@dastard>
References: <56CA6492.7000407@lechnology.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56CA6492.7000407@lechnology.com>
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
To: David Lechner <david@lechnology.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 21, 2016 at 07:29:54PM -0600, David Lechner wrote:
> Long story short, I had a dual disk failure in a raid 5. I've managed to
> get the raid back up and salvaged what I could. However, the xfs is
> seriously damaged. I've tried running xfs_repair, but it is failing and
> it recommended to send a message to this mailing list. This is an Ubuntu
> 12.04 machine, so xfs_repair version 3.1.7.

So the first thing to do is get a more recent xfsprogs package and
try that. There's not a lot of point in us looking at problems with
a 4 and half year old package that we've probably already fixed.

> The file system won't mount. Fails with "mount: Structure needs
> cleaning". So I tried xfs_repair. I had to resort to xfs_repair -L
> because the first 500MB or so of the filesystem was wiped out.

Oh, so even if you can repair the filesystem, your data is likely to
be irretreivably corrupted.

> Now,
> xfs_repair /dev/md127 gets stuck, so I am running xfs_repair -P
> /dev/md127. This gets much farther, but it is failing too. It gives an
> error message like this:
> 
> 
> ...
> disconnected inode 2101958, moving to lost+found
> corrupt dinode 2101958, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x7f2c57e1b120)
> 
> fatal error -- 117 - couldn't iget disconnected inode
> 
> 
> 
> However, nblocks = 0 does not seem to be true...

Probably because it got cleared in memory before this problem was
tripped over.

> If I re-run xfs_repair -P /dev/md127, it will fail on different
> seemingly random inode with the same error message.

Yup, you definitely need to run a current xfs_repair on this
filesystem before going any further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
