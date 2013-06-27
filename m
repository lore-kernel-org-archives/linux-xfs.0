Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67DAF7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 10:06:35 -0500 (CDT)
Message-ID: <51CC54F6.8070703@sgi.com>
Date: Thu, 27 Jun 2013 10:06:30 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 15/15] xfs: implement inode change count
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1372313099-8121-16-git-send-email-david@fromorbit.com>
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

On 06/27/13 01:04, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> For CRC enabled filesystems, add support for the monotonic inode
> version change counter that is needed by protocols like NFSv4 for
> determining if the inode has changed in any way at all between two
> unrelated operations on the inode.
>
> This bumps the change count the first time an inode is dirtied in a
> transaction. Since all modifications to the inode are logged, this
> will catch all changes that are made to the inode, including
> timestamp updates that occur during data writes.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
