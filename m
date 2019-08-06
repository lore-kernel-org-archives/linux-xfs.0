Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34499 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfHFUHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 16:07:11 -0400
Date: Tue, 6 Aug 2019 20:07:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: XFS segementation fault with new linux 4.19.63
Message-ID: <20190806200707.GV30113@42.do-not-panic.com>
References: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
 <20190806070806.GA13112@infradead.org>
 <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
 <20190806092318.GE7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806092318.GE7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Kinky Nekoboi <kinky_nekoboi@nekoboi.moe>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 07:23:18PM +1000, Dave Chinner wrote:
> On Tue, Aug 06, 2019 at 09:10:57AM +0200, Kinky Nekoboi wrote:
> > Addional info:
> > 
> > this only occurs if kernel is compiled with:
> > 
> > CONFIG_XFS_DEBUG=y
> > 
> > running 4.19.64 without xfs debugging works fine
> 
> I'm guessing 4.19 doesn't have commit c08768977b9a ("xfs: finobt AG
> reserves don't consider last AG can be a runt")....

It does not. Kinky, can you confirm if cherry picking it fixes your
crash? If so I can queue it up for the next batch of fixes for v4.19.

  Luis
