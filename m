Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0EEB29DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:54:27 -0500 (CDT)
Message-ID: <522A32F2.8060406@sgi.com>
Date: Fri, 06 Sep 2013 14:54:26 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: don't assert fail on bad inode numbers
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
	<1378208858-20557-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378208858-20557-3-git-send-email-david@fromorbit.com>
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

On 09/03/13 06:47, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Let the inode verifier do it's work by returning an error when we
> fail to find correct magic numbers in an inode buffer.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks okay - the xfs_buf_ioerror() sets the error code for the caller to 
detect.

We talked about this in June:
  http://oss.sgi.com/archives/xfs/2013-06/msg00712.html

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
