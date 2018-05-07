Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:51358 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752969AbeEGX7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 19:59:18 -0400
Date: Tue, 8 May 2018 09:59:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: don't assert fail with AIL lock held
Message-ID: <20180507235916.GK23861@dastard>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-6-david@fromorbit.com>
 <20180507121806.GF38916@bfoster.bfoster>
 <20180507145048.GG7476@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507145048.GG7476@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, May 07, 2018 at 07:50:48AM -0700, Christoph Hellwig wrote:
> > Otherwise seems Ok, but kind of ugly. What about something like the
> > following diff (applied on top of this patch)? Still hacky, but it
> > avoids the multiple lock cycles for each check failure and preserves the
> > actual assert strings. (Untested and probably could use comment
> > updates..).
> 
> This looks a little better.  But maybe we should just replace the
> ASSERT statements with WARN_ON_ONCE calls to make them non-fatal
> but otherwise leave things as-is?

Yup, it's cleaner than my change, but I still asserts here as it's
debug-only code and asserts stop tracing instantly. That makes it
much easier to debug problems this code detects because you don't
need to do any work to find where in the tracing output the error
was first detected....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
