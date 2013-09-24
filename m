Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84E517F50
	for <xfs@oss.sgi.com>; Tue, 24 Sep 2013 10:32:01 -0500 (CDT)
Message-ID: <5241B06E.1030306@sgi.com>
Date: Tue, 24 Sep 2013 10:31:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: don't try to mark uncached buffers stale on
	error.
References: <1380002476-18839-1-git-send-email-david@fromorbit.com>
	<1380002476-18839-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1380002476-18839-2-git-send-email-david@fromorbit.com>
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

On 09/24/13 01:01, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> fsstress failed during a shutdown with the following assert:
>
> XFS: Assertion failed: xfs_buf_islocked(bp), file: fs/xfs/xfs_buf.c, line: 143
> .....
>   xfs_buf_stale+0x3f/0xf0
>   xfs_bioerror_relse+0x2d/0x90
>   xfsbdstrat+0x51/0xa0
>   xfs_zero_remaining_bytes+0x1d1/0x2d0
>   xfs_free_file_space+0x5d0/0x600
>   xfs_change_file_space+0x251/0x3a0
>   xfs_ioc_space+0xcc/0x130
> .....
>
> xfs_zero_remaining_bytes() works with uncached buffers, and hence if
> we are preventing IO due to a shutdown, we should not be marking it
> stale as that is only for cached buffers. Instead, just mark it with
> an error and make sure it gets to the caller.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
