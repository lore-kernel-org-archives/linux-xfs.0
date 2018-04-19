Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbeDSIcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Apr 2018 04:32:25 -0400
Date: Thu, 19 Apr 2018 01:32:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfs: create the XFS_QMOPT_QUOTIP_LOCKED flag
Message-ID: <20180419083224.GA17515@infradead.org>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401917977.11465.9543981144688523511.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401917977.11465.9543981144688523511.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:39:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new QMOPT flag to signal that we've already locked the quota
> inode.  This will be used by the quota scrub code refactoring to avoid
> dropping the quota ip lock during scrub.  The flag is incompatible with
> the DQALLOC flag because dquot allocation creates a transaction, and we
> shouldn't be doing that with the ILOCK held.

Locked flag are always a sign for code smell.  And this already is
pretty smelly code before that flag is added.  I think someone (i.e.
either you or me :)) needs to do a major refactoring here first.
