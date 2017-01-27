Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57984 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753841AbdA0GNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 01:13:42 -0500
Date: Fri, 27 Jan 2017 01:13:18 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Message-ID: <20170127061318.xd2qxashbl4dajez@thunk.org>
References: <20170117025607.frrcdbduthhutrzj@thunk.org>
 <20170117082425.GD19699@dhcp22.suse.cz>
 <20170117151817.GR19699@dhcp22.suse.cz>
 <20170117155916.dcizr65bwa6behe7@thunk.org>
 <20170117161618.GT19699@dhcp22.suse.cz>
 <20170117172925.GA2486@quack2.suse.cz>
 <20170119083956.GE30786@dhcp22.suse.cz>
 <20170119092236.GC2565@quack2.suse.cz>
 <20170119094405.GK30786@dhcp22.suse.cz>
 <20170126074455.GC8456@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170126074455.GC8456@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Thu, Jan 26, 2017 at 08:44:55AM +0100, Michal Hocko wrote:
> > > I'm convinced the current series is OK, only real life will tell us whether
> > > we missed something or not ;)
> > 
> > I would like to extend the changelog of "jbd2: mark the transaction
> > context with the scope GFP_NOFS context".
> > 
> > "
> > Please note that setups without journal do not suffer from potential
> > recursion problems and so they do not need the scope protection because
> > neither ->releasepage nor ->evict_inode (which are the only fs entry
> > points from the direct reclaim) can reenter a locked context which is
> > doing the allocation currently.
> > "
> 
> Could you comment on this Ted, please?

I guess....   so there still is one way this could screw us, and it's this reason for GFP_NOFS:

        - to prevent from stack overflows during the reclaim because
	          the allocation is performed from a deep context already

The writepages call stack can be pretty deep.  (Especially if we're
using ext4 in no journal mode over, say, iSCSI.)

How much stack space can get consumed by a reclaim?

						- Ted
    		 
