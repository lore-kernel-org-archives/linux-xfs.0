Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfGSVhm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jul 2019 17:37:42 -0400
Date: Fri, 19 Jul 2019 16:37:40 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Message-ID: <20190719213740.GA31263@redhat.com>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
 <bug-204049-201763-eo3Tgqh1ro@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-204049-201763-eo3Tgqh1ro@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 19, 2019 at 09:29:04PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=204049
> 
> --- Comment #5 from Luis Chamberlain (mcgrof@kernel.org) ---
> (In reply to Luis Chamberlain from comment #4)
> > The crash observed on stable kernels can be fixed with commit 6958d11f77
> > ("xfs: don't trip over uninitialized buffer on extent read of corrupted
> > inode") merged on v5.1.
> > 
> > I can't reproduce the immediate panic on v5.1 with the
> > "xfs_reflink_normapbt" anymore, as such I believe this seems like a
> > regression, and you should be able to bisect to v5.1 as the good kernel.
> 
> Correction, it just took longer to crash. Same crash as in kz#204223 [0] on
> v5.1. That issue is still not fixed.

In my experience,
many iterations of g/388 will definitely ferret out elusive failures.
It's sometimes tough to distinguish between real problems and abheritions.

-Bill


> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204223
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
