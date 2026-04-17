Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61BA2AD00
	for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2026 02:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776392127; cv=none; b=OuBxlJnJ3PQfpb/FFiWeHnxIZq22wPg/EMan/+gxBlQjxUBF0BSoom+5+obNlAzoX3Ru636YtuySAvuXoHdfdrVqG5y4pmQejwnaOXMymUcipXV9RUvaLhgfR9mFTfTKkH4K6dPWaxBmWTy+tjMWjnzCUSkr20gXR3WLWg8kBLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776392127; c=relaxed/simple;
	bh=0/lyXGkKFiSZc8pIApTKDpiVFRf4a8ueh+JFKqqvjT4=;
	h=Cc:Subject:References:Content-Type:Date:Message-Id:To:From:
	 Mime-Version:In-Reply-To; b=G/TjGtE97EIbWwDGQqfgIA0KR2eYAhxcEU0PiyPVveEyijhh5oTFgsno+OH/OxaTi3urFRKU4ka6YBtIQm3jZAbLrJfPA7+EWEunZjW4riR92KUI55s9YA4PaxHUAEialld9lF0YONIDn59IXQWaVO7ua3xphbds9RkDaLgjVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=IG4gWBEY; arc=none smtp.client-ip=209.127.230.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="IG4gWBEY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1776392119; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0/lyXGkKFiSZc8pIApTKDpiVFRf4a8ueh+JFKqqvjT4=;
 b=IG4gWBEYPN7WuL+7hJjpHjd+pK+IA6Gs24WdYh2ASImovTh0jxLUNxrhlDV7voWUTVWDVe
 c8Whv6nuWQNxsfp2qI4SnWMk+aZFDd4rrX44KPivVwGfu6vWNmL4siOUGdvhXFuopUgDab
 uQU+yyPTGk9PGkw+b8OqNHr0idPkRr8/eLe/uOPKqJNI/4XQn45w9JBAaGjHtypjHP6OoP
 MzwivbOPCNeMkZUPiylv3pgmkNPL0ZQ52RXY9I6LavaeAieytLshxTdO0v6WziWlLBxSV8
 ID1u/HsypE7EIfPgxsZK6eGO2azZJ9PNnBw9x+GAJEhpXvW4R6njVzYzxIn2rw==
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	"Brian Foster" <bfoster@redhat.com>, 
	"Fengnan Chang" <fengnanchang@gmail.com>, <brauner@kernel.org>, 
	<hch@infradead.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<lidiangang@bytedance.com>
Subject: Re: [PATCH] iomap: avoid memset iomap when iter is done
References: <20260416030642.26744-1-changfengnan@bytedance.com> <aeDjui2LGSidEHcJ@bfoster> <20260416152705.GC114239@frogsfrogsfrogs>
	<aeFlvXDShzIuOU9z@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Apr 2026 10:15:14 +0800
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.2a887e59.940e.4103.87d7.62770ee521ce@bytedance.com>
To: "Dave Chinner" <dgc@kernel.org>
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aeFlvXDShzIuOU9z@dread>
X-Lms-Return-Path: <lba+169e197b5+6cf6a2+vger.kernel.org+changfengnan@bytedance.com>


> From: "Dave Chinner"<dgc@kernel.org>
> Date:=C2=A0 Fri, Apr 17, 2026, 06:42
> Subject:=C2=A0 Re: [PATCH] iomap: avoid memset iomap when iter is done
> To: "Darrick J. Wong"<djwong@kernel.org>
> Cc: "Brian Foster"<bfoster@redhat.com>, "Fengnan Chang"<fengnanchang@gmai=
l.com>, <brauner@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.o=
rg>, <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <lidian=
gang@bytedance.com>, "Fengnan Chang"<changfengnan@bytedance.com>
> On Thu, Apr 16, 2026 at 08:27:05AM -0700, Darrick J. Wong wrote:
> > On Thu, Apr 16, 2026 at 09:27:22AM -0400, Brian Foster wrote:
> > > On Thu, Apr 16, 2026 at 11:06:42AM +0800, Fengnan Chang wrote:
> > > > When iomap_iter() finishes its iteration (returns <=3D 0), it is no=
 longer
