Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37A577F4E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 15:21:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7470AC003
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 13:21:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qPFPV7HYzgn72opG for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 13:21:47 -0800 (PST)
Date: Thu, 27 Nov 2014 08:21:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: no quota output if no usage?
Message-ID: <20141126212144.GD9561@dastard>
References: <5476297F.8080304@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5476297F.8080304@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Nov 26, 2014 at 01:26:55PM -0600, Eric Sandeen wrote:
> This seems a bit weird:
> 
> # xfs_quota -x -c 'quota -p project1' /mnt/test
> #
> 
> Huh, did it work?
> 
> # xfs_quota -x -c 'quota -pv project1' /mnt/test
> Disk quotas for Project project1 (1)
> Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
> /dev/sdc2                    0    1024000    1228800   00 [--------] /mnt/test
> #
> 
> Oh, ok!
> 
> I don't know why reporting limits should depend on the verbose flag, but it
> has been that way since 2005 in quota_mount() :
> 
>         if (!(flags & VERBOSE_FLAG)) {
>                 count = 0;
>                 if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
>                         count++;
>                 if ((form & XFS_INODE_QUOTA) && d.d_icount)
>                         count++;
>                 if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
>                         count++;
>                 if (!count)
>                         return 0;
>         }
> 
> I'm inclined to change it, but is it OK to change the output of this - might old
> scripts be relying on this (odd) silent behavior?  I think it can certainly cause
> confusion (as evidenced by at least one bug I'm looking at ...)

It's done that way because the quota lookup can find dquots that are
completely empty because there are no uid/gid/prid found in the
filesystem, but the dquot is allocated because it's within a block
that has in use dquots in it. I'd guess that if you queried a
non-existent project quota (e.g. prid 2) you'd get the same
result....

i.e. you've got to have inodes or blocks accounted to have a dquot
"created" for the uid/gid/prid in normal conditions, hence dquots
with zero counts are ignored by default as they are effectively
the same as unallocated dquots....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
