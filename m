Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35427 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390492AbfFKFo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 01:44:56 -0400
MIME-Version: 1.0
References: <20190610172606.4119-1-amir73il@gmail.com> <20190611011612.GQ1871505@magnolia>
 <20190611025108.GB2774@mit.edu> <20190611032926.GA1872778@magnolia>
In-Reply-To: <20190611032926.GA1872778@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 11 Jun 2019 08:44:43 +0300
Message-ID: <CAOQ4uxgAgKhp55VGzBZ=ODKg5ztbJCB+WiFceXZjvw9=ecPdGw@mail.gmail.com>
Subject: Re: [PATCH] vfs: allow copy_file_range from a swapfile
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

On Tue, Jun 11, 2019 at 6:29 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Mon, Jun 10, 2019 at 10:51:08PM -0400, Theodore Ts'o wrote:
> > On Mon, Jun 10, 2019 at 06:16:12PM -0700, Darrick J. Wong wrote:
> > > On Mon, Jun 10, 2019 at 08:26:06PM +0300, Amir Goldstein wrote:
> > > > read(2) is allowed from a swapfile, so copy_file_range(2) should
> > > > be allowed as well.
> > > >
> > > > Reported-by: Theodore Ts'o <tytso@mit.edu>
> > > > Fixes: 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Darrick,
> > > >
> > > > This fixes the generic/554 issue reported by Ted.
> > >
> > > Frankly I think we should go the other way -- non-root doesn't get to
> > > copy from or read from swap files.
> >
> > The issue is that without this patch, *root* doesn't get to copy from
> > swap files.  Non-root shouldn't have access via Unix permissions.  We
>
> I'm not sure even root should have that privilege - it's a swap file,
> and until you swapoff, it's owned by the kernel and we shouldn't let
> backup programs copy your swapped out credit card numbers onto tape.
>

I am not a security expert and I do not want to be, but I believe it's
better to have a complete security model before plugging random
"security holes".

That said. I don't have a strong feeling about allowing copy_file_range
from swap file. If someone complains and they have a valid use case,
we can always relax it then.

Anyway, as you saw, I removed the test case from xfstest, leaving
the behavior (as far as the testsuite cares) undefined.

Thanks,
Amir.
