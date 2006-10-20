Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Oct 2006 03:35:03 -0700 (PDT)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9KAYpaG007499
	for <xfs@oss.sgi.com>; Fri, 20 Oct 2006 03:34:52 -0700
Message-ID: <4538A66F.8060300@sgi.com>
Date: Fri, 20 Oct 2006 11:35:27 +0100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_bmap -n fix
References: <200610200418.AA04613@TNESG9305.tnes.nec.co.jp>
In-Reply-To: <200610200418.AA04613@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

Hi Utako,

That's definitely a bug, thanks for the fix.

Lachlan

Utako Kusaka wrote:
> Hi,
> 
> This patch fixes the issue that
> "xfs_bmap -n [nnn]" doesn't work correctly.
> 
> Example：
> # xfs_io -c "bmap -n 3" test/file2
> test/file2:
>         0: [0..4849151]: 41943136..46792287
>         1: [4849152..51641343]: 46792768..93584959
>         2: [51641344..68418047]: 93585472..110362175
> # xfs_bmap -n 3 test/file2
> test/file2:
>         0: [0..4849151]: 41943136..46792287
>         1: [4849152..51641343]: 46792768..93584959
>         2: [51641344..98433535]: 93585472..140377663
>         3: [98433536..131987455]: 140378176..173932095
>         4: [131987456..145225727]: 173932104..187170375
>         5: [145225728..192017919]: 187170880..233963071
>         6: [192017920..209715199]: 233963584..251660863
> 
> Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
> ---
> 
> --- xfsprogs-2.8.11-orgn/io/xfs_bmap.sh 2006-06-26 14:01:15.000000000 +0900
> +++ xfsprogs-2.8.11/io/xfs_bmap.sh      2006-10-20 12:22:19.771009697 +0900
> @@ -14,7 +14,7 @@ do
>         a)      OPTS=$OPTS" -a";;
>         d)      OPTS=$OPTS" -d";;
>         l)      OPTS=$OPTS" -l";;
> -       n)      OPTS=$OPTS" '-n "$OPTARG"'";;
> +       n)      OPTS=$OPTS" -n "$OPTARG"";;
>         p)      OPTS=$OPTS" -p";;
>         v)      OPTS=$OPTS" -v";;
>         V)      VERSION=true;;
> 
> 
