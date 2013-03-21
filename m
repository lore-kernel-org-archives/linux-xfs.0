Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F9EB7F37
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 20:09:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BA8C304039
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 18:09:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LZl1qzCAt3GCWcQN for <xfs@oss.sgi.com>;
	Wed, 20 Mar 2013 18:09:11 -0700 (PDT)
Date: Thu, 21 Mar 2013 12:09:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 299-305: remove fio config files after finished
	test
Message-ID: <20130321010902.GH17758@dastard>
References: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363685450-27452-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 05:30:50PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> After finished test, temporarily fio config file should be removed.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  299 | 2 +-
>  300 | 2 +-
>  301 | 2 +-
>  302 | 2 +-
>  303 | 2 +-
>  304 | 2 +-
>  305 | 1 +
>  7 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/299 b/299
> index 4305ead..9d0c32f 100644
> --- a/299
> +++ b/299
> @@ -32,7 +32,7 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
> +trap "rm -f $tmp.*; rm -f $tmp-$seq.fio; exit \$status" 0 1 2 3 15

Umm, wouldn't this be better:

-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp*; exit \$status" 0 1 2 3 15


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
