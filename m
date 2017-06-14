Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41019 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdFNGqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2017 02:46:21 -0400
Date: Tue, 13 Jun 2017 23:46:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170614064619.GA3598@infradead.org>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard>
 <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
 <20170612235002.GF17542@dastard>
 <CALoZfD4RXJUusr7-r8COsUY+8_D6z68LbCRkp+9VM1E2tUV1UA@mail.gmail.com>
 <20170613221647.GG17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170613221647.GG17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sweet Tea Dorminy <sweettea@permabit.com>, linux-xfs@vger.kernel.org

On Wed, Jun 14, 2017 at 08:16:47AM +1000, Dave Chinner wrote:
> Yes, that's my understanding, too, but I also thought that multiple
> outstanding flushes are ordered by the block layer. i.e. flushes can
> be reordered against other operations, but not other flushes.

There is no such guarantee.  For request based drivers some ordering
happens in practice, but that's an implementation artifact and not
a gurantee, and for bio based drivers all bets are off.
