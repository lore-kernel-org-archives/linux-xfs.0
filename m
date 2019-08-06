Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42515 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732361AbfHFJY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 05:24:28 -0400
Date: Tue, 6 Aug 2019 19:23:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS segementation fault with new linux 4.19.63
Message-ID: <20190806092318.GE7777@dread.disaster.area>
References: <e0ca189e-2f96-6599-40ce-a4fc8866d8d1@nekoboi.moe>
 <20190806070806.GA13112@infradead.org>
 <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbe57554-ed5f-6163-d48c-9069aa2dcc7b@nekoboi.moe>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kinky Nekoboi <kinky_nekoboi@nekoboi.moe>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Aug 06, 2019 at 09:10:57AM +0200, Kinky Nekoboi wrote:
> Addional info:
> 
> this only occurs if kernel is compiled with:
> 
> CONFIG_XFS_DEBUG=y
> 
> running 4.19.64 without xfs debugging works fine

I'm guessing 4.19 doesn't have commit c08768977b9a ("xfs: finobt AG
reserves don't consider last AG can be a runt")....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
