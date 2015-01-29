Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B98AD7F78
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:04:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A2A830405F
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:04:15 -0800 (PST)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id 1IMFCg1kWUzCJibo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:04:14 -0800 (PST)
Received: by mail-pa0-f44.google.com with SMTP id rd3so38858153pab.3
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:04:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALJmpHNkhDc-54LKwi7k_-V9aoZD75cZZ2gf7N6YFt0T=-GiSA@mail.gmail.com>
References: <54c1c11e.678c420a.37a1.13c6@mx.google.com>
	<20150128012758.GS16552@dastard>
	<CALJmpHNkhDc-54LKwi7k_-V9aoZD75cZZ2gf7N6YFt0T=-GiSA@mail.gmail.com>
Date: Thu, 29 Jan 2015 18:34:13 +0530
Message-ID: <CALJmpHNBHNdnfRT2rJ35CniM5euu65SXR_mXjFQF48O+4JC1eQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] xfs_spaceman: XFS_IOC_FIEMAPFS ioctl replacing
	previous FS_IOC_FIEMAPFS
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: xfs@oss.sgi.com

>> --- a/linux-xfs/fs/xfs/xfs_ioctl.c    2015-01-04 15:45:26.518359725 +0530
>> +++ b/linux-xfs/fs/xfs/xfs_ioctl.c    2015-01-04 15:24:06.030407817 +0530
>> @@ -49,6 +49,8 @@
>>  #include <linux/exportfs.h>
>>
>>
>> +/* So that the fiemap access checks can't overflow on 32 bit machines. */
>> +#define FIEMAP_MAX_EXTENTS   (UINT_MAX / sizeof(struct fiemap_extent))
>
> Just move to include/linux/fs.h where the FS_IOC_FIEMAP definitions
> are.

>> +static int fiemap_check_ranges(struct super_block *sb,
>> +                            u64 start, u64 len, u64 *new_len)
>> +{
>> +     u64 maxbytes = (u64) sb->s_maxbytes;
>> +
>> +     *new_len = len;
>> +
>> +     if (len == 0)
>> +             return -EINVAL;
>> +
>> +     if (start > maxbytes)
>> +             return -EFBIG;
>> +
>> +     /*
>> +      * Shrink request scope to what the fs can actually handle.
>> +      */
>> +     if (len > maxbytes || (maxbytes - len) < start)
>> +             *new_len = maxbytes - start;
>>
>> +     return 0;
>> +}
>
> Rather than copying this code, I'd suggest that you remove the "static"
> declaration, export the symbol and add a prototype to
> include/linux/fs.h similar to fiemap_check_flags().
>

>> +static int xfsctl_fiemapfs(struct super_block *sb, unsigned long arg)
>
> - xfs_ioctl_fiemapfs() follows the naming convention used in the
>   rest of the file
> - this is an XFS specific function now, so should pass the xfs_mount
>   rather than the VFS super_block.
> - need a comment saying it was mostly copied from fs/ioctl.c::ioctl_fiemap().
> - arg has already marked as __user converted in the calling
>   function, so we need to retain the __user annotations here.
> - format for XFS functions is this:
>
> /*
>  * Mostly copied from ioctl_fiemap()
>  */
> static int
> xfs_ioctl_fiemapfs(
>         struct xfs_mount        *mp,
>         void __user             *arg)
>
>

>> +     if (!sb->s_op->fiemapfs)
>> +             return -EOPNOTSUPP;
>
> No need to check this - we can call the XFS function directly.
>

>>                       free(fiemap);
>>                       exitcode = 1;
>> @@ -338,6 +338,10 @@
>>
>>       if (!init(argc, argv))
>>               return 0;
>> +
>> +     if (dumpflag)
>> +             printf("%8s %8s %8s\n", "agno", "agbno", "len");
>
> Added functionality? That should be in a separate patch ;)
>

We have assimilated the changes and divided them into three
patches one for the kernel space code, one for the user space
code  and one patch for the above added functionality.

The updated patches have been sent as a separate thread :)

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
