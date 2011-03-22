Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2MHY5Zk033715 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 12:34:10 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CFA98F80C6
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 10:37:06 -0700 (PDT)
Subject: Re: [PATCH, v2] xfstests: drop "Mount point match" from 028 and
	047 golden output
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <201103020449.p224nRbO024369@stout.americas.sgi.com>
References: <201103020449.p224nRbO024369@stout.americas.sgi.com>
Date: Tue, 22 Mar 2011 12:35:48 -0500
Message-ID: <1300815348.2875.11.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

Ping?

On Tue, 2011-03-01 at 22:49 -0600, Alex Elder wrote:
> Bill's latest update to xfsdump dropped a line of output that served
> no real purpose.  This change updates the golden output for the two
> tests that included that line of output.
> 
> Updated to filter out that line from dump output also, so old
> versions of the code will still produce the same output (suggested
> by Dave Chinner).
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  028.out     |    1 -
>  047.out     |    1 -
>  common.dump |    1 +
>  3 files changed, 1 insertion(+), 2 deletions(-)
> 
> Index: b/028.out
> ===================================================================
> --- a/028.out
> +++ b/028.out
> @@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/U
>         /var/xfsdump/inventory/UUID.InvIndex
>           Checking access for
>            /var/xfsdump/inventory/UUID.StObj
> -          Mount point match
>              Session 0: HOSTNAME:SCRATCH_MNT
>  -------------------------------------------------
>  Pruning this matching entry:
> Index: b/047.out
> ===================================================================
> --- a/047.out
> +++ b/047.out
> @@ -225,7 +225,6 @@ Processing file /var/xfsdump/inventory/U
>         /var/xfsdump/inventory/UUID.InvIndex
>           Checking access for
>            /var/xfsdump/inventory/UUID.StObj
> -          Mount point match
>              Session 0: HOSTNAME:SCRATCH_MNT
>  -------------------------------------------------
>  An entry matching the mount point/time is :
> Index: b/common.dump
> ===================================================================
> --- a/common.dump
> +++ b/common.dump
> @@ -814,6 +814,7 @@ _dump_filter_main()
>        -e '/\/dev\/tty/d'				\
>        -e '/inventory session uuid/d'			\
>        -e '/ - Running single-threaded/d'		\
> +      -e '/Mount point match/d'				\
>        -e '/^.*I\/O metrics: .*$/d'			\
>        -e 's/1048576/BLOCKSZ/'				\
>        -e 's/2097152/BLOCKSZ/'				\



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
