Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbdEBMO1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 08:14:27 -0400
Date: Tue, 2 May 2017 08:14:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: support debug mode with assert warnings
Message-ID: <20170502121423.GB6975@bfoster.bfoster>
References: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
 <20170502073730.GA19021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502073730.GA19021@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, May 02, 2017 at 12:37:30AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 28, 2017 at 01:29:01PM -0400, Brian Foster wrote:
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > Every now and then I find myself wanting to enable DEBUG mode code
> > without having to BUG the kernel every time an assert fails. Currently,
> > I end up just commenting out the BUG() call from assfail(). Any thoughts
> > on something like the below to update our configuration to support the
> > ability to enable debug mode with assert warnings?
> > 
> > While this appears as a new option in Kconfig, it just reuses the
> > existing XFS_WARN definition to convert asserts into warnings regardless
> > of whether debug mode is enabled or not. There are probably multiple
> > other ways to do something like this (e.g., a Kconfig 'choice' selection
> > for various XFS debug modes, dropping the BUG() entirely, etc.).
> > Thoughts?
> > 
> > Brian
> > 
> >  fs/xfs/Kconfig     |  9 +++++++++
> >  fs/xfs/xfs_linux.h | 32 +++++++++++++++++++-------------
> >  2 files changed, 28 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> > index 35faf12..db6d830 100644
> > --- a/fs/xfs/Kconfig
> > +++ b/fs/xfs/Kconfig
> > @@ -96,3 +96,12 @@ config XFS_DEBUG
> >  	  not useful unless you are debugging a particular problem.
> >  
> >  	  Say N unless you are an XFS developer, or you play one on TV.
> > +
> > +config XFS_WARN
> > +	bool "Non-fatal Asserts"
> > +	default n
> > +	depends on XFS_FS && XFS_DEBUG
> > +	help
> > +	  Say Y here to convert DEBUG mode ASSERT failures into warnings.
> > +	  Otherwise, ASSERT failures are considered fatal errors and BUG the
> > +	  kernel.
> 
> I'm very confused by this patch.  At least my fs/xfs/Kconfig already
> has a "config XFS_WARN" line.  What am I missing?

As noted above, this is just a reuse of the flag. XFS_WARN and XFS_DEBUG
are currently mutually exclusive. The former enables warnings on assert
failures. The latter enables BUG()'s on assert failures and the
additional, typical debug mode code. The Kconfig hack above simply pops
up a conditional option when debug mode is enabled that effectively
allows setting both XFS_WARN and XFS_DEBUG at the same time. The header
files interpret this as debug mode enabled with an override for the
assert failures to warn rather than BUG().

Note that this is just a hack and we can organize the Kconfig options
however we want. For example, we could call this XFS_DEBUG_WARN and
continue to consider it a debug mode sub-flag, or we could turn the
debug mode option into a multi-mode selector (i.e., Debug modes: "None,"
"Warn only," "Debug mode," "Debug mode w/ non-fatal asserts"). I played
around a bit with the latter but it seems like a bit of overkill to me.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
