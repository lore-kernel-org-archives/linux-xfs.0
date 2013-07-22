Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1F227F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 08:22:39 -0500 (CDT)
Message-ID: <51ED321F.7080402@sgi.com>
Date: Mon, 22 Jul 2013 08:22:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 36/49] xfs: Introduce tr_fsyncts to m_reservation
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-37-git-send-email-david@fromorbit.com>
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
> A preparation step.
>
> For now fsync_ts transaction use the pre-calculated log reservation
> size of tr_swrite.
> This patch introduce a new item tr_fsyncts to mp->m_reservations
> structure so that we can fetch the log reservation value for it
> in a same manner to others.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
