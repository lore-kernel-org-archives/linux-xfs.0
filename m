Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14GrC3d076491 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:53:13 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13C5E137B297
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:54:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dNfnfKULmc6IqO0e for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:54:21 -0800 (PST)
Message-ID: <4B6AFBB9.7000701@redhat.com>
Date: Thu, 04 Feb 2010 10:54:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: don't try to detect filesystems on regular files
	via blkid
References: <4B6AF6FC.6030101@redhat.com> <878wb9j6e8.fsf@meyering.net>
In-Reply-To: <878wb9j6e8.fsf@meyering.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jim Meyering <jim@meyering.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Jim Meyering wrote:
> Eric Sandeen wrote:
>> https://bugzilla.redhat.com/show_bug.cgi?id=561870
>>
>> # dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k
>> # mkfs.xfs: probe of k failed, cannot detect existing filesystem.
>> # mkfs.xfs: Use the -f option to force overwrite.
>>
>> blkid fails to do a probe of a regular file.
>>
>> I wish blkid would cope with this, but for now it might
>> be better to just turn it off.
>>
>> Reported-by: Jim Meyering <meyering@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 9baf116..de87647 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -300,10 +300,15 @@ check_overwrite(
>>  	int		fd;
>>  	long long	size;
>>  	int		bsz;
>> +	struct stat	statbuf;
>>
>>  	if (!device || !*device)
>>  		return 0;
>>
>> +	/* blkid can't get info from a regular file */
>> +	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
>> +		return 0;
>> +
>>  	ret = -1; /* will reset on success of all setup calls */
>>
>>  	fd = open(device, O_RDONLY);
> 
> Hi Eric,
> 
> Did you consider calling fstat after opening,
> rather than "stat" before?
> 
>         /* blkid can't get info from a regular file */
>         if (!fstat(fd, &statbuf) && S_ISREG(statbuf.st_mode)) {
>                 close(fd);
>                 return 0;
>         }
> 
> That's slightly more efficient, and not prone to confusion
> in the unlikely event that "device" changes inode between
> the stat and the open calls.

Ok, yes that's probably better, will resend.  thanks.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
