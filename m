Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43626 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbfHFVW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 17:22:57 -0400
Date: Wed, 7 Aug 2019 07:21:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/24] xfs: eagerly free shadow buffers to reduce CIL
 footprint
Message-ID: <20190806212148.GH7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-16-david@fromorbit.com>
 <20190805180300.GE14760@bfoster>
 <20190805233326.GA7777@dread.disaster.area>
 <20190806125727.GD2979@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806125727.GD2979@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Tue, Aug 06, 2019 at 08:57:27AM -0400, Brian Foster wrote:
> On Tue, Aug 06, 2019 at 09:33:26AM +1000, Dave Chinner wrote:
> > I'll recheck this, but I'm pretty sure overwrite won't leave a
> > shadow buffer around.
> > 
> 
> But before that we have the following logic:
> 
> static void
> xlog_cil_alloc_shadow_bufs(
> 	...
> 
> 	if (!lip->li_lv_shadow ||
> 	    buf_size > lip->li_lv_shadow->lv_size) {
> 		...
> 		lv = kmem_alloc_large(buf_size, KM_SLEEP | KM_NOFS);
> 		...
> 		lip->li_lv_shadow = lv;
> 	} else {
> 		<reuse shadow>
> 	}
> 	...
> }
> 
> ... which always allocates a shadow buffer if one doesn't exist. We
> don't look at the currently used (lip->li_lv) buffer at all here. IIUC,
> that has to do with the TOCTOU race described in the big comment above
> the function.. hm?

You might be right there. I haven't had a chance to follow up on
this from yesterday yet, so I'll keep this in mind when I look at it
again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
