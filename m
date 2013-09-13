Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EABF29DFB
	for <xfs@oss.sgi.com>; Fri, 13 Sep 2013 05:05:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60D78304032
	for <xfs@oss.sgi.com>; Fri, 13 Sep 2013 03:05:48 -0700 (PDT)
Message-ID: <5232E39F.60206@oracle.com>
Date: Fri, 13 Sep 2013 18:06:23 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Make the incore inode di_size to xfs_ufsize_t
References: <52269DF4.5040305@oracle.com> <20130912142446.GZ1935@sgi.com>
In-Reply-To: <20130912142446.GZ1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Ben,

On 09/12/2013 10:24 PM, Ben Myers wrote:

> Hey Jeff,
> 
> On Wed, Sep 04, 2013 at 10:41:56AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Make the incore inode di_size to unsigned, this would be helpful
>> to catch the negative sizes of it in many cases, so that we don't
>> need to perform additional check for it being less than ZERO or not.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_inode_fork.c |    3 +--
>>  fs/xfs/xfs_log_format.h |    2 +-
>>  2 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
>> index 02f1083..2b60a5a 100644
>> --- a/fs/xfs/xfs_inode_fork.c
>> +++ b/fs/xfs/xfs_inode_fork.c
>> @@ -167,8 +167,7 @@ xfs_iformat_fork(
>>  			}
>>  
>>  			di_size = be64_to_cpu(dip->di_size);
>> -			if (unlikely(di_size < 0 ||
>> -				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>> +			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>>  				xfs_warn(ip->i_mount,
>>  			"corrupt inode %Lu (bad size %Ld for local inode).",
>>  					(unsigned long long) ip->i_ino,
>> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
>> index a49ab2c..2795fc5 100644
>> --- a/fs/xfs/xfs_log_format.h
>> +++ b/fs/xfs/xfs_log_format.h
>> @@ -547,7 +547,7 @@ typedef struct xfs_icdinode {
>>  	xfs_ictimestamp_t di_atime;	/* time last accessed */
>>  	xfs_ictimestamp_t di_mtime;	/* time last modified */
>>  	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
>> -	xfs_fsize_t	di_size;	/* number of bytes in file */
>> +	xfs_ufsize_t	di_size;	/* number of bytes in file */
> 
> These two changes by themselves look fairly innocuous, but upon closer
> inspection I'm not so sure...

> 
> e.g. xfs_fsize_t is still signed, and i_size is loff_t is still signed.
> I'm wondering if this doesn't represent a subtle change in the on-disk
> format for inodes up in that size range.  This was on my 3.12 queue.  I
> think it bears more discussion, so I'll hold off on this one for now.

As per my understanding for Dave's comments, maybe it's better to make
di_size to be unsigned with few changes, that's why I chose to fix the
incore di_size only.  Hence if a negative di_size is read from the disk
to the incore in above case with Dan's fix, it will be evaluated to be
an unexpected large value which would cause the corresponding check up fails.

Similarly, if a negative value is assigned to the incore di_size, it'll be
evaluated to an unexpected bigger value as well. In consequence, after flushing
the incore structure to disk, and read it back again, it will go through
the previous check up again. 

> 
> FWIW I believe we're still ok with just Dan's fix because the maximum
> size for local format is half a block or less.

Ok, meanwhile, let's waiting for other's comments.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
