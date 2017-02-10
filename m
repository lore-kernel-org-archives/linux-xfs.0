Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47382 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752129AbdBJN6g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 08:58:36 -0500
Date: Fri, 10 Feb 2017 08:58:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/3] xfs: restore and enhance xfs indlen test
Message-ID: <20170210135830.GA3155@bfoster.bfoster>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
 <20170210071519.GB21408@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210071519.GB21408@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Feb 10, 2017 at 03:15:19PM +0800, Eryu Guan wrote:
> On Thu, Feb 09, 2017 at 02:43:41PM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > This series is associated with the "buffered write and indlen fixes"
> > series recently posted to the XFS list. These patches move the original
> > test to the XFS directory as it now depends on an XFS-specific
> > mechanism, restore the effectiveness of the original test, and finally
> > enhance the test to reproduce the newly identified problems fixed by the
> > kernel patches. Thoughts, reviews, flames appreciated.
> 
> I think it's still worth keeping the original fzero tests in generic, as
> a generic function/regression test, though it's not effective to
> reproduce the original bug. And maybe it's still working and effective
> on some distro kernels? How about just adding a new test for XFS?
> 

Sure, in that case I guess I can just copy generic/033 rather than move
it and then squash these down into a single patch. Any other comments on
the resulting test before I post an update?

Brian

> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
