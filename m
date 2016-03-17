Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9D037CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 15:57:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9FAA78F8066
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 13:57:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uNZxS2lHw0uF9bk8 for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2016 13:57:33 -0700 (PDT)
Date: Fri, 18 Mar 2016 07:57:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: new fs, xfs_admin new label, metadata corruption detected
Message-ID: <20160317205729.GL30721@dastard>
References: <CAJCQCtR4tq8+BXRX+Y4rkqn6ZrFLw-9SX=gXKkF3QS1b2c8Ksg@mail.gmail.com>
	<56E8AA22.7080301@sandeen.net>
	<CAJCQCtQYMitUvPN1ORyEHvDhddJ09Hp_xK_CBc0e1Cu972S3_w@mail.gmail.com>
	<CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJCQCtQJ_1ARXYuN3j2VyVN8FBtG0myqmPnOgco1v-tQxqmyBg@mail.gmail.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 16, 2016 at 08:39:21PM -0600, Chris Murphy wrote:
> OK I can consistently reproduce this on the CLI. I end up with totally different
> 
> # lvcreate -L 40g VG -n testxfs
>   Logical volume "testxfs" created.
....
[grow]
....
> # xfs_repair -n /dev/VG/testxfs
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> Metadata corruption detected at xfs_agf block 0x8c00008/0x1000
> fllast 1014 in agf 7 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x6400008/0x1000
> fllast 1014 in agf 5 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x5000008/0x1000
> fllast 1014 in agf 4 too large (max = 1014)
> Metadata corruption detected at xfs_agf block 0x7800008/0x1000
> fllast 1014 in agf 6 too large (max = 1014)
>         - found root inode chunk

That's caused by commit 96f859d ("libxfs: pack the agfl header
structure so XFS_AGFL_SIZE is correct") and growfs setting the
last free list entry to something that a userspace without the
commit  9fccb9f ("libxfs: pack the agfl header structure so
XFS_AGFL_SIZE is correct") fails to validate correctly.

i.e. update userspace to 4.5.0, and the repair noise will go away.

I think we probably need to fix the growfs code to set it's initial
flfirst/fllast values to be 1/0, not 0/EOFL, and the problem will
then go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
