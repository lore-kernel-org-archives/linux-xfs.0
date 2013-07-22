Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BABD87F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 08:27:45 -0500 (CDT)
Message-ID: <51ED3351.5010304@sgi.com>
Date: Mon, 22 Jul 2013 08:27:45 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 38/49] xfs: refactor xfs_trans_reserve() interface
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-39-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-39-git-send-email-david@fromorbit.com>
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
> With the new xfs_trans_res structure has been introduced, the log
> reservation size, log count as well as log flags are pre-initialized
> at mount time.  So it's time to refine xfs_trans_reserve() interface
> to be more neat.
>
> Also, introduce a new helper M_RES() to return a pointer to the
> mp->m_resv structure to simplify the input.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


> +/* shorthand way of accessing reservation structure */
> +#define M_RES(mp)	(&(mp)->m_resv)

Not a fan of this define- it does not buy much savings in text and clarity.

Beside my anti-shouty rant, the patch looks good.


Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
