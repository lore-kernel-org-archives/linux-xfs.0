Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48885 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727130AbfGARm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 13:42:56 -0400
Date: Mon, 1 Jul 2019 13:41:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH RFC 00/11] iomap: regroup code by functional area
Message-ID: <20190701174129.GA3315@mit.edu>
References: <156200051933.1790352.5147420943973755350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156200051933.1790352.5147420943973755350.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jul 01, 2019 at 10:01:59AM -0700, Darrick J. Wong wrote:
> Note that this is not the final format of the patches, because I intend
> to pick a point towards the end of the merge window (after everyone
> else's merges have landed), rebase this series atop that, and push it
> back to Linus.

So normally Linus isn't psyched about pulling branches that were
rebased at the last minute.  I guess we could ask him ahead of time if
he's OK with this plan.  Or have you done that already?

Alternatively you could rebase this on top of v5.3-rc2, after the
merge window closes, and get agreement from the 4 file systems which
are currently iomap users: ext2, ext4, gfs2, and xfs to start their
development trees on top of that common branch for the 5.4 merge
window.  After all, it's just moving code around and there are no
substantive changes in this patch series, right?  So there's no rush
as I understand things for this to hit mainline.

Cheers,

						- Ted
