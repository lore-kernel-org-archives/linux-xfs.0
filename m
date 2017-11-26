Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:53976 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdKZCPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 21:15:19 -0500
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
        <20171123220045.GV5858@dastard>
        <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
        <201711242103.FIH57396.FOFVJtQFLSMOHO@I-love.SAKURA.ne.jp>
        <20171125233453.GX5858@dastard>
In-Reply-To: <20171125233453.GX5858@dastard>
Message-Id: <201711261114.DBJ78191.SOOFOHMJLQFVFt@I-love.SAKURA.ne.jp>
Date: Sun, 26 Nov 2017 11:14:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: mhocko@kernel.org, hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Dave Chinner wrote:
> IOWs, we don't actually need to touch this code, but if you really
> must, just remove the KM_NOFS tag.

OK. Then, please remove KM_NOFS. GFP_KERNEL is safer than GFP_NOFS
in the sense that it won't cause OOM lockup due to unable to invoke
the OOM killer.
