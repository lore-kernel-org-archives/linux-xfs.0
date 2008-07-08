Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 01:02:09 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6881htK009670
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 01:01:45 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3BFD1889C32
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 01:02:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id J2CqmH622pIkqeUh for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 01:02:47 -0700 (PDT)
Date: Tue, 8 Jul 2008 04:02:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove INT_GET and friends
Message-ID: <20080708080247.GA13762@infradead.org>
References: <47FF794C.4020801@sandeen.net> <4872D96A.7070703@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4872D96A.7070703@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 07, 2008 at 10:05:14PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Thanks to hch's endian work, INT_GET etc are no longer used,
> > and may as well be removed.  INT_SET is still used in
> > the acl code, though.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> > ---
> > 
> >  xfs_arch.h |   68 ---------------------------------
> >  1 files changed, 68 deletions(-)
> > 
> 
> Ping?  these are just unused macros.

You might want to wait until the generic ACL code goes in, because then
we can kill the remaining macros, too.  Or just put this in now, I don't
really care :)
