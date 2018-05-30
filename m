Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60168 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965247AbeE3Jww (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 May 2018 05:52:52 -0400
Date: Wed, 30 May 2018 11:59:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Cluster-devel] [PATCH 11/34] iomap: move IOMAP_F_BOUNDARY to
        gfs2
Message-ID: <20180530095911.GB31068@lst.de>
References: <20180523144357.18985-1-hch@lst.de> <20180523144357.18985-12-hch@lst.de> <20180530055033.GZ30110@magnolia> <bc621d7c-f1a6-14c2-663f-57ded16811fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc621d7c-f1a6-14c2-663f-57ded16811fa@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-mm@kvack.org

On Wed, May 30, 2018 at 10:30:32AM +0100, Steven Whitehouse wrote:
> I may have missed the context here, but I thought that the boundary was a 
> generic thing meaning "there will have to be a metadata read before more 
> blocks can be mapped" so I'm not sure why that would now be GFS2 specific?

It was always a hack.  But with iomap it doesn't make any sensee to start
with, all metadata I/O happens in iomap_begin, so there is no point in
marking an iomap with flags like this for the actual iomap interface.
