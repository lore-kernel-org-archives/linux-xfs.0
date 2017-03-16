Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36095 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752510AbdCPTvs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Mar 2017 15:51:48 -0400
Date: Thu, 16 Mar 2017 20:50:56 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: use dedicated log worker wq to avoid deadlock with
 cil wq
Message-ID: <20170316195056.GN28800@wotan.suse.de>
References: <1489083497-22964-1-git-send-email-bfoster@redhat.com>
 <20170316191734.GM5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170316191734.GM5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, David Jeffery <djeffery@redhat.com>, sebastian.parschauer@suse.com, AlNovak@suse.com

On Thu, Mar 16, 2017 at 12:17:34PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 09, 2017 at 01:18:17PM -0500, Brian Foster wrote:
> > The log covering background task used to be part of the xfssyncd
> > workqueue. That workqueue was removed as of commit 5889608df ("xfs:
> > syncd workqueue is no more") and the associated work item scheduled
> > to the xfs-log wq. The latter is used for log buffer I/O completion.

That went in on v3.8.

<-- snip -->

> > In this scenario
> > both workqueues are deadlocked waiting on eachother.
> > 
> > Add a new workqueue specifically for the high level log covering and
> > ail pushing worker, as was the case prior to commit 5889608df.
> > 
> > Diagnosed-by: David Jeffery <djeffery@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>

> > ---
> > 
> > Note that this seems difficult to reproduce in practice because I
> > believe it also relies on memory pressure. Otherwise, the xfs-log wq
> > rescuer thread may be available to unwind the deadlock.

Still, a dead lock is no bueno. No happy user can exist with a deadlock.

> I /think/ this looks ok?  But let me run it through xfstests before I
> commit to anything. :)

Provided that goes smooth -- this seems like a stable candidate to me.
Otherwise we're going to have to carry it anyway on distributions.

  Luis
