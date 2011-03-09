Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p29HRYcE050168 for <xfs@oss.sgi.com>; Wed, 9 Mar 2011 11:27:39 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 507ADACE169
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 09:30:23 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id de0XokhAaGHM29rS for <xfs@oss.sgi.com>;
	Wed, 09 Mar 2011 09:30:23 -0800 (PST)
Message-ID: <4D77B92F.9020008@sandeen.net>
Date: Wed, 09 Mar 2011 11:30:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: make 127 and 134 clean up after themselves
References: <201103042022.p24KMAss008218@stout.americas.sgi.com>
In-Reply-To: <201103042022.p24KMAss008218@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On 3/4/11 2:22 PM, Alex Elder wrote:
> Tests 127 and 134 leave temp files around when they complete.
> Fix (or enable) their cleanup functions to remedy this.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Weird, 134 had the trap commented out from the initial commit...

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  127 |    1 +
>  134 |    3 +--
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/127
> ===================================================================
> --- a/127
> +++ b/127
> @@ -38,6 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
>  
>  _cleanup()
>  {
> +    rm -f $tmp.output
>      _cleanup_testdir
>  }
>  
> Index: b/134
> ===================================================================
> --- a/134
> +++ b/134
> @@ -43,8 +43,7 @@ _cleanup()
>  	umount $SCRATCH_MNT 2>/dev/null
>  	rm -f $tmp.*
>  }
> -#trap "_cleanup; exit \$status" 0 1 2 3 15
> -
> +trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # real QA test starts here
>  _supported_fs xfs
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
