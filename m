Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NLxfmT219128 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 16:59:41 -0500
Subject: Re: [PATCH 2/3] xfs: clear XFS_IDIRTY_RELEASE on truncate down
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1308792901-22880-3-git-send-email-david@fromorbit.com>
References: <1308792901-22880-1-git-send-email-david@fromorbit.com>
	<1308792901-22880-3-git-send-email-david@fromorbit.com>
Date: Thu, 23 Jun 2011 16:59:36 -0500
Message-ID: <1308866376.2010.33.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Thu, 2011-06-23 at 11:35 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an inode is truncated down, speculative preallocation is
> removed from the inode. This should also reset the state bits for
> controlling whether preallocation is subsequently removed when the
> file is next closed. The flag is not being cleared, so repeated
> operations on a file that first involve a truncate (e.g. multiple
> repeated dd invocations on a file) give different file layouts for
> the second and subsequent invocations.
> 
> Fix this by clearing the XFS_IDIRTY_RELEASE state bit when the
> XFS_ITRUNCATED bit is detected in xfs_release() and hence ensure
> that speculative delalloc is removed on files that have been
> truncated down.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
