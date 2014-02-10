Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC8AA7F50
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:39:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C262F8F8037
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:39:50 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	B3AGMdmY4B6X7gxY for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 13:39:48 -0800 (PST)
Date: Tue, 11 Feb 2014 08:39:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
Message-ID: <20140210213944.GT13647@dastard>
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
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
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Feb 10, 2014 at 08:10:56PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> So i was wandering why test 004 could pass my previous wrong
> kernel patch while it defenitely should not.
> 
> By some debugging, i found here perl script is wrong, we did not
> filter out anything and this unit test did not work acutally.so
> it came out we will never fail this test.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/004 | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>  mode change 100755 => 100644 tests/btrfs/004
> 
> diff --git a/tests/btrfs/004 b/tests/btrfs/004
> old mode 100755
> new mode 100644
> index 14da9f1..17a6e34
> --- a/tests/btrfs/004
> +++ b/tests/btrfs/004
> @@ -57,10 +57,9 @@ _require_command "/usr/sbin/filefrag"
>  
>  rm -f $seqres.full
>  
> -FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
> -'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
> -'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
> -'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
> +FILEFRAG_FILTER='if (/blocks of (\d+) bytes/) {$blocksize = $1; next} ($ext, '\
> +'$logical, $physical, $length) = (/^\s*(\d+):\s+(\d+)..\s+\d+:'\
> +'\s+(\d+)..\s+\d+:\s+(\d+):/) or next; print $physical * $blocksize, "#", '\
>  '$length * $blocksize, "#", $logical * $blocksize, " "'

Oh, boy, who allowed that mess to pass review? Please format this in
a readable manner while you are changing it.

FILEFRAG_FILTER='
	if (/blocks of (\d+) bytes/) {			\
		$blocksize = $1;			\
		next;					\
	}
.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
