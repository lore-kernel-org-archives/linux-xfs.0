Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52074 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1427831AbdDWHiT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 03:38:19 -0400
Date: Sun, 23 Apr 2017 09:38:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] xfs: don't use bool values in trace buffers
Message-ID: <20170423073817.GA20524@lst.de>
References: <20170421152123.11316-1-hch@lst.de> <20170421152123.11316-6-hch@lst.de> <20170421193321.GJ23371@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421193321.GJ23371@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Apr 21, 2017 at 12:33:21PM -0700, Darrick J. Wong wrote:
> On Fri, Apr 21, 2017 at 05:21:22PM +0200, Christoph Hellwig wrote:
> > Using bool values produces sparse warnings of this form:
> > 
> > fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> > fs/xfs/./xfs_trace.h:2252:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> > fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> > fs/xfs/./xfs_trace.h:2278:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> > fs/xfs/./xfs_trace.h:2307:1: warning: odd constant _Bool cast (ffffffffffffffff becomes 1)
> > 
> > Just use a char instead to fix those up.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> /me wonders what version of sparse produces this?

Latest git master HEAD:

commit ce18a906b82d0341cb33a71f7b1d8b98d11b345d
Author: Lance Richardson <lrichard@redhat.com>
Date:   Wed Sep 21 10:13:58 2016 -0400

    sparse: update __builtin_object_size() prototype

