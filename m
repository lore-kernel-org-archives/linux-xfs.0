Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLFicd072772 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:15:44 -0500
Message-ID: <4F5FB8F9.6020401@sgi.com>
Date: Tue, 13 Mar 2012 16:15:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/10] xfs: Fix open flag handling in open_by_handle code
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-3-git-send-email-david@fromorbit.com>
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

On 03/06/12 22:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Sparse identified some unsafe handling of open flags in the xfs open
> by handle ioctl code. Update the code to use the correct access
> macros to ensure that we handle the open flags correctly.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
