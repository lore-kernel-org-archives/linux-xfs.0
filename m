Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52724 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbeDQPpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 11:45:07 -0400
Date: Tue, 17 Apr 2018 08:44:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: cap the length of deduplication requests
Message-ID: <20180417154450.GB24738@magnolia>
References: <20180417051918.GD5203@magnolia>
 <20180417065800.GA2857@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417065800.GA2857@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Mon, Apr 16, 2018 at 11:58:00PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 16, 2018 at 10:19:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since deduplication potentially has to read in all the pages in both
> > files in order to compare the contents, cap the deduplication request
> > length at MAX_RW_COUNT (roughly 2GB) so that we have /some/ upper bound
> > on the request length and can't just lock up the kernel forever.  Found
> > by running generic/304 after commit 1ddae54555b62 ("common/rc: add
> > missing 'local' keywords").
> 
> Looks fine.  btrfs limits to 16MB, I guess we don't want to go that low?

I've wondered about that -- the btrfs developers opine that you're
unlikely to hit a 16+ MB extent that can be deduplicated, but seeing as
the usage model seems to be "copy files onto fs, let dedupe program
target files in the background", I have my doubts.

Specifically, most of the usage models I envision are backup programs
wanting to dedupe files that are almost but not quite the same; and VM
farms.  The cross-host VM migration tools I've seen tend to copy the
image as fast as possible to minimize transition time and worry about
whether or not there are shared blocks later.

OTOH I do worry a little about the prospect of doing 4GB of IO per
kernel call, so maybe this should be (MAX_RW_COUNT/2)?.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
