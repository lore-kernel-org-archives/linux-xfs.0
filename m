Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 301E17F53
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 12:11:59 -0500 (CDT)
Message-ID: <535945DC.6010108@sgi.com>
Date: Thu, 24 Apr 2014 12:11:56 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC] libxfs: adding attribute fork frees xfs_inode ptr
References: <20140423210034.892939354@sgi.com>
	<20140423210445.700477624@sgi.com> <20140423222215.GT18672@dastard>
In-Reply-To: <20140423222215.GT18672@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On 04/23/14 17:22, Dave Chinner wrote:
> On Wed, Apr 23, 2014 at 04:04:35PM -0500, Mark Tinguely wrote:
>> User space does not currently perform any attribute adding/deleting,
>> but if we do want to fix attributes or use them for parent inode
>> pointers, user space should support attributes.
>>
>> The adding an attribute fork is done in an embedded transaction
>> inside xfs_attr_set_int(). The xfs_trans_commit in xfs_bmap_add_attrfork()
>> will free the xfs_inode pointer causing xfs_attr_calc_size() in
>> xfs_attr_set_int() to fail.
>
> It shouldn't. xfs_bmap_add_attrfork() does:
>
> 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>
> which in the kernel code sets:
>
> 	iip->ili_lock_flags = lock_flags;
>
>
> The libxfs code doesn't do that, so when xfs_trans_commit() gets
> to inode_item_unlock():
>
>
>          if (!iip->ili_lock_flags)
>                  libxfs_iput(ip, 0);
>          else
>                  iip->ili_lock_flags = 0;
>
> It frees the inode rather than just returning it with the lock
> flags cleared.
>
> Note that libxfs still has libxfs_trans_ijoin_ref() which sets the
> lock flags, but this has been removed from the kernel code. IOWs,
> this is a libxfs/trans.c::xfs_trans_ijoin() bug, not something that
> needs fixing in the shared kernel/user libxfs code.
>
> Cheers,
>
> Dave.

nod. That is the correct thing to do.

Since the shared user/kernel code will no longer do a xfs_trans_ihold(), 
the libxfs_iput() should be factored out out of inode_item_unlock() and 
have the creator release the inode pointer when it is appropriate.

No one besides me is using this so it can go into the next release of 
xfs_progs.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
