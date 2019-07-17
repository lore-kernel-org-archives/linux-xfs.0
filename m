Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfGQOxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 10:53:47 -0400
Date: Wed, 17 Jul 2019 07:53:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] iomap: move the SEEK_HOLE code into a separate file
Message-ID: <20190717145335.GD7093@magnolia>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321358581.148361.8774330141606166898.stgit@magnolia>
 <20190717050118.GD7113@infradead.org>
 <CAHc6FU7A3U1FZXwXfvJRL1FazUu=zfJ4=AwpggNG5QWvsywt2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU7A3U1FZXwXfvJRL1FazUu=zfJ4=AwpggNG5QWvsywt2A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jul 17, 2019 at 02:44:20PM +0200, Andreas Gruenbacher wrote:
> On Wed, 17 Jul 2019 at 07:01, Christoph Hellwig <hch@infradead.org> wrote:
> > > diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> > > new file mode 100644
> > > index 000000000000..0c36bef46522
> > > --- /dev/null
> > > +++ b/fs/iomap/seek.c
> > > @@ -0,0 +1,214 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/*
> > > + * Copyright (C) 2010 Red Hat, Inc.
> > > + * Copyright (c) 2016-2018 Christoph Hellwig.
> > > + */
> >
> > This looks a little odd.  There is nothing in here from Daves original
> > iomap prototype.  It did start out with code from Andreas though which
> > might or might not be RH copyright.  So we'll need Andreas and/or RH
> > legal to chime in.
> 
> That code should be Copyright (C) 2017 Red Hat, Inc.

Ok, fixed.

--D

> > Otherwise looks good:
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks,
> Andreas
