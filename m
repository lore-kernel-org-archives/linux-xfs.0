Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41020 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbcJZSGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 14:06:43 -0400
Date: Wed, 26 Oct 2016 11:06:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/39] xfs: connect refcount adjust functions to upper
 layers
Message-ID: <20161026180617.GH26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743664880.11035.14935300477479467762.stgit@birch.djwong.org>
 <20161026102444.GE29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026102444.GE29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:24:44AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 04:04:08PM -0700, Darrick J. Wong wrote:
> > Plumb in the upper level interface to schedule and finish deferred
> > refcount operations via the deferred ops mechanism.
> > 
> > [Plumb in refcount deferred op log items.]
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Shouldn't we try to shared xfs_trans_refcount.c instead?

There's not a lot to share, since the kernel version actually has to
create log intent items and log them prior to calling the libxfs
functions, whereas xfsprogs calls the libxfs functions directly.

The only identical functions are _diff_items, _finish_cleanup, and
_cancel_item.  Those last two are one-liners.

--D
