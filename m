Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53143 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932880AbdJQLa4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 07:30:56 -0400
Date: Tue, 17 Oct 2017 13:30:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Message-ID: <20171017113052.GC24136@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-18-jack@suse.cz>
 <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com>
 <20171013072224.GG9105@infradead.org>
 <CAPcyv4g+YE4D0-_Y=yxa2s8Ns8F89=HdY=-_Pg_gYxcXtZ8tTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g+YE4D0-_Y=yxa2s8Ns8F89=HdY=-_Pg_gYxcXtZ8tTg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri 13-10-17 08:52:28, Dan Williams wrote:
> On Fri, Oct 13, 2017 at 12:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Oct 11, 2017 at 03:11:21PM -0700, Dan Williams wrote:
> >> > +       /*
> >> > +        * We don't support synchronous mappings for non-DAX files. At least
> >> > +        * until someone comes with a sensible use case.
> >> > +        */
> >> > +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
> >> > +               return -EOPNOTSUPP;
> >>
> >> Perhaps EPERM instead to differentiate the unsupported flags case?
> >> There's precedent for mmap returning EPERM for reasons other than
> >> incompatible PROT flags.
> >
> > Why would we want to voluntarily use arcane errors for a entirely
> > new interface under our control?
> >
> > -EOPNOTSUPP is nice and explicit about what is going on.
> 
> We have this general and perennial problem of parsing why the kernel
> is throwing an error. It saves a debug step if the error code is
> unique, and in this case would indicate that the filesystem supports
> MAP_SYNC but the administrator failed to arrange for the device to be
> in DAX mode.

So I understand this wish however I think the error codes should also
reflect the nature of the problem. And EPERM has something to do with access
permissions, not whether file supports DAX access or not.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
