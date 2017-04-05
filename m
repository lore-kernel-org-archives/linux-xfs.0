Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932105AbdDELKu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 07:10:50 -0400
Date: Wed, 5 Apr 2017 19:10:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: Should xfstest generic/388 be using _require_command for
 fsstress?
Message-ID: <20170405111048.GB22845@eguan.usersys.redhat.com>
References: <20170405104205.GZ22845@eguan.usersys.redhat.com>
 <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk>
 <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
 <2718.1491389955@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2718.1491389955@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: bfoster@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Apr 05, 2017 at 11:59:15AM +0100, David Howells wrote:
> | 388:45:	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> | 388:58:_require_command "$KILLALL_PROG" "killall"
> | 388:79:		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> 
> Should this be using _require_command for fsstress and $FSSTRESS_PROG like the
> other tests that use fsstress?

fsstress is a bit special, it's mandatory for xfstests, it's checked in
common/config

[ ! -x $FSSTRESS_PROG ] && _fatal "fsstress not found or executable"

(Perhaps we should treat fsstress just as other test binaries, but it's
been this way since the beginning of xfstests.)

And generic/388 does invoke fsstress by calling $FSSTRESS_PROG, but not
necessary in this killall case.

We define NAME_PROG variables mainly for doing tweeks easily in this
variable, like adding an option globally. Take $XFS_IO_PROG as an
example in init_rc.

        # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io                                                                                                             
        $XFS_IO_PROG -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \                                                                                                       
                export XFS_IO_PROG="$XFS_IO_PROG -F"

> 
> Also, should 388 be printing "Silence is golden" at the end of the test?

Yes, and it does print this message, but in the middle of test, not end.

Thanks,
Eryu
