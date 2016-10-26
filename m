Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52949 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932310AbcJZKYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:24:45 -0400
Date: Wed, 26 Oct 2016 03:24:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/39] xfs: connect refcount adjust functions to upper
 layers
Message-ID: <20161026102444.GE29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743664880.11035.14935300477479467762.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743664880.11035.14935300477479467762.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:04:08PM -0700, Darrick J. Wong wrote:
> Plumb in the upper level interface to schedule and finish deferred
> refcount operations via the deferred ops mechanism.
> 
> [Plumb in refcount deferred op log items.]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Shouldn't we try to shared xfs_trans_refcount.c instead?
