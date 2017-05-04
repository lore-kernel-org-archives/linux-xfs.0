Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdEDMo2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 May 2017 08:44:28 -0400
Date: Thu, 4 May 2017 08:44:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: support debug mode with assert warnings
Message-ID: <20170504124419.GD3248@bfoster.bfoster>
References: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
 <20170502073730.GA19021@infradead.org>
 <20170502121423.GB6975@bfoster.bfoster>
 <20170504115725.GB22052@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170504115725.GB22052@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, May 04, 2017 at 04:57:25AM -0700, Christoph Hellwig wrote:
> On Tue, May 02, 2017 at 08:14:25AM -0400, Brian Foster wrote:
> > As noted above, this is just a reuse of the flag. XFS_WARN and XFS_DEBUG
> > are currently mutually exclusive. The former enables warnings on assert
> > failures. The latter enables BUG()'s on assert failures and the
> > additional, typical debug mode code. The Kconfig hack above simply pops
> > up a conditional option when debug mode is enabled that effectively
> > allows setting both XFS_WARN and XFS_DEBUG at the same time. The header
> > files interpret this as debug mode enabled with an override for the
> > assert failures to warn rather than BUG().
> 
> Oh, I didn't know Kconfig allows the same symbol to be define twice.
> But even if that's ok I'd say it's rather odd.
> 

Yes, I just slapped it together quickly to float the idea.

> > Note that this is just a hack and we can organize the Kconfig options
> > however we want. For example, we could call this XFS_DEBUG_WARN and
> > continue to consider it a debug mode sub-flag, or we could turn the
> > debug mode option into a multi-mode selector (i.e., Debug modes: "None,"
> > "Warn only," "Debug mode," "Debug mode w/ non-fatal asserts"). I played
> > around a bit with the latter but it seems like a bit of overkill to me.
> 
> Maybe we need something like:
> 
>  XFS_WARN (as-is)
>  XFS_WARN_BUG (XFS_WARN + BUG_ON on assert)
>  XFS_DEBUG (everyhing under XFS_DEBUG currently that's not related to
> 	ASSERT)

That allows asserts to BUG() on an XFS_WARN kernel, which is not quite
what I want to accomplish here (and I don't think that's really needed
for an XFS_WARN kernel). I'm not quite following if/how that allows to
disable assert BUG()s on an XFS_DEBUG kernel. Would XFS_DEBUG now never
BUG() unless XFS_WARN_BUG is defined as well?

If so, that sounds reasonable to me. I may just suggest tweaking it to
something like this:

XFS_WARN (as-is)
XFS_DEBUG (DEBUG code modified to warn on assert failure by default)
XFS_ASSERT_BUG (depends on XFS_DEBUG, enables BUG() on assert failure)

WARN and DEBUG remain mutually exclusive, the default assert behavior
for DEBUG changes to a warning rather than BUG(), and the latter is
enabled by a new conditional XFS_ASSERT_BUG config option. My only
slight concern is that changes default behavior for distros that might
create debug builds/packages, but I can see whether we can mitigate that
by setting 'default y' for XFS_ASSERT_BUG so long as it is only
available in XFS_DEBUG mode. Thoughts?

Brian

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
