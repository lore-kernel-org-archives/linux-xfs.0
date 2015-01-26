Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E3BF7F8B
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 16:37:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CA2B8F8039
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 14:37:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZEpwUVQYEOFAKDnL for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 14:37:18 -0800 (PST)
Date: Tue, 27 Jan 2015 09:37:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: maxpct option for small xfs filesystems
Message-ID: <20150126223715.GA7621@dastard>
References: <54C667F3.8040303@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54C667F3.8040303@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 26, 2015 at 07:14:43PM +0300, Alexander Tsvetkov wrote:
> Hello,
> 
> I'm trying to understand the expected behaviour of "maxpct" option
> in case of small xfs filesystem
> comparing the maximum percentage defined for this option with the
> percentage of actually allocated
> inodes in filesystem, but the result of prepared test case doesn't
> correspond to the expectations:
> 
> [root@fedora ~]#mkfs.xfs -f -d size=16m -i maxpct=1 /dev/sdb2

On 3.19-rc5, immediately after mount:

# df -i /mnt/scratch
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/ram1         640     3   637    1% /mnt/scratch

Which indicates that imaxpct=1 is being calculated correctly, before
we even look at whether it is being enforced correctly or not.

So, what kernel version?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> [root@fedora ~]# for i in {0..100000}; do str=$(mktemp
> --tmpdir=/mnt/scratch tmp.XXXXXXXXXX); echo $str; done

Which is a complex (and very slow!) way of doing:

# for i in {0..100000}; do echo > /mnt/scratch/$i ; done 2> /dev/null

> filesystem is full with created files:
> 
> [root@fedora ~]# df -Th | grep scratch
> /dev/sdb2      xfs        13M   13M  148K  99% /mnt/scratch

# df -Th /mnt/scratch
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/ram1      xfs    13M  1.1M   12M   9% /mnt/scratch
# df -i /mnt/scratch
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/ram1         640   640     0  100% /mnt/scratch

> and from the number of actually created inodes:
> 
> [root@fedora ~]# xfs_db -c "blockget -n" -c "ncheck" /dev/sdb2 | wc -l
> 40512

That's a directory structure entry count, equivalent to 'find
/mnt/scratch | wc -l', not an allocated inode count which is what
'df -i' reports. Even so, on 3.19-rc5:

# xfs_db -c "blockget -n" -c "ncheck" /dev/ram1 | wc -l
637

which matches what 'df -i' tells us about allocated inodes and hence
imaxpct is working as expected.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
