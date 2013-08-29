Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D87A07F55
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 10:13:28 -0500 (CDT)
Date: Thu, 29 Aug 2013 10:13:24 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: don't account buffer cancellation during log
	recovery readahead
Message-ID: <20130829151324.GB5262@sgi.com>
References: <1377555053-23000-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377555053-23000-1-git-send-email-david@fromorbit.com>
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

On Tue, Aug 27, 2013 at 08:10:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing readhaead in log recovery, we check to see if buffers are
> cancelled before doing readahead. If we find a cancelled buffer,
> however, we always decrement the reference count we have on it, and
> that means that readahead is causing a double decrement of the
> cancelled buffer reference count.
> 
> This results in log recovery *replaying cancelled buffers* as the
> actual recovery pass does not find the cancelled buffer entry in the
> commit phase of the second pass across a transaction. On debug
> kernels, this results in an ASSERT failure like so:
> 
> XFS: Assertion failed: !(flags & XFS_BLF_CANCEL), file: fs/xfs/xfs_log_recover.c, line: 1815
> 
> xfstests generic/311 reproduces this ASSERT failure with 100%
> reproducability.
> 
> Fix it by making readahead only peek at the buffer cancelled state
> rather than the full accounting that xlog_check_buffer_cancelled()
> does.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Nice work Dave!
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
