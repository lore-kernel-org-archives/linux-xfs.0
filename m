Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7CInwpT234587 for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 13:49:58 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91F4814CC869
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 11:59:08 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 2EdTDpKRa3H42lJd for
	<xfs@oss.sgi.com>; Thu, 12 Aug 2010 11:59:08 -0700 (PDT)
Received: from Liberator.local (unknown [12.198.177.3])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id DA4354106E08
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 13:50:18 -0500 (CDT)
Message-ID: <4C644269.20109@sandeen.net>
Date: Thu, 12 Aug 2010 14:50:17 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 228: suppress core dump message
References: <4C0FB207.20706@sandeen.net>
In-Reply-To: <4C0FB207.20706@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> When running 228 with abrt on in rhel6, I was getting different
> output due to a (core dumped) message on SIGXFSZ.  For some reason
> I wasn't able to use sed to filter it, and just ulimit -c 0 didn't
> suppress it either.
> 
> abrt sets the core pattern to:
> 
> "|/usr/libexec/abrt-hook-ccpp /var/spool/abrt %p %s %u %c""
> 
> which apparently allows core dumps even if ulimit -c is 0, due
> to the pipe.
> 
> Temporarily changing the kernel's core pattern to just plain "core"
> and setting ulimit -c to 0 does suppress it.  These are reset to
> original values after the test is run.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

hm ping on this one?

> ---
> 
> --- 228.orig	2010-06-09 11:13:27.000000000 -0400
> +++ 228	2010-06-09 11:19:57.000000000 -0400
> @@ -31,6 +31,8 @@
>  {
>  	cd /
>  	rm -f $tmp.*
> +	sysctl -w kernel.core_pattern="$core_pattern" &>/dev/null
> +	ulimit -c $ulimit_c
>  }
>  
>  here=`pwd`
> @@ -58,6 +60,12 @@
>  avail=`df -P $TEST_DIR | awk 'END {print $4}'`
>  [ "$avail" -ge 104000 ] || _notrun "Test device is too small ($avail KiB)"
>  
> +# Suppress core dumped messages
> +core_pattern=`sysctl kernel.core_pattern | awk -F = '{print $NF}'`
> +ulimit_c=`ulimit -c`
> +sysctl -w kernel.core_pattern=core &>/dev/null
> +ulimit -c 0
> +
>  # Set the FSIZE ulimit to 100MB and check
>  ulimit -f 102400
>  flim=`ulimit -f`
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
