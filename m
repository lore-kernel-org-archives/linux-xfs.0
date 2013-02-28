Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC8117F82
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2013 09:37:52 -0600 (CST)
Message-ID: <512F79CE.4030502@sgi.com>
Date: Thu, 28 Feb 2013 09:37:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't verify buffers after IO errors
References: <1361931954-11105-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1361931954-11105-1-git-send-email-david@fromorbit.com>
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

On 02/26/13 20:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When we read a buffer, we might get an error from the underlying
> block device and not the real data. Hence if we get an IO error, we
> shouldn't run the verifier but instead just pass the IO error
> straight through.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good. needs to go into Linux 3.7/8 stable?

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
