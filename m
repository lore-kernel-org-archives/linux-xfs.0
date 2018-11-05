Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42888 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387672AbeKFHNZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 02:13:25 -0500
Date: Mon, 5 Nov 2018 13:51:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: defer online discard submission to a workqueue
Message-ID: <20181105215139.GA3160@infradead.org>
References: <20181105181021.8174-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105181021.8174-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 01:10:21PM -0500, Brian Foster wrote:
> When online discard is enabled, discards of busy extents are
> submitted asynchronously as a bio chain. bio completion and
> resulting busy extent cleanup is deferred to a workqueue. Async
> discard submission is intended to avoid blocking log forces on a
> full discard sequence which can take a noticeable amount of time in
> some cases.
> 
> We've had reports of this still producing log force stalls with XFS
> on VDO,

Please fix this in VDO instead.  We should not work around out of
tree code making stupid decisions.
