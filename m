Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07C4B7F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:49:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF2178F8037
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:49:06 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id DsbP0DEOwOAF85Na (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:49:06 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 17:49:05 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E19E13E4003F
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 17:48:38 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72Nn1vg378280 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 17:49:01 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r72Nn0lT026844
	for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 17:49:01 -0600
Subject: Re: [PATCH 02/10 v2] xfstests: Export all important variables in
	common/config
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-3-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-3-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 18:49:00 -0500
Message-ID: <1375487340.4155.69.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com


Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Thu, 2013-07-11 at 12:37 +0200, Lukas Czerner wrote:
> Currently we do not export some of the important variables in
> common/config. Fix this.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  common/config | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/common/config b/common/config
> index 67c1498..1679acf 100644
> --- a/common/config
> +++ b/common/config
> @@ -56,19 +56,19 @@ export LANG=C
>  [ -d /usr/freeware/bin ] && PATH=$PATH:/usr/freeware/bin
>  PATH=".:$PATH"
> 
> -HOST=`hostname -s`
> -HOSTOS=`uname -s`
> -[ "$HOSTOS" = "IRIX64" ] && HOSTOS="IRIX"
> +export HOST=`hostname -s`
> +export HOSTOS=`uname -s`
> +[ "$HOSTOS" = "IRIX64" ] && export HOSTOS="IRIX"
> 
> -MODULAR=0               # using XFS as a module or not
> -BOOT="/boot"            # install target for kernels
> +export MODULAR=0               # using XFS as a module or not
> +export BOOT="/boot"            # install target for kernels
>  export EXTRA=${EXTRA:=xfs-qa}
> 
>  # general parameters (mainly for auto-qa)
> -SOAK_PROC=3             # -p option to fsstress
> -SOAK_STRESS=10000       # -n option to fsstress
> -SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
> -EMAIL=root@localhost    # where auto-qa will send its status messages
> +export SOAK_PROC=3             # -p option to fsstress
> +export SOAK_STRESS=10000       # -n option to fsstress
> +export SOAK_PASSES=-1          # count of repetitions of fsstress (while soaking)
> +export EMAIL=root@localhost    # where auto-qa will send its status messages
>  export HOST_OPTIONS=${HOST_OPTIONS:=local.config}
>  export CHECK_OPTIONS=${CHECK_OPTIONS:="-g auto"}
>  export BENCH_PASSES=${BENCH_PASSES:=5}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
