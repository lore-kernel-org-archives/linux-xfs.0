Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PGD8pA256235 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 11:13:08 -0500
Message-ID: <4FE88E11.2050208@sgi.com>
Date: Mon, 25 Jun 2012 11:13:05 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: probe data buffer from page cache for unwritten
	extents
References: <4FE85C7B.3010909@oracle.com>
In-Reply-To: <4FE85C7B.3010909@oracle.com>
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
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 06/25/12 07:41, Jeff Liu wrote:
> Hello,
>
> Using the start offset rather than map->br_startoff to calculate the starting page index could
> get more accurate data offset in page cache probe routine.
> With this refinement, the old max_t() could be able to remove too.
>
> Thanks Mark for pointing this out!
>
> -Jeff
>
>
> Cc: Mark Tinguely<tinguely@sgi.com>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---

> +			/*
> +			 * xfs_bmapi_read() can handle repeated hole regions,
> +			 * hence it should not return two extents both are
> +			 * holes.  If the 2nd extent is unwritten, there must
> +			 * have data buffer resides in page cache.
> +			 */
> +			BUG();


Looks great.

I hit the BUG() using a test with the following test:

  hole
  unwritten (treated as a hole)
  unwritten (treated as a hole)
  page of data.

I will send the current version of the test program.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
