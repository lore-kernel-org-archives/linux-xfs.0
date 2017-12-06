Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:41594 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753516AbdLFBpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 20:45:55 -0500
Date: Wed, 6 Dec 2017 12:45:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 00/73] XArray version 4
Message-ID: <20171206014536.GA4094@dastard>
References: <20171206004159.3755-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> I looked through some notes and decided this was version 4 of the XArray.
> Last posted two weeks ago, this version includes a *lot* of changes.
> I'd like to thank Dave Chinner for his feedback, encouragement and
> distracting ideas for improvement, which I'll get to once this is merged.

BTW, you need to fix the "To:" line on your patchbombs:

> To: unlisted-recipients: ;, no To-header on input <@gmail-pop.l.google.com> 

This bad email address getting quoted to the cc line makes some MTAs
very unhappy.

> 
> Highlights:
>  - Over 2000 words of documentation in patch 8!  And lots more kernel-doc.
>  - The page cache is now fully converted to the XArray.
>  - Many more tests in the test-suite.
> 
> This patch set is not for applying.  0day is still reporting problems,
> and I'd feel bad for eating someone's data.  These patches apply on top
> of a set of prepatory patches which just aren't interesting.  If you
> want to see the patches applied to a tree, I suggest pulling my git tree:
> http://git.infradead.org/users/willy/linux-dax.git/shortlog/refs/heads/xarray-2017-12-04
> I also left out the idr_preload removals.  They're still in the git tree,
> but I'm not looking for feedback on them.

I'll give this a quick burn this afternoon and see what catches fire...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
