Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 21:32:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A4WNjd030346
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 21:32:25 -0700
Message-ID: <47FD987A.40804@sgi.com>
Date: Thu, 10 Apr 2008 14:32:58 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] xfsqa - fix redirection in 091
References: <20080410042701.GG108924158@sgi.com>
In-Reply-To: <20080410042701.GG108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Fix the filtering of xfsinfo by punting stdout to /dev/null.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/091 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs-cmds/xfstests/091
> ===================================================================
> --- xfs-cmds.orig/xfstests/091	2008-04-08 12:25:08.000000000 +1000
> +++ xfs-cmds/xfstests/091	2008-04-10 07:33:10.674694972 +1000
> @@ -50,7 +50,7 @@ kernel=`uname -r  | sed -e 's/\(2\..\).*
>  
>  # 2.6 Linux kernels support sector aligned direct I/O only
>  if [ "$HOSTOS" = "Linux" -a "$kernel" = "2.6" ]; then
> -	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info
> +	xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.info > /dev/null
>  	if [ $? -eq 0 ]; then
>  		source $tmp.info
>  		bsize=$sectsz

fine

--Tim
