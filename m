Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49242 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754212AbdJQSgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 14:36:12 -0400
Date: Tue, 17 Oct 2017 11:35:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <20171017183559.GD4707@magnolia>
References: <20171010021949.GB8049@wotan.suse.de>
 <a0eaaf24-75cf-19c4-c287-2445eae6fc70@sandeen.net>
 <20171010040736.GY7122@magnolia>
 <20171013000216.GD8049@wotan.suse.de>
 <20171017182728.GD17331@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171017182728.GD17331@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, gfigueira@suse.com, tetsuya.inoue@suse.com

On Tue, Oct 17, 2017 at 08:27:28PM +0200, Luis R. Rodriguez wrote:
> On Fri, Oct 13, 2017 at 02:02:16AM +0200, Luis R. Rodriguez wrote:
> > On Mon, Oct 09, 2017 at 09:07:36PM -0700, Darrick J. Wong wrote:
> > > On Mon, Oct 09, 2017 at 10:07:12PM -0500, Eric Sandeen wrote:
> > > > 
> > > > 
> > > > On 10/9/17 9:19 PM, Luis R. Rodriguez wrote:
> > > > > What ever happened to this patch [0]? It was ACKed [1] 
> > > > 
> > > > (it was reviewed-by hch)
> > > > 
> > > > > but I haven't
> > > > > seen it merged. Did it fall through the cracks?
> > > > 
> > > > Seems like it, possibly because I sent V2 as a re:, accidentally.
> > > 
> > > <grumble>
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If we're going to add this shouldn't we then also have checks for
> > xfs_btree_get_bufl() calls?
> 
> *re-poke*

AFAICT the two callers of xfs_btree_get_bufl already checked that the
incoming argument isn't NULLFSBLOCK, and (at least in theory) the bnobt
shouldn't have freespace records extending outside the filesystem.

That said, new patches accepted. ;)

--D

> 
>   Luis
