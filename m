Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58684 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfBTPAU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 10:00:20 -0500
Date: Wed, 20 Feb 2019 16:00:19 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] xfs: introduce an always_cow mode
Message-ID: <20190220150019.GB27724@lst.de>
References: <20190218091827.12619-1-hch@lst.de> <20190218091827.12619-9-hch@lst.de> <20190219052545.GG32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219052545.GG32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

[fullquote deleted, please follow email ettiquette]

On Mon, Feb 18, 2019 at 09:25:45PM -0800, Darrick J. Wong wrote:
> >  
> > +bool
> > +xfs_inode_need_cow(
> 
> xfs_inode_trim_to_cow() ?
> 
> Otherwise generally looks ok to me, but it's late so I'll send this now
> and get back to review in the morning.

Hmm, that name seems even more confusing than the original one.  But
I don't have any better suggestion.
