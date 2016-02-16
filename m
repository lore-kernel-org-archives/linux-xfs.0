Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6CAA47CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 18:55:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 222C18F8035
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 16:55:01 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qBEGam2Bx6W6h1Fo for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 16:54:58 -0800 (PST)
Subject: Re: [PATCH 4/4] xfs: XFS_DIFLAG2_DAX limited by PAGE_SIZE
References: <1455513734-15192-1-git-send-email-david@fromorbit.com>
	<1455513734-15192-5-git-send-email-david@fromorbit.com>
	<56C26954.2010001@sandeen.net> <20160216003923.GL14668@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56C27360.4020004@sandeen.net>
Date: Mon, 15 Feb 2016 18:54:56 -0600
MIME-Version: 1.0
In-Reply-To: <20160216003923.GL14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 2/15/16 6:39 PM, Dave Chinner wrote:
> On Mon, Feb 15, 2016 at 06:12:04PM -0600, Eric Sandeen wrote:

...

>> So which is it, at least PAGE_SIZE or == PAGE_SIZE?
> 
> Linux does not support filesystems where the block size is larger
> than the page size, so the supported set of "block size at least as
> large as PAGE_SIZE" is only block size == PAGE_SIZE.

Um, ok.  Comment is still confusing.  ;)

>>>  	/* If the DAX state is not changing, we have nothing to do here. */
>>>  	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>> index 9c984a0..fb7dc61 100644
>>> --- a/fs/xfs/xfs_iops.c
>>> +++ b/fs/xfs/xfs_iops.c
>>> @@ -1186,6 +1186,7 @@ xfs_diflags_to_iflags(
>>>  	if (flags & XFS_DIFLAG_NOATIME)
>>>  		inode->i_flags |= S_NOATIME;
>>>  	if (S_ISREG(inode->i_mode) &&
>>> +	    ip->i_mount->m_sb.sb_blocksize == PAGE_SIZE &&
>>>  	    (ip->i_mount->m_flags & XFS_MOUNT_DAX ||
>>>  	     ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
>>>  		inode->i_flags |= S_DAX;
>>
>> Is it possible to get mounted with XFS_MOUNT_DAX if blocksize != PAGE_SIZE?
> 
> No, It's checked at mount time.
> 
>> If so, should it be?  This seems like a strange place to catch this mismatch.
> 
> It's not for catching a bad mount option (which will go away,
> anyway). it's for catching an "in-pmem" inode flag that can't be
> applied because, e.g, the kernel was rebuilt with a different base
> page size and now the extents won't align correctly for DAX to work.

Oh, with the di_flags2 already set on disk, and now encountering a
new page size.  Right, ok.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
