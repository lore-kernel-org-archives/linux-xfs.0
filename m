Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:18347 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751963AbdGRW47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 18:56:59 -0400
Date: Wed, 19 Jul 2017 08:56:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS group quota incorrectly "inherits" its hard limit from user 0
Message-ID: <20170718225655.GO17762@dastard>
References: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yaron Presente <yaron@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 12:51:20AM +0300, Yaron Presente wrote:
> Hi,
> I'm running a Linux system with kernel version 3.18.19.
> While experimenting with groups quota, I did the following steps:
> 
> 1. Mounted XFS with both users and groups quota enabled
> 2. Set user 0 (aka the SuperUser) hard limit to 800000 . I believe
> that this has the same affect as using xfs_quota limit command with
> "-d" (i.e. setting the default hard limit for users which don't have
> their hard limit set explicitly)

What is the exact command you used to do this, what version of the
quota utils are you using, and what is the strace output of the
command?

-Dave.

> 3. Set user 2001117 hard limit to 1024000 (I set a different limit
> than user 0's on purpose, in order to show that the group hard limit
> was not inherited from this user, but from user 0)
> 4. Created a 1MB file that is owned by user 2001117 and group 2000514
> 5. Group 2000514 which previously didn't have any hard limit defined
> now "inherited" user 0 hard limit of 800000 .

> 
> See output of xfs_quota below.
> Thanks,
> Yaron
> 
> 
> Before creating the file:
> ==================
> 
> root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
> /export/share_3
> User quota on /export/share_3 (/dev/dm-28)
>                                Blocks
> User ID          Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> #0                  0               0      800000      00  [--------]
> #2001117       0               0     1024000     00 [--------]
> 
> Group quota on /export/share_3 (/dev/dm-28)
>                                Blocks
> Group ID         Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> #0                  0               0          0          00 [--------]
> 
> (group 2000514  is not listed since it does not have a hard limit and
> its quota is not used by any file)
> 
> After creating the file:
> ================
> 
> root@vsa-0000011e-vc-0:~# xfs_quota -x -c "report -L0 -U 2100000"
> /export/share_3
> User quota on /export/share_3 (/dev/dm-28)
>                                Blocks
> User ID          Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> #0                  0               0     800000      00  [--------]
> #2001117      1024         0    1024000     00 [--------]
> 
> Group quota on /export/share_3 (/dev/dm-28)
>                                Blocks
> Group ID         Used       Soft       Hard    Warn/Grace
> ---------- --------------------------------------------------
> #0                  0               0          0           00 [--------]
> #2000514      1024         0      800000     00 [--------]
>    <===   This is the problem. It's not clear where this hard limit
> came from
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Dave Chinner
david@fromorbit.com
