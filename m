Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726186AbfBGK1x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 05:27:53 -0500
Date: Thu, 7 Feb 2019 11:27:50 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Message-ID: <20190207102750.GA4570@quack2.suse.cz>
References: <20190130041707.27750-1-david@fromorbit.com>
 <20190130041707.27750-2-david@fromorbit.com>
 <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com>
 <20190131013403.GI4205@dastard>
 <20190131091011.GP18811@dhcp22.suse.cz>
 <20190131185704.GA8755@castle.DHCP.thefacebook.com>
 <20190131221904.GL4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131221904.GL4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Chris Mason <clm@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On Fri 01-02-19 09:19:04, Dave Chinner wrote:
> Maybe for memcgs, but that's exactly the oppose of what we want to
> do for global caches (e.g. filesystem metadata caches). We need to
> make sure that a single, heavily pressured cache doesn't evict small
> caches that lower pressure but are equally important for
> performance.
> 
> e.g. I've noticed recently a significant increase in RMW cycles in
> XFS inode cache writeback during various benchmarks. It hasn't
> affected performance because the machine has IO and CPU to burn, but
> on slower machines and storage, it will have a major impact.

Just as a data point, our performance testing infrastructure has bisected
down to the commits discussed in this thread as the cause of about 40%
regression in XFS file delete performance in bonnie++ benchmark.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
