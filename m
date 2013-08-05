Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 709BA7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:39:12 -0500 (CDT)
Message-ID: <52001B7F.5020906@sgi.com>
Date: Mon, 05 Aug 2013 16:39:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 27/49] xfs: move inode fork definitions to a new header
	file
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-28-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-28-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The inode fork definitions are a combination of on-disk format
> definition and in-memory tracking and manipulation. They are both
> shared with userspace, so move them all into their own file so
> sharing is easy to do and track.  This removes all inode fork
> related information from xfs_inode.h.
>
> Do the same for the all the C code that currently resides in
> xfs_inode.c for the same reason.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

xfsprogs equivalent of the for 3.12 kernel patch 12/49.

move remaining shared inode to new xfs_inode_fork.c/h. new function 
prototypes.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
