Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69DIqTg115269 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 08:18:52 -0500
Subject: Re: [PATCH 2/2] Show duration of current test
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1278602632-12425-2-git-send-email-lczerner@redhat.com>
References: <1278602632-12425-1-git-send-email-lczerner@redhat.com>
	<1278602632-12425-2-git-send-email-lczerner@redhat.com>
Date: Fri, 09 Jul 2010 08:21:44 -0500
Message-ID: <1278681704.5154.24.camel@doink>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: esandeen@redhat.com, xfs@oss.sgi.com

On Thu, 2010-07-08 at 17:23 +0200, Lukas Czerner wrote:
> It may be useful to compare both times, last and current, in the
> xfstests output.

This one looks good.

Signed-off-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  check |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/check b/check
> index 560ac7b..f792009 100755
> --- a/check
> +++ b/check
> @@ -275,13 +275,14 @@ do
>  	    else
>  		if diff $seq.out $tmp.out >/dev/null 2>&1
>  		then
> -		    echo ""
>  		    if $err
>  		    then
>  			:
>  		    else
>  			echo "$seq `expr $stop - $start`" >>$tmp.time
> +			echo -n " `expr $stop - $start`s"
>  		    fi
> +		    echo ""
>  		else
>  		    echo " - output mismatch (see $seq.out.bad)"
>  		    mv $tmp.out $seq.out.bad



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
