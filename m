Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752710AbdKXMJt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 07:09:49 -0500
Date: Fri, 24 Nov 2017 13:09:46 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171124120946.7zsz27dlni7s7ijm@dhcp22.suse.cz>
References: <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
 <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
 <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: david@fromorbit.com, hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 24-11-17 21:03:28, Tetsuo Handa wrote:
> Michal Hocko wrote:
> > Thanks. Updated patch below
> > ---
> > From 1009db61988c48c9a9e327a9d076945b29b02eee Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.com>
> > Date: Thu, 23 Nov 2017 17:13:40 +0100
> > Subject: [PATCH] xfs: fortify xfs_alloc_buftarg error handling
> 
> Do we need below patch on top of Michal's patch?
> KM_NOFS was added by commit b17cb364dbbbf65a ("xfs: fix missing KM_NOFS
> tags to keep lockdep happy"). If not needed, some comment is expected.

I am not not familiar with the code but git blame says that the whole
point of NOFS here was to make lockdep happy. We do have means to
silence the warning if the original concern still applies.
-- 
Michal Hocko
SUSE Labs
