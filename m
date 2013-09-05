Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BEF027F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 17:27:37 -0500 (CDT)
Message-ID: <52290559.10504@sgi.com>
Date: Thu, 05 Sep 2013 17:27:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 29/55] xfs: introduce xfs_inode_buf.c for inode buffer
	operations
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-30-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-30-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On 09/04/13 17:05, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The only thing remaining in xfs_inode.[ch] are the operations that
> read, write or verify physical inodes in their underlying buffers.
> Move all this code to xfs_inode_buf.[ch] and so we can stop sharing
> xfs_inode.[ch] with userspace.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 13/50.

Did not change from previous posting. I am more okay with the patch
this time.

Moves the last shared inode items to xfs_trans.h and removes the
kernel-only xfs_inode.h.

Sources do not have icreate patch (kernel commit cca9f93a) which is not
appropriate for xfsprogs...mentioned because it is a code difference.

The uuid_copy being renamed to platform_uuid_copy() is not a biggy, 
xfs.h does the same in a define.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
