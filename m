Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79ACD7CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 16:45:34 -0500 (CDT)
Date: Tue, 27 Aug 2013 16:45:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: fix bad dquot buffer size in log recovery readahead
Message-ID: <20130827214534.GZ5262@sgi.com>
References: <1377573943-25770-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377573943-25770-1-git-send-email-david@fromorbit.com>
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

On Tue, Aug 27, 2013 at 01:25:43PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfstests xfs/087 fails 100% reliably with this assert:
> 
> XFS (vdb): Mounting Filesystem
> XFS (vdb): Starting recovery (logdev: internal)
> XFS: Assertion failed: bp->b_flags & XBF_STALE, file: fs/xfs/xfs_buf.c, line: 548
> 
> while trying to read a dquot buffer in xlog_recover_dquot_ra_pass2().
> 
> The issue is that the buffer length to read that is passed to
> xfs_buf_readahead is in units of filesystem blocks, not disk blocks.
> (i.e. FSB, not daddr). Fix it but putting the correct conversion in
> place.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
