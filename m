Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932838AbdCaMNq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 08:13:46 -0400
Date: Fri, 31 Mar 2017 20:13:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests: Add first statx test
Message-ID: <20170331121342.GN22845@eguan.usersys.redhat.com>
References: <20170331101941.GL22845@eguan.usersys.redhat.com>
 <15267.1490891560@warthog.procyon.org.uk>
 <14231.1490961943@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14231.1490961943@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org

On Fri, Mar 31, 2017 at 01:05:43PM +0100, David Howells wrote:
> Eryu Guan <eguan@redhat.com> wrote:
> 
> > _require_scratch is not called, but in the test $SCRATCH_MNT is used. So
> > you need to either call "_require_scratch" here or use $TEST_DIR in the
> > test. For this statx(2) test, I think test in $TEST_DIR would be
> > sufficient.
> 
> SCRATCH is cleaned between runs of ./check, but not this isn't so for TEST,
> right?
> 
> David

Yes, TEST_DEV is supposed to be aging across tests, while SCRATCH_DEV is
re-created in tests. But you need to clean it explicitly in the test by
calling _scratch_mkfs, then mount it beforing writing anything to
$SCRATCH_MNT.

So the usual steps to use SCRATCH_DEV/SCRATCH_MNT is:

# this makes sure we have SCRATCH_DEV/MNT configured and unmounts it
# if SCRATCH_DEV is still mounted, so you don't need to unmount it
_require_scratch

# create filesystem on SCRATCH_DEV and mount it at SCRATCH_MNT
_scratch_mkfs
_scratch_mount
...
# then you can write to SCRATCH_MNT
$XFS_IO_PROG -fc "pwrite 0 1M" $SCRATCH_MNT/testfile

Thanks,
Eryu
