Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbcI2RIA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 13:08:00 -0400
Date: Thu, 29 Sep 2016 10:07:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 45/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20160929170759.GJ4546@infradead.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503150585.30303.6967077248029323904.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503150585.30303.6967077248029323904.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Sep 27, 2016 at 07:58:25PM -0700, Darrick J. Wong wrote:
> Now that we have an fallocate flag to unshare a range of blocks, make
> XFS actually implement it.

There is unshared flag in here.  Instead it performs an unshare
without passing any flag, which will break existing users of fallocate
like the NFS server.

> v2: NFS doesn't pass around struct file pointers, which means that our
> unshare functions all crash when filp == NULL.  We don't need filp
> anyway, so remove all the parts where we pass filp around.

NFSD passes a file pointer just fine.  Note that it really should
matter, but this comment confused me.
