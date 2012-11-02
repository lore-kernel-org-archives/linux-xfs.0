Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2LLGxK185117 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 16:21:16 -0500
Message-ID: <509439B6.9020906@sgi.com>
Date: Fri, 02 Nov 2012 16:23:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] xfs: silence uninitialised f.file warning.
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-2-git-send-email-david@fromorbit.com>
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

On 11/01/12 19:38, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Uninitialised variable build warning introduced by 2903ff0 ("switch
> simple cases of fget_light to fdget"), gcc is not smart enough to
> work out that the variable is not used uninitialised, and the commit
> removed the initialisation at declaration that the old variable had.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
