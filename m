Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38422 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfGQMoc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jul 2019 08:44:32 -0400
Received: by mail-ot1-f66.google.com with SMTP id d17so24875184oth.5
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jul 2019 05:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
 <156321358581.148361.8774330141606166898.stgit@magnolia> <20190717050118.GD7113@infradead.org>
In-Reply-To: <20190717050118.GD7113@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 17 Jul 2019 14:44:20 +0200
Message-ID: <CAHc6FU7A3U1FZXwXfvJRL1FazUu=zfJ4=AwpggNG5QWvsywt2A@mail.gmail.com>
Subject: Re: [PATCH 4/9] iomap: move the SEEK_HOLE code into a separate file
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, 17 Jul 2019 at 07:01, Christoph Hellwig <hch@infradead.org> wrote:
> > diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
> > new file mode 100644
> > index 000000000000..0c36bef46522
> > --- /dev/null
> > +++ b/fs/iomap/seek.c
> > @@ -0,0 +1,214 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2010 Red Hat, Inc.
> > + * Copyright (c) 2016-2018 Christoph Hellwig.
> > + */
>
> This looks a little odd.  There is nothing in here from Daves original
> iomap prototype.  It did start out with code from Andreas though which
> might or might not be RH copyright.  So we'll need Andreas and/or RH
> legal to chime in.

That code should be Copyright (C) 2017 Red Hat, Inc.

> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,
Andreas
