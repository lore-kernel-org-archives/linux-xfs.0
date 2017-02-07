Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39598 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753284AbdBGJuv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 04:50:51 -0500
Date: Tue, 7 Feb 2017 10:50:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: don't block the log commit handler for
        discards
Message-ID: <20170207095049.GA15588@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-5-git-send-email-hch@lst.de> <20170203162237.GE45388@bfoster.bfoster> <20170204095954.GE18472@lst.de> <20170206164924.GH57865@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206164924.GH57865@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 11:49:24AM -0500, Brian Foster wrote:
> > Can you explain in which contex you mean this?  I'm a bit lost on this
> > comment unfortunately.
> 
> Sorry.. what I'm concerned about is waiting on in-flight discards during
> unmount. The current discard code issues the discards synchronously and
> so the log force is sufficient to drain in-flight I/O before we start
> breaking down core data structures in the unmount path that would be
> referenced by end_io handlers and such.
> 
> With this change, the log force can return with discards still in
> flight. In fact, a subsequent flush of the workqueue is not sufficient
> since there's no guarantee the work item has been queued by that point
> either. If we don't have unmount serialization against in-flight I/Os,
> this can lead to unmount crashes (see the I/O accounting infrastructure
> added in commit 9c7504aa7 for an example of this problem with async
> buffer I/Os). Am I missing something that protects us from this problem
> here?

No, you're right.  We should have a xfs_extent_busy_flush_all call
in the unmount path.  I'll resend the series again with that added.
