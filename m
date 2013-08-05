Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C30CC7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 17:07:07 -0500 (CDT)
Date: Mon, 5 Aug 2013 17:07:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 08/12] xfs: correctly map remote attr buffers during
	removal
Message-ID: <20130805220704.GE3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-9-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:24:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we don't map the buffers correctly (same as for get/set
> operations) then the incore buffer lookup will fail. If a block
> number matches but a length is wrong, then debug kernels will ASSERT
> fail in _xfs_buf_find() due to the length mismatch. Ensure that we
> map the buffers correctly by basing the length of the buffer on the
> attribute data length rather than the remote block count.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 6863ef8449f1908c19f43db572e4474f24a1e9da

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
