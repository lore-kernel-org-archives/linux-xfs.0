Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32838 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbdBJHOr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 02:14:47 -0500
Date: Fri, 10 Feb 2017 08:14:18 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [BUG 4.10-rc7] sb_fdblocks inconsistency in xfs/297 test
Message-ID: <20170210071418.GC9346@dhcp22.suse.cz>
References: <20170210035348.GA7075@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210035348.GA7075@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri 10-02-17 11:53:48, Eryu Guan wrote:
> Hi,
> 
> I was testing 4.10-rc7 kernel and noticed that xfs_repair reported XFS
> corruption after fstests xfs/297 test. This didn't happen with 4.10-rc6
> kernel, and git bisect pointed the first bad commit to
> 
> commit d1908f52557b3230fbd63c0429f3b4b748bf2b6d
> Author: Michal Hocko <mhocko@suse.com>
> Date:   Fri Feb 3 13:13:26 2017 -0800
> 
>     fs: break out of iomap_file_buffered_write on fatal signals
> 
>     Tetsuo has noticed that an OOM stress test which performs large write
>     requests can cause the full memory reserves depletion.  He has tracked
>     this down to the following path
> ....
> 
> It's the sb_fdblocks field reports inconsistency:
> ...
> Phase 2 - using internal log   
>         - zero log...
>         - scan filesystem freespace and inode maps...
> sb_fdblocks 3367765, counted 3367863
>         - 11:37:41: scanning filesystem freespace - 16 of 16 allocation groups done
>         - found root inode chunk
> ...
> 
> And it can be reproduced almost 100% with all XFS test configurations
> (e.g. xfs_4k xfs_2k_reflink), on all test hosts I tried (so I didn't
> bother pasting my detailed test and host configs, if more info is needed
> please let me know).

The patch can lead to short writes when the task is killed. Was there
any OOM killer triggered during the test? If not who is killing the
task? I will try to reproduce later today.
-- 
Michal Hocko
SUSE Labs
