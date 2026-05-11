Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEEF37B01C
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 12:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778501410; cv=none; b=f48ymQ10gNSo/EAmfOUAAaO3Bjol2PpOmPvjfERG2KF6vrf1BgCzPur/18P5E2dfalLNqSva0L64TVEYdClsL21zjjHlYGPaHXyyitTBT2/dUQitfQBZh5wqns+ANJE7vwQVILbG6hy2CEqXMyjQGfdBV9Bzc9JMvlArMUIHwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778501410; c=relaxed/simple;
	bh=ZBJ4h5nCWBanrV2m09PbsOLPmlSGZqOJ0JeVjN3uV+4=;
	h=Date:Mime-Version:Content-Type:Message-Id:To:Subject:From:
	 References:In-Reply-To; b=GHzbYP0K55baDXJ1pLdOHOn7xIi+qunZzg9+HP1z/2gjzTFcP5OvE/4mJP73kiTp0mxvBWOGFPABf9Z9isUeU8GD6zPMAeBLpjRUhU0Lq6ht9wPJGvMVnSJ/3alurE9cgWKCpUPMz9dYJ2urWJvvlc0Ret1XB2ynEV2kLQmuXOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=RZ3JW151; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="RZ3JW151"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778501396; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ZBJ4h5nCWBanrV2m09PbsOLPmlSGZqOJ0JeVjN3uV+4=;
 b=RZ3JW151cILG3IbduLJ6woi8F2hqiFvJD6F2usKNntQ9kjY4NcahoUBGPU3kj288DVeFMT
 VS2l/+Q4/x8+lNyJXAaqDWg5lqNdXu2WLb/Dqpe5/nNl0VhvY4xO2nKiqagL+/Mm3+JA5k
 PUYh7AJ1pqqVxbktnxiTu1HoRjo0r/0Gwfdfka9d47rG/OCpRD99UXJap12PTskhu448BX
 FR7qh5hKbdcdCePp9TvBJsgf2pY0SFQBkqJJimsZ6P0G6+0hDTWKSw6mxoJn7a0Z+qmNPF
 dHcneS3fcPRUFGi1D2YFeKm/T2l1gljCPO8KhTHAi18pJUMM8aXfZ0rp3U1Gvg==
Date: Mon, 11 May 2026 20:09:51 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+16a01c712+52d5db+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.4a56b91c.8a12.4668.b740.76ff3633f48f@bytedance.com>
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>
Subject: Re: [PATCH v2] iomap: add simple read path for small direct I/O
From: "changfengnan" <changfengnan@bytedance.com>
References: <20260428114730.14384-1-changfengnan@bytedance.com>
In-Reply-To: <20260428114730.14384-1-changfengnan@bytedance.com>

Ping.

