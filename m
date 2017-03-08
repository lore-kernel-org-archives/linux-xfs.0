Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752882AbdCHDbv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 22:31:51 -0500
Date: Wed, 8 Mar 2017 11:29:56 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954
 iomap_dio_rw+0x39a/0x3b0
Message-ID: <20170308032956.GX14226@eguan.usersys.redhat.com>
References: <1488922559.3877.6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1488922559.3877.6.camel@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

Hi Jeff,

On Tue, Mar 07, 2017 at 04:35:59PM -0500, Jeff Layton wrote:
> I was doing an xfstests run on xfs with v4.11.0-rc1, and these two
> warnings popped. Looks like invalidate_inode_pages2_range failed? A
> small patch to print the error there showed that it was returning
> -EBUSY.
> 
> Pretty easy to reproduce by running xfstests generic/095 on a KVM guest
> running v4.11.0-rc1.
> 
> [  591.302422] run fstests generic/095 at 2017-03-07 15:38:32
> [  591.452226] XFS (vda6): Unmounting Filesystem
> [  591.825895] XFS (vda6): Mounting V5 Filesystem
> [  591.841560] XFS (vda6): Ending clean mount
> [  592.127155] ------------[ cut here ]------------
> [  592.133775] WARNING: CPU: 2 PID: 20539 at fs/iomap.c:954 iomap_dio_rw+0x39a/0x3b0

and

> [  592.202828] WARNING: CPU: 0 PID: 20540 at fs/iomap.c:896 iomap_dio_rw+0x1b1/0x3b0

IIRC, these warnings are kind of "known issue", they're filtered out by
generic/095 and should not cause the test to fail. You can check the
comments before filter_xfs_dmesg() function in generic/095 test.

Did generic/095 fail for you due to dmesg check? If so I think there
might be an fstests bug. My generic/095 run on 4.11-rc1 kernel triggered
these warnings too, but test itself didn't report failure.

Thanks,
Eryu
