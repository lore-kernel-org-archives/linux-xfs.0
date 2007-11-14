Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 14:48:49 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEMmgvn009715
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 14:48:43 -0800
Date: Wed, 14 Nov 2007 23:48:46 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 2.6.24-rc2 XFS nfsd hang --- filldir change responsible?
In-Reply-To: <20071114114907.GA31466@puku.stupidest.org>
Message-ID: <alpine.DEB.0.99999.0711142340450.12443@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114114907.GA31466@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@panasas.com>

On Wed, 14 Nov 2007, Chris Wedgwood wrote:
> After some bisection pain (sg broken in the middle and XFS not
> compiling in other places) the regression seems to be:
>
>    commit 051e7cd44ab8f0f7c2958371485b4a1ff64a8d1b
>    Author: Christoph Hellwig <hch@infradead.org>
>    Date:   Tue Aug 28 13:58:24 2007 +1000

Following a git-bisect howto[0], I tried to revert this commit:

# git checkout master
# git revert 051e7cd44ab8f0f7c2958371485b4a1ff64a8d1b
Auto-merged fs/xfs/linux-2.6/xfs_file.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_file.c
Auto-merged fs/xfs/linux-2.6/xfs_vnode.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_vnode.h
Auto-merged fs/xfs/xfs_dir2.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_dir2.c
Auto-merged fs/xfs/xfs_dir2.h
Auto-merged fs/xfs/xfs_dir2_block.c
Auto-merged fs/xfs/xfs_dir2_sf.c
Auto-merged fs/xfs/xfs_vnodeops.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.c
Automatic revert failed.  After resolving the conflicts,
mark the corrected paths with 'git add <paths>' and commit the result.

Any ideas?

Christian

[0] is this still up-to-date? 
http://kernel.org/pub/software/scm/git/docs/v1.4.4.4/howto/isolate-bugs-with-bisect.txt
-- 
BOFH excuse #423:

It's not RFC-822 compliant.
