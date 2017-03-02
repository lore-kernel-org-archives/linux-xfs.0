Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdCBTNm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 14:13:42 -0500
Date: Thu, 2 Mar 2017 16:47:44 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
Message-ID: <20170302154744.GN1404@dhcp22.suse.cz>
References: <20170302124909.GE1404@dhcp22.suse.cz>
 <20170302130009.GC3213@bfoster.bfoster>
 <20170302132755.GG1404@dhcp22.suse.cz>
 <20170302134157.GD3213@bfoster.bfoster>
 <20170302135001.GI1404@dhcp22.suse.cz>
 <20170302142315.GE3213@bfoster.bfoster>
 <20170302143441.GL1404@dhcp22.suse.cz>
 <20170302145131.GF3213@bfoster.bfoster>
 <20170302151411.GM1404@dhcp22.suse.cz>
 <20170302153002.GG3213@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302153002.GG3213@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu 02-03-17 10:30:02, Brian Foster wrote:
> On Thu, Mar 02, 2017 at 04:14:11PM +0100, Michal Hocko wrote:
[...]
> > I am not objecting to adding fatal_signal_pending as well I just thought
> > that from the logic POV breaking after reaching the minimum size is just
> > the right thing to do. We can optimize further by checking
> > fatal_signal_pending and reducing retries when we know it doesn't make
> > much sense but that should be done on top as an optimization IMHO.
> > 
> 
> I don't think of it as an optimization to not invoke calls (a
> non-deterministic number of times) that we know are going to fail, but

the point is that vmalloc failure modes are an implementation detail
which might change in the future. The fix should be really independent
on the current implementation that is why I think the
fatal_signal_pending is just an optimization.

> ultimately I don't care too much how it's framed or if it's done in
> separate patches or whatnot. As long as they are posted at the same
> time. ;)

Done

-- 
Michal Hocko
SUSE Labs
