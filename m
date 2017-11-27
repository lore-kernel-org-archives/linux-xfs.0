Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56813 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdK0IFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 03:05:03 -0500
Date: Mon, 27 Nov 2017 09:05:00 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171127080500.akpzasr6z6adyesk@dhcp22.suse.cz>
References: <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
 <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
 <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
 <20171125233453.GX5858@dastard>
 <201711261114.DBJ78191.SOOFOHMJLQFVFt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201711261114.DBJ78191.SOOFOHMJLQFVFt@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: david@fromorbit.com, hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun 26-11-17 11:14:25, Tetsuo Handa wrote:
> Dave Chinner wrote:
> > IOWs, we don't actually need to touch this code, but if you really
> > must, just remove the KM_NOFS tag.
> 
> OK. Then, please remove KM_NOFS. GFP_KERNEL is safer than GFP_NOFS
> in the sense that it won't cause OOM lockup due to unable to invoke
> the OOM killer.

I agree that we should remove nofs request if they are not really
needed. But arguing your usual OOM lockup is (again) over exaggerating.
As a rule of thumb, it is almost always better to have the full reclaim
context rather than reduced one because the later one can influence
other parts of the system as they might need to do more work.

-- 
Michal Hocko
SUSE Labs
