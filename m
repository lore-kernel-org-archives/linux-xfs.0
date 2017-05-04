Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49813 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdEDL50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 07:57:26 -0400
Date: Thu, 4 May 2017 04:57:25 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC] xfs: support debug mode with assert warnings
Message-ID: <20170504115725.GB22052@infradead.org>
References: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
 <20170502073730.GA19021@infradead.org>
 <20170502121423.GB6975@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170502121423.GB6975@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, May 02, 2017 at 08:14:25AM -0400, Brian Foster wrote:
> As noted above, this is just a reuse of the flag. XFS_WARN and XFS_DEBUG
> are currently mutually exclusive. The former enables warnings on assert
> failures. The latter enables BUG()'s on assert failures and the
> additional, typical debug mode code. The Kconfig hack above simply pops
> up a conditional option when debug mode is enabled that effectively
> allows setting both XFS_WARN and XFS_DEBUG at the same time. The header
> files interpret this as debug mode enabled with an override for the
> assert failures to warn rather than BUG().

Oh, I didn't know Kconfig allows the same symbol to be define twice.
But even if that's ok I'd say it's rather odd.

> Note that this is just a hack and we can organize the Kconfig options
> however we want. For example, we could call this XFS_DEBUG_WARN and
> continue to consider it a debug mode sub-flag, or we could turn the
> debug mode option into a multi-mode selector (i.e., Debug modes: "None,"
> "Warn only," "Debug mode," "Debug mode w/ non-fatal asserts"). I played
> around a bit with the latter but it seems like a bit of overkill to me.

Maybe we need something like:

 XFS_WARN (as-is)
 XFS_WARN_BUG (XFS_WARN + BUG_ON on assert)
 XFS_DEBUG (everyhing under XFS_DEBUG currently that's not related to
	ASSERT)

