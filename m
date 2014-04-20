Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA8D17F55
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 19:56:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D79638F8035
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2014 17:56:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2CC4acGMZzfbcvDP for <xfs@oss.sgi.com>;
	Sat, 19 Apr 2014 17:56:49 -0700 (PDT)
Date: Sun, 20 Apr 2014 10:56:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: fix check for zero range support in generic/009
Message-ID: <20140420005645.GB15995@dastard>
References: <20140419190524.GA2116@wallace>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140419190524.GA2116@wallace>
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
To: Eric Whitney <enwlinux@gmail.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sat, Apr 19, 2014 at 03:05:24PM -0400, Eric Whitney wrote:
> Generic/001 fails when run on a file system that does not support byte range
> zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
> on a pre-3.15 extent-mapped file system.  The code in the test intended
> to prevent this contains an apparent typo that results in a check for
> fallocate() rather than zero range support.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  tests/generic/009 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/009 b/tests/generic/009
> index b7b0b3f..65abe3c 100644
> --- a/tests/generic/009
> +++ b/tests/generic/009
> @@ -44,7 +44,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # real QA test starts here
>  _supported_os Linux
> -_require_xfs_io_falloc "fzero"
> +_require_xfs_io_command "fzero"

There should be a helper in common/rc for this. i.e.
_require_xfs_io_fzero. There's helpers for everything else. Can you
add the helper and wire the tests up to it properly?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
