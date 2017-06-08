Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750919AbdFHQIy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 12:08:54 -0400
Date: Thu, 8 Jun 2017 12:08:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2] xfs: fix a couple xfs_buf_log_item shutdown problems
Message-ID: <20170608160852.GF5244@bfoster.bfoster>
References: <1496750930-53954-1-git-send-email-bfoster@redhat.com>
 <20170608155653.GJ4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608155653.GJ4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 08:56:53AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2017 at 08:08:48AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This series fixes a couple filesystem shutdown corner cases related to
> > dealing with the xfs_buf_log_item reference count. Patch 1 fixes a
> > reference count leak that leads to an unmount hang due to a held buffer.
> > Patch 2 fixes a premature free of the bli that leads to a panic due to
> > use after free. Both of the above problems can be reproduced by running
> > generic/388 in a loop (though it may require 100-200 iterations).
> > 
> > I was originally considering reworking the bli reference counting, but I
> > don't have a clear idea on whether a cleaner solution is available atm.
> > These isolated fixes are lower risk and resolve the associated problems,
> > so should probably be considered independently regardless.
> > 
> > With these patches applied, generic/388 survives several thousand
> > iterations and otherwise no regressions are observed in my tests.
> > Thoughts, reviews, flames appreciated.
> 
> Series looks ok, will test...
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'm not seeing anything in here that screams "hot 4.12 bug fix"; is that
> impression correct?
> 

Correct, thanks!

Brian

> --D
> 
> > 
> > Brian
> > 
> > Brian Foster (2):
> >   xfs: release bli from transaction properly on fs shutdown
> >   xfs: remove bli from AIL before release on transaction abort
> > 
> >  fs/xfs/xfs_buf_item.c  | 21 ++++++++++++---------
> >  fs/xfs/xfs_trans_buf.c | 21 ++++++++++++++-------
> >  2 files changed, 26 insertions(+), 16 deletions(-)
> > 
> > -- 
> > 2.7.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
