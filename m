Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46617 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdJMHWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Oct 2017 03:22:25 -0400
Date: Fri, 13 Oct 2017 00:22:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Message-ID: <20171013072224.GG9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-18-jack@suse.cz>
 <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 03:11:21PM -0700, Dan Williams wrote:
> > +       /*
> > +        * We don't support synchronous mappings for non-DAX files. At least
> > +        * until someone comes with a sensible use case.
> > +        */
> > +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
> > +               return -EOPNOTSUPP;
> 
> Perhaps EPERM instead to differentiate the unsupported flags case?
> There's precedent for mmap returning EPERM for reasons other than
> incompatible PROT flags.

Why would we want to voluntarily use arcane errors for a entirely
new interface under our control?

-EOPNOTSUPP is nice and explicit about what is going on.
