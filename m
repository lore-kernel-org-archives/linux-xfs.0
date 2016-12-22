Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758914AbcLVJif (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 04:38:35 -0500
Date: Thu, 22 Dec 2016 10:38:28 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 0/9 v2] scope GFP_NOFS api
Message-ID: <20161222093828.GF6048@dhcp22.suse.cz>
References: <20161215140715.12732-1-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215140715.12732-1-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>, Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org, cluster-devel@redhat.com, linux-nfs@vger.kernel.org, logfs@logfs.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>

Are there any objections to the approach and can we have this merged to
the mm tree?

Dave has expressed the patch2 should be dropped for now. I will do that
in a next submission but I do not want to resubmit until there is a
consensus on this.

What do other than xfs/ext4 developers think about this API. Can we find
a way to use it?
-- 
Michal Hocko
SUSE Labs
