Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4BC937CAF
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 00:37:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C7A6304039
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 22:37:26 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	De3798LdmiULGQjq for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2016 22:37:19 -0800 (PST)
Date: Wed, 3 Feb 2016 17:37:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Request for information on bloated writes using Swift
Message-ID: <20160203063705.GB459@dastard>
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
	<56B16A3C.1030207@sandeen.net>
	<CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFHL4X0QBtFpz3=HMVMrp6NoaW5BRkDSoTE1yJQvQ=0JrW5+YQ@mail.gmail.com>
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
To: Dilip Simha <nmdilipsimha@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 07:40:34PM -0800, Dilip Simha wrote:
> Hi Eric,
> 
> Thank you for your quick reply.
> 
> Using xfs_io as per your suggestion, I am able to reproduce the issue.
> However, I need to falloc for 256K and write for 257K to see this issue.
> 
> # xfs_io -f -c "falloc 0 256k" -c "pwrite 0 257k" /srv/node/r1/t1.txt
> # stat /srv/node/r1/t4.txt | grep Blocks
>   Size: 263168     Blocks: 1536       IO Block: 4096   regular file

Fallocate sets the XFS_DIFLAG_PREALLOC on the inode.

When you writing *past the preallocated area* and do delayed
allocation, the speculative preallocation beyond EOF is double the
size of the extent at EOF. i.e. 512k, leading to 768k being
allocated to the file (1536 blocks, exactly).

This is expected behaviour.

> # xfs_io -f -c "pwrite 0 257k" /srv/node/r1/t2.txt
> # stat  /srv/node/r1/t2.txt | grep Blocks
> Size: 263168    *Blocks*: 520        IO Block: 4096   regular file

So pure delayed allocation, specualtive preallocation starts at 64k
file size, so it would have been (((64k + 64K) + 128K) + 256k) =
768k.


> I waited for around 15 mins before collecting the stat output to give the
> background reclamation logic a fair chance to do its job. I also tried
> changing the value of speculative_prealloc_lifetime from 300 to 10. But it
> was of no use.

The prealloc cleaner skips inodes with XFS_DIFLAG_PREALLOC set on
them.

Because the XFS_DIFLAG_PREALLOC flag is not set on the delayed
allocation inode, the EOF blocks cleaner runs truncates it to EOF,
and 260k (520 blocks) remains allocated to the file.

i.e. you are seeing behaviour exactly as designed and intended.

The way swift is using fallocate is actively harmful. You do not
want preallocation for write once files - this is exactly the
workload that delayed allocation was designed to be optimal for as
delayed allocation sequentialises the IO from multiple files.

Using preallocation means writeback of the data cannot be optimised
across files as the preallocation location will not be sequential to
the IO that was just issued, hence writeback will seek the disks
back and forth instead of seeing a nice sequential IO stream.

<sigh>

Yet another way that the swift storage back end tries to be smart
but ends up just making things go slow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
