Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADLGlSr152136 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 15:16:47 -0600
Message-ID: <50A2B936.5090703@sgi.com>
Date: Tue, 13 Nov 2012 15:18:46 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/32] xfs: growfs: use uncached buffers for new headers
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1352721264-3700-8-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/12/2012 05:53 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> When writing the new AG headers to disk, we can't attach write
> verifiers because they have a dependency on the struct xfs-perag
> being attached to the buffer to be fully initialised and growfs
> can't fully initialise them until later in the process.
>
> The simplest way to avoid this problem is to use uncached buffers
> for writing the new headers. These buffers don't have the xfs-perag
> attached to them, so it's simple to detect in the write verifier and
> be able to skip the checks that need the xfs-perag.
>
> This enables us to attach the appropriate buffer ops to the buffer
> and hence calculate CRCs on the way to disk. IT also means that the
> buffer is torn down immediately, and so the first access to the AG
> headers will re-read the header from disk and perform full
> verification of the buffer. This way we also can catch corruptions
> due to problems that went undetected in growfs.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   fs/xfs/xfs_fsops.c |   63 ++++++++++++++++++++++++++++++++++------------------
>   1 file changed, 41 insertions(+), 22 deletions(-)
>

Looks good.

Reviewed-by Rich Johnston <rjohnston@sgi.com>

--Rich


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
