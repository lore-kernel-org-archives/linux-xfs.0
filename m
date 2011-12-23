Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBNA1ogI210708 for <xfs@oss.sgi.com>; Fri, 23 Dec 2011 04:01:51 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yrgRfAav59ykIW6o for <xfs@oss.sgi.com>;
	Fri, 23 Dec 2011 02:01:48 -0800 (PST)
Date: Fri, 23 Dec 2011 21:01:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: use uid/gid instead of actual name to fix
	install issue
Message-ID: <20111223100135.GA12731@dastard>
References: <1324623173-32707-1-git-send-email-b19537@freescale.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1324623173-32707-1-git-send-email-b19537@freescale.com>
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
To: b19537@freescale.com
Cc: xfs@oss.sgi.com

On Fri, Dec 23, 2011 at 02:52:53PM +0800, b19537@freescale.com wrote:
> From: Zhenhua Luo <b19537@freescale.com>
> 
>     > when running install-sh during the install process, following
>       error might appear:
> 	> ../../install-sh -o bj -g bj -m 644 -T so_dot_version libhandle.lai /lib; ../../install-sh -o bj -g bj -T so_dot_current libhandle.lai /lib
> 	> chown: invalid user: `bj:bj'
> 	> chown: invalid user: `bj:bj'
> 	> Installing libdisk-install
> 	> make[1]: Nothing to be done for `install'.
> 	> Installing copy-install
> 	> ../install-sh -o bj -g bj -m 755 -d /usr/sbin
> 	> chown: invalid user: `bj:bj'
> 	> make[1]: *** [install] Error 1
> 	> make: *** [copy-install] Error 2
> 
> Signed-off-by: Zhenhua Luo <b19537@freescale.com>
> ---
>  include/install-sh |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/install-sh b/include/install-sh
> index 18c051f..9d8ff06 100755
> --- a/include/install-sh
> +++ b/include/install-sh
> @@ -105,10 +105,10 @@ do
>     c)
>  	;;
>     g)
> -	GROUP=$OPTARG
> +	GROUP=`id -g $OPTARG`
>  	;;
>     o)
> -	OWNER=$OPTARG
> +	OWNER=`id -u $OPTARG`
>  	;;
>     m)
>  	DIRMODE=`expr $OPTARG`

How does this fix the the problem that the user/group "bj" does
not exist?

$ id -g bj
id: bj: No such user
$ id -g bj 2> /dev/null
$

All this patch does is result in a OWNER/GROUP variable that is
empty when an invalid user/group is specified. Hence it will make
the install complete with a different user to the one specified in
the install command line. It should error out (like it does now) if
a user/group does not exist, not install as some other (unknown)
user.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
