Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 02:18:31 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA4AIP0a001629
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 02:18:27 -0800
Date: Sun, 4 Nov 2007 09:49:21 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] show all mount args in /proc/mounts
Message-ID: <20071104094921.GA14493@infradead.org>
References: <20071029233543.GQ995458@sgi.com> <20071030100617.GB23489@infradead.org> <20071102014855.GH995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102014855.GH995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Nov 02, 2007 at 12:48:55PM +1100, David Chinner wrote:
> On Tue, Oct 30, 2007 at 10:06:17AM +0000, Christoph Hellwig wrote:
> > On Tue, Oct 30, 2007 at 10:35:43AM +1100, David Chinner wrote:
> > > There are several mount options that don't show up in /proc/mounts.
> > > Add them in and clean up the showargs code at the same time.
> > 
> > Looks good.  Care to submit a patch ontop of this to move all the mount
> > option handling to xfs_super.c as it's entirely linux-specific in this
> > form?
> 
> Sure. This what you mean?

Yes, exactly.  Looks good to me.
