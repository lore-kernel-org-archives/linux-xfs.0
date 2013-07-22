Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72F837F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 08:49:40 -0500 (CDT)
Message-ID: <51ED3874.3020601@sgi.com>
Date: Mon, 22 Jul 2013 08:49:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 40/49] xfs: Refactor xfs_ticket_alloc() to extract a new
	helper
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-41-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-41-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Refactor xlog_ticket_alloc() to extract a new helper, i.e.
> xfs_log_calc_unit_res().
>
> This helper would be used to calculate the total log reservation
> size by adding extra log operation/transation headers for a new
> log ticket.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
