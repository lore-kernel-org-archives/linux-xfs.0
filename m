Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42961 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754024AbcI3HYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:24:41 -0400
Date: Fri, 30 Sep 2016 00:24:40 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 19/63] xfs: create bmbt update intent log items
Message-ID: <20160930072440.GA13587@infradead.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520485900.29434.2840092953627910158.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520485900.29434.2840092953627910158.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 29, 2016 at 08:07:39PM -0700, Darrick J. Wong wrote:
> Create bmbt update intent/done log items to record redo information in
> the log.  Because we roll transactions multiple times for reflink
> operations, we also have to track the status of the metadata updates
> that will be recorded in the post-roll transactions in case we crash
> before committing the final transaction.  This mechanism enables log
> recovery to finish what was already started.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but the amount of boilerplate code we add for each log item really
worries me.  We should think of a way to avoid all that code
duplication.

