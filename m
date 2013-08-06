Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 174327F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 13:23:12 -0500 (CDT)
Message-ID: <52013F0C.2060206@sgi.com>
Date: Tue, 06 Aug 2013 13:23:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 41/49] xfs: Introduce a new structure to hold transaction
	reservation items
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-42-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-42-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Introduce a new structure xfs_trans_res to hold transaction
> reservation item info per log ticket.
>
> We also need to improve xfs_trans_resv_calc() by initializing the
> log count as well as log flags for permanent log reservation.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 35/49
plus find max log reservation for mkfs.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
