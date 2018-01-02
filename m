Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36569 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751183AbeABRBK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jan 2018 12:01:10 -0500
Date: Tue, 2 Jan 2018 18:01:07 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 01/19] fs: new API for handling inode->i_version
Message-ID: <20180102170107.GC4911@quack2.suse.cz>
References: <20171222120556.7435-1-jlayton@kernel.org>
 <20171222120556.7435-2-jlayton@kernel.org>
 <87zi6a73ud.fsf@notabene.neil.brown.name>
 <1513986897.21071.2.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513986897.21071.2.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: NeilBrown <neil@brown.name>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Fri 22-12-17 18:54:57, Jeff Layton wrote:
> On Sat, 2017-12-23 at 10:14 +1100, NeilBrown wrote:
> > > +#include <linux/fs.h>
> > > +
> > > +/*
> > > + * The change attribute (i_version) is mandated by NFSv4 and is mostly for
> > > + * knfsd, but is also used for other purposes (e.g. IMA). The i_version must
> > > + * appear different to observers if there was a change to the inode's data or
> > > + * metadata since it was last queried.
> > > + *
> > > + * It should be considered an opaque value by observers. If it remains the same
> > 
> >                                  ^^^^^^^^^^^^
> > 
> > You keep using that word ... I don't think it means what you think it
> > means.
> > Change that sentence to:
> > 
> >     Observers see i_version as a 64 number which never decreases.
> > 
> > and the rest still makes perfect sense.
> > 
> 
> Thanks! Fixed in my tree. I'll not resend the set just for that though.

With this fixed the patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
