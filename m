Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48576 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753119AbdKAPBh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Nov 2017 11:01:37 -0400
Date: Wed, 1 Nov 2017 16:01:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Message-ID: <20171101150136.GA26080@lst.de>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com> <20171031003358.GD5858@dastard> <CAM_iQpUD5ffaKS7TQ5n9A67TWqrVm8AVKf6ERz3pSFu7rL2rbg@mail.gmail.com> <20171101030536.GN5858@dastard> <CAM_iQpVOmNj6aDNr-Z5owAxS0o0+1j7P3=qzzUWci0f2wVnvaw@mail.gmail.com> <20171101050701.GP5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101050701.GP5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Wed, Nov 01, 2017 at 04:07:01PM +1100, Dave Chinner wrote:
> > We are trying to make kdump working, but even if kdump works
> > we still can't turn on panic_on_warn since this is production
> > machine.
> 
> Hmmm. Ok, maybe you could leave a trace of the xfs_iget* trace
> points running and check the log tail for unusual events around the
> time of the next crash. e.g. xfs_iget_reclaim_fail events. That
> might point us to a potential interaction we can look at more
> closely. I'd also suggest slab poisoning as well, as that will
> catch other lifecycle problems that could be causing list
> corruptions such as use-after-free.

KASAN has also been really useful for these kinds of issues.
