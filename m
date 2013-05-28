Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 365247CBF
	for <xfs@oss.sgi.com>; Tue, 28 May 2013 16:49:32 -0500 (CDT)
Date: Tue, 28 May 2013 16:49:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 6/9] xfs: disable swap extents ioctl on CRC enabled
	filesystems
Message-ID: <20130528214931.GA20028@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369636707-15150-7-git-send-email-david@fromorbit.com>
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

On Mon, May 27, 2013 at 04:38:24PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently, swapping extents from one inode to another is a simple
> act of switching data and attribute forks from one inode to another.
> This, unfortunately in no longer so simple with CRC enabled
> filesystems as there is owner information embedded into the BMBT
> blocks that are swapped between inodes. Hence swapping the forks
> between inodes results in the inodes having mapping blocks that
> point to the wrong owner and hence are considered corrupt.
> 
> To fix this we need an extent tree block or record based swap
> algorithm so that the BMBT block owner information can be updated
> atomically in the swap transaction. This is a significant piece of
> new work, so for the moment simply don't allow swap extent
> operations to succeed on CRC enabled filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I believe we do want to have functional swap extents for crc enabled
filesystems.  But this is fine as long as it is temporary.  Thanks Eric for
pointing this out on IRC.   Looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
