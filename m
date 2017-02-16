Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752859AbdBPHmg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Feb 2017 02:42:36 -0500
Date: Thu, 16 Feb 2017 15:42:34 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/5] xfs: quota deadlock fixes
Message-ID: <20170216074234.GV24562@eguan.usersys.redhat.com>
References: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487173247-5965-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, Feb 15, 2017 at 10:40:42AM -0500, Brian Foster wrote:
> Hi all,
> 
> This is a collection of several quota related deadlock fixes for
> problems that have been reported to the list recently.
> 
> Patch 1 fixes the low memory quotacheck problem reported by Martin[1].
> Dave is CC'd as he had comments on this particular thread that started a
> discussion, but I hadn't heard anything back since my last response.
> 
> Patch 2 fixes a separate problem I ran into while attempting to
> reproduce Eryu's xfs/305 hang report[2]. 
> 
> Patches 3-5 fix the actual problem reported by Eryu, which is a quotaoff
> deadlock reproduced by xfs/305.
> 
> Further details are included in the individual commit log descriptions.
> Thoughts, reviews, flames appreciated.
> 
> Eryu,
> 
> I've run several hundred iterations of this on your reproducer system
> without reproducing the hang. I have reproduced a reset overnight but
> still haven't been able to grab a stack trace from that occurrence (I'll
> try again today/tonight with better console logging). I suspect this is
> a separate problem (possibly just an ASSERT() failure as this is a DEBUG
> kernel), but I'd appreciate any testing you can run against these
> patches to verify.

Sure, I'll give them a test and report back once I got results. Thanks
for looking into it!

Eryu

> 
> Brian
> 
> [1] http://www.spinics.net/lists/linux-xfs/msg01901.html
> [2] http://www.spinics.net/lists/linux-xfs/msg03835.html
> 
> Brian Foster (5):
>   xfs: bypass dquot reclaim to avoid quotacheck deadlock
>   xfs: allocate quotaoff transactions up front to avoid log deadlock
>   xfs: support ability to wait on new inodes
>   xfs: update ag iterator to support wait on new inodes
>   xfs: wait on new inodes during quotaoff dquot release
> 
>  fs/xfs/xfs_icache.c      | 58 ++++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_icache.h      |  8 +++++++
>  fs/xfs/xfs_inode.h       |  4 +++-
>  fs/xfs/xfs_qm.c          | 11 +++++++++
>  fs/xfs/xfs_qm.h          |  1 +
>  fs/xfs/xfs_qm_syscalls.c | 45 +++++++++++++++++++++----------------
>  6 files changed, 98 insertions(+), 29 deletions(-)
> 
> -- 
> 2.7.4
> 
