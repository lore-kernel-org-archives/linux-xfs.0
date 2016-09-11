Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57346 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755724AbcIKM6L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2016 08:58:11 -0400
Date: Sun, 11 Sep 2016 05:58:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] vfs: support FS_XFLAG_REFLINK and FS_XFLAG_COWEXTSIZE
Message-ID: <20160911125808.GD1399@infradead.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
 <147216786073.525.16014208838990530622.stgit@birch.djwong.org>
 <20160905145622.GB7662@infradead.org>
 <20160906191515.GA26927@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160906191515.GA26927@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com, viro@ZenIV.linux.org.uk, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org

On Tue, Sep 06, 2016 at 12:15:15PM -0700, Darrick J. Wong wrote:
> So far I've put the reflink flag to use in xfs_scrub to look for
> obvious signs of brokenness such as extents that overlap or have the
> shared flag set but the inode flag is off; and to skip various kinds
> of checks that don't have to happen when blocks don't overlap.
> 
> I doubt there's much of a use for the flag outside of the XFS utilities.
> For a while I pondered only exposing the fsxattr flag if the caller had
> CAP_SYS_ADMIN (the level of priviledge required to run scrub) but
> decided that I wouldn't change the existing interface like that unless
> I had a really good reason.

I don't think CAP_SYS_ADMIN is nessecarily the right thing, but it's
still an XFS implementation detail which I don't think we should
pollute a flags API for normal user space applications with.
