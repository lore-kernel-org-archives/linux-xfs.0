Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45080 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbcLIRlr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Dec 2016 12:41:47 -0500
Date: Fri, 9 Dec 2016 18:41:45 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
        selecting an AG
Message-ID: <20161209174145.GA15960@lst.de>
References: <1481303709-12632-1-git-send-email-hch@lst.de> <20161209173213.GZ16813@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161209173213.GZ16813@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com

On Fri, Dec 09, 2016 at 09:32:13AM -0800, Darrick J. Wong wrote:
> > +	if (xfs_alloc_is_userdata(args->datatype))
> > +		indlen = __xfs_bmap_worst_indlen(args->mp, max(args->minlen, args->maxlen));
> 
> /me wonders, when is it the case that minlen > maxlen?

Good question.  I just added that when I noticed minlen alone doesn't
work as we might need the bigger calculation based on maxlen.  I'll
do a quick audit and move to maxlen only.

> 
> I'm also wondering why we can't just increase args->minleft to require
> that we leave enough space in whichever AG we pick to expand to bmbt?
> AFAICT that's the purpose of the minleft field.

Not sure what the original intentions was, but as-is it seems pretty
b0rked.

E.g. xfs_bmap_btalloc, xfs_bmapi_allocate or xfs_alloc_vextentjust set
minleft to 0 when when we are low on space which make it a bit pointless.

Also in the bmap code where we set minleft we don't really know how
much we'll need as we'll only decide on the actual final allocation
size deep down in the allocator.  I'll do a little archeology session
now to figure out how we got the current minleft semantics, as they seem
really weird.

> /* Make sure we leave enough space in this AG for a bmbt expansion. */

Sure.

> > +xfs_filblks_t
> > +__xfs_bmap_worst_indlen(
> > +	xfs_mount_t	*mp,		/* mount structure */
> 
> struct xfs_mount?

Yeah, minimum changes for now.  If we end up going down this route I'd
probably just always pass the mount to xfs_bmap_worst_indlen, but
I wanted the minimal amount of change for now.
