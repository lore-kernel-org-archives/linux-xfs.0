Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbeEWDhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 23:37:15 -0400
Subject: Re: [PATCH V2] xfsprogs: be careful about what we stat in
 platform_check_mount
References: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
 <998e7209-d700-5006-a2a0-e4c37ef0c024@sandeen.net>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <a909876b-3fd4-495a-3731-0f11411fe773@oracle.com>
Date: Tue, 22 May 2018 20:37:05 -0700
MIME-Version: 1.0
In-Reply-To: <998e7209-d700-5006-a2a0-e4c37ef0c024@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

Looks ok to me.  You can add my review.

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

Thanks!

On 05/22/2018 02:58 PM, Eric Sandeen wrote:
> After we lost ustat(2) in commit 4e7a824, we ended up with a slightly
> bonkers method to determine if our target block device was mounted:
> it goes through every entry returned by getmntent and stats the dir
> to see if its underlying device matches ours.
> 
> Unfortunately that dir might be a hung nfs server and sadness ensues.
> 
> So just do a really simple sanity check before we try to stat the
> mountpoint: does its device start with a / ?  If not, skip it.
> 
> Fixes: 4e7a824 ("libxfs/linux.c: Replace use of ustat by stat")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: just look for fully-qualified device paths vs expecting an actual
> block device.
> 
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index 0bace3e..5c8602e 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -77,7 +77,17 @@ platform_check_mount(char *name, char *block, struct 
> stat *s, int flags)
>               progname, name);
>           return 1;
>       }
> +    /*
> +     * This whole business is to work out if our block device is mounted
> +     * after we lost ustat(2), see:
> +     *     4e7a824 libxfs/linux.c: Replace use of ustat by stat
> +     * We don't really want to stat every single mounted directory,
> +     * as that may include tmpfs, cgroups, procfs or - worst - hung nfs
> +     * servers.  So first, a simple check: does the "dev" start with "/" ?
> +     */
>       while ((mnt = getmntent(f)) != NULL) {
> +        if (mnt->mnt_fsname[0] != '/')
> +            continue;
>           if (stat(mnt->mnt_dir, &mst) < 0)
>               continue;
>           if (mst.st_dev != s->st_rdev)
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  
> https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=R6pqMHln20gGSsVL6glkacPVahf-7ntcy9uginrHVqU&s=svjEUGJ89ba2TeolXCPU9AjtORnBzV-56WGzef1Q6X0&e= 
> 
