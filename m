Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:40831 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753838AbdHYBCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 21:02:39 -0400
Date: Fri, 25 Aug 2017 11:01:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170825010155.GK21024@dastard>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170824180441.GL27873@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On Thu, Aug 24, 2017 at 08:04:41PM +0200, Luis R. Rodriguez wrote:
> While all this is nice, I'm sure we're all aware of the dangers of setting
> things in stone through sysfs, its likely already decided for the above
> tunables, but adding a uevent *is* yet another layer of user interface
> which userspace can *expect* and we should be certain we want this so
> we won't regress userspace later.
> 
> Just saying, we better damn be sure this is the way we want to go.

I'm not sure what you are trying to warn us about? :/

These are events on an XFS specific kobj, it's not a generic VFS
filesystem event we are generating here. It's no different from a
hardware device generating it's own uevents to tell userspace
something changed in the device.

A quick grep would have told you that GFS2 already has it's own
online/offline uevents (e.g. gfs2_online_uevent()), as does the
DLM code. Orangefs seems to use quite a few of uevent notifications,
too. So it's not like we're doing something controversial or unique
here, nor something that locks us out of a non-existent VFS event
notification mechanism.

Please, talk all you want about a Grand Unified VFS Event
Notification infrastructure and filesystem tool libraries, but
please don't hijack an unrelated discussion to do it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
