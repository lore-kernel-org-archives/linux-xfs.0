Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 801AD7F9A
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 23:37:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6330AC005
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 21:37:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1OYgMUuN4OQCGEBI for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 21:37:36 -0700 (PDT)
Message-ID: <53C8A48F.5080000@sandeen.net>
Date: Thu, 17 Jul 2014 23:37:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: log running test to dmesg
References: <534EF81D.20205@redhat.com>
In-Reply-To: <534EF81D.20205@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 4/16/14, 4:37 PM, Eric Sandeen wrote:
> We already log the running test to system logs via "logger"
> but viro pointed out that we can use /dev/kmsg to insert it
> into dmesg as well.  When looking at the serial console that
> could be pretty useful.
> 
> Thanks to viro for the test -w suggestion too.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

can we get this one in?  Dave asked for a generic helper, but
no test needs to print to kmsg, and nobody else uses LOGGER_PROG.

All we use either one for is logging the test run.

If somebody needs it for another purpose, it makes sense to add a
helper...

-Eric

> ---
> 
> diff --git a/check b/check
> index 268417c..09b2320 100755
> --- a/check
> +++ b/check
> @@ -457,6 +457,7 @@ do
>  	$timestamp && echo -n "	["`date "+%T"`"]"
>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
>  	$LOGGER_PROG "run xfstest $seqnum"
> +	test -w /dev/kmsg && echo "run xfstest $seqnum" > /dev/kmsg
>  	./$seq >$tmp.rawout 2>&1
>  	sts=$?
>  	$timestamp && _timestamp
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
