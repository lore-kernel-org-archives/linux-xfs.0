Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 36BE87F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 21:14:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99C96AC002
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 19:14:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MnBASZiGAa8xKKnF for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 19:14:41 -0800 (PST)
Message-ID: <52F1ACA0.30702@sandeen.net>
Date: Tue, 04 Feb 2014 21:14:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs/296: fix golden output
References: <1391565192-26213-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1391565192-26213-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/4/14, 7:53 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This test never passed, so the golden output was never properly
> verified as correct. Now that the bug is fixed, fix the golden
> output to match the actual test output.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  tests/xfs/296.out | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/296.out b/tests/xfs/296.out
> index 1fb1b69..c279465 100644
> --- a/tests/xfs/296.out
> +++ b/tests/xfs/296.out
> @@ -50,6 +50,7 @@ Checking for xattr on restored file
>  user.name
>  
>  Checking for capability on restored file
> -RESTORE_DIR/DUMP_SUBDIR/testfile cap_setgid,cap_setuid+ep
> +RESTORE_DIR/DUMP_SUBDIR/testfile = cap_setgid,cap_setuid+ep
>  # file: RESTORE_DIR/DUMP_SUBDIR/testfile
>  security.capability
> +
> 

Hm, thanks.  I guess I just made it up the first time.  ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
