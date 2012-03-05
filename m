Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q251N52N069812 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 19:23:05 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PFB8fsAEAUtPYPLn for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 17:23:03 -0800 (PST)
Date: Mon, 5 Mar 2012 12:23:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: before test execution, print test number to
	syslog
Message-ID: <20120305012301.GM5091@dastard>
References: <1330691215-4796-1-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
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

On Fri, Mar 02, 2012 at 01:26:55PM +0100, Stefan Behrens wrote:
> When the xfstests are executed in a batch (like "check 001-299")
> and produce syslog output, it is helpful to know which test was
> causing the output. Therefore each time a test is started, a
> syslog message is generated that contains the number of the
> xfstest.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
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

Only thing I'd suggest here is that errors (e.g. logger is not
installed) are redirected to /dev/null so there isn't additional
noise if we fail to log to syslog.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
