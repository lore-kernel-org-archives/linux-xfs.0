Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:56317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdKND3F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 22:29:05 -0500
Date: Tue, 14 Nov 2017 11:31:37 +0800
From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [Regression/XFS/PM] Freeze tasks failed in xfsaild
Message-ID: <20171114033137.GA23219@yu-chen.sh.intel.com>
References: <20171113103139.GA18936@yu-chen.sh.intel.com>
 <20171113201414.GD16026@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171113201414.GD16026@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Hendrik Woltersdorf <hendrikw@arcor.de>, Dave Chinner <dchinner@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jiri Kosina <jkosina@suse.cz>, Len Brown <len.brown@intel.com>, Rui Zhang <rui.zhang@intel.com>, Dan Williams <dan.j.williams@intel.com>, Yu Chen <yu.chen.surf@gmail.com>, linux-xfs@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 13, 2017 at 09:14:14PM +0100, Luis R. Rodriguez wrote:
> On Mon, Nov 13, 2017 at 06:31:39PM +0800, Yu Chen wrote:
> > The xfs-buf/dm-1 should be freezed according to
> > commit 8018ec083c72 ("xfs: mark all internal workqueues
> > as freezable"), thus a easier way might be have to revert
> > commit 18f1df4e00ce ("xfs: Make xfsaild freezeable
> > again") for now, after this reverting the xfsaild/dm-1
> > becomes non-freezable again, thus pm does not see this
> > thread - unless we find a graceful way to treat xfsaild/dm-1
> > as 'frozen' if it is waiting for an already 'frozen' task,
> > or if the filesystem freeze is added in.
> > 
> > Any comments would be much appreciated.
> 
> Reverting 18f1df4e00ce ("xfs: Make xfsaild freezeable again")
> would break the proper form of the kthread for it to be freezable.
> This "form" is not defined formally, and sadly its just a form
> learned throughout years over different kthreads in the kernel.
> 
> I'm also not convinced all our hibernation / suspend woes would be fixed by
> reverting this commit, its why I worked instead on formalizing a proper freeze
> / thaw, which a lot of filesystems already implement prior to system
> hibernation / suspend / resume [0].
> 
> I'll be respinning this series without the last patch, provided I'm able to
> ensure I don't need the ext[234] hack I did in that thread. Can you test the
> first 3 patches *only* on that series and seeing if that helps on your XFS
> front as well?
> 
> [0] https://lkml.kernel.org/r/20171003185313.1017-1-mcgrof@kernel.org
> 
>   Luis
Thanks for the comment Luis,
Yes, I agree the freezing of filesystem is a proper/thorough fix for such
kind issues, but as Dan said, it might be a little risky for us to
to deploy it on our products currently, unless it is in the
mainline/stable branch. Although the XFS issue might not be 100% reproducible,
we can help test the patch set while seeking for a lightweight 'fix'.
Thanks,
	Yu
