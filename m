Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:42244 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfE2QUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 12:20:38 -0400
MIME-Version: 1.0
References: <20190526061100.21761-1-amir73il@gmail.com> <20190526061100.21761-10-amir73il@gmail.com>
 <20190528164844.GJ5221@magnolia>
In-Reply-To: <20190528164844.GJ5221@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 19:20:21 +0300
Message-ID: <CAOQ4uxiWxkmvtK6qX6T5cOAFeTb3Oo9xocG+yY24RaMftnJ2tQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/8] man-pages: copy_file_range updates
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

> > +A major rework of the kernel implementation occurred in 5.3. Areas of the API
> > +that weren't clearly defined were clarified and the API bounds are much more
> > +strictly checked than on earlier kernels. Applications should target the
> > +behaviour and requirements of 5.3 kernels.
>
> Are there any weird cases where a program targetting 5.3 behavior would
> fail or get stuck in an infinite loop on a 5.2 kernel?

I don't think so. When Dave wrote this paragraph the behavior was changed
from short copy to EINVAL. That would have been a problem to maintain
old vs. new copy loops, but now the behavior  did not change in that respect.

>
> Particularly since glibc spat out a copy_file_range fallback for 2.29
> that tries to emulate the kernel behavior 100%.  It even refuses
> cross-filesystem copies (because hey, we documented that :() even though
> that's perfectly fine for a userspace implementation.
>
> TBH I suspect that we ought to get the glibc developers to remove the
> "no cross device copies" code from their implementation and then update
> the manpage to say that cross device copies are supposed to be
> supported all the time, at least as of glibc 2.(futureversion).

I don't see a problem with copy_file_range() returning EXDEV.
That is why I left EXDEV in the man page.
Tools should know how to deal with EXDEV by now.
If you are running on a new kernel, you get better likelihood
for copy_file_range() to do clone or in-kernel copy for you.

>
> Anyways, thanks for taking on the c_f_r cleanup! :)
>

Sure, get ready for another round ;-)

Thanks for the review!
Amir.
