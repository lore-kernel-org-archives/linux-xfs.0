Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 20:23:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P3NC88021145
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 20:23:14 -0700
Message-ID: <47E8703C.30603@sgi.com>
Date: Tue, 25 Mar 2008 14:23:40 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net>
In-Reply-To: <47E5CFBA.7060405@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Thanks, Eric.

On IRIX:
 > where xfsdump xfsrestore xfsinvutil
/sbin/xfsdump
/usr/sbin/xfsdump
/sbin/xfsrestore
/usr/sbin/xfsinvutil
 > ls -l /sbin/xfsdump
lrwxr-xr-x    ... /sbin/xfsdump -> ../usr/sbin/xfsdump*

I'll add the IRIX xfsrestore path and wait for Russell or
whoever to complain about BSD :)

--Tim

Eric Sandeen wrote:
> it may not always be obvious to outsiders that xfsdump is packaged
> separately from xfsprogs... is it worth checking for the binaries
> rather than spewing verbose failures if it's not installed?
> 
> (and are the locations ok for irix/bsd/whatnot too...?)
> 
> ... also abort if bc not found (common.filter requires this,
> my minimal testing root didn't have it and much error spew
> ensued... nicer to check up front IMHO)
> 
> -Eric
> 
> Index: xfstests/common.dump
> ===================================================================
> --- xfstests.orig/common.dump
> +++ xfstests/common.dump
> @@ -41,6 +41,10 @@ do_quota_check=true # do quota check if 
>  
>  _need_to_be_root
>  
> +[ -x /usr/sbin/xfsdump ] || _notrun "xfsdump executable not found"
> +[ -x /usr/sbin/xfsrestore ] || _notrun "xfsrestore executable not found"
> +[ -x /usr/sbin/xfsinvutil ] || _notrun "xfsinvutil executable not found"
> +
>  # install our cleaner
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> Index: xfstests/common.config
> ===================================================================
> --- xfstests.orig/common.config
> +++ xfstests/common.config
> @@ -114,6 +114,9 @@ export AWK_PROG="`set_prog_path awk`"
>  export SED_PROG="`set_prog_path sed`"
>  [ "$SED_PROG" = "" ] && _fatal "sed not found"
>  
> +export BC_PROG="`set_prog_path bc`"
> +[ "$BC_PROG" = "" ] && _fatal "bc not found"
> +
>  export PS_ALL_FLAGS="-ef"
>  
>  export DF_PROG="`set_prog_path df`"
> 
> 
