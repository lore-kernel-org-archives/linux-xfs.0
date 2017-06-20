Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbdFTJGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2017 05:06:18 -0400
Date: Tue, 20 Jun 2017 02:06:07 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't crash on unexpected holes in dir/attr btrees
Message-ID: <20170620090607.GD15374@infradead.org>
References: <20170616175337.GE5421@birch.djwong.org>
 <351d0c66-4969-7ce9-da9c-6d2901e1bdef@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <351d0c66-4969-7ce9-da9c-6d2901e1bdef@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, list@jonas-server.de, David Shaw <dshaw@jabberwocky.com>, Emmanuel Florac <eflorac@intellique.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 01:12:41PM -0500, Eric Sandeen wrote:
> On 6/16/17 12:53 PM, Darrick J. Wong wrote:
> > Hi all,
> > 
> > So I /think/ the xfs_attr_inactive crashes that both of you have been
> > seeing are a result of XFS assuming that there aren't ever any mapping
> > holes in the extended attribute fork and crashing when it tries to
> > grab a buffer for the hole and fails to notice that holes don't have
> > buffers.  This lightly tested patch gets rid of /that/ problem.
> > 
> > So, if you're willing, can you try this out and see if the crashes go
> > away?  Granted, this might only enable us to lurch on whatever's next...
> 
> If it's unexpected, does that mean something else is wrong?  If so,
> should there be a warning or a corrupted state, or anything like that?

xfs_attr_rmtval_remove certainly removes blocks from the attr mapping,
but those should be expected..
