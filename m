Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5C9F77F6A
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 17:14:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 39BCB8F8035
	for <xfs@oss.sgi.com>; Mon, 27 Jan 2014 15:14:14 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lzlGriCB933tKnAU for <xfs@oss.sgi.com>;
	Mon, 27 Jan 2014 15:14:12 -0800 (PST)
Date: Tue, 28 Jan 2014 10:13:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_alloc.c, line:
	1590
Message-ID: <20140127231349.GE2212@dastard>
References: <OF435D1285.DABE6E9A-ON44257C6D.002777BA-44257C6D.00279370@beeline.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <OF435D1285.DABE6E9A-ON44257C6D.002777BA-44257C6D.00279370@beeline.ru>
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
To: Dmitriy Yu Leonov <DLeonov@beeline.ru>
Cc: xfs@oss.sgi.com

On Mon, Jan 27, 2014 at 11:12:15AM +0400, Dmitriy Yu Leonov wrote:
> 
> Hello, dear developers
> 
> Faced  with  the  problem of using XFS. I'm use the XFS file system on
> the  server without problems three years. Recently discovered that the
> disk (raid-array) with XFS is not available.
> 
> The logs raid controller appeared: 2014-01-24 07:12:34 H/W Monitor Raid
> Powered On

So something went wrong with the HW RAID, and then you found errors
in the filesystem?

> When I restart the server, I found that the raid array is not mount on
> the mount point /dev/sdb1 (filesystem XFS).

It failed to mount with the stack trace that you attached? If so,
there's a corrupt freespace tree in the filesystem.

> When  I  run  the utility xfs_repair -P /dev/sdb1 it hangs. When I run
> mount  /dev/sdb1  not  issued  any  errors and application also hangs.
> Task's cannot finish even the command kill -9 <pid>.

First of all, I'd suggest updating to at least version 3.1.11 of
xfsprogs. If it still hangs, then it's quite likely there something
still wrong with your HW RAID.

Your first step is to make sure your HW RAID is healthy before
trying to repair or mount the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
