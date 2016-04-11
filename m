Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8A237CA0
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 22:32:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3225AAC001
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 20:32:01 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id qUPNGOnUVQ5juVgo
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 10 Apr 2016 20:31:59 -0700 (PDT)
Received: from mail-yw0-f180.google.com ([209.85.161.180])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1apSZx-0004cx-C2
	for xfs@oss.sgi.com; Mon, 11 Apr 2016 03:31:57 +0000
Received: by mail-yw0-f180.google.com with SMTP id o66so102802122ywc.3
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 20:31:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459752994-2205-1-git-send-email-ming.lei@canonical.com>
References: <1459752994-2205-1-git-send-email-ming.lei@canonical.com>
Date: Mon, 11 Apr 2016 11:31:56 +0800
Message-ID: <CACVXFVOK7Mw7pGfT=iaUJCt=QTREfJuXuN+-beW3G-q6HF3KXA@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] block: prepare for multipage bvecs
From: Ming Lei <ming.lei@canonical.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, "open list:DRBD DRIVER" <drbd-dev@lists.linbit.com>

On Mon, Apr 4, 2016 at 2:56 PM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> Interests[1] have been shown in multipage bvecs, so this patchset
> try to prepare for the support and do two things:
>
> 1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
> then we can drop the non-standard way for iterating bvec, which
> can be thought as a good cleanup for lib/iov_iter.c
>
> 2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
> one user for each. Once multipage bvecs is introduced, one bio
> may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
> which should be introduced in future and is similiar with current
> BIO_MAX_PAGES.
>
> xfstests(-a auto) have been run and no regression found by this
> patchset against linus v4.6-rc1-next-20160329.
>
> V3:
>         - include kenrel.h & bug.h in bvec.h for fix comiling failure on arm
>         as reported by 0day ktest
>         - build test on arm & arm64
>
> V2:
>         - rename bvec_iter.h as bvec.h
>         - always include bvec.h into blk_types.h as suggested by Christoph
>
> V1:
>         - don't move BIO_MAX_* to bvec_iter.h as pointed out by Christoph
>         - run xfstests against v4.6-rc1-next-20160329
>         - add Reviewed-by
>         - for 1,4 and 5, Reviewd-by not added, Christoph still expressed
>         'this looks fine to me.'
>
>  drivers/block/drbd/drbd_int.h |  4 +-
>  fs/xfs/xfs_buf.c              |  4 +-
>  include/linux/bio.h           | 52 -----------------------
>  include/linux/blk_types.h     | 22 +---------
>  include/linux/bvec.h          | 96 +++++++++++++++++++++++++++++++++++++++++++
>  lib/iov_iter.c                | 30 +++++---------
>  6 files changed, 110 insertions(+), 98 deletions(-)

Gentle ping...

Thanks,

>
>
> Thanks,
> Ming
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
