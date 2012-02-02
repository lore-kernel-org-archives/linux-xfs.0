Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q123cUpX027414 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 21:38:30 -0600
Message-ID: <4F2A051D.7050608@oracle.com>
Date: Thu, 02 Feb 2012 11:38:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V6
References: <4F2504DD.5020503@oracle.com> <4F283F71.1020606@sgi.com>
In-Reply-To: <4F283F71.1020606@sgi.com>
Reply-To: jeff.liu@oracle.com
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 02/01/2012 03:22 AM, Mark Tinguely wrote:

> On 01/29/12 02:35, Jeff Liu wrote:
>> Hello,
>>
>> Sorry for the delay!! I just got back from vacation.
>>
>> This is the V6 to introduce SEEK_DATA/SEEK_HOLE support to XFS.
>> As we have discussed previously, I have removed the dirty data probing
>> stuff and just treating unwritten extents as data in this post.
>>
>> Changes to V6:
>> --------------
>> * remove xfs_has_unwritten_buffer() for now.
>> * xfs_bmapi_read() returns the br_state == XFS_EXT_NORM for a hole, so
>> we need to check its startblock is not a "nullstartblock" in this case.
>> * call i_size_read() after taking the ilock shared, otherwise, isize
>> could be stale.
>> * remove "ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK)" from xfs_seek_data()
>> since it will not used.
>> * in xfs_file_llseek(), return -EINVAL rather than -EOPNOTSUPP if
>> whence is not valid according to http://linux.die.net/man/2/lseek.
>> * s/int lock/uint lock/ in both xfs_seek_data() and xfs_seek_hole().
>> * s/out_lock/out_unlock/ in both functions too.
>>
>> Tests:
>> ------
>> * seek_sanity_tester:
>> http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/42514
>>
>> *seek_copy_tester:
>> http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/42522
>>
>>
>> Thank you!
>> -Jeff
>>
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>
>> ---
>>   fs/xfs/xfs_file.c |  168
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 files changed, 167 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 753ed9b..41a045f 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> +STATIC loff_t
>> +xfs_seek_data(
> <deleted>
>> +        error = xfs_bmapi_read(ip, fsbno, len - fsbno, map,&nmap,
>> +                       XFS_BMAPI_ENTIRE);
>> +        if (error)
>> +            goto out_unlock;
> 
> 
>> +STATIC loff_t
>> +xfs_seek_hole(
> <deleted>
>> +    error = xfs_bmap_first_unused(NULL, ip, 1,&fsbno, XFS_DATA_FORK);
>> +    if (error)
>> +        goto out_unlock;
> 
> The code looks good for the reduced problem. It test correctly. I am
> still finding holes only if they start on a 16KB boundary which we
> discussed before. I mention it in case more advanced test cases are
> generated.

> 
> Question:
> If the routines that are looking for extents/hole return an error (I see
> EFSCORRUPTED, EAGAIN, ENOMEM, EIO as possible errors in these routines),
> should you convert them to an error such as EIO? There is no specific
> error mention in the lseek manual page.

Thanks for your review!
The 'errno' should be convert to -ENXIO in those cases(this is the way I
observed from Btrfs and OCFS2), I'll take care of it in next post.


Thanks,
-Jeff

> 
> --Mark Tinguely.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
