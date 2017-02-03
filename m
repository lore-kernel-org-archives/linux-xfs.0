Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38015 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbdBCPno (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 10:43:44 -0500
Date: Fri, 3 Feb 2017 16:32:22 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 8/8] Revert "ext4: fix wrong gfp type under transaction"
Message-ID: <20170203153222.GH19325@dhcp22.suse.cz>
References: <20170117161618.GT19699@dhcp22.suse.cz>
 <20170117172925.GA2486@quack2.suse.cz>
 <20170119083956.GE30786@dhcp22.suse.cz>
 <20170119092236.GC2565@quack2.suse.cz>
 <20170119094405.GK30786@dhcp22.suse.cz>
 <20170126074455.GC8456@dhcp22.suse.cz>
 <20170127061318.xd2qxashbl4dajez@thunk.org>
 <20170127093735.GB4143@dhcp22.suse.cz>
 <20170127164042.2o3bnyopihcb224g@thunk.org>
 <20170130081210.GD8443@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130081210.GD8443@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, djwong@kernel.org, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Mon 30-01-17 09:12:10, Michal Hocko wrote:
> On Fri 27-01-17 11:40:42, Theodore Ts'o wrote:
> > On Fri, Jan 27, 2017 at 10:37:35AM +0100, Michal Hocko wrote:
> > > If this ever turn out to be a problem and with the vmapped stacks we
> > > have good chances to get a proper stack traces on a potential overflow
> > > we can add the scope API around the problematic code path with the
> > > explanation why it is needed.
> > 
> > Yeah, or maybe we can automate it?  Can the reclaim code check how
> > much stack space is left and do the right thing automatically?
> 
> I am not sure how to do that. Checking for some magic value sounds quite
> fragile to me. It also sounds a bit strange to focus only on the reclaim
> while other code paths might suffer from the same problem.
> 
> What is actually the deepest possible call chain from the slab reclaim
> where I stopped? I have tried to follow that path but hit the callback
> wall quite early.
>  
> > The reason why I'm nervous is that nojournal mode is not a common
> > configuration, and "wait until production systems start failing" is
> > not a strategy that I or many SRE-types find.... comforting.
> 
> I understand that but I would be much more happier if we did the
> decision based on the actual data rather than a fear something would
> break down.

ping on this. I would really like to move forward here and target 4.11
merge window. Is your concern so serious to block this patch?
-- 
Michal Hocko
SUSE Labs
