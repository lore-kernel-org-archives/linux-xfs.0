Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D83607F5F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:47:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF5968F8074
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:47:31 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SrhL27g7MZx4CBOr for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 18:47:27 -0800 (PST)
Date: Wed, 27 Nov 2013 13:47:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131127024713.GE10988@dastard>
References: <20131127023119.GB13101@boogeyman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131127023119.GB13101@boogeyman>
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
To: Phil White <cerise-xfs@l.armory.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 06:31:19PM -0800, Phil White wrote:
> Gents:
> 
> I was making an image for a VM using everyone's favorite fs with a line
> that looked something like this:
> -------------
> dd if=/dev/zero of=~/image bs=1024 count=1048576 && ./mkfs/mkfs.xfs && mount -o loop ~/image /mnt/loop
> -------------
> 
> 
> mkfs.xfs gave me this output:
> -------------
> meta-data=/root/image            isize=256    agcount=4, agsize=65536 blks
>          =                       sectsz=512   attr=2, projid32bit=0
> data     =                       bsize=4096   blocks=262144, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> existing superblock read failed: Invalid argument
> mkfs.xfs: pwrite64 failed: Invalid argument
> mkfs.xfs: read failed: Invalid argument
> -------------
.....
> 
> While it occurred to me that the problem might just be line 806 of some files
> in xfsprogs, I threw it under a debugger and took a closer look.  The file
> descriptor value in xi->dfd pointed at ~/image.  errno was set to 22.  I
> thought that might indicate a problem with lseek(), so I rewrote the pwrite64()
> and pread() as lseek()s and read()/write()
> 
> As you may have guessed, this did me no good at all.
> 
> It's trying to read/write 512 bytes at the beginning of the file which seems
> reasonably innocuous.  I double checked the man page which says that under
> 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.

That doesn't mean it is correct, because the man page also says:

" In Linux alignment restrictions vary by filesystem and kernel
version and might be absent entirely."

So, I bet that your underlying filesystem (i.e. the host filesystem)
has a sector size of 4k, and that's why direct Io on 512 byte
alignment is failing. In that case, run "mkfs.xfs -s size=4k ..."
and mkfs should just work fine...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
