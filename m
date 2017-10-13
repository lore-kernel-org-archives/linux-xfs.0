Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbdJMACS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 20:02:18 -0400
Date: Fri, 13 Oct 2017 02:02:16 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <20171013000216.GD8049@wotan.suse.de>
References: <20171010021949.GB8049@wotan.suse.de>
 <a0eaaf24-75cf-19c4-c287-2445eae6fc70@sandeen.net>
 <20171010040736.GY7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010040736.GY7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, gfigueira@suse.com, tetsuya.inoue@suse.com

On Mon, Oct 09, 2017 at 09:07:36PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 09, 2017 at 10:07:12PM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 10/9/17 9:19 PM, Luis R. Rodriguez wrote:
> > > What ever happened to this patch [0]? It was ACKed [1] 
> > 
> > (it was reviewed-by hch)
> > 
> > > but I haven't
> > > seen it merged. Did it fall through the cracks?
> > 
> > Seems like it, possibly because I sent V2 as a re:, accidentally.
> 
> <grumble>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

If we're going to add this shouldn't we then also have checks for
xfs_btree_get_bufl() calls?

  Luis
