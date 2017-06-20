Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdFTGbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 02:31:45 -0400
Date: Mon, 19 Jun 2017 23:31:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 7/7] xfs: Switch to iomap for seeking in
 quota files
Message-ID: <20170620063135.GA12636@infradead.org>
References: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
 <1497624680-16685-8-git-send-email-agruenba@redhat.com>
 <20170616153029.GB5421@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616153029.GB5421@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 08:30:29AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 16, 2017 at 04:51:20PM +0200, Andreas Gruenbacher wrote:
> > (This patch is largely untested.)
> 
> In principle the XFS bits look ok, but I think you'd be better off with
> a review from hch and, uh, while you wait, a run through the xfstests
> 'quota' group and probably 'auto' too?

I think for the quota code we should simply not even use seek
hole / data.  Quota files don't have delayed allocations, unwritten
extents or COW forks, so it's just a trivial lookup in the extent
list.  I'll fix that part up to make Andreas' life easier.