> From: "Fengnan Chang"<changfengnan@bytedance.com>
> Date:=C2=A0 Tue, Apr 28, 2026, 19:48
> Subject:=C2=A0 [PATCH v2] iomap: add simple read path for small direct I/=
O
> To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <ojas=
win@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, <linux-f=
sdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-kernel@vger.k=
ernel.org>, <lidiangang@bytedance.com>
> Cc: "Fengnan Chang"<changfengnan@bytedance.com>
> When running 4K random read workloads on high-performance Gen5 NVMe
> SSDs, the software overhead in the iomap direct I/O path
> (__iomap_dio_rw) becomes a significant bottleneck.
>=C2=A0
> Using io_uring with poll mode for a 4K randread test on a raw block
> device:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /dev/nvme10n1
> Result: ~3.2M IOPS
>=C2=A0
> Running the exact same workload on ext4 and XFS:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /mnt/testfile
> Result: ~1.84M IOPS
>=C2=A0
> Profiling the ext4 workload reveals that a significant portion of CPU
> time is spent on memory allocation and the iomap state machine
> iteration:
> =C2=A0 5.33% =C2=A0[kernel] =C2=A0[k] __iomap_dio_rw
> =C2=A0 3.26% =C2=A0[kernel] =C2=A0[k] iomap_iter
> =C2=A0 2.37% =C2=A0[kernel] =C2=A0[k] iomap_dio_bio_iter
> =C2=A0 2.35% =C2=A0[kernel] =C2=A0[k] kfree
> =C2=A0 1.33% =C2=A0[kernel] =C2=A0[k] iomap_dio_complete
>=C2=A0
> Introduce simple reads to reduce the overhead of iomap, simple read path
> is triggered when the request satisfies:
> - I/O size is <=3D inode blocksize (fits in a single block, no splits).
> - No custom `iomap_dio_ops` (dops) registered by the filesystem.
>=C2=A0
> After this optimization, the heavy generic functions disappear from the
> profile, replaced by a single streamlined execution path:
> =C2=A0 4.83% =C2=A0[kernel] =C2=A0[k] iomap_dio_simple_read
>=C2=A0
> With this patch, 4K random read IOPS on ext4 increases from 1.84M to
> 2.19M in the original single-core io_uring poll-mode workload.
>=C2=A0
> Below are the test results using fio:
>=C2=A0
> =C2=A0 fs =C2=A0 =C2=A0workload =C2=A0 =C2=A0 =C2=A0 qd =C2=A0 =C2=A0simp=
le=3D0 =C2=A0 =C2=A0 =C2=A0simple=3D1 =C2=A0 =C2=A0 =C2=A0gain
> =C2=A0 ext4 =C2=A0libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 18,7=
38 =C2=A0 =C2=A0 =C2=A0 =C2=A018,761 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.12%
> =C2=A0 ext4 =C2=A0libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 128 =C2=A0 455,383 =
=C2=A0 =C2=A0 =C2=A0 471,473 =C2=A0 =C2=A0 =C2=A0 +3.53%
> =C2=A0 ext4 =C2=A0libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 256 =C2=A0 453,273 =
=C2=A0 =C2=A0 =C2=A0 468,555 =C2=A0 =C2=A0 =C2=A0 +3.37%
> =C2=A0 ext4 =C2=A0libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 512 =C2=A0 447,320 =
=C2=A0 =C2=A0 =C2=A0 469,036 =C2=A0 =C2=A0 =C2=A0 +4.85%
> =C2=A0 ext4 =C2=A0io_uring =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 18,798 =
=C2=A0 =C2=A0 =C2=A0 =C2=A018,824 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.14%
> =C2=A0 ext4 =C2=A0io_uring =C2=A0 =C2=A0 =C2=A0 128 =C2=A0 503,834 =C2=A0=
 =C2=A0 =C2=A0 528,353 =C2=A0 =C2=A0 =C2=A0 +4.87%
> =C2=A0 ext4 =C2=A0io_uring =C2=A0 =C2=A0 =C2=A0 256 =C2=A0 503,635 =C2=A0=
 =C2=A0 =C2=A0 527,617 =C2=A0 =C2=A0 =C2=A0 +4.76%
> =C2=A0 ext4 =C2=A0io_uring =C2=A0 =C2=A0 =C2=A0 512 =C2=A0 501,802 =C2=A0=
 =C2=A0 =C2=A0 527,882 =C2=A0 =C2=A0 =C2=A0 +5.20%
> =C2=A0 ext4 =C2=A0io_uring_poll =C2=A01 =C2=A0 =C2=A0 19,246 =C2=A0 =C2=
=A0 =C2=A0 =C2=A019,270 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.12%
> =C2=A0 ext4 =C2=A0io_uring_poll =C2=A0128 =C2=A0 1,463,343 =C2=A0 =C2=A0 =
1,565,019 =C2=A0 =C2=A0 +6.95%
> =C2=A0 ext4 =C2=A0io_uring_poll =C2=A0256 =C2=A0 1,651,112 =C2=A0 =C2=A0 =
1,888,182 =C2=A0 =C2=A0 +14.36%
> =C2=A0 ext4 =C2=A0io_uring_poll =C2=A0512 =C2=A0 1,632,641 =C2=A0 =C2=A0 =
1,893,259 =C2=A0 =C2=A0 +15.96%
> =C2=A0 xfs =C2=A0 libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 18,7=
15 =C2=A0 =C2=A0 =C2=A0 =C2=A018,734 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.10%
> =C2=A0 xfs =C2=A0 libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 128 =C2=A0 452,974 =
=C2=A0 =C2=A0 =C2=A0 473,459 =C2=A0 =C2=A0 =C2=A0 +4.52%
> =C2=A0 xfs =C2=A0 libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 256 =C2=A0 454,435 =
=C2=A0 =C2=A0 =C2=A0 470,855 =C2=A0 =C2=A0 =C2=A0 +3.61%
> =C2=A0 xfs =C2=A0 libaio =C2=A0 =C2=A0 =C2=A0 =C2=A0 512 =C2=A0 456,796 =
=C2=A0 =C2=A0 =C2=A0 473,047 =C2=A0 =C2=A0 =C2=A0 +3.56%
> =C2=A0 xfs =C2=A0 io_uring =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 18,755 =
=C2=A0 =C2=A0 =C2=A0 =C2=A018,795 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.21%
> =C2=A0 xfs =C2=A0 io_uring =C2=A0 =C2=A0 =C2=A0 128 =C2=A0 509,459 =C2=A0=
 =C2=A0 =C2=A0 534,819 =C2=A0 =C2=A0 =C2=A0 +4.98%
