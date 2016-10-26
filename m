Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51041 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753777AbcJZKVt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 06:21:49 -0400
Date: Wed, 26 Oct 2016 03:21:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/39] xfs: convert RUI log formats to use variable
 length arrays
Message-ID: <20161026102147.GA29648@infradead.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743662427.11035.5343374767358259727.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147743662427.11035.5343374767358259727.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 04:03:44PM -0700, Darrick J. Wong wrote:
> Use variable length array declarations for RUI log items,
> and replace the open coded sizeof formulae with a single function.
> 
> [Fix up the logprint code to reflect the new RUI format.]

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
