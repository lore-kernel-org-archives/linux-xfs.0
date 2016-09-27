Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55964 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753214AbcI0Ssw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 14:48:52 -0400
Date: Tue, 27 Sep 2016 20:48:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: rewrite the COW writeback mapping code
Message-ID: <20160927184850.GA22830@lst.de>
References: <1474730361-5234-1-git-send-email-hch@lst.de> <1474730361-5234-3-git-send-email-hch@lst.de> <20160926213557.GD14092@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160926213557.GD14092@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

> if (xfs_is_reflink_inode(XFS_I(inode))) {
> 
> since we don't have to care about COW mappings unless the inode also has
> shared extents.  The code you got this from seems to have this bug too;
> I'll just fix this when I push the patch onto my stack.

Indeed.  I felt the check to be a bit odd, but for some reason didn't
follow up on it.
