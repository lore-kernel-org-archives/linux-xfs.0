Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933224AbdJXN1Q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 09:27:16 -0400
Date: Tue, 24 Oct 2017 15:27:13 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171024132713.GD8556@quack2.suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-19-jack@suse.cz>
 <20171020214753.GA15733@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171020214753.GA15733@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org

On Fri 20-10-17 15:47:53, Ross Zwisler wrote:
> On Thu, Oct 19, 2017 at 02:58:17PM +0200, Jan Kara wrote:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  man2/mmap.2 | 30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> > 
> > diff --git a/man2/mmap.2 b/man2/mmap.2
> > index 47c3148653be..598ff0c64f7f 100644
> > --- a/man2/mmap.2
> > +++ b/man2/mmap.2
> > @@ -125,6 +125,21 @@ are carried through to the underlying file.
> >  to the underlying file requires the use of
> >  .BR msync (2).)
> >  .TP
> > +.B MAP_SHARED_VALIDATE
> > +The same as
> > +.B MAP_SHARED
> > +except that
> > +.B MAP_SHARED
> > +mappings ignore unknown flags in
> > +.IR flags .
> > +In contrast when creating mapping of
> > +.B MAP_SHARED_VALIDATE
> > +mapping type, the kernel verifies all passed flags are known and fails the
> > +mapping with
> > +.BR EOPNOTSUPP
> > +otherwise. This mapping type is also required to be able to use some mapping
> > +flags.
> > +.TP
> 
> Some small nits:
> 
> I think you should maybe include a "(since Linux 4.15)" type note after the
> MAP_SHARED_VALIDATE header.  You also need to update the following line:
> 
>        Both of these flags are described in POSIX.1-2001 and POSIX.1-2008.
> 
> Which used to refer to MAP_SYNC and MAP_PRIVATE.

Thanks, I've fixed these.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
