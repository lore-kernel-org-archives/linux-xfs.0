Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0EABB7F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 20:22:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E396C8F8035
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 18:22:13 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9EJbzSuhMkTukFb4 for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 18:22:12 -0700 (PDT)
Date: Tue, 12 Mar 2013 12:21:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: determine path of logger
Message-ID: <20130312012152.GG21651@dastard>
References: <1363045012-21119-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363045012-21119-1-git-send-email-dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 12:36:52AM +0100, David Sterba wrote:
> The path of the syslog writer utility 'logger' is hardcoded and not
> always correct, use set_prog_path.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  check         | 2 +-
>  common.config | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/check b/check
> index c20179c..9a5b256 100755
> --- a/check
> +++ b/check
> @@ -243,7 +243,7 @@ do
>  	start=`_wallclock`
>  	$timestamp && echo -n "	["`date "+%T"`"]"
>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
> -	[ -x /usr/bin/logger ] && /usr/bin/logger "run xfstest $seq"
> +	$LOGGER_PROG "run xfstest $seq"
>  	./$seq >$tmp.rawout 2>&1
>  	sts=$?
>  	$timestamp && _timestamp
> diff --git a/common.config b/common.config
> index a0b017d..ed0f44c 100644
> --- a/common.config
> +++ b/common.config
> @@ -177,6 +177,7 @@ export DUMPE2FS_PROG="`set_prog_path dumpe2fs`"
>  export FIO_PROG="`set_prog_path fio`"
>  export FILEFRAG_PROG="`set_prog_path filefrag`"
>  export E4DEFRAG_PROG="`set_prog_path e4defrag`"
> +export LOGGER_PROG="`set_prog_path logger`"
>  
>  # Generate a comparable xfsprogs version number in the form of
>  # major * 10000 + minor * 100 + release

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