> =C2=A0 xfs =C2=A0 io_uring =C2=A0 =C2=A0 =C2=A0 256 =C2=A0 509,853 =C2=A0=
 =C2=A0 =C2=A0 536,051 =C2=A0 =C2=A0 =C2=A0 +5.14%
> =C2=A0 xfs =C2=A0 io_uring =C2=A0 =C2=A0 =C2=A0 512 =C2=A0 507,926 =C2=A0=
 =C2=A0 =C2=A0 533,558 =C2=A0 =C2=A0 =C2=A0 +5.05%
> =C2=A0 xfs =C2=A0 io_uring_poll =C2=A01 =C2=A0 =C2=A0 19,230 =C2=A0 =C2=
=A0 =C2=A0 =C2=A019,269 =C2=A0 =C2=A0 =C2=A0 =C2=A0+0.20%
> =C2=A0 xfs =C2=A0 io_uring_poll =C2=A0128 =C2=A0 1,467,398 =C2=A0 =C2=A0 =
1,567,840 =C2=A0 =C2=A0 +6.84%
> =C2=A0 xfs =C2=A0 io_uring_poll =C2=A0256 =C2=A0 1,636,852 =C2=A0 =C2=A0 =
1,878,917 =C2=A0 =C2=A0 +14.79%
> =C2=A0 xfs =C2=A0 io_uring_poll =C2=A0512 =C2=A0 1,639,495 =C2=A0 =C2=A0 =
1,874,813 =C2=A0 =C2=A0 +14.35%
>=C2=A0
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Assisted-by: Codex:gpt-5-5
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
> =C2=A0fs/iomap/direct-io.c | 382 ++++++++++++++++++++++++++++++++++++++++=
+--
> =C2=A01 file changed, 371 insertions(+), 11 deletions(-)
>=C2=A0
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index e911daedff65a..807d8c628a464 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -9,6 +9,9 @@
> =C2=A0#include <linux/iomap.h>
> =C2=A0#include <linux/task_io_accounting_ops.h>
> =C2=A0#include <linux/fserror.h>
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +#include <linux/init.h>
> =C2=A0#include "internal.h"
> =C2=A0#include "trace.h"
> =C2=A0
> @@ -236,20 +239,26 @@ static void iomap_dio_done(struct iomap_dio *dio)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_complete_work(&dio->aio.work)=
;
> =C2=A0}
> =C2=A0
> -static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completi=
on)
> +static inline void iomap_dio_bio_release_pages(struct bio *bio,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int dio=
_flags, bool error)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio *dio =3D bio->bi_private;
> -
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio->flags & IOMAP_DIO_BOUNCE) {
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_iov_iter_unb=
ounce(bio, !!dio->error,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio->flags & IOMAP_DIO_USER_BACKED=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_BOUNCE) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_iov_iter_unb=
ounce(bio, error,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_flags & IOMAP_DIO_USER_BACKED)=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio=
);
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (dio->flags & IOMAP_DIO_USER_BACKE=
D) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (dio_flags & IOMAP_DIO_USER_BACKED=
) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_check_p=
ages_dirty(bio);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_release=
_pages(bio, false);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio=
);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +}
> +
> +static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completi=
on)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio *dio =3D bio->bi_private;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_bio_release_pages(bio, dio->flags,=
 !!dio->error);
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Do not touch bio below, we just gave=
 up our reference. */
