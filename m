Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 10:08:38 -0800 (PST)
Received: from fieldses.org (mail.fieldses.org [66.93.2.214])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEI8Y5R030302
	for <linux-xfs@oss.sgi.com>; Wed, 14 Nov 2007 10:08:35 -0800
Date: Wed, 14 Nov 2007 13:08:38 -0500
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114180838.GE14254@fieldses.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org> <20071114173922.GC14254@fieldses.org> <20071114174419.GA15271@infradead.org> <20071114175322.GD14254@fieldses.org> <20071114180241.GA16656@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114180241.GA16656@infradead.org>
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Wed, Nov 14, 2007 at 06:02:41PM +0000, Christoph Hellwig wrote:
> On Wed, Nov 14, 2007 at 12:53:22PM -0500, J. Bruce Fields wrote:
> > On Wed, Nov 14, 2007 at 05:44:19PM +0000, Christoph Hellwig wrote:
> > > On Wed, Nov 14, 2007 at 12:39:22PM -0500, J. Bruce Fields wrote:
> > > > This must have come up before; feel free to remind me: is there any way
> > > > to make the interface easier to use?  (E.g. would it help if the filldir
> > > > callback could be passed a dentry?)
> > > 
> > > The best thing for the filesystem would be to have a readdirplus
> > > (or have it folded into readdir) instead of calling into lookup
> > > from ->filldir.
> > 
> > And the readdirplus would pass a dentry to its equivalent of ->filldir?
> > Or something else?
> 
> Personally I'd prefer it to only grow a struct stat or rather it's members
> But the nfsd code currently expects a dentry so this might require some
> major refactoring.

Well, we need to check for mountpoints, for example, so I don't see any
way out of needing a dentry.  What's the drawback?

--b.
