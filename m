Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D3637F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:39:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43DBD8F8040
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:39:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yUUMsW4aoGOM6cUQ for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 18:39:57 -0800 (PST)
Message-ID: <5296ACFB.4030901@sandeen.net>
Date: Wed, 27 Nov 2013 20:39:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Problem with mkfs.xfs on a regular file
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
In-Reply-To: <20131127024713.GE10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Phil White <cerise-xfs@l.armory.com>
Cc: xfs@oss.sgi.com

On 11/26/13, 8:47 PM, Dave Chinner wrote:
> On Tue, Nov 26, 2013 at 06:31:19PM -0800, Phil White wrote:
>> Gents:
>>
>> I was making an image for a VM using everyone's favorite fs with a line
>> that looked something like this:
>> -------------
>> dd if=/dev/zero of=~/image bs=1024 count=1048576 && ./mkfs/mkfs.xfs && mount -o loop ~/image /mnt/loop
>> -------------
>>
>>
>> mkfs.xfs gave me this output:
>> -------------
>> meta-data=/root/image            isize=256    agcount=4, agsize=65536 blks
>>          =                       sectsz=512   attr=2, projid32bit=0
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal log           bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> existing superblock read failed: Invalid argument
>> mkfs.xfs: pwrite64 failed: Invalid argument
>> mkfs.xfs: read failed: Invalid argument
>> -------------
> .....
>>
>> While it occurred to me that the problem might just be line 806 of some files
>> in xfsprogs, I threw it under a debugger and took a closer look.  The file
>> descriptor value in xi->dfd pointed at ~/image.  errno was set to 22.  I
>> thought that might indicate a problem with lseek(), so I rewrote the pwrite64()
>> and pread() as lseek()s and read()/write()
>>
>> As you may have guessed, this did me no good at all.
>>
>> It's trying to read/write 512 bytes at the beginning of the file which seems
>> reasonably innocuous.  I double checked the man page which says that under
>> 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.
> 
> That doesn't mean it is correct, because the man page also says:
> 
> " In Linux alignment restrictions vary by filesystem and kernel
> version and might be absent entirely."
> 
> So, I bet that your underlying filesystem (i.e. the host filesystem)
> has a sector size of 4k, and that's why direct Io on 512 byte
> alignment is failing. In that case, run "mkfs.xfs -s size=4k ..."
> and mkfs should just work fine...

Sadly, no.  Or at least, probably not.

__initbuf
	memalign(libxfs_device_alignment(), bytes);

where libxfs_device_alignment() does:

platform_align_blockdev
	        if (!max_block_alignment)
			return getpagesize();
		return max_block_alignment;
  
and through twisty paths through platform_findsizes(), max_block_alignment is BBSIZE, or 512.

IOWS: xfsprogs is a braindead package that doesn't know how to properly handle non-512-aligned DIO.  ;)  </snark>

We should fix xfsprogs, but I'm also looking making 4k "sector" xfs able to do 512 DIOs as long as the device under it can do 512 DIOS.

We got into the 4k DIO alignment because mkfs.xfs saw a 512 logical / 4k physical drive, and chose 4k for its own internal sector size, which is great in terms of doing metadata IO efficiently, but not so great in terms of rejecting 512 byte IOs that the drive could otherwise do.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
