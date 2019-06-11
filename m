Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34454 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389723AbfFKBLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 21:11:44 -0400
Date: Mon, 10 Jun 2019 18:11:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs-linux: copy-file-range-fixes updated to
 fe0da9c09b2d
Message-ID: <20190611011132.GP1871505@magnolia>
References: <20190610160624.GG1871505@magnolia>
 <CAOQ4uxhkE_TsN7XMBgzxVhEYDw+gZEOOCiZzn9otVwQtB-XHeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhkE_TsN7XMBgzxVhEYDw+gZEOOCiZzn9otVwQtB-XHeA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Anna Schumaker <Anna.Schumaker@netapp.com>, Steve French <smfrench@gmail.com>, Ilya Dryomov <idryomov@gmail.com>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org

On Mon, Jun 10, 2019 at 08:14:08PM +0300, Amir Goldstein wrote:
> +CC affected maintainers
> 
> On Mon, Jun 10, 2019 at 7:06 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Hi folks,
> >
> > The copy-file-range-fixes branch of the xfs-linux repository at:
> >
> >         git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> >
> > has just been updated.  This is a common branch from which everyone else
> > can create their own copy-file-range fix branches for 5.3.  When you
> > send your pull request to Linus please let him know that the fixes
> > stream out from here like some kind of hydra. :)
> 
> Thanks Darrick!
> Should we also request to include this branch in linux-next?

Yeah, I was going to do that after 24h (i.e. it'll be in Wednesday's
-next) to see if anyone had any last minute "ZOMG this patch has to be
changed" screaming.

> Attention nfs/cifs/fuse/ceph maintainers!
> This branch includes changes to your filesystems.
> At lease nfs/cifs/ceph have been tested with these changes and the
> new xfstests.
> 
> I think it would be preferred if you merge Darrick's branch into your
> 5.3 branch as soon as you have one ready to reduce chances of
> conflicts down the road.
> 
> I will be sending out 2 more patches to cifs/ceph, which depend on
> this branch directly to maintainers.

Noted.

--D

> Thanks,
> Amir.
