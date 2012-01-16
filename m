Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GH0tJN104553 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 11:00:55 -0600
Message-ID: <4F1457CA.1060802@sgi.com>
Date: Mon, 16 Jan 2012 11:00:58 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] xfstests: use command line option for setting extra
	space
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
	<1321875088-30801-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-6-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Allow the extra free space to leave in large scratch filesystems to
> be specified by a command line option rather than just via an
> environment variable.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   common |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/common b/common
> index da86cd9..78ac654 100644
> --- a/common
> +++ b/common
> @@ -247,6 +247,11 @@ s/ .*//p
>   	    usage
>   	    ;;
>
> +	--extra-space=*)
> +	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
> +	    xpand=false
> +	    ;;
> +
>   	*)
>   	    start=$r
>   	    end=$r


Nice to have SCRATCH_DEV_EMPTY_SPACE variable and command line entry 
documented.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
