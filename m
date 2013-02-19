Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FBFB7F5F
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 11:41:51 -0600 (CST)
Message-ID: <5123B95D.5020305@sgi.com>
Date: Tue, 19 Feb 2013 11:41:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/3] xfsprogs: sync the changes in transaction log
	space reservations  to user space
References: <51230E2D.2090307@oracle.com>
In-Reply-To: <51230E2D.2090307@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 02/18/13 23:31, Jeff Liu wrote:
> Sync the kernel code changes regarding transaction log space reservations to user space.
>
> As we have splitted the calculation of attrset log space reservations into mount
> time and runtime in kernel code, here we need to fix max_attrset_trans_res_adjust()
> to reflect this change.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
