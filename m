Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51548 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933132AbdAJEwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 23:52:34 -0500
Date: Mon, 9 Jan 2017 20:52:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 7/7] xfs/ext4: check negative inode size
Message-ID: <20170110045229.GD3732@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357832063.7677.12994144585642711957.stgit@birch.djwong.org>
 <20170109205518.GF14033@birch.djwong.org>
 <20170110044023.GK1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170110044023.GK1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jan 10, 2017 at 12:40:23PM +0800, Eryu Guan wrote:
> On Mon, Jan 09, 2017 at 12:55:18PM -0800, Darrick J. Wong wrote:
> > Craft a malicious filesystem image with a negative inode size,
> > then try to trigger a kernel DoS by appending data to the file.
> > Ideally this should trigger verifier errors instead of hanging.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: use $DEBUGFS_PROG instead of debugfs; improve documentation
> 
> Thanks for all the updated patches! I fixed a minor typo locally and
> committed.
> 
> > diff --git a/tests/shared/401 b/tests/shared/401
> > new file mode 100755
> > index 0000000..7b61cbb
> > --- /dev/null
> > +++ b/tests/shared/401
> > @@ -0,0 +1,77 @@
> > +#! /bin/bash
> > +# FSQA Test No. 401
> > +#
> > +# Since loff_t is a signed type, it is invalid for a filesystem to load
> > +# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
> > +# which means that we can trivially DoS the VFS by creating such a file
> > +# and appending to it.  This causes an integer overflow in the routines
> > +# underlying writeback, which results in the kernel locking up.
> > +#
> > +# So, create this malformed inode and try a buffered dio append to make
>                                                ^^^^^^^^
> I removed the "buffered" here and from xfs/401.

D'oh!!!  Thanks for fixing that.

--D

> 
> Thanks,
> Eryu
