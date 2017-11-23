Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55515 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbdKWQbR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Nov 2017 11:31:17 -0500
Date: Thu, 23 Nov 2017 17:31:15 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] xfs: handle register_shrinker error
Message-ID: <20171123163115.gmm7q6p5ut4pfp7n@dhcp22.suse.cz>
References: <20171123120828.31881-1-mhocko@kernel.org>
 <20171123132633.GB21798@infradead.org>
 <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <201711240117.DDH05249.LMOOFQFJOHFStV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201711240117.DDH05249.LMOOFQFJOHFStV@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: hch@infradead.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 24-11-17 01:17:12, Tetsuo Handa wrote:
> Michal Hocko wrote:
> > Hmm, you are right. I have (blindly) followed the current code flow
> > which is wrong as well. The following should do the trick. Should I
> > split that into two patches?
> 
> Well, xfs_alloc_buftarg() needs to be more careful.
[...]
>         btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS); // This is GFP_NOFS context. But...
[...]
>         if (list_lru_init(&btp->bt_lru)) // This is GFP_KERNEL context.

this sounds like a separate thing to cleanup or document.
-- 
Michal Hocko
SUSE Labs
