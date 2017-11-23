Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43119 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751376AbdKWIPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 03:15:04 -0500
Date: Thu, 23 Nov 2017 00:15:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: Don't trim extents for fiemap
Message-ID: <20171123081504.GB24556@infradead.org>
References: <1511424369-28740-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511424369-28740-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com, darrick.wong@oracle.com

On Thu, Nov 23, 2017 at 10:06:09AM +0200, Nikolay Borisov wrote:
> For file extents xfs currently always calls xfs_bmapi_read with not flags,
> meaning extents are going to be truncated to the requested range. This is
> differs than what other filesystems do (ext4/btrfs don't trim extents). So
> harmonize the behavior across the filesystem by explicitly not trimming
> extents when we are called from fiemap code.

Given that the iomap code generally trims extents, can you just try
to always enable XFS_BMAPI_ENTIRE?
