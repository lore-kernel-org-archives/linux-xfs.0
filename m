Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51260 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbdAQC5d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 21:57:33 -0500
Date: Mon, 16 Jan 2017 21:56:07 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Message-ID: <20170117025607.frrcdbduthhutrzj@thunk.org>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141107.23953-9-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170106141107.23953-9-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>

On Fri, Jan 06, 2017 at 03:11:07PM +0100, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> This reverts commit 216553c4b7f3e3e2beb4981cddca9b2027523928. Now that
> the transaction context uses memalloc_nofs_save and all allocations
> within the this context inherit GFP_NOFS automatically, there is no
> reason to mark specific allocations explicitly.
> 
> This patch should not introduce any functional change. The main point
> of this change is to reduce explicit GFP_NOFS usage inside ext4 code
> to make the review of the remaining usage easier.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Changes in the jbd2 layer aren't going to guarantee that
memalloc_nofs_save() will be executed if we are running ext4 without a
journal (aka in no journal mode).  And this is a *very* common
configuration; it's how ext4 is used inside Google in our production
servers.

So that means the earlier patches will probably need to be changed so
the nOFS scope is done in the ext4_journal_{start,stop} functions in
fs/ext4/ext4_jbd2.c.

					- Ted
