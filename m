Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBIDgKfw022174 for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 07:42:21 -0600
Received: from qb-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9F531BF564F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 05:42:18 -0800 (PST)
Received: from qb-out-1314.google.com (qb-out-1314.google.com [72.14.204.170])
	by cuda.sgi.com with ESMTP id 7398FjWerUJdQZaz for
	<xfs@oss.sgi.com>; Thu, 18 Dec 2008 05:42:18 -0800 (PST)
Received: by qb-out-1314.google.com with SMTP id e19so232823qba.8
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2008 05:42:18 -0800 (PST)
Message-ID: <494A1B69.70300@ankitjain.org>
Date: Thu, 18 Dec 2008 15:14:09 +0530
From: Ankit Jain <me@ankitjain.org>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC] fs: Add new pre-allocation ioctls to vfs for
	compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org>
	<20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
>> 2. Should the corresponding ioctls be removed from ocfs2?
> 
> Well, a small amount of the code in fs/ocfs2/ioctl.c can certainly go away.
> Shouldn't we be talking about doing the same for xfs too?

Yep. I'll cook up cleanup patches for these two and post them.

-Ankit

> 
> 
>> Signed-off-by: Ankit Jain <me@ankitjain.org>
>> ---
>>  fs/ioctl.c             |   37 +++++++++++++++++++++++++++
>>  fs/open.c              |   51 ++++++++++++++++++-------------------
>>  include/linux/falloc.h |   19 ++++++++++++++
>>  include/linux/fs.h     |    2 +
>>  4 files changed, 83 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/ioctl.c b/fs/ioctl.c
>> index 43e8b2c..5e565c8 100644
>> --- a/fs/ioctl.c
>> +++ b/fs/ioctl.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/writeback.h>
>>  #include <linux/buffer_head.h>
>> +#include <linux/falloc.h>
>>  
>>  #include <asm/ioctls.h>
>>  
>> @@ -346,6 +347,37 @@ EXPORT_SYMBOL(generic_block_fiemap);
>>  
>>  #endif  /*  CONFIG_BLOCK  */
>>  
>> +/*
>> + * This provides compatibility with legacy XFS pre-allocation ioctls
>> + * which predate the fallocate syscall.
>> + *
>> + * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
>> + * are used here, rest are ignored.
>> + */
>> +static int ioctl_preallocate(struct file *filp, unsigned long arg)
>> +{
>> +	struct inode *inode = filp->f_path.dentry->d_inode;
>> +	struct space_resv sr;
>> +
>> +	if (copy_from_user(&sr, (struct space_resv __user *) arg, sizeof(sr)))
>> +		return -EFAULT;
>> +
>> +	switch (sr.l_whence) {
>> +	case SEEK_SET:
>> +		break;
>> +	case SEEK_CUR:
>> +		sr.l_start += filp->f_pos;
>> +		break;
>> +	case SEEK_END:
>> +		sr.l_start += i_size_read(inode);
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return do_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
>> +}
>> +
>>  static int file_ioctl(struct file *filp, unsigned int cmd,
>>  		unsigned long arg)
>>  {
>> @@ -361,6 +393,11 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
>>  		return put_user(inode->i_sb->s_blocksize, p);
>>  	case FIONREAD:
>>  		return put_user(i_size_read(inode) - filp->f_pos, p);
>> +	case F_IOC_RESVSP:
>> +	case F_IOC_RESVSP64:
>> +	case F_IOC_UNRESVSP:
>> +	case F_IOC_UNRESVSP64:
>> +		return ioctl_preallocate(filp, arg);
> 
> This patch is not implementing proper support for F_IOC_UNRESVSP and
> F_IOC_UNRESVSP64, so why are you catching those here? To be more clear,
> those are used for freeing space in a file ("puching holes"), which
> fallocate is not set up to do right now.
> 	--Mark
> 
> --
> Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
