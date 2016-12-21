Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45241 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbcLUFxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2016 00:53:40 -0500
Date: Tue, 20 Dec 2016 21:53:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfsprogs: for-next branch updated to ebd6aa8
Message-ID: <20161221055335.GE5487@birch.djwong.org>
References: <e1862d0c-6e1d-66d0-bf35-5a8650a08cef@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1862d0c-6e1d-66d0-bf35-5a8650a08cef@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 20, 2016 at 11:33:39PM -0600, Eric Sandeen wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This is just a handful of targeted fixes prior to the 4.9.0
> release.  If you have something else that you think is absolutely
> critical, please let me know ASAP.

Was rather hoping "xfs_io: fix the minimum arguments to the reflink command"
would make it for 4.9, but obviously nobody cared enough to run into it and
complain other than /me... 8-)

Anyway I'll go test this.

--D

> 
> I'd appreciate some distributed testing.  If all goes well,
> the contents of the for-next branch will be the release this time,
> hopefully by the end of the week.
> 
> The new head of the for-next branch is commit:
> 
> ebd6aa8 xfs_quota: handle wrapped id from GETNEXTQUOTA
> 
> New Commits:
> 
> Darrick J. Wong (3):
>       [5ef80b9] xfs_repair: fix bogus rmapbt record owner check
>       [ff14f59] xfs_repair: fix some potential null pointer deferences
>       [f9cd7f8] xfs_repair: change null check to assertion
> 
> Eric Sandeen (3):
>       [f714016] xfs_repair: junk leaf attribute if count == 0
>       [8ebad4d] xfs_repair: don't indicate dirtiness if FSGEOMETRY fails
>       [ebd6aa8] xfs_quota: handle wrapped id from GETNEXTQUOTA
> 
> 
> Code Diffstat:
> 
>  quota/report.c       |  8 ++++++++
>  repair/attr_repair.c |  3 ++-
>  repair/phase5.c      | 16 +++++++++++-----
>  repair/rmap.c        |  2 +-
>  repair/scan.c        |  8 ++++++--
>  repair/slab.h        |  2 +-
>  repair/xfs_repair.c  |  2 +-
>  7 files changed, 30 insertions(+), 11 deletions(-)
> 
> 
> 



