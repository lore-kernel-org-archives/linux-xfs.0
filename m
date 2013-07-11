Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B55617F3F
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:11:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C180AC008
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 18:11:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	vNeUe01s8FSVkkbr for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 18:11:08 -0700 (PDT)
Date: Thu, 11 Jul 2013 11:11:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] ext4: ignore valid errors from defragmentation tests
Message-ID: <20130711011105.GV3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
	<1373367918-7516-3-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373367918-7516-3-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On Tue, Jul 09, 2013 at 03:05:17PM +0400, Dmitry Monakhov wrote:
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  tests/ext4/301 |    3 +++
>  tests/ext4/302 |    3 +++
>  tests/ext4/303 |    6 ++++++
>  tests/ext4/304 |    3 +++
>  4 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/tests/ext4/301 b/tests/ext4/301
> index 0ca3622..30e4273 100755
> --- a/tests/ext4/301
> +++ b/tests/ext4/301
> @@ -74,6 +74,9 @@ donorname=test1.def
>  filename=test1
>  inplace=0
>  rw=write
> +continue_on_error=write
> +ignore_error=,ENOSPC:EBUSY
> +error_dump=0
>  numjobs=${NUM_JOBS}
>  runtime=30*${TIME_FACTOR}
>  time_based

Seems harmless enough to me.

Acked-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
