Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 07:37:05 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALFasZE011719
	for <linux-xfs@oss.sgi.com>; Wed, 21 Nov 2007 07:36:55 -0800
Date: Wed, 21 Nov 2007 15:07:46 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071121150746.GB8454@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org> <20071114173922.GC14254@fieldses.org> <20071114174419.GA15271@infradead.org> <20071114175322.GD14254@fieldses.org> <20071114180241.GA16656@infradead.org> <20071114180838.GE14254@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114180838.GE14254@fieldses.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Nov 14, 2007 at 01:08:38PM -0500, J. Bruce Fields wrote:
> > Personally I'd prefer it to only grow a struct stat or rather it's members
> > But the nfsd code currently expects a dentry so this might require some
> > major refactoring.
> 
> Well, we need to check for mountpoints, for example, so I don't see any
> way out of needing a dentry.  What's the drawback?

You're right - we'd probably need the dentry.  The drawback is that
we need to always get it in the dcache.  Which might be a good thing
depending on the workload.
