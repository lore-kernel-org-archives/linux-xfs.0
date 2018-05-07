Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45442 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbeEGOut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 10:50:49 -0400
Date: Mon, 7 May 2018 07:50:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfs: don't assert fail with AIL lock held
Message-ID: <20180507145048.GG7476@infradead.org>
References: <20180502080157.11386-1-david@fromorbit.com>
 <20180502080157.11386-6-david@fromorbit.com>
 <20180507121806.GF38916@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507121806.GF38916@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

> Otherwise seems Ok, but kind of ugly. What about something like the
> following diff (applied on top of this patch)? Still hacky, but it
> avoids the multiple lock cycles for each check failure and preserves the
> actual assert strings. (Untested and probably could use comment
> updates..).

This looks a little better.  But maybe we should just replace the
ASSERT statements with WARN_ON_ONCE calls to make them non-fatal
but otherwise leave things as-is?
