Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20118 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdJCRQL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 13:16:11 -0400
Date: Tue, 3 Oct 2017 10:16:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [GIT PULL] xfsprogs: mkfs refactor
Message-ID: <20171003171604.GC6503@magnolia>
References: <20171003080607.GM15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003080607.GM15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 07:06:07PM +1100, Dave Chinner wrote:
> Hi Eric,
> 
> I've put the latest mkfs refactor code that I have up in place
> you can pull it from. I've rebased it against the current for-next
> tree (4.13.1 release) and fixed all the problems that xfstests
> exposes. The only thing I haven't fixed is xfs/191 that does mkfs
> command line behaviour verification because the refactored version
> fixes several problems that the old mkfs didn't handle correctly
> (e.g. being able to specify certain things like agsize in blocks or
> sectors).
> 
> There's a small filter patch needed for xfstests that I'll post in
> a reply to this pull request that will filter out the new "defaults
> sourced from ..." output and so prevent spurious xfstests failures.
> 
> If you want I can tag the branch with a signed tag for you to pull
> from (same process as Linus prefers) rather than just a branch in a
> tree. If you'd prefer that I post this as patches instead, then let
> me know and I'll bomb the list instead.

I had a look at mkfs-refactor.  It looks ok to me (I defer to Eric on
the question of pull req. vs. patchbomb) though I have one question:

calculate_log_size calls max_trans_res, and max_trans_res assembles a
fake struct xfs_mount in order to call libxfs_log_calc_minimum_size.
I've fixed a few mkfs bugs over the past couple of years that all stem
from us forgetting to propagate superblock settings from the
configuration we're building in main() into the fake xfs_mount->m_sb
that we use to calculate the minimum log size, which results in a
disagreement between the kernel and mkfs as to what is the minimum log
size for a given fs configuration.  This disagreement pops up in the
form of a freshly mkfs'd 500MB filesystem immediately failing to mount.

With this branch applied it looks like we've nearly finished filling out
the real xfs_mount->m_sb when we call calculate_log_size, so could we
refactor setup_superblock to set all the non-log superblock fields in
the real m_sb and then pass that directly into max_trans_res so that we
can memcpy the real superblock settings into the fake struct xfs_mount?

Doing that will eliminate a whole class of "we forgot that we have to
set sb_newfield in setup_superblock /and/ in max_trans_res and now mkfs
creates broken filesystems" bugs.  Even now there are small
discrepancies between (for example) tr_itruncate.tr_logres in the kernel
and in mkfs, which make me nervous.  AFAICT the discrepancies result in
mkfs using a minimum log size that is larger than what the kernel
calculates, so there's no user-visible badness.

--D

> 
> Cheers,
> 
> Dave.
> 
> The following changes since commit d4a36331dc383c7c7747e244b3ae20155ae92c98:
> 
>   xfsprogs: Release v4.13.1 (2017-09-26 20:45:05 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsprogs-dev mkfs-refactor
> 
> for you to fetch changes up to a4bc6d3c7bb5babc51f7341039dafcff5fcc6c7e:
> 
>   mkfs: tidy up definitions (2017-09-29 08:44:30 +1000)
> 
> ----------------------------------------------------------------
> Dave Chinner (42):
>       mkfs: can't specify sector size of internal log
>       mkfs: make subopt table const
>       mkfs: introduce a structure to hold CLI options
>       mkfs: add generic subopt parsing table
>       mkfs: factor block subopts parser
>       mkfs: factor data subopts parser
>       mkfs: factor inode subopts parser
>       mkfs: factor log subopts parser
>       mkfs: factor meta subopts parser
>       mkfs: factor naming subopts parser
>       mkfs: factor rt subopts parser
>       mkfs: factor sector subopts parser
>       mkfs: Introduce mkfs configuration structure
>       mkfs: factor printing of mkfs config
>       mkfs: factor in memory superblock setup
>       mkfs: factor out device preparation
>       mkfs: factor writing AG headers
>       mkfs: factor secondary superblock updates
>       mkfs: introduce default configuration structure
>       mkfs: rename top level CLI parameters
>       mkfs: factor sectorsize validation
>       mkfs: factor blocksize validation
>       mkfs: factor log sector size validation
>       mkfs: factor superblock feature validation
>       mkfs: factor directory blocksize validation
>       mkfs: factor inode size validation
>       mkfs: factor out device size calculations
>       mkfs: fix hidden parameter in DTOBT()
>       mkfs: factor rtdev extent size validation
>       mkfs: rework stripe calculations
>       mkfs: factor device opening
>       mkfs: factor data device validation
>       mkfs: factor log device validation
>       mkfs: factor rt device validation
>       mkfs: factor AG geometry calculations
>       mkfs: factor AG alignment
>       mkfs: rework imaxpct calculation
>       mkfs: factor initial mount setup
>       mkfs: factor log size calculations
>       mkfs: cleanup redundant temporary code
>       mkfs: move error functions
>       mkfs: tidy up definitions
> 
>  include/libxfs.h |    2 +-
>  mkfs/xfs_mkfs.c  | 4645 ++++++++++++++++++++++++++++++------------------------
>  2 files changed, 2602 insertions(+), 2045 deletions(-)
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
