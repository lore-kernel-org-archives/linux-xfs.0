Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53702 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754256AbdHYBUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 21:20:04 -0400
Date: Fri, 25 Aug 2017 03:20:01 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170825012001.GY27873@wotan.suse.de>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <20170825010155.GK21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170825010155.GK21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, NeilBrown <neilb@suse.com>, Tso Ted <tytso@mit.edu>, Dmitri Pal <dpal@redhat.com>

On Fri, Aug 25, 2017 at 11:01:55AM +1000, Dave Chinner wrote:
> On Thu, Aug 24, 2017 at 08:04:41PM +0200, Luis R. Rodriguez wrote:
> > While all this is nice, I'm sure we're all aware of the dangers of setting
> > things in stone through sysfs, its likely already decided for the above
> > tunables, but adding a uevent *is* yet another layer of user interface
> > which userspace can *expect* and we should be certain we want this so
> > we won't regress userspace later.
> > 
> > Just saying, we better damn be sure this is the way we want to go.
> 
> I'm not sure what you are trying to warn us about? :/
> 
> These are events on an XFS specific kobj, it's not a generic VFS
> filesystem event we are generating here. It's no different from a
> hardware device generating it's own uevents to tell userspace
> something changed in the device.

I meant that once its sent even if it is XFS specific, it will be
something that some userspace can expect and then we'd always have
to send it later.

> A quick grep would have told you that GFS2 already has it's own
> online/offline uevents (e.g. gfs2_online_uevent()), as does the
> DLM code. Orangefs seems to use quite a few of uevent notifications,
> too. So it's not like we're doing something controversial or unique
> here, nor something that locks us out of a non-existent VFS event
> notification mechanism.

I don't think its controversial *at all*. Just that a mount uevent,
with uuid, sounds like something we could at least agree is pretty generic.

Regardless of what we end up doing with it or how.

  Luis
