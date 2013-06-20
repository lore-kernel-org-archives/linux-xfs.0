Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F88C7F61
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 13:45:18 -0500 (CDT)
Message-ID: <51C34DBE.1070100@sgi.com>
Date: Thu, 20 Jun 2013 13:45:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/60] xfs: plug directory buffer readahead
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-4-git-send-email-david@fromorbit.com>
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

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Similar to bulkstat inode chunk readahead, we need to plug directory
> data buffer readahead during getdents to ensure that we can merge
> adjacent readahead requests and sort out of order requests optimally
> before they are dispatched. This improves the readahead efficiency
> and reduces the IO load it generates as the IO patterns are
> significantly better for both contiguous and fragmented directories.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
