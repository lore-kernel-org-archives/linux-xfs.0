Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB26330C146
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 03:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785207887; cv=none; b=KxxLkZZ0q6hxeRyfbOGPcVwsVwuw9LMoyiQncnSfRYhNlZNeO5nO2f+HKK0EedrxmKBocsHsNInOjKlaYiHd0NMVDUaV7E0PxwsReLwHx7/VGNJRrLlcM/JEDNloQVSv/PA/29IDFYKH0vvDIAp1mT+VXliLzOJg8aZ0GKOu6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785207887; c=relaxed/simple;
	bh=0yE7t8qNpTMSvOMi5C2p2H1utbfuX5/vCg0PXN5S8gA=;
	h=Message-Id:To:Cc:Content-Type:Date:Subject:From:Mime-Version:
	 References:In-Reply-To; b=B1n/dTGtIm1KbaY8f1T/N1iND9gY5tsn2r+e53gNAohH0QiMtu2R2dnqeWFFV8skIIb2bd88r1wR3puvih8Xp7bDuXxmNLMilP3HWAGr87jigRU5LcKjc5dw7fzZlrindchem7VSP0H4iCMgx4NOBmdBWs/prg4uh1VxESYSBBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lABZEAom; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lABZEAom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785207879; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=0yE7t8qNpTMSvOMi5C2p2H1utbfuX5/vCg0PXN5S8gA=;
 b=lABZEAomN5KBkr3eW0himr0GCMPKYAulTOiOI8fbPBE3NTp9loiNYSZWyurr2F9V3Z1ghd
 IcXBBHl6WY5+WnMjd0KyWdK3aJQ7PaZkrc4R7AJzKKK69iKwr5dmJ7haB/lvw8vdrrSime
 QfrQ9awOY/WDxrhzwQjt7SCQwNcNnCuPGuXr0nTTeLE/WzJAWKiH/K1gmAgXDf9wHLDocf
 bdJmCwY63YANW9hryiBkdDhiUIWih2eEHMxK4eTAWJN0o0c7YqdnKASCuwcecLN5dITzc3
 8Xp73QOrtvbtkUTHD4LEA/xRZ6SgienHu2twVaRrB1Gp34u7WH611DZQ4xebsw==
Message-Id: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.3b277109.3b33.4175.9d57.4ea2181fb636@bytedance.com>
To: "Joanne Koong" <joannelkoong@gmail.com>
Cc: "Christian Brauner" <brauner@kernel.org>, <hch@lst.de>, 
	"Darrick J . Wong" <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>, 
	<kbusch@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, 
	"Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, 
	"David Sterba" <dsterba@suse.com>, "Gao Xiang" <xiang@kernel.org>, 
	"Namjae Jeon" <linkinjeon@kernel.org>, <tytso@mit.edu>, 
	"Jaegeuk Kim" <jaegeuk@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>, 
	"Hyunchul Lee" <hyc.lee@gmail.com>, 
	"Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>, 
	"Carlos Maiolino" <cem@kernel.org>, 
	"Damien Le Moal" <dlemoal@kernel.org>, <libaokun@linux.alibaba.com>, 
	<linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>
X-Lms-Return-Path: <lba+16a681c45+fb37e0+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 11:04:34 +0800
Subject: Re: [PATCH v4 03/21] iomap: use GFP_NOWAIT when application for iomap_dio_simple allocations
From: "changfengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260727211758.1116539-1-joannelkoong@gmail.com>
	<20260727211758.1116539-4-joannelkoong@gmail.com>
In-Reply-To: <20260727211758.1116539-4-joannelkoong@gmail.com>


> From: "Joanne Koong"<joannelkoong@gmail.com>
> Date:=C2=A0 Tue, Jul 28, 2026, 05:24
> Subject:=C2=A0 [PATCH v4 03/21] iomap: use GFP_NOWAIT when application fo=
r iomap_dio_simple allocations
> To: "Christian Brauner"<brauner@kernel.org>, <hch@lst.de>, "Darrick J . W=
ong"<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>
> Cc: <changfengnan@bytedance.com>, <kbusch@kernel.org>, "Matthew Wilcox"<w=
illy@infradead.org>, "Jan Kara"<jack@suse.cz>, "Jonathan Corbet"<corbet@lwn=
.net>, "David Sterba"<dsterba@suse.com>, "Gao Xiang"<xiang@kernel.org>, "Na=
mjae Jeon"<linkinjeon@kernel.org>, <tytso@mit.edu>, "Jaegeuk Kim"<jaegeuk@k=
ernel.org>, "Miklos Szeredi"<miklos@szeredi.hu>, "Andreas Gruenbacher"<agru=
enba@redhat.com>, "Mikulas Patocka"<mikulas@artax.karlin.mff.cuni.cz>, "Hyu=
nchul Lee"<hyc.lee@gmail.com>, "Konstantin Komarov"<almaz.alexandrovich@par=
agon-software.com>, "Carlos Maiolino"<cem@kernel.org>, "Damien Le Moal"<dle=
moal@kernel.org>, <libaokun@linux.alibaba.com>, <linux-ext4@vger.kernel.org=
>, <linux-xfs@vger.kernel.org>
> From: Christoph Hellwig <hch@lst.de>
>=C2=A0
> For non-blocking iocbs we should avoid blocking allocation where
> possible, so switch to a GFP_NOWAIT allocation here.
>=C2=A0
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>

> ---
> =C2=A0fs/iomap/direct-io.c | 7 ++++++-
> =C2=A01 file changed, 6 insertions(+), 1 deletion(-)
>=C2=A0
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 36c976cf0848..5c28124b9f02 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
> =C2=A0ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter=
 *iter,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ioma=
p_iter *iomi)
> =C2=A0{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0gfp_t gfp =3D (iomi->flags & IOMAP_NOWAIT) ?=
 GFP_NOWAIT : GFP_KERNEL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct iomap_dio_simple *sr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int alignment;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct bio *bio;
> @@ -1015,7 +1016,11 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb=
, struct iov_iter *iter,
> =C2=A0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =3D bio_alloc_bioset(iomi->iomap.bd=
ev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_iov_vecs_to_alloc(iter, BIO_MAX_=
VECS),
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_OP_READ, GFP_KERNEL, &iomap_dio_simp=
le_pool);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 REQ_OP_READ, gfp, &iomap_dio_simple_pool=
);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!bio) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -EAGAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_dio_end=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr =3D container_of(bio, struct iomap_d=
io_simple, bio);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->iocb =3D iocb;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sr->dio_flags =3D 0;
> --=C2=A0
> 2.52.0
>=C2=A0
