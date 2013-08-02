Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B7B527F52
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 18:51:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B649AC002
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 16:51:59 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id u0HWnt2IlhxVEE65 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Aug 2013 16:51:58 -0700 (PDT)
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 2 Aug 2013 17:51:57 -0600
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3C22DC90026
	for <xfs@oss.sgi.com>; Fri,  2 Aug 2013 19:51:52 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r72Npr3R157538 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:51:53 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r72NprXc022636 for <xfs@oss.sgi.com>; Fri, 2 Aug 2013 19:51:53 -0400
Subject: Re: [PATCH 06/10 v2] xfstests: Allow to specify RESULT_BASE directory
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1373539085-8577-7-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-7-git-send-email-lczerner@redhat.com>
Date: Fri, 02 Aug 2013 18:51:52 -0500
Message-ID: <1375487512.4155.73.camel@chandra-dt.ibm.com>
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

On Thu, 2013-07-11 at 12:38 +0200, Lukas Czerner wrote:
> This commit adds the possibility to specify RESULT_BASE directory from
> the config file, or with environment variable. The default remains the
> same "$here/results/".
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

> ---
>  check         | 1 -
>  common/config | 5 +++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/check b/check
> index dc972d7..428eba1 100755
> --- a/check
> +++ b/check
> @@ -66,7 +66,6 @@ export FSTYP
>  SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
>  SRC_GROUPS="generic shared"
>  export SRC_DIR="tests"
> -export RESULT_BASE=${RESULT_BASE:="$here/results"}
> 
>  usage()
>  {
> diff --git a/common/config b/common/config
> index 34c99e1..39dd469 100644
> --- a/common/config
> +++ b/common/config
> @@ -230,6 +230,11 @@ if [ -f "$HOST_OPTIONS" ]; then
>  fi
> 
>  get_next_config() {
> +	# set default RESULT_BASE
> +	if [ -z "$RESULT_BASE" ]; then
> +		export RESULT_BASE="$here/results/"
> +	fi
> +
>  	#  Mandatory Config values.
>  	MC=""
>  	[ -z "$EMAIL" ]          && MC="$MC EMAIL"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
