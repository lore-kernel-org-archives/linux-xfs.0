Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753910AbdLFCFS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 21:05:18 -0500
Date: Tue, 5 Dec 2017 18:05:15 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/73] XArray version 4
Message-ID: <20171206020515.GL26021@bombadil.infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206014536.GA4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Dec 06, 2017 at 12:45:49PM +1100, Dave Chinner wrote:
> On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> > From: Matthew Wilcox <mawilcox@microsoft.com>
> > 
> > I looked through some notes and decided this was version 4 of the XArray.
> > Last posted two weeks ago, this version includes a *lot* of changes.
> > I'd like to thank Dave Chinner for his feedback, encouragement and
> > distracting ideas for improvement, which I'll get to once this is merged.
> 
> BTW, you need to fix the "To:" line on your patchbombs:
> 
> > To: unlisted-recipients: ;, no To-header on input <@gmail-pop.l.google.com> 
> 
> This bad email address getting quoted to the cc line makes some MTAs
> very unhappy.

I know :-(  I was unhappy when I realised what I'd done.

https://marc.info/?l=git&m=151252237912266&w=2

> I'll give this a quick burn this afternoon and see what catches fire...

All of the things ... 0day gave me a 90% chance of hanging in one
configuration.  Need to drill down on it more and find out what stupid
thing I've done wrong this time.
