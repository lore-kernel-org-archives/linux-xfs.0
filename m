Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45262 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdBOFw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Feb 2017 00:52:58 -0500
Date: Tue, 14 Feb 2017 21:52:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 0/4] buffered write and indlen fixes
Message-ID: <20170215055251.GE6813@birch.djwong.org>
References: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2017 at 08:03:05AM -0500, Brian Foster wrote:
> This is just a small update to rebase onto for-next with all previous
> debug artifacts removed. No code changes.
> 
> Brian
> 
> v3:
> - Rebase to a clean for-next branch.

/me sorted out the merge wonkiness by hand, looks like it's testing ok.

Looks good, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

[queued for 4.11]

--D

> v2: http://www.spinics.net/lists/linux-xfs/msg04215.html
> - Use do_div() to fix 32-bit builds.
> - Prepend patches 1-2 to re-enable indlen testing from xfstests.
> v1: http://www.spinics.net/lists/linux-xfs/msg04083.html
> 
> Brian Foster (4):
>   xfs: clear delalloc and cache on buffered write failure
>   xfs: resurrect debug mode drop buffered writes mechanism
>   xfs: handle indlen shortage on delalloc extent merge
>   xfs: split indlen reservations fairly when under reserved
> 
>  fs/xfs/libxfs/xfs_bmap.c | 70 +++++++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_iomap.c       |  9 +++++++
>  fs/xfs/xfs_mount.h       | 15 ++++++-----
>  fs/xfs/xfs_sysfs.c       | 14 +++++-----
>  4 files changed, 73 insertions(+), 35 deletions(-)
> 
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
