Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED75C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jan 2022 21:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343778AbiAJVIf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:08:35 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44987 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343788AbiAJVIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jan 2022 16:08:35 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 13B7662C0DB;
        Tue, 11 Jan 2022 08:08:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1n71u3-00DkQ4-8B; Tue, 11 Jan 2022 08:08:31 +1100
Date:   Tue, 11 Jan 2022 08:08:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: kill the XFS_IOC_{ALLOC,FREE}SP* ioctls
Message-ID: <20220110210831.GZ945095@dread.disaster.area>
References: <20220110174827.GW656707@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110174827.GW656707@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=61dca051
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=VwQbUJbxAAAA:8 a=Oh2cFVv5AAAA:8
        a=7-415B0cAAAA:8 a=C6iWn-t2eLV4mpphddYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=7KeoIwV6GZqOttXkcoxL:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 09:48:27AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> According to Dave lore, these ioctls originated in the early 1990s in
> Irix EFS as a (somewhat clunky) way to preallocate space at the end of a
> file.

Heh. "Dave lore".

Better reference - glibc Irix v4 compatibility header file from
1997:

https://chromium.googlesource.com/chromiumos/third_party/glibc-ports/+/master/sysdeps/unix/sysv/irix4/bits/fcntl.h

What it tells us is that fcntl(F_ALLOCSP) was supported on Irix 4.0
and the release dates for Irix 4 were 09/91 to 04/93. So there's the
"for EFS in the early 1990s" date in a more concrete form...

XFS was first released 18 months later in Irix 5.3 in December
1994....

> Irix XFS, naturally, picked up these ioctls to maintain
> compatibility, which meant that they were ported to Linux in the early
> 2000s.
> 
> Recently it was pointed out to me they still lurk in the kernel, even
> though the Linux fallocate syscall supplanted the functionality a long
> time ago.  fstests doesn't seem to include any real functional or stress
> tests for these ioctls, which means that the code quality is ... very
> questionable.  Most notably, it was a stale disk block exposure vector
> for 21 years and nobody noticed or complained.  As mature programmers
> say, "If you're not testing it, it's broken."
> 
> Given all that, let's withdraw these ioctls from the XFS userspace API.
> Normally we'd set a long deprecation process, but I estimate that there
> aren't any real users, so let's trigger a warning in dmesg and return
> -ENOTTY.

*nod*

> @@ -1965,13 +1884,10 @@ xfs_file_ioctl(
>  	case XFS_IOC_ALLOCSP:
>  	case XFS_IOC_FREESP:
>  	case XFS_IOC_ALLOCSP64:
> -	case XFS_IOC_FREESP64: {
> -		xfs_flock64_t		bf;
> -
> -		if (copy_from_user(&bf, arg, sizeof(bf)))
> -			return -EFAULT;
> -		return xfs_ioc_space(filp, &bf);
> -	}
> +	case XFS_IOC_FREESP64:
> +		xfs_warn_once(mp,
> +	"dangerous XFS_IOC_{ALLOC,FREE}SP ioctls no longer supported");
> +		return -ENOTTY;

I wouldn't even say "dangerous", just that they are no longer
supported. I would dump the process name, too, so we can identify
what application (if any) is still using this, and maybe even append
"Use fallocate(2) instead."

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