> > > > necessary to memset the entire iomap and srcmap structures.
> > > >=C2=A0
> > > > In high-IOPS scenarios (like 4k randread NVMe polling with io_uring=
),
> > > > where the majority of I/Os complete in a single extent map, this wa=
sted
> > > > memory write bandwidth, as the caller will just discard the iterato=
r.
> > > >=C2=A0
> > > > Use this command to test:
> > > > taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -=
X1
> > > > -n1 -P1 /mnt/testfile
> > > > IOPS improve about 5% on ext4 and XFS.
> > > >=C2=A0
> > > > However, we MUST still call iomap_iter_reset_iomap() to release the
> > > > folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
> > > > references. Therefore, split the cleanup logic: always release the
> > > > folio_batch, but skip the memset() when ret <=3D 0.
> > > >=C2=A0
> > > > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> > > > ---
> > > > =C2=A0fs/iomap/iter.c | 5 +++--
> > > > =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
> > > >=C2=A0
> > > > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > > > index c04796f6e57f..91eb5e6165ff 100644
> > > > --- a/fs/iomap/iter.c
> > > > +++ b/fs/iomap/iter.c
> > > > @@ -15,8 +15,6 @@ static inline void iomap_iter_reset_iomap(struct =
iomap_iter *iter)
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > > > =C2=A0
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0iter->status =3D 0;
> > > > - =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->iomap, 0, sizeof(iter->i=
omap));
> > > > - =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->srcmap, 0, sizeof(iter->=
srcmap));
> > > > =C2=A0}
> > > > =C2=A0
> > > > =C2=A0/* Advance the current iterator position and decrement the re=
maining length */
> > > > @@ -106,6 +104,9 @@ int iomap_iter(struct iomap_iter *iter, const s=
truct iomap_ops *ops)
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret <=3D 0)
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retur=
n ret;
> > > > =C2=A0
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->iomap, 0, sizeof(iter->i=
omap));
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0memset(&iter->srcmap, 0, sizeof(iter->=
srcmap));
> > > > +
> > >=C2=A0
> > > This seems reasonable to me in principle, but it feels a little odd t=
o
> > > leave a reset helper that doesn't really do a "reset." I wonder if th=
is
> > > should be refactored into an iomap_iter_complete() (i.e. "complete an
> > > iteration") helper that includes the ret assignment logic just above =
the
> > > reset call and returns it, and then maybe leave a oneline comment abo=
ve
> > > the memset so somebody doesn't blindly fold it back in the future. So
> > > for example:
> > >=C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D iomap_iter_complete(iter);
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret <=3D 0)
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> > >=C2=A0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* save cycles and only clear the mapping=
s if we plan to iterate */
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(..);
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 ...
> > >=C2=A0
> > > We'd probably have to recheck some of the iter state within the new
> > > helper, but that doesn't seem like a big deal to me. Thoughts?
> >=C2=A0
> > What kind of computer is this where there's a 5% hit to iops from a
> > memset of ~150 bytes?
>=C2=A0
> Even small costs can have a big impact when you have to pay it many
> times.
>=C2=A0
> i.e. 2 million IOPS * 2 * 72 bytes per IO =3D 288MB/s of memory being
> zeroed unnecessarily in very small (inefficient) chunks.
>=C2=A0
> That's definitely enough to cause a 5% drop in IOPS when the
> workload is CPU or memory bandwidth bound....

My CPU is=C2=A0 Intel(R) Xeon(R) Platinum 8457C with 1TB RAM, NVMe is=C2=A0
PS1010 and the system is very idle, only run one command with one core:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 \
-X1 -n1 -P1 /mnt/mytest=EF=BC=8CIOPS=C2=A0 improved from 1.9M to 2.0M.
My test is a CPU bound case=EF=BC=8Cthese two memset operations should
have taken only about 15 nanoseconds. at 2.0 million IOPS, the total=C2=A0
CPU time budget per I/O operation averages just 500 nanoseconds.
Taking into account the impact on the pipeline and the L1 cache, a 5%
improvement is reasonable.

>=C2=A0
> -Dave.
> --=C2=A0
> Dave Chinner
> dgc@kernel.org
>=C2=A0
