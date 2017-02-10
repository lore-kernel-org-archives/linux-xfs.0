Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59694 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdBJQeg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 11:34:36 -0500
Date: Fri, 10 Feb 2017 11:32:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/3] xfs: restore and enhance xfs indlen test
Message-ID: <20170210163207.GB3155@bfoster.bfoster>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
 <20170210071519.GB21408@eguan.usersys.redhat.com>
 <20170210135830.GA3155@bfoster.bfoster>
 <20170210162523.GB6813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210162523.GB6813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Feb 10, 2017 at 08:25:23AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 10, 2017 at 08:58:30AM -0500, Brian Foster wrote:
> > On Fri, Feb 10, 2017 at 03:15:19PM +0800, Eryu Guan wrote:
> > > On Thu, Feb 09, 2017 at 02:43:41PM -0500, Brian Foster wrote:
> > > > Hi all,
> > > > 
> > > > This series is associated with the "buffered write and indlen fixes"
> > > > series recently posted to the XFS list. These patches move the original
> > > > test to the XFS directory as it now depends on an XFS-specific
> > > > mechanism, restore the effectiveness of the original test, and finally
> > > > enhance the test to reproduce the newly identified problems fixed by the
> > > > kernel patches. Thoughts, reviews, flames appreciated.
> > > 
> > > I think it's still worth keeping the original fzero tests in generic, as
> > > a generic function/regression test, though it's not effective to
> > > reproduce the original bug. And maybe it's still working and effective
> > > on some distro kernels? How about just adding a new test for XFS?
> > > 
> > 
> > Sure, in that case I guess I can just copy generic/033 rather than move
> > it and then squash these down into a single patch. Any other comments on
> > the resulting test before I post an update?
> 
> /me thinks the new test ought to _notrun if the fail_writes file doesn't
> show up... that said /me is sorta braindead after a lot of travel
> yesterday and could've missed it already being there. :(
> 

Yep, there's a '_require_xfs_sysfs ...' in there that skips the test as
appropriate.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > Thanks,
> > > Eryu
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
