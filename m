Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EDE97CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 01:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62F7C304062
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2016 23:57:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wM9PmMNSIYqxSSMe for <xfs@oss.sgi.com>;
	Mon, 12 Sep 2016 23:57:41 -0700 (PDT)
Date: Tue, 13 Sep 2016 16:57:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix signed integer overflow
Message-ID: <20160913065738.GF30497@dastard>
References: <1473403112-31072-1-git-send-email-xiexiuqi@huawei.com>
	<1473403321.13672.35.camel@perches.com>
	<57D261E0.7080005@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <57D261E0.7080005@huawei.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 03:16:48PM +0800, Xie XiuQi wrote:
> On 2016/9/9 14:42, Joe Perches wrote:
> > On Fri, 2016-09-09 at 14:38 +0800, Xie XiuQi wrote:
> >> Use 1U for unsigned long, or we'll meet a overflow issue with UBSAN.
> > 
> > trivia: misleading commit message
> > 
> > 1U is for unsigned int not unsigned long int
> > 
> 
> Sorry, my fault. Thank you for your comments.
> 
> From 9cb8e36406a54ce0eaade31dd28f6068f03de1d2 Mon Sep 17 00:00:00 2001
> From: Xie XiuQi <xiexiuqi@huawei.com>
> Date: Tue, 6 Sep 2016 11:15:34 +0800
> Subject: [PATCH v2] xfs: fix signed integer overflow
....
> ---
>  fs/xfs/xfs_buf_item.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e455f90..3a27997 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -865,7 +865,7 @@ xfs_buf_item_log_segment(
>          */
>         if (bit) {
>                 end_bit = MIN(bit + bits_to_set, (uint)NBWORD);
> -               mask = ((1 << (end_bit - bit)) - 1) << bit;
> +               mask = ((1U << (end_bit - bit)) - 1) << bit;
>                 *wordp |= mask;
>                 wordp++;
>                 bits_set = end_bit - bit;

This patch is whitespace damaged and fails to apply. I've fixed it
up as this is a trivial change. However, please fix the problem
before you submit more patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
