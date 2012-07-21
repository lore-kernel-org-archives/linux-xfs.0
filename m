Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6L6OmI9198836 for <xfs@oss.sgi.com>; Sat, 21 Jul 2012 01:24:49 -0500
Message-ID: <500A4B24.40908@oracle.com>
Date: Sat, 21 Jul 2012 14:24:36 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4] xfs: probe data buffer from page cache for unwritten
	extents
References: <50091696.4000903@oracle.com> <5009A786.3080500@sgi.com>
In-Reply-To: <5009A786.3080500@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On 07/21/2012 02:46 AM, Mark Tinguely wrote:
> On 07/20/12 03:28, Jeff Liu wrote:
>> Hi All,
>>
>> According to Mark and Christoph's comments for v3, except optimizing 
>> xfs_seek_data() with unwritten extents
>> probing, the xfs_seek_hole() is also refined to that in this version.
>>
>>
>
> Just some feedback.
>
> Test program fragment:
>
>         ret = do_fallocate(fd, 512*1024, 256*1024, 0);
>         if (ret < 0)
>                 goto out;
>         pwrite(fd, buf, 4096, 1024*516);
>         lseek(fd, 800*1024, SEEK_SET);
>         ret = write(fd, buf, bufsz);
>         if (ret < 0)
>                 goto out;
>
> Output:
>
> HOLE/DATA at 512K 786432 / 528384   <- undiscovered hole here
> HOLE/DATA at 516K 786432 / 528384   <- okay, data but we should
>                                         return next page as hole.
> HOLE/DATA at 520K 532480 / 819200   <- hole is discovered because
>                                        there is no trailing data
Oops! for xfs_seek_hole(), I should use min_t() to pre-claculate offset 
before searching page cache.
Thanks for your prompt feedback.  I'll do some extra tests and post the 
revised soon.

Thanks,
-Jeff

>
> --Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