> =C2=A0
> @@ -387,6 +396,14 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_i=
ter *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> =C2=A0}
> =C2=A0
> +static inline unsigned int iomap_dio_alignment(struct inode *inode,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct block_dev=
ice *bdev, unsigned int dio_flags)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return i_blocksi=
ze(inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return bdev_logical_block_size(bdev);
> +}
> +
> =C2=A0static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap=
_dio *dio)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct iomap *iomap =3D &iter->io=
map;
> @@ -405,10 +422,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *ite=
r, struct iomap_dio *dio)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * File systems that write out of place=
 and always allocate new blocks
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * need each bio to be block aligned as=
 that's the unit of allocation.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D fs=
_block_size;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D bd=
ev_logical_block_size(iomap->bdev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D iomap_dio_alignment(inode, iom=
ap->bdev, dio->flags);
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((pos | length) & (alignment - 1))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIN=
VAL;
> @@ -880,12 +894,350 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter=
 *iter,
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(__iomap_dio_rw);
> =C2=A0
> +struct iomap_dio_simple_read {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0*iocb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0size;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0dio_flags;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0state;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0union {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct task_stru=
ct =C2=A0 =C2=A0 =C2=A0 =C2=A0*waiter;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct work_stru=
ct =C2=A0 =C2=A0 =C2=A0 =C2=A0work;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Align @bio to a cacheline boundary so tha=
t, combined with the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * front_pad passed to bioset_init(), the bi=
o sits at the start of
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * a cacheline in memory returned by the (HW=
CACHE-aligned) bio
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * slab. =C2=A0This keeps the hot fields blo=
ck layer touches on submit
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * and completion (bi_iter, bi_status, ...) =
within a single line.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio =C2=A0 =C2=A0 =C2=A0 =C2=A0bio __=
__cacheline_aligned_in_smp;
> +};
> +
> +static struct bio_set iomap_dio_simple_read_pool;
> +
> +/*
> + * In the async simple read path, we need to prevent bio_endio() from
> + * triggering iocb->ki_complete() before the submitter has returned
> + * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently.
> + *
> + * We use a three-state rendezvous to synchronize the submitter and end_=
io:
> + *
> + * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the =
bio.
> + *
> + * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and w=
ill
> + * return -EIOCBQUEUED. If end_io sees this state, it takes over and cal=
ls
> + * ki_complete().
> + *
> + * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished the
> + * submit path. end_io sets this state and does nothing else. The submit=
ter
> + * will see this state and handle the completion synchronously (bypassin=
g
> + * ki_complete() and returning the actual result).
> + */
> +enum {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0IOMAP_DIO_SIMPLE_SUBMITTING =3D 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0IOMAP_DIO_SIMPLE_QUEUED,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0IOMAP_DIO_SIMPLE_DONE,
> +};
> +
> +static ssize_t iomap_dio_simple_read_finish(struct kiocb *iocb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio,=
 ssize_t ret)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple_read *sr =3D bio->bi=
_private;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(!ret)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sr->size=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_pos +=
=3D ret;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fserror_report_i=
o(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->size, ret, GFP_NOFS);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_bio_release_pages(bio, sr->dio_fla=
gs, ret < 0);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +}
> +
> +static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(iocb->private, NULL);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_dio_simple_read_finish(iocb, b=
io,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0blk_status_to_errno(bio->bi_status));
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_complete(iocb, ret < 0 ? ret=
 : 0, ret > 0 ? ret : 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +}
> +
> +static void iomap_dio_simple_read_complete_work(struct work_struct *work=
)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple_read *sr =3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0container_of(wor=
k, struct iomap_dio_simple_read, work);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb *iocb =3D sr->iocb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_dio_simple_read_complete(iocb,=
 &sr->bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iocb->ki_complete(iocb, ret);
> +}
> +
> +static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_rea=
d *sr)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kiocb *iocb =3D sr->iocb;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(sr->bio.bi_status)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *in=
ode =3D file_inode(iocb->ki_filp);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0INIT_WORK(&sr->w=
ork, iomap_dio_simple_read_complete_work);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0queue_work(inode=
->i_sb->s_dio_done_wq, &sr->work);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_simple_read_complete_work(&sr->wor=
k);
> +}
> +
> +static void iomap_dio_simple_read_end_io(struct bio *bio)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple_read *sr =3D bio->bi=
_private;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sr->waiter) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct task_stru=
ct *waiter =3D sr->waiter;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(sr->w=
aiter, NULL);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_wake_io_task=
(waiter);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (likely(atomic_read(&sr->state) =3D=3D IO=
MAP_DIO_SIMPLE_QUEUED) ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_cmpxchg(&sr->state, IOM=
AP_DIO_SIMPLE_SUBMITTING,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 IOMAP_DIO_SIMPLE_DONE) =3D=3D IOMAP_DIO_SIMPLE_QUEUED)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_simple=
_read_async_done(sr);
> +}
> +
> +static inline bool iomap_dio_simple_read_supported(struct kiocb *iocb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iov_iter =
*iter, unsigned int dio_flags)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D iov_iter_count(iter);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iov_iter_rw(iter) !=3D READ)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Simple read is an optimization for small =
IO. Filter out large IO
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * early as it's the most common case to fai=
l for typical direct IO
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * workloads.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (count > inode->i_sb->s_blocksize)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMA=
P_DIO_PARTIAL))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_pos + count > i_size_read(inode=
))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return true;
> +}
> +
> +static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iov_iter =
*iter, const struct iomap_ops *ops,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0void *private, u=
nsigned int dio_flags)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *inode =3D file_inode(iocb->ki_=
filp);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0size_t count =3D iov_iter_count(iter);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0int nr_pages;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple_read *sr;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int alignment;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_iter iomi =3D {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.inode =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D inode,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.pos =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D iocb->ki_pos,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.len =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D count,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.flags =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D IOMAP_DIRECT,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.private =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D private,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0};
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bool wait_for_completion =3D is_sync_kiocb(i=
ocb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_BOUNCE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nr_pages =3D bio=
_iov_bounce_nr_vecs(iter, REQ_OP_READ);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nr_pages =3D bio=
_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_flags & IOCB_NOWAIT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.flags |=3D =
IOMAP_NOWAIT;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D kiocb_write_and_wait(iocb, count);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_begin(inode);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D ops->iomap_begin(inode, iomi.pos, co=
unt, iomi.flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap, &iomi.srcmap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(in=
ode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iomi.iomap.type !=3D IOMAP_MAPPED ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.iomap.offset > iomi.pos |=
|
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomi.iomap.offset + iomi.iomap=
.length < iomi.pos + count) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -ENOTBLK=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap_e=
nd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0alignment =3D iomap_dio_alignment(inode, iom=
i.iomap.bdev, dio_flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iomi.pos | count) & (alignment - 1)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EINVAL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_iomap_e=
nd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!inode->i_sb->s_dio_done_wq)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sb_init_=
dio_done_wq(inode->i_sb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out_iomap_end;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_rw_begin(iocb, iter, dio_fla=
gs, 0);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (user_backed_iter(iter))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio_flags |=3D I=
OMAP_DIO_USER_BACKED;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =3D bio_alloc_bioset(iomi.iomap.bdev, nr=
_pages,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_OP_READ | REQ_SYNC | REQ_IDLE,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_KERNEL, &iomap_dio_simple_read_pool)=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0sr =3D container_of(bio, struct iomap_dio_si=
mple_read, bio);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0fscrypt_set_bio_crypt_ctx(bio, inode, iomi.p=
os >> inode->i_blkbits,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0GFP_KERNEL);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->iocb =3D iocb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->dio_flags =3D dio_flags;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_iter.bi_sector =3D iomap_sector(&iom=
i.iomap, iomi.pos);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_ioprio =3D iocb->ki_ioprio;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_private =3D sr;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_end_io =3D iomap_dio_simple_read_end=
_io;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_BOUNCE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D bio_iov_=
iter_bounce(bio, iter);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D bio_iov_=
iter_get_pages(bio, iter, alignment - 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(ret))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_bio_put=
;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio->bi_iter.bi_size !=3D count) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iov_iter_revert(=
iter, bio->bi_iter.bi_size);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -ENOTBLK=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_bio_rel=
ease_pages;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->size =3D bio->bi_iter.bi_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((dio_flags & IOMAP_DIO_USER_BACKED) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!(dio_flags & IOMAP_DIO_BOUNCE=
))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_set_pages_di=
rty(bio);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (iocb->ki_flags & IOCB_NOWAIT)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_opf |=3D=
 REQ_NOWAIT;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((iocb->ki_flags & IOCB_HIPRI) && !wait_f=
or_completion) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio->bi_opf |=3D=
 REQ_POLLED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_set_polled(b=
io, iocb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0WRITE_ONCE(iocb-=
>private, bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (wait_for_completion) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->waiter =3D c=
urrent;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_crypto_submi=
t_bio(bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&sr->=
state, IOMAP_DIO_SIMPLE_SUBMITTING);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->waiter =3D N=
ULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_crypto_submi=
t_bio(bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EIOCBQU=
EUED;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops->iomap_end)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->iomap_end(i=
node, iomi.pos, count, count, iomi.flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (wait_for_completion) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (;;) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0set_current_state(TASK_UNINTERRUPTIBLE);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (!READ_ONCE(sr->waiter))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0blk_io_schedule();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__set_current_st=
ate(TASK_RUNNING);
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_simple_read_finish(iocb, bio,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_status_to_errno(bio->bi_status=
));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(in=
ode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_=
complete(iocb, ret < 0 ? ret : 0,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret >=
 0 ? ret : 0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (atomic_cmpxchg(&sr->state, IOMAP_=
DIO_SIMPLE_SUBMITTING,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0IOMAP_DIO_SIMPLE_QUEUED) =
=3D=3D
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 IOMAP_DI=
O_SIMPLE_DONE) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_simple_read_complete(iocb, bio);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0trace_iomap_dio_=
rw_queued(inode, iomi.pos, count);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +
> +out_bio_release_pages:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dio_flags & IOMAP_DIO_BOUNCE)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_iov_iter_unb=
ounce(bio, true, false);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_release_page=
s(bio, false);
> +out_bio_put:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_put(bio);
> +out_iomap_end:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ops->iomap_end)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ops->iomap_end(i=
node, iomi.pos, count, 0, iomi.flags,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &iomi.iomap);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0inode_dio_end(inode);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;
> +}
> +
> =C2=A0ssize_t
> =C2=A0iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struc=
t iomap_ops *ops, const struct iomap_dio_ops *dops,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned in=
t dio_flags, void *private, size_t done_before)
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio *dio;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0ssize_t ret;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Fast path for small, block-aligned reads =
that map to a single
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * contiguous on-disk extent.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * @dops must be NULL: a non-NULL @dops mean=
s the caller wants its
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * ->end_io / ->submit_io hooks invoked, and=
 in particular wants its
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * bios to be allocated from the filesystem-=
private @dops->bio_set
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * (whose front_pad sizes a filesystem-priva=
te wrapper around the
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * bio). =C2=A0The fast path instead allocat=
es from the shared
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * iomap_dio_simple_read_pool, whose front_p=
ad matches
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * struct iomap_dio_simple_read; the two wra=
ppers are not
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * interchangeable, so we must fall back to =
__iomap_dio_rw() in
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * that case.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * @done_before must be zero: a non-zero cal=
ler-accumulated residual
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * cannot be carried through a single-bio in=
line completion.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 *
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * -ENOTBLK is the private sentinel returned=
 by iomap_dio_simple_read()
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * when it decides the request does not fit =
the fast path.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * In that case we proceed to the generic __=
iomap_dio_rw() slow
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * path. =C2=A0Any other errno is a real res=
ult and is propagated as-is,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 * in particular -EAGAIN for IOCB_NOWAIT mus=
t reach the caller.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!dops && !done_before &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iomap_dio_simple_read_supporte=
d(iocb, iter, dio_flags)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D iomap_di=
o_simple_read(iocb, iter, ops, private, dio_flags);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret !=3D -EN=
OTBLK)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return ret;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dio =3D __iomap_dio_rw(iocb, iter, ops,=
 dops, dio_flags, private,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 done_before);
> @@ -894,3 +1246,11 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *i=
ter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return iomap_dio_complete(dio);
> =C2=A0}
> =C2=A0EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +
> +static int __init iomap_dio_init(void)
> +{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0return bioset_init(&iomap_dio_simple_read_po=
ol, 4,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 offsetof(struct iomap_dio_simple_read, bio),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
> +}
> +fs_initcall(iomap_dio_init);
> --=C2=A0
> 2.39.5 (Apple Git-154)
>=C2=A0
