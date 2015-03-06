Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 588DE7F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 15:09:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 439D78F8052
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 13:09:32 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	GvZ3Tvqk63qUUVm9 for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 13:09:29 -0800 (PST)
Date: Sat, 7 Mar 2015 08:09:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: take XFS_IOLOCK_EXCL if suid removal is required
Message-ID: <20150306210927.GA13958@dastard>
References: <54F9DBAE.2070002@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F9DBAE.2070002@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Mar 06, 2015 at 10:54:06AM -0600, Eric Sandeen wrote:
> This sequence:
> 
> # rm -f sparsefile
> # truncate --size=1m sparsefile
> # chmod ugo+rws sparsefile
> # ls -l sparsefile
> -rwSrwSrw-. 1 root root 1048576 Mar  6 10:29 sparsefile
> # su tester
> 
> $ xfs_io -d -c "pwrite 0 4096" sparsefile
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0000 sec (21.505 KiB/sec and 5.3763 ops/sec)
> $ exit
> 
> will lead to a WARN_ON() in notify change, because i_mutex is
> not held, and we get to notify_change via suid removal with
> only XFS_IOLOCK_SHARED held, i.e. no i_mutex.
> 
> Upgrade the lock to XFS_IOLOCK_EXCL in this case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I believe Jan Kara has already addressed this problem in
this patchset:

http://oss.sgi.com/archives/xfs/2015-03/msg00051.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
