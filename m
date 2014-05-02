Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 387557F57
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:44:38 -0500 (CDT)
Message-ID: <5363BD62.7050707@sgi.com>
Date: Fri, 02 May 2014 10:44:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
In-Reply-To: <5363B4C9.4000900@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Martin Papik <mp6058@gmail.com>, xfs@oss.sgi.com


Please do a "ps -ef" before umount to see if the unmount is hung.

--Mark.

On 05/02/14 10:07, Eric Sandeen wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 5/2/14, 8:47 AM, Martin Papik wrote:
>>
>>
>> I ran into a problem using XFS. The USB device on which I have an XFS
>> file system got disconnected and xfs_repair and xfs_check fail with a
>> message saying the file system is mounted writable. There is no entry
>> in /etc/mtab or /proc/mounts. However I see messages in the kernel log
>> (dmesg) about write failures to the disconnected drive.
>
> platform_check_iswritable() and platform_check_ismounted() in xfsprogs check
> these things.
>
> platform_check_ismounted() does a ustat() of the block device,
> "ustat() returns  information  about  a mounted file system"
> and it knows if it's mounted or not,
> "EINVAL: dev does not refer to a device containing a mounted file system."
>
> so something, somewhere thinks it's mounted.  Check /proc/mounts?
>
>> Please let me know what I can do short of zeroing the log, which I
>> believe would result in some data loss.
>
> Hate to say it, but a reboot may be simplest.  Zeroing the log won't
> help.  OTOH, if you lost USB connectivity, you already lost some data.
>
> - -Eric
>
>
>
>> Martin
>>


<deletes>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
