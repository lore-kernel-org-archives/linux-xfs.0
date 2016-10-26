Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45181 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753064AbcJZQha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 12:37:30 -0400
Date: Wed, 26 Oct 2016 09:37:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/39] xfs_io: provide long-format help for falloc
Message-ID: <20161026163704.GB26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743674377.11035.8133878879225366578.stgit@birch.djwong.org>
 <20161026103405.GN29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026103405.GN29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:34:05AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 04:05:43PM -0700, Darrick J. Wong wrote:
> > Provide long-format help for falloc so that xfstests can use
> > _require_xfs_io_command to check for falloc command line args.
> 
> As it turns out checking those args isn't actually suitable.

Yeah, ultimately I simply made an 'funshare' command and xfstests
checks whether it works the same way it does for fzero/fpunch/etc.
That makes the commit message a little out of date; will change it.

--D

> But documentation is always good to have, so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
