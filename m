Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdFAEHf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 00:07:35 -0400
Date: Thu, 1 Jun 2017 12:07:33 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] xfs: fix installation for extended output files
Message-ID: <20170601040733.GW23805@eguan.usersys.redhat.com>
References: <20170601025327.GU23805@eguan.usersys.redhat.com>
 <1496286073-23298-1-git-send-email-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496286073-23298-1-git-send-email-yangx.jy@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 01, 2017 at 11:01:13AM +0800, Xiao Yang wrote:
> The installation of these extended output files are skipped
> because they aren't matched by xfstests.  So we rename them
> to adapt building rules.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

This patch is 2.4M in size, no wonder it didn't hit the list..

(cc linux-xfs list for these xfs specific tests)

> ---
>  tests/xfs/018                         |    8 +-
>  tests/xfs/018.op.irix                 | 5628 ---------------------------------
>  tests/xfs/018.op.linux                | 4714 ---------------------------
>  tests/xfs/018.out.irix                | 5628 +++++++++++++++++++++++++++++++++
>  tests/xfs/018.out.linux               | 4714 +++++++++++++++++++++++++++
>  tests/xfs/018.out.trans_buf           | 1821 +++++++++++
>  tests/xfs/018.out.trans_inode         | 2609 +++++++++++++++
>  tests/xfs/018.trans_buf               | 1821 -----------
>  tests/xfs/018.trans_inode             | 2609 ---------------

xfs/018 081 and 082 are all marked as 'deprecated', I'm wondering if we
can just remove them.

>  tests/xfs/040                         |    4 +-
>  tests/xfs/040.good                    |   16 -
>  tests/xfs/040.out.good                |   16 +

xfs/040 is doing source code diff between userspace vs kernel space, I'm
not sure if this is still needed. But xfs/040 requires KWORKAREA points
to a directory that contains both userspace and kernel code, I suspect
it's rarely run.

>  tests/xfs/081                         |    2 +-
>  tests/xfs/081.out.ugquota.trans_inode | 3091 ++++++++++++++++++
>  tests/xfs/081.ugquota.trans_inode     | 3091 ------------------
>  tests/xfs/082                         |    8 +-
>  tests/xfs/082.op.irix                 | 5628 ---------------------------------
>  tests/xfs/082.op.linux                | 4714 ---------------------------
>  tests/xfs/082.out.irix                | 5628 +++++++++++++++++++++++++++++++++
>  tests/xfs/082.out.linux               | 4714 +++++++++++++++++++++++++++
>  tests/xfs/082.out.trans_buf           | 1821 +++++++++++
>  tests/xfs/082.out.trans_inode         | 2609 +++++++++++++++
>  tests/xfs/082.trans_buf               | 1821 -----------
>  tests/xfs/082.trans_inode             | 2609 ---------------
>  24 files changed, 32662 insertions(+), 32662 deletions(-)

Thanks,
Eryu
