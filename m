Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30730 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbcI3RZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:25:30 -0400
Date: Fri, 30 Sep 2016 10:24:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/63] xfs: create bmbt update intent log items
Message-ID: <20160930172458.GK14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520485900.29434.2840092953627910158.stgit@birch.djwong.org>
 <20160930072440.GA13587@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930072440.GA13587@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:24:40AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 08:07:39PM -0700, Darrick J. Wong wrote:
> > Create bmbt update intent/done log items to record redo information in
> > the log.  Because we roll transactions multiple times for reflink
> > operations, we also have to track the status of the metadata updates
> > that will be recorded in the post-roll transactions in case we crash
> > before committing the final transaction.  This mechanism enables log
> > recovery to finish what was already started.
> 
> Looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> but the amount of boilerplate code we add for each log item really
> worries me.  We should think of a way to avoid all that code
> duplication.

Yeah, the boilerplate both here and especially for btree rebuilding in
xfs_repair phase 5 worry me.  I've heard chatter about creating another
redo item type to handle directory parent pointers; that's probably a
good time to refactor the log item things.

Not sure about repair, maybe that's tackleable as part of xfsprogs 4.9.

--D
