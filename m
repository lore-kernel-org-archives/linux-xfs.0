Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CD2729DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 15:49:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01E66304053
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 13:49:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nMt14XWF4wXRon5w for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 13:49:21 -0700 (PDT)
Message-ID: <51881750.3090309@sandeen.net>
Date: Mon, 06 May 2013 15:49:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Internal error xfs_sb_read_verify at line 726
References: <20130506112717.GA502@x4> <5187E290.8090109@sandeen.net>
	<20130506183020.GA513@x4> <51880121.8000001@sandeen.net>
	<20130506192629.GA503@x4> <5188074F.2090500@sandeen.net>
	<20130506195521.GB503@x4>
In-Reply-To: <20130506195521.GB503@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On 5/6/13 2:55 PM, Markus Trippelsdorf wrote:
> On 2013.05.06 at 14:41 -0500, Eric Sandeen wrote:
>> On 5/6/13 2:26 PM, Markus Trippelsdorf wrote:
>>> On 2013.05.06 at 14:14 -0500, Eric Sandeen wrote:
>>>> On 5/6/13 1:30 PM, Markus Trippelsdorf wrote:
>>>>> On 2013.05.06 at 12:04 -0500, Eric Sandeen wrote:
>>>>>> On 5/6/13 6:27 AM, Markus Trippelsdorf wrote:
>>>>>>> Today I accidentally tried to mount my backup disk at /dev/sdc instead
>>>>>>> of /dev/sdc1 and this is what happened:
>>>>>>>
>>>>>>> ...
>>>>>>> EXT4-fs (sdc): VFS: Can't find ext4 filesystem
>>>>>>> FAT-fs (sdc): bogus number of reserved sectors
>>>>>>> FAT-fs (sdc): Can't find a valid FAT filesystem
>>>>>>> FAT-fs (sdc): bogus number of reserved sectors
>>>>>>> FAT-fs (sdc): Can't find a valid FAT filesystem
>>>>>>> ISOFS: Unable to identify CD-ROM format.
>>>>>>> XFS (sdc): bad magic number
>>>>>>> ffff8800db620000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>>>> ffff8800db620010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>>>> ffff8800db620020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>>>> ffff8800db620030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>>>> XFS (sdc): Internal error xfs_sb_read_verify at line 726 of file fs/xfs/xfs_mount.c.  Caller 0xffffffff8119e5cd
>>>>>>
>>>>>> This seems to be a recent regression.
>>>>>>
>>>>>> Comments above xfs_sb_quiet_read_verify() indicate that this behavior is
>>>>>> to be avoided:
>>>>>>
>>>>>>  * We may be probed for a filesystem match, so we may not want to emit
>>>>>>  * messages when the superblock buffer is not actually an XFS superblock.
>>>>>>
>>>>>> and it checks for proper magic prior to all the chattiness above int
>>>>>> that function.
>>>>>>
>>>>>> The superblock read is suposed to choose whether to be noisy or not,
>>>>>> in xfs_readsb():
>>>>>>
>>>>>
>>>>> The following patch fixes the issue for me:
>>>>>
>>>>>
>>>>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>>>>> index f6bfbd7..db8f27f 100644
>>>>> --- a/fs/xfs/xfs_mount.c
>>>>> +++ b/fs/xfs/xfs_mount.c
>>>>> @@ -721,6 +721,11 @@ xfs_sb_read_verify(
>>>>>  	}
>>>>>  	error = xfs_sb_verify(bp);
>>>>>  
>>>>> +	if (error == XFS_ERROR(EWRONGFS)) {
>>>>> +		xfs_buf_ioerror(bp, EWRONGFS);
>>>>> +		return;
>>>>> +	}
>>>>> +
>>>>>  out_error:
>>>>>  	if (error) {
>>>>>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
>>>>
>>>> That might make sense, I don't think we need the loudness for EWRONGFS
>>>> no matter how we got there.  
>>>>
>>>> But:
>>>>
>>>> Out of curiosity, what was the actual mount command you used?  It seems like
>>>> the auto-probing should have set the MS_SILENT flag to avoid this in
>>>> the first place, i.e. we should have gone down the quiet path
>>>> (xfs_sb_quiet_read_verify) and avoided this altogether.
>>>>
>>>> How do you reproduce this?
>>>
>>> I power on the drive and simply run:
>>>
>>>  # mount /dev/sdc /mnt
>>
>> Interesting.  On my test box, that never even issues the mount syscall,
>> because it uses blkid (I guess) to probe, and finds nothing.
>>
>> Which util-linux do you have?
> 
> v2.21.2
> 
>> An strace -v of the mount command might be useful.
> 
> execve("/bin/mount", ["mount", "/dev/sdc", "/mnt"], [/* 44 vars */]) = 0

...

> stat("/sbin/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs.d/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/usr/sbin/mount.ext4", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> mount("/dev/sdc", "/mnt", "ext4", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> stat("/sbin/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs.d/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/usr/sbin/mount.vfat", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> mount("/dev/sdc", "/mnt", "vfat", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> stat("/sbin/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs.d/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/usr/sbin/mount.msdos", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> mount("/dev/sdc", "/mnt", "msdos", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> stat("/sbin/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs.d/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/usr/sbin/mount.iso9660", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> mount("/dev/sdc", "/mnt", "iso9660", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)
> stat("/sbin/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs.d/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/sbin/fs/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> stat("/usr/sbin/mount.xfs", 0x7fff283f7550) = -1 ENOENT (No such file or directory)
> mount("/dev/sdc", "/mnt", "xfs", MS_MGC_VAL, NULL) = -1 EINVAL (Invalid argument)

Interesting, so it really does try to mount by successive fs types.

I wonder when that behavior changed (my util-linux-ng 2.17 on RHEL6 doesn't do this)

I'll take a look.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
