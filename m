Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 404387F59
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 13:00:55 -0500 (CDT)
Date: Fri, 28 Jun 2013 13:00:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 15/15] xfs: implement inode change count
Message-ID: <20130628180054.GX20932@sgi.com>
References: <1372313099-8121-1-git-send-email-david@fromorbit.com>
	<1372313099-8121-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372313099-8121-16-git-send-email-david@fromorbit.com>
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

On Thu, Jun 27, 2013 at 04:04:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
