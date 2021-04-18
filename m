Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80569C433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 14:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F951610E7
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 14:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhDROot (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 10:44:49 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35185 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231689AbhDROor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 10:44:47 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 13IEi8Hg021641
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Apr 2021 10:44:08 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3C49915C3B0D; Sun, 18 Apr 2021 10:44:08 -0400 (EDT)
Date:   Sun, 18 Apr 2021 10:44:08 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eryu Guan <guan@eryu.me>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/9] common/dmthin: make this work with external log
 devices
Message-ID: <YHxFuFvbAiiIrbIo@mit.edu>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230182.2754991.16864806174255630147.stgit@magnolia>
 <YHwlTMySYgKuaw6Y@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHwlTMySYgKuaw6Y@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 18, 2021 at 08:25:48PM +0800, Eryu Guan wrote:
> > diff --git a/tests/generic/223 b/tests/generic/223
> > index 1f85efe5..a5ace82f 100755
> > --- a/tests/generic/223
> > +++ b/tests/generic/223
> > @@ -43,6 +43,9 @@ for SUNIT_K in 8 16 32 64 128; do
> >  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
> >  	_scratch_mount
> >  
> > +	# Make sure everything is on the data device
> > +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> 
> What does this do for non-xfs filesystems? Do we need a FSTYP check and
> do chattr only on XFS?

This clears the FS_NOTAIL_FL flag, which prevents tail merging, on the
root directory of the mounted scratch file system.  That should be
harmless on non-xfs file systems; in fact, the only file system that
even uses NOTAIL_FL flag is reiserfs, and the NOTAIL_FL flag is not
set by default on the root directory of a newly created reiserfs file
system.

However, by default reiserfs does not support the
FS_IOC_{GET,SET}FLAGS ioctl unless the mount option "attrs" is given.
Why, I have no idea:

root@kvm-xfstests:~# mount -t reiserfs /vtmp/foo.img /mnt
root@kvm-xfstests:~# xfs_io -c 'chattr -t' /mnt
xfs_io: cannot get flags on /mnt: Inappropriate ioctl for device

So it might be a good idea to redirect stderr for the xfs_io
invocation to /dev/null, for those file systems which do not support
the FS_IOC_{GET,SET}FLAGS ioctls.

I also have no idea why this helps for xfs --- I would think it's a
no-op, but I'm guessing there's some magical side-effect which is
taking place when FS_IOC_SETFLAGS ioctl is processed?  Maybe it would
be worth a comment explaining what is going on --- and whether this is
going to make any difference if the patch series which unifies
FS_IOC_{GETSET}FLAGS handling is merged?

						- Ted
