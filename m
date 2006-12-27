Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Dec 2006 09:58:21 -0800 (PST)
Received: from deflector.emaze.net (deflector.emaze.net [213.178.220.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBRHwEqw021218
	for <linux-xfs@oss.sgi.com>; Wed, 27 Dec 2006 09:58:16 -0800
Message-ID: <4592B581.7080806@emaze.net>
Date: Wed, 27 Dec 2006 19:03:45 +0100
From: Francesco Degrassi <francesco.degrassi@emaze.net>
MIME-Version: 1.0
Subject: Re: Possible performance problem introduced between kernel 2.6.15
 and 2.6.17 on xfs code
References: <458D4845.2010803@emaze.net> <458D4EEB.3060501@sandeen.net> <458DCB8D.3040804@emaze.net> <4592942C.5000306@sandeen.net>
In-Reply-To: <4592942C.5000306@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

I tried ext2, ext3, jfs, reiser3, vfat and the problem does not show up.
Anyway i discovered that if i create a regular file in an XFS partition,
create an XFS filesystem on it as if it was a regular block device, and
mount it with the loop device, the problem does NOT manifest.
So it seems to affect XFS filesystems on regular block devices only ?
I'm confused.


____________EXAMPLE________________
root@francesco:/tmp$ mount | grep tmp
/dev/sda7 on /tmp type xfs (rw)
root@francesco:/tmp$ dd if=/dev/zero of=bdev bs=1024 count=200000
root@francesco:/tmp$ mkfs.xfs -f bdev
root@francesco:/tmp$ mkdir mpoint
root@francesco:/tmp$ mount -o loop bdev mpoint/
root@francesco:/tmp$ time gnomevfs-copy \
/home/fdegrassi/Desktop/downloads/systemrescuecd-x86-1.2.18.iso mpoint/

real	0m3.998s
user	0m0.080s
sys	0m1.292s

root@francesco:/tmp$ time gnomevfs-copy \
/home/fdegrassi/Desktop/downloads/systemrescuecd-x86-1.2.18.iso /tmp


real	2m55.448s
user	0m0.100s
sys	0m1.984s

________________________END_____________________

Thanks for your time, Eric.

Francesco Degrassi

Eric Sandeen wrote:
> fdegrassi wrote:
>> The specific problem is related to gnome point-n-click only.
>> Anyway, I could be wrong, but i don't think it is a bug in gnome because:
>> 1. it affects specifically local XFS filesystems only
>> 2. the problem is not present on kernel 2.6.15 (I tested 2.6.17 and
>> 2.6.15, both on ubuntu 6.10)
>> 3. the problem does not manifest if i disable the call to
>> gnome_vfs_forget_cache, that, for what i understand, simply calls
>> fadvice POSIX_FADV_DONTNEED.
>>
>> More info can be found on gnome bugzilla entry.
>> Francesco Degrassi
>>
> 
> Thanks.  I didn't mean to suggest that it was necessarily a gnome bug,
> just wanted to narrow down the problem.  Do you have any idea if other
> filesystems on 2.6.17 also show this slowdown?
> 
> -Eric
