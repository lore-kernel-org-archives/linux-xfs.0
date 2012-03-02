Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22FTGiQ093162 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 09:29:17 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id jyGRm8GQ9KTQpH0L for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 07:29:15 -0800 (PST)
Message-ID: <4F50E74A.3070008@sandeen.net>
Date: Fri, 02 Mar 2012 09:29:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: before test execution, print test number to
	syslog
References: <1330691215-4796-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1330691215-4796-1-git-send-email-sbehrens@giantdisaster.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: xfs@oss.sgi.com

On 3/2/12 6:26 AM, Stefan Behrens wrote:
> When the xfstests are executed in a batch (like "check 001-299")
> and produce syslog output, it is helpful to know which test was
> causing the output. Therefore each time a test is started, a
> syslog message is generated that contains the number of the
> xfstest.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'd like to be sure others are ok with this, but I think
it's a good idea, thanks.

-Eric

> ---
>  check |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/check b/check
> index f792009..883edcc 100755
> --- a/check
> +++ b/check
> @@ -241,6 +241,7 @@ do
>  	start=`_wallclock`
>  	$timestamp && echo -n "	["`date "+%T"`"]"
>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
> +	logger "run xfstest $seq"
>  	./$seq >$tmp.rawout 2>&1
>  	sts=$?
>  	$timestamp && _timestamp

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
