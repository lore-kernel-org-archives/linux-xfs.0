Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BMZL0o252269 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 17:35:21 -0500
Message-ID: <507749A2.4020206@redhat.com>
Date: Thu, 11 Oct 2012 18:35:14 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com>
In-Reply-To: <20121011141335.GY13214@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 10/11/2012 10:13 AM, Ben Myers wrote:
> Hey Brian,
> 
> On Fri, Oct 05, 2012 at 10:17:12AM -0400, Brian Foster wrote:
>> The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
>> scan. The xfs_eofblocks structure is defined to support the command
>> parameters (scan mode).
> 
> It would help to have an xfstest to exercise this ioctl to pull in with this
> series.  Do you have any code that could be wrangled into a test case?
> 

Yes, makes sense. I have some very basic test code I could put somewhere
to invoke the ioctl(). One of the questions I've been meaning to ask is
whether it would be relevant for that code to live in a common tool,
such as adding a new command to xfs_io. Then perhaps create an xfstests
test using that. Thoughts?

FYI, I have a few other things on my plate at the moment so
unfortunately it will be a bit before I can get back to XFS work... But
I'm fine with the set pending until I can come up with some test
coverage if that is preferable, of course.

Brian

> Regards,
> 	Ben
> 
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_fs.h     |   15 +++++++++++++++
>>  fs/xfs/xfs_icache.c |    5 +++--
>>  fs/xfs/xfs_icache.h |    2 +-
>>  fs/xfs/xfs_ioctl.c  |   16 ++++++++++++++++
>>  4 files changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
>> index c13fed8..5f48b3e 100644
>> --- a/fs/xfs/xfs_fs.h
>> +++ b/fs/xfs/xfs_fs.h
>> @@ -339,6 +339,20 @@ typedef struct xfs_error_injection {
>>  
>>  
>>  /*
>> + * Speculative preallocation trimming.
>> + */
>> +#define XFS_EOFBLOCKS_VERSION		1
>> +struct xfs_eofblocks {
>> +	__u32		eof_version;
>> +	__u32		eof_flags;
>> +	unsigned char	pad[12];
>> +};
>> +
>> +/* eof_flags values */
>> +#define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
>> +
>> +
>> +/*
>>   * The user-level Handle Request interface structure.
>>   */
>>  typedef struct xfs_fsop_handlereq {
>> @@ -456,6 +470,7 @@ typedef struct xfs_handle {
>>  /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
>>  #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
>>  #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
>> +#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
>>  
>>  /*
>>   * ioctl commands that replace IRIX syssgi()'s
>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index b02a3df..35efdda 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -1206,11 +1206,12 @@ xfs_inode_free_eofblocks(
>>  int
>>  xfs_icache_free_eofblocks(
>>  	struct xfs_mount	*mp,
>> -	int			flags)
>> +	int			flags,
>> +	struct xfs_eofblocks	*eofb)
>>  {
>>  	ASSERT((flags & ~(SYNC_TRYLOCK|SYNC_WAIT)) == 0);
>>  	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
>> -					 NULL, XFS_ICI_EOFBLOCKS_TAG);
>> +					 eofb, XFS_ICI_EOFBLOCKS_TAG);
>>  }
>>  
>>  void
>> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
>> index abca9fb..b46716c 100644
>> --- a/fs/xfs/xfs_icache.h
>> +++ b/fs/xfs/xfs_icache.h
>> @@ -37,7 +37,7 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
>>  
>>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
>> -int xfs_icache_free_eofblocks(struct xfs_mount *, int);
>> +int xfs_icache_free_eofblocks(struct xfs_mount *, int, struct xfs_eofblocks *);
>>  
>>  int xfs_sync_inode_grab(struct xfs_inode *ip);
>>  int xfs_inode_ag_iterator(struct xfs_mount *mp,
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 0e0232c..ad4352f 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -42,6 +42,7 @@
>>  #include "xfs_inode_item.h"
>>  #include "xfs_export.h"
>>  #include "xfs_trace.h"
>> +#include "xfs_icache.h"
>>  
>>  #include <linux/capability.h>
>>  #include <linux/dcache.h>
>> @@ -1602,6 +1603,21 @@ xfs_file_ioctl(
>>  		error = xfs_errortag_clearall(mp, 1);
>>  		return -error;
>>  
>> +	case XFS_IOC_FREE_EOFBLOCKS: {
>> +		struct xfs_eofblocks eofb;
>> +		int flags;
>> +
>> +		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>> +			return -XFS_ERROR(EFAULT);
>> +
>> +		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
>> +			return -XFS_ERROR(EINVAL);
>> +
>> +		flags = (eofb.eof_flags & XFS_EOF_FLAGS_SYNC) ? SYNC_WAIT : SYNC_TRYLOCK;
>> +		error = xfs_icache_free_eofblocks(mp, flags, &eofb);
>> +		return -error;
>> +	}
>> +
>>  	default:
>>  		return -ENOTTY;
>>  	}
>> -- 
>> 1.7.7.6
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
