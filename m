Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3J8e4hO032051 for <xfs@oss.sgi.com>; Thu, 19 Apr 2012 03:40:04 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 10mZG1VmPE20p2cA for
	<xfs@oss.sgi.com>; Thu, 19 Apr 2012 01:40:03 -0700 (PDT)
Date: Thu, 19 Apr 2012 10:39:57 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: Change the diff output of failed tests
In-Reply-To: <1334047113-32720-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1204191038390.4508@dhcp-27-109.brq.redhat.com>
References: <1334047113-32720-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Tue, 10 Apr 2012, Lukas Czerner wrote:

> Currently the entire diff is printed to the stdout in the case that the
> test output template differs from the actual test run. However in some
> cases the diff can be _very_ long. This commit changes it so that we
> print only first 10 lines of the diff.
> 
> Also indent the diff output from the left by four spaces for better
> output readability.

ping

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  check |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/check b/check
> index f792009..c5d67a5 100755
> --- a/check
> +++ b/check
> @@ -286,7 +286,11 @@ do
>  		else
>  		    echo " - output mismatch (see $seq.out.bad)"
>  		    mv $tmp.out $seq.out.bad
> -		    $diff $seq.out $seq.out.bad
> +		    $diff $seq.out $seq.out.bad | head -n 10 | \
> +			sed -e 's/^\(.\)/    \1/'
> +		    echo "     ..."
> +		    echo "     (Run '$diff $seq.out $seq.out.bad' to see the" \
> +			 "entire diff)"
>  		    err=true
>  		fi
>  	    fi
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
