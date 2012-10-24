Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OGDW3d025435 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 11:13:32 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qsCeeGoBqgf9ma6C for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 09:15:16 -0700 (PDT)
Message-ID: <50881477.5050602@redhat.com>
Date: Wed, 24 Oct 2012 12:16:55 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121023013104.GJ4291@dastard>
In-Reply-To: <20121023013104.GJ4291@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/22/2012 09:31 PM, Dave Chinner wrote:
> On Fri, Oct 05, 2012 at 10:17:12AM -0400, Brian Foster wrote:
...
>>  /*
>> + * Speculative preallocation trimming.
>> + */
>> +#define XFS_EOFBLOCKS_VERSION		1
>> +struct xfs_eofblocks {
>> +	__u32		eof_version;
>> +	__u32		eof_flags;
>> +	unsigned char	pad[12];
>> +};
> 
> 12 bytes of padding is a bit wierd at this point. It's 
> problematic for 32bit userspace on 64 bit kernels, in that the size
> of the structure can end up different (i.e. 20 bytes on 32b, 24 bytes
> on 64b) depending on the architectures natural alignment.
> 
> I can also see that adding multiple extra variables to the structure
> are quite likely (e.g. per-ag control, start/end inode numbers,
> etc), so 12 bytes of padding really isn't sufficient, IMO. I'd tend
> to pad out to, say, 128 bytes rather than 32, just in case. i.e:
> 
> 	__u64		pad[15];
> 
> And then take away from this padding space as you add functioanlity
> in fucture patches.
> 
> This extra padding means the version number won't need to increase
> any time soon, as it will be a while before we run out of either
> padding or flag space, instead of as soon as we add a new function
> to the ioctl....
> 

Ok, I'll convert the file size parameter to a __u64 (as per discussed in
the spaceman eofblocks command thread) and expand the padding.

>> +
>> +/* eof_flags values */
>> +#define XFS_EOF_FLAGS_SYNC		0x01	/* sync/wait mode scan */
> 
> I kind of prefer flags being defined by (1 << 0) style to keep
> larger flag numbers concise, but that's not a big deal.
> 

Eh, I find this cleaner than looking at the raw values as well.

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
> 
> Checking that no unsupported flags are set here is necessary. Also,
> checking the padding is zero is probably a good idea, as it will
> force applications to zero the structure properly before being able
> to use this interface properly....
> 

Ok.

>> +		flags = (eofb.eof_flags & XFS_EOF_FLAGS_SYNC) ? SYNC_WAIT : SYNC_TRYLOCK;
> 
> Line if a bit too long. However, would it be better to place this
> inside xfs_icache_free_eofblocks()?
> 

Are you suggesting to eliminate the flags parameter to
xfs_icache_free_eofblocks? The reason for the current interface is that
the background scan caller doesn't require the eofb parameter, so I
decided to generalize the sync/wait parameter in the caller.

If we want to push it into xfs_icache_free_eofblocks(), I think it would
be better at that point to eliminate the flags param and either infer
SYNC_TRYLOCK on a NULL eofb or to require an eofb and pass one with
a cleared XFS_EOF_FLAGS_SYNC from the background scan. Thoughts?

Brian

>> +		error = xfs_icache_free_eofblocks(mp, flags, &eofb);
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
