Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:04:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q44VQh004946
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:04:31 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 773FA1AF2E9A
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:06:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 3LrjMV0K7xgmu6Oj for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:06:06 -0700 (PDT)
Message-ID: <48DC5FAD.2070409@sandeen.net>
Date: Thu, 25 Sep 2008 23:06:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Show pointer address for mem dump with corruption error
References: <op.uh2jplxz3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.uh2jplxz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> When XFS detects corruption, it prints a message and a small hex dump
> of the offending code.
> 
> The first value in this hexdump currently is "0000000:" which is just
> the offset into the pointer being passed to print_hex_dump().
> 
> The following patch changes this to display the address of the memory
> dump:
> 
> --- a/fs/xfs/support/debug.c    2008-09-26 13:15:02.000000000 +1000
> +++ b/fs/xfs/support/debug.c    2008-09-26 12:53:50.765134441 +1000
> @@ -84,5 +84,5 @@ assfail(char *expr, char *file, int line
>   void
>   xfs_hex_dump(void *p, int length)
>   {
> -       print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p,  
> length, 1);
> +       print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p,  
> length, 1);
>   }
> 
> 

Looks fine (and a fine idea) to me :)

-Eric
