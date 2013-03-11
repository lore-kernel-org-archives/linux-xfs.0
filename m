Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 212AA7F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 10:00:48 -0500 (CDT)
Message-ID: <513DE38D.9000901@sgi.com>
Date: Mon, 11 Mar 2013 09:00:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: ensure we capture IO errors correctly
References: <1362708074-14987-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1362708074-14987-1-git-send-email-david@fromorbit.com>
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

On 03/07/13 20:01, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Failed buffer readahead can leave the buffer in the cache marked
> with an error. Most callers that then issue a subsequent read on the
> buffer do not zero the b_error field out, and so we may incorectly
> detect an error during IO completion due to the stale error value
> left on the buffer.
>
> Avoid this problem by zeroing the error before IO submission. This
> ensures that the only IO errors that are detected those captured
> from are those captured from bio submission or completion.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
