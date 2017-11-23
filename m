Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:28012 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752842AbdKWQB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 11:01:56 -0500
Subject: Re: [PATCH] xfs: handle register_shrinker error
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20171123120828.31881-1-mhocko@kernel.org>
        <20171123132633.GB21798@infradead.org>
        <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
In-Reply-To: <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
Message-Id: <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
Date: Fri, 24 Nov 2017 01:01:10 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mhocko@kernel.org, hch@infradead.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Michal Hocko wrote:
> On Thu 23-11-17 05:26:33, Christoph Hellwig wrote:
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> > I can take a stab at the quota one.
> 
> That would be really great!
> 
Again, it does not look good. Since kmem_free() does only kvfree(),
nothing will release memory allocated by list_lru_init().
