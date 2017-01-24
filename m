Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbdAXQTS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 11:19:18 -0500
Date: Tue, 24 Jan 2017 11:19:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: use per-AG reservations for the finobt
Message-ID: <20170124161917.GF60234@bfoster.bfoster>
References: <1485194742-23185-1-git-send-email-hch@lst.de>
 <20170124140649.GC60234@bfoster.bfoster>
 <20170124144937.GA27261@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170124144937.GA27261@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 03:49:37PM +0100, Christoph Hellwig wrote:
> On Tue, Jan 24, 2017 at 09:06:49AM -0500, Brian Foster wrote:
> > Darrick called out in the previous version that this requires traversal
> > of the entire tree at mount time. Do you have any test results on what
> > kind of worst case mount delays we could be looking at here?
> 
> Even with pretty horribly fragmented file systems I've not seen
> major delays.  But I don't have a setup with a lot of actual disks
> but mostly SSDs these days, so this might not statistically significant.

Heh, I might have some systems with slow storage around. ;P It may take
a little time to populate a large enough fs with inodes though..

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
