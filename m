Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757942AbcK3TaP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2016 14:30:15 -0500
Date: Wed, 30 Nov 2016 11:30:11 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] xfs: fiemap support for cow fork
Message-ID: <20161130193011.GA28491@infradead.org>
References: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
 <1480360181-20396-2-git-send-email-bfoster@redhat.com>
 <20161128191551.GT16813@birch.djwong.org>
 <20161128193119.GA12674@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161128193119.GA12674@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 02:31:19PM -0500, Brian Foster wrote:
> # xfs_io -c "bmap -c" /mnt/file 
> xfs_io: xfsctl(XFS_IOC_GETBMAPX) iflags=0x28 ["/mnt/file"]: Invalid
> argument
> 
> Is this under construction or expected to work as is?

You'll need a CONFIG_XFS_DEBUG build.
