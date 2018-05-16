Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38512 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeEPQ0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 12:26:16 -0400
Received: by mail-pl0-f65.google.com with SMTP id c11-v6so725908plr.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 May 2018 09:26:16 -0700 (PDT)
Date: Wed, 16 May 2018 09:26:14 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516162614.GB14174@vader>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
 <20180516162329.GA21071@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516162329.GA21071@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>

On Wed, May 16, 2018 at 09:23:29AM -0700, Christoph Hellwig wrote:
> >  
> > -	/* Skip holes. */
> > +	/* No holes. */
> >  	if (iomap->type == IOMAP_HOLE)
> > -		goto out;
> > +		goto err;
> 
> If we end up not allowing holes this check can just be removed
> entirely.  We already check for the allow types below.  I have to
> admit I would move that type check above the bdev check, though.

True, although I wonder if we should be logging more specific error
messages instead of a generic "not a valid swap file" message. At least
for my Btrfs patches, that's what I do. I'll send a v2 with a second
patch doing that.
