Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 06:54:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GDsFj5008815
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:54:16 -0700
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B8FF1412239
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:55:58 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.188]) by cuda.sgi.com with ESMTP id PA5SAasLnIhKEiTt for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 06:55:58 -0700 (PDT)
Message-ID: <48F747E5.3090007@gmx.net>
Date: Thu, 16 Oct 2008 15:55:49 +0200
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu>
In-Reply-To: <20081016134112.GA8773@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Jianjun Kong schrieb:
> On Thu, Oct 16, 2008 at 11:29:26AM +1100, Tim Shimmin wrote:
>> Resending as I mangled sending the mail from home last time. Sorry.
>>
>> Please include the following patch for 2.6.27.1 stable release as
>> suggested by Christoph Hellwig and Eric Sandeen.
>> It fixes a regression in the recent remount recoding
>> where remounting say from ro to rw allows the xfs flags to
>> be out of sync with the vfs flags, resulting
>> in failures for some programs such as touch (which end up calling xfs_setattr).
>> The fix is a very minor and clear.
>>
>> Thanks,
>> Tim.
>>
>> Date: Sun, 12 Oct 2008 14:30:44 +0200
>> From: Christoph Hellwig <hch@lst.de>
>> To: xfs@oss.sgi.com
>> Subject: [PATCH] fix remount rw with unrecognized options
>>
>> When we skip unrecognized options in xfs_fs_remount we should just break
>> out of the switch and not return because otherwise we may skip clearing
>> the xfs-internal read-only flag.  This will only show up on some
>> operations like touch because most read-only checks are done by the VFS
>> which thinks this filesystem is r/w.  Eventually we should replace the
>> XFS read-only flag with a helper that always checks the VFS flag to make
>> sure they can never get out of sync.
>>
>> Bug reported and fix verified by Marcel Beister on #xfs.
>> Bug fix verified by updated xfstests/189.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Acked-by: Eric Sandeen <sandeen@sandeen.net>
>> Signed-off-by: Timothy Shimmin <tes@sgi.com>
>>
>> Index: mainline/fs/xfs/linux-2.6/xfs_super.c
>> ===================================================================
>> --- mainline.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:26.542652847 +1100
>> +++ mainline/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:45.376217172 +1100
>> @@ -1323,7 +1323,7 @@ xfs_fs_remount(
>> 	"XFS: mount option \"%s\" not supported for remount\n", p);
>> 			return -EINVAL;
>> #else
>> -			return 0;
>> +			break;
>> #endif
>> 		}
>> 	}
> 
> 
> And the code above "return 0" can not be executed, so delete them.
> __________________________________________
> #if 0
>                         printk(KERN_INFO
>         "XFS: mount option \"%s\" not supported for remount\n", p);
>                         return -EINVAL;
> #else                                                                                                            
>                         return 0;
> -----------------------------------------
> 
> 
> Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index e390136..bd5ec81 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1318,12 +1318,7 @@ xfs_fs_remount(
>  			 * every remount request, and silently ignore all
>  			 * options that we can't actually change.
>  			 */
> -#if 0
> -			printk(KERN_INFO
> -	"XFS: mount option \"%s\" not supported for remount\n", p);
> -			return -EINVAL;
> -#else
> -			break;
> +			break 0;
>  #endif
>  		}
>  	}
I see my compilers error message '"#endif" without corresponding "#if"'
and i think he'll also dislike the 'break 0;' ... 'missing ";" before
"0" in line xxx' ;-).

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
 X        AGAINST HTML MAIL
/ \
