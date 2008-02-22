Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 10:03:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1MI3ALF010422
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 10:03:14 -0800
Message-ID: <47BF0859.6020707@sandeen.net>
Date: Fri, 22 Feb 2008 11:37:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [REVIEW] Add lazy-counter conversion to xfs_repair
References: <op.t6wyesz53jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.t6wyesz53jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> In response to the thread "Differences in mkfs.xfs and xfs_info output.",  
> xfs_repair has been improved to allow version changes/conversion of  
> filesystems.
> 
> So, this patch introduces the first in an ongoing series of in-place  
> filesystem version changes with xfs_repair and the "-c" (convert) option.
> 
> To turn on/off the lazy-superblock feature, run the following xfs_repair  
> commmand on your filesystem:
> 
> # xfs_repair -c lazycount=[0|1] <device>

How about adding this to xfs_admin as well, since some flag changes are
already in there?

i.e. xfs_admin -<something... l and L are taken> could invoke xfs_repair
-c lazycount ...?

It just strikes me as a tad confusing that to change v2 logs or
unwritten extent support, you use xfs_admin, and to change lazy sb
counters, you must run repair...

(I understand that repair must be run post-change, but a common tool to
invoke all feature changes seems good to me)

-Eric
