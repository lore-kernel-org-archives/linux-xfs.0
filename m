Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:33929 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfCYG4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Mar 2019 02:56:04 -0400
Received: by mail-yw1-f66.google.com with SMTP id x129so5490892ywc.1
        for <linux-xfs@vger.kernel.org>; Sun, 24 Mar 2019 23:56:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com>
 <20190325001044.GA23020@dastard> <20190325065155.GA21259@lst.de>
In-Reply-To: <20190325065155.GA21259@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 25 Mar 2019 08:55:52 +0200
Message-ID: <CAOQ4uxjpqDQP2AKA8Hrt4jDC65cTo4QdYDOKFE-C3cLxBBa6pQ@mail.gmail.com>
Subject: Re: [QUESTION] Long read latencies on mixed rw buffered IO
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Mar 25, 2019 at 8:52 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Mar 25, 2019 at 11:10:44AM +1100, Dave Chinner wrote:
> > That's one part of it. The other is POSIX atomic write semantics.
> >
> > https://pubs.opengroup.org/onlinepubs/009695399/functions/read.html
> >
> > "I/O is intended to be atomic to ordinary files and pipes and FIFOs.
> > Atomic means that all the bytes from a single operation that started
> > out together end up together, without interleaving from other I/O
> > operations."
> >
> > i.e. that independent read()s should see a write() as a single
> > atomic change. hence if you do a read() concurrently with a write(),
> > the read should either run to completion before the write, or the
> > write run to completion before the read().
> >
> > XFS is the only linux filesystem that provides this behaviour.
>
> I don't think that is entirely true.  ocfs2 and gfs2 also took
> a cluster wide shared lock in read last time I looked, and of
> course we do the right thing when using DAX for all supported
> file systems.

It's true. XFS is the only one to take i_rwsem.
ocfs2, cifs have cluster wide (or strict) shared lock in certain modes,
(not unconditionally), but that is understandable because they don't
have the page lock across all nodes or to guaranty client cache coherency.

Thanks,
Amir.
