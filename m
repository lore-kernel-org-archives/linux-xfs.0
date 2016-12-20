Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33063 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbcLTIiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2016 03:38:22 -0500
Date: Tue, 20 Dec 2016 09:38:18 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/9] xfs: introduce and use KM_NOLOCKDEP to silence
 reclaim lockdep false positives
Message-ID: <20161220083818.GB3769@dhcp22.suse.cz>
References: <20161215140715.12732-1-mhocko@kernel.org>
 <20161215140715.12732-3-mhocko@kernel.org>
 <20161219212413.GN4326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161219212413.GN4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>

On Tue 20-12-16 08:24:13, Dave Chinner wrote:
> On Thu, Dec 15, 2016 at 03:07:08PM +0100, Michal Hocko wrote:
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > Now that the page allocator offers __GFP_NOLOCKDEP let's introduce
> > KM_NOLOCKDEP alias for the xfs allocation APIs. While we are at it
> > also change KM_NOFS users introduced by b17cb364dbbb ("xfs: fix missing
> > KM_NOFS tags to keep lockdep happy") and use the new flag for them
> > instead. There is really no reason to make these allocations contexts
> > weaker just because of the lockdep which even might not be enabled
> > in most cases.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> 
> I'd suggest that it might be better to drop this patch for now -
> it's not necessary for the context flag changeover but does
> introduce a risk of regressions if the conversion is wrong.
> 
> Hence I think this is better as a completely separate series
> which audits and changes all the unnecessary KM_NOFS allocations
> in one go. I've never liked whack-a-mole style changes like this -
> do it once, do it properly....

OK, fair enough. I thought it might be better to have an example user so
that others can follow but as you say, the risk of regression is really
there and these kind of changes definitely need a throughout review.

I am not sure I will be able to post more of those changes because that
requires an intimate knowledge of the fs so I hope somebody can take
over there and follow up.

Thanks!
-- 
Michal Hocko
SUSE Labs
