Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41694 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933177AbdGSPeB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Jul 2017 11:34:01 -0400
Subject: Re: XFS group quota incorrectly "inherits" its hard limit from user 0
References: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b70d94df-9d0a-ae0d-58ac-7d15c73695bd@sandeen.net>
Date: Wed, 19 Jul 2017 10:34:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAH4CUCPgFnm0s07uEU3ke6V8cPtSvQxMLo60nemuuqGygmZRhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yaron Presente <yaron@zadarastorage.com>, linux-xfs@vger.kernel.org



On 07/18/2017 04:51 PM, Yaron Presente wrote:
> Hi,
> I'm running a Linux system with kernel version 3.18.19.

Quite an old kernel.  You're missing this upstream fix/change:

commit be6079461abf796e29d02b450a16908f4bf58f6c
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Mon Feb 8 11:27:55 2016 +1100

    xfs: Split default quota limits by quota type
    
    Default quotas are globally set due historical reasons. IRIX only
    supported user and project quotas, and default quota was only
    applied to user quotas.
    
    In Linux, when a default quota is set, all different quota types
    inherits the same default value.
    
    An user with a quota limit larger than the default quota value, will
    still be limited to the default value because the group quotas also
    inherits the default quotas. Unless the group which the user belongs
    to have a custom quota limit set.
    
    This patch aims to split the default quota value by quota type.
    Allowing each quota type having different default values.
    
    Default time limits are still set globally. XFS does not set a
    per-user/group timer, but a single global timer. For changing this
    behavior, some changes should be made in user-space tools another
    bugs being fixed.
    
    Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-Eric

> While experimenting with groups quota, I did the following steps:
> 
> 1. Mounted XFS with both users and groups quota enabled
> 2. Set user 0 (aka the SuperUser) hard limit to 800000 . I believe
> that this has the same affect as using xfs_quota limit command with
> "-d" (i.e. setting the default hard limit for users which don't have
> their hard limit set explicitly)
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
