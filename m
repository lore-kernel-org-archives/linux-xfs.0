Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DDDB7CA3
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 20:33:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F290CAC004
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 18:33:17 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id IsDbm5gIiQoFdFfq
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 18:33:15 -0700 (PDT)
Received: from mail-yw0-f172.google.com ([209.85.161.172])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1akiWw-0002rk-3D
	for xfs@oss.sgi.com; Tue, 29 Mar 2016 01:33:14 +0000
Received: by mail-yw0-f172.google.com with SMTP id g127so1699018ywf.2
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 18:33:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
Date: Tue, 29 Mar 2016 09:33:13 +0800
Message-ID: <CACVXFVPABFW=dnv_g6noXg5w-sdTTBxaickn8HSLSCd8KJcd0A@mail.gmail.com>
Subject: Re: [PATCH 0/8] block: prepare for multipage bvecs
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
To: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Tue, Mar 22, 2016 at 2:12 PM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> Interests[1] have been shown in multipage bvecs, so this patchset
> try to prepare for the support and do two things:
>
> 1) the 1st 4 patches use bvec iterator to implement iterate_bvec(),
> then we can drop the non-standard way for iterating bvec
>
> 2) remove BIO_MAX_SECTORS & BIO_MAX_SIZE, and now there is only
> one user for each. Once multipage bvecs is introduced, one bio
> may hold lots of sectors, and we should always use sort of BIO_MAX_VECS
> which should be introduced in future and is similiar with current
> BIO_MAX_PAGES.
>
> xfstests(-a auto) have been run and no regression found by this
> patchset against linus v4.5+.

Hi Jens,

Looks no one objects this patchset, and the change of iov_iter.c
is a good cleanup too, so what do you think of the patchset?

Thanks,
Ming

>
>  drivers/block/drbd/drbd_int.h |  4 +--
>  fs/xfs/xfs_buf.c              |  2 +-
>  include/linux/bio.h           | 55 +------------------------------
>  include/linux/blk_types.h     |  4 +--
>  include/linux/bvec_iter.h     | 77 +++++++++++++++++++++++++++++++++++++++++++
>  lib/iov_iter.c                | 31 +++++++----------
>  6 files changed, 94 insertions(+), 79 deletions(-)
>
>
> [1], http://marc.info/?w=2&r=1&s=++[LSF%2FMM+ATTEND]+block%3A+multipage+bvecs&q=t
>
>
> Thanks,
> Ming
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
