Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42482 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755550AbdBQMpJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Feb 2017 07:45:09 -0500
Date: Fri, 17 Feb 2017 13:45:07 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] xfs: remove XFS_ALLOCTYPE_ANY_AG and
        XFS_ALLOCTYPE_START_AG
Message-ID: <20170217124507.GD23739@lst.de>
References: <20170216212110.4370-1-hch@lst.de> <20170216212110.4370-3-hch@lst.de> <20170217010528.GJ6813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170217010528.GJ6813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 16, 2017 at 05:05:28PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 16, 2017 at 10:21:10PM +0100, Christoph Hellwig wrote:
> > XFS_ALLOCTYPE_ANY_AG  was only used for the RT allocator and is unused now,
> > and XFS_ALLOCTYPE_START_AG has been unused for a while.
> > 
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'm wondering for sake of historical context, has XFS ever used these?

All the way back to 1996 XFS_ALLOCTYPE_START_AG seems to have been
unused, and XFS_ALLOCTYPE_ANY_AG seems to only have been used in the
RT allocator.
