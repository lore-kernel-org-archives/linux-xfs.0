Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4A2pVia145062 for <xfs@oss.sgi.com>; Wed, 9 May 2012 21:51:31 -0500
Message-ID: <4FAB2D14.3020104@oracle.com>
Date: Thu, 10 May 2012 10:51:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support V8
References: <4F3E532E.6000708@oracle.com> <4FAAACA1.3090600@sgi.com>
In-Reply-To: <4FAAACA1.3090600@sgi.com>
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

On 05/10/2012 01:42 AM, Mark Tinguely wrote:

> On 02/17/12 07:16, Jeff Liu wrote:
>> Hello,
>>
>> This is the revised patch according to Dave's comments for V7.
>>
>> Changes to V8:
>> --------------
>> 1. If there is an internal error raised at extent reading routine, just
>> return it rather than ENXIO.
>> 2. Add the commit message.
>> 3. Remove the for(;;) loop since there is no continuous holes shown even
>> if create a Petabyte sparse file with hole extent length longer than
>> 32-bit.  Thanks Dave for helping verify that!
>> 4. In xfs_seek_data(), s/len/end/, looks 'end' is more meaningful here
>> to indicate the range of extents mapped.
>> 5. Remove BUG() from xfs_seek_data() since xfs_bmapi_read() have found
>> any corruption during the lookup, it should not occurred at all.
>>
>> Any comments are appreciated!
>>
>> Thanks,
>> -Jeff
>>
>>
>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>> ---
>>   This patch adds lseek(2) SEEK_DATA/SEEK_HOLE functionality.
> 
>> +STATIC loff_t
>> +xfs_seek_hole(
>> +    struct file        *file,
>> +    loff_t            start,
>> +    u32            type)
>> +{
>> +    struct inode        *inode = file->f_mapping->host;
>> +    struct xfs_inode    *ip = XFS_I(inode);
>> +    struct xfs_mount    *mp = ip->i_mount;
>> +    loff_t            uninitialized_var(offset);
>> +    loff_t            holeoff;
>> +    xfs_fsize_t        isize;
>> +    xfs_fileoff_t        fsbno;
>> +    uint            lock;
>> +    int            error;
>> +
>> +    lock = xfs_ilock_map_shared(ip);
>> +
>> +    isize = i_size_read(inode);
>> +    if (start>= isize) {
>> +        error = ENXIO;
>> +        goto out_unlock;
>> +    }
>> +
>> +    fsbno = XFS_B_TO_FSBT(mp, start);
>> +    error = xfs_bmap_first_unused(NULL, ip, 1,&fsbno, XFS_DATA_FORK);
>> +    if (error)
>> +        goto out_unlock;
>> +
>> +    holeoff = XFS_FSB_TO_B(mp, fsbno);
>> +    if (holeoff<= start)
>> +        offset = start;
>> +    else
>> +        offset = min_t(loff_t, holeoff, isize);
>> +
>> +    if (offset != file->f_pos)
>> +        file->f_pos = offset;
>> +
>> +out_unlock:
>> +    xfs_iunlock_map_shared(ip, lock);
>> +
>> +    if (error)
>> +        return -error;
>> +    return offset;
>> +}
> 
> Sorry this got set aside. This is being dusted off for inclusion.

Thanks for picking this up!

> 
> Refresh my memory, do we need a XFS_FORCED_SHUTDOWN test in
> xfs_seek_hole()? In the earlier versions it was covered in the
> xfs_bmapi_read().

Yes, definitely.

> 
> A comment on the min_t() that the xfs_bmap_first_unused() could
> return a value bigger than the isize if there are no more holes
> may help the forgetful such as myself.

I'll leave a comment for it, it would be helpful to recall the case for
a long period.

Thanks,
-Jeff

> 
> Otherwise it looks good.
> 
> Thank-you.
> 
> Mark Tinguely <tinguely@sgi.com>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
