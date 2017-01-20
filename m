Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdATFcd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Jan 2017 00:32:33 -0500
Date: Fri, 20 Jan 2017 13:25:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 0/3] xfs: test malformed inode mode
Message-ID: <20170120052550.GV1859@eguan.usersys.redhat.com>
References: <1483968625-29160-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483968625-29160-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Hi,

On Mon, Jan 09, 2017 at 03:30:22PM +0200, Amir Goldstein wrote:
> Eryu,
> 
> This is the 3rd revision of the malformed inode mode test.
> 
> Like with v2, patch 1 is safe and it passes on kernel 4.9.
> 
> Like with v2, patch 2 is safe, but unlike v2, it fails on
> kernel 4.9, because I added a stronger expectation for the
> test to fails on stat of directory with inode size 0.
> 
> Like with v2, patch 3 triggers an XFS assert and I removed
> the "safety pin" that was there in v2.
> 
> I already sent the fix patch to Darick, which addresses the
> failures in both patch 2 and 3.
> 
> You could merge patch 1 now and defer merging patches 2-3
> or you could wait with merging the entire test. up to you.

I'll merge patch 2-3 in this week update, Darrick has sent the fixes to
Linus, hopefully they'll be in rc5 next week.

Thanks,
Eryu
