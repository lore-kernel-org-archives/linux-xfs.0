Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 07:06:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9GE68gO009894
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 07:06:08 -0700
Received: from z.billxu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B51BA9CB84
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 07:07:50 -0700 (PDT)
Received: from z.billxu.com (smtp.zeuux.org [210.51.160.52]) by cuda.sgi.com with ESMTP id kVXBYx72hStGFM7G for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 07:07:50 -0700 (PDT)
Date: Thu, 16 Oct 2008 22:07:44 +0800
From: Jianjun Kong <jianjun@zeuux.org>
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016140744.GA10412@ubuntu>
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu> <48F747E5.3090007@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F747E5.3090007@gmx.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Klaus Strebel <klaus.strebel@gmx.net>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 16, 2008 at 03:55:49PM +0200, Klaus Strebel wrote:
>Jianjun Kong schrieb:
>> On Thu, Oct 16, 2008 at 11:29:26AM +1100, Tim Shimmin wrote:
>>> Resending as I mangled sending the mail from home last time. Sorry.
>>>
>>> Please include the following patch for 2.6.27.1 stable release as
>>> suggested by Christoph Hellwig and Eric Sandeen.
>>> It fixes a regression in the recent remount recoding
>>> where remounting say from ro to rw allows the xfs flags to
>>> be out of sync with the vfs flags, resulting
>>> in failures for some programs such as touch (which end up calling xfs_setattr).
>>> The fix is a very minor and clear.
>>>
>>> Thanks,
>>> Tim.
>>>
>>> Date: Sun, 12 Oct 2008 14:30:44 +0200
>>> From: Christoph Hellwig <hch@lst.de>
>>> To: xfs@oss.sgi.com
>>> Subject: [PATCH] fix remount rw with unrecognized options
>>>
>>> When we skip unrecognized options in xfs_fs_remount we should just break
>>> out of the switch and not return because otherwise we may skip clearing
>>> the xfs-internal read-only flag.  This will only show up on some
>>> operations like touch because most read-only checks are done by the VFS
>>> which thinks this filesystem is r/w.  Eventually we should replace the
>>> XFS read-only flag with a helper that always checks the VFS flag to make
>>> sure they can never get out of sync.
>>>
>>> Bug reported and fix verified by Marcel Beister on #xfs.
>>> Bug fix verified by updated xfstests/189.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> Acked-by: Eric Sandeen <sandeen@sandeen.net>
>>> Signed-off-by: Timothy Shimmin <tes@sgi.com>
>>>
>>> Index: mainline/fs/xfs/linux-2.6/xfs_super.c
>>> ===================================================================
>>> --- mainline.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:26.542652847 +1100
>>> +++ mainline/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:45.376217172 +1100
>>> @@ -1323,7 +1323,7 @@ xfs_fs_remount(
>>> 	"XFS: mount option \"%s\" not supported for remount\n", p);
>>> 			return -EINVAL;
>>> #else
>>> -			return 0;
>>> +			break;
>>> #endif

<....>
>> Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
>> ---
>>  fs/xfs/linux-2.6/xfs_super.c |    7 +------
>>  1 files changed, 1 insertions(+), 6 deletions(-)
>> 
>> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
>> index e390136..bd5ec81 100644
>> --- a/fs/xfs/linux-2.6/xfs_super.c
>> +++ b/fs/xfs/linux-2.6/xfs_super.c
>> @@ -1318,12 +1318,7 @@ xfs_fs_remount(
>>  			 * every remount request, and silently ignore all
>>  			 * options that we can't actually change.
>>  			 */
>> -#if 0
>> -			printk(KERN_INFO
>> -	"XFS: mount option \"%s\" not supported for remount\n", p);
>> -			return -EINVAL;
>> -#else
>> -			break;
>> +			break 0;
>>  #endif
>>  		}
>>  	}
>I see my compilers error message '"#endif" without corresponding "#if"'
>and i think he'll also dislike the 'break 0;' ... 'missing ";" before
>"0" in line xxx' ;-).

Sorry. another one :)

Signed-off-by: Jianjun Kong <kongjianjun@gmail.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index e390136..c019f78 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1318,13 +1318,7 @@ xfs_fs_remount(
 			 * every remount request, and silently ignore all
 			 * options that we can't actually change.
 			 */
-#if 0
-			printk(KERN_INFO
-	"XFS: mount option \"%s\" not supported for remount\n", p);
-			return -EINVAL;
-#else
-			break;
-#endif
+			break ;
 		}
 	}
 
-- 
1.5.2.5



-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
