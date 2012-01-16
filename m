Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GHnV4h105906 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 11:49:31 -0600
Message-ID: <4F14632C.3040501@sgi.com>
Date: Mon, 16 Jan 2012 11:49:32 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/8] xfstests: always us test option when checking large
	scratch device
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-8-git-send-email-david@fromorbit.com>
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

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Some tests call _check_scratch_device directly and when using a
> large filesystem this needs to run with a -t option to avoid
> consuming large amounts of memory. Make this happen in all cases
> that the scratch device is checked.
>


Looks good.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
