Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdAQR3g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jan 2017 12:29:36 -0500
Date: Tue, 17 Jan 2017 18:29:25 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Message-ID: <20170117172925.GA2486@quack2.suse.cz>
References: <20170106141107.23953-1-mhocko@kernel.org>
 <20170106141107.23953-9-mhocko@kernel.org>
 <20170117025607.frrcdbduthhutrzj@thunk.org>
 <20170117082425.GD19699@dhcp22.suse.cz>
 <20170117151817.GR19699@dhcp22.suse.cz>
 <20170117155916.dcizr65bwa6behe7@thunk.org>
 <20170117161618.GT19699@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170117161618.GT19699@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Tue 17-01-17 17:16:19, Michal Hocko wrote:
> > > But before going to play with that I am really wondering whether we need
> > > all this with no journal at all. AFAIU what Jack told me it is the
> > > journal lock(s) which is the biggest problem from the reclaim recursion
> > > point of view. What would cause a deadlock in no journal mode?
> > 
> > We still have the original problem for why we need GFP_NOFS even in
> > ext2.  If we are in a writeback path, and we need to allocate memory,
> > we don't want to recurse back into the file system's writeback path.
> 
> But we do not enter the writeback path from the direct reclaim. Or do
> you mean something other than pageout()'s mapping->a_ops->writepage?
> There is only try_to_release_page where we get back to the filesystems
> but I do not see any NOFS protection in ext4_releasepage.

Maybe to expand a bit: These days, direct reclaim can call ->releasepage()
callback, ->evict_inode() callback (and only for inodes with i_nlink > 0),
shrinkers. That's it. So the recursion possibilities are rather more limited
than they used to be several years ago and we likely do not need as much
GFP_NOFS protection as we used to.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
