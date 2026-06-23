Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C3C388881
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782235810; cv=pass; b=uxaiIG2UmdsolmUvpybWS1SvhOAjjkLkTukOLY+EyaGrmEOWybWLwZc4mTLrURFpbsuqhjAmKwFQV+JKM5etyuk7KgwN0k3BNzk2l/X623turUwQZo7LqKFr5ZrJgV4EtMgGp7TOVi+HpW+eNjqsC1++iyrfHBE92e3v1yZOvAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782235810; c=relaxed/simple;
	bh=1XpXzTFHWJsw8C2JyfoXebC5Ni6jg74rJbCKW4Yfwc8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eBua06NS6EKsOkMbJxHUJiMrxstYnEBJ+Vczcn4sSKVYzP1KJkjtTiH10af+ji2OCEhpOjJwibau96Egm1D3uX3hE45R1al1Dis/Iag6fiLVeAyiMndiFalyAamW0MnjRbICKVwXHQTa5vWf+EAcD25reX/TpipY/baArmFe3s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WytVRz8n; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WytVRz8n"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4624c1409c9so125121f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 10:30:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782235807; cv=none;
        d=google.com; s=arc-20240605;
        b=XfEWJDaAIcT0i3PHo4cZhH6WK1kmvAZPhuD24r4xIFeeICgTvoOhJsGoHKk2T/XOXr
         fWroANpJa050a7h733xVXCzeK0xipeHbFAfZraWein0t+wEV6z7Cf+k3x7tGsoBbU8QX
         bpw1GxDjY3qxTuAnu7cyyFidEStdV2pP1IbMhDVUODFdyv8QgMarFX8yjYkv2LuUZ/Kp
         D/Yz7jBJkPpHBbCVO6w4OuNNoteU6pA5KrWrJv3eG0tL6Dugn+6k0ytw/Tk0N1vCLX0m
         BNsGp9JbKMnMcV+A+tVFBSkUUK/+THsIqI0yib/dsKlq2niSjBPK24bPByl89D98C9++
         6+eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RzrzEGZb0ltwNCVmNPEJth41Ktgi1EiQYCAOhqDS73Y=;
        fh=U9fBM4odAxZ9V29v+44XTFZrtgGv5zLsHTVTTJCprU8=;
        b=DQxdd6E/ym2Sm1qbqPMa8W6OLiuy8o52s7DV5bF5Rcy+IKerr38MqPrgiwuy1/mRUJ
         WS9ItErv+AcBSU9Xg6MXZlorW/QDIOSfeddHzgktaV8iModhqtz89GHy5cRU4kwW6gGj
         KzMjkhBf9IEvCis6eMRArLRrGZVnjRtHJcV2VscOGoXJpIlU1uq6fJrjXIv6pNzz7tuc
         ezdB6vMCtlIGSnQ+InQ7pzkdZL0WYc4uYEmJzb29rRP76NMz/N6Mi6iowEvKN7lCvWeU
         ED4vZ3FaRCd+R3k8MnEgzSc3i3AdSUrQWIp1xjnttPT4lWkeza8nXVsR9M/M1dnDkB7S
         81gA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782235807; x=1782840607; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzrzEGZb0ltwNCVmNPEJth41Ktgi1EiQYCAOhqDS73Y=;
        b=WytVRz8nYLB3avlW/jLj3IVXga/m71X/04RLBmvfCJvqQ2DeXyImIDE/DcHN5Nn1JO
         Xr/WpSFz/6fp7RO+Ri0Ne+YIpLZsrwnIg3xHrAQ9jeqQRF4FRkc9emusRIpBzK/rEiIi
         xtUIT4dRqYXQsb62fhxzwHhhpMZppJeV7OvvJZ+JCaJRrNmT8Id4LdjvrUBawr5Wd6vQ
         Cu2kVDyLAPb2r4Rm7sypv0NCOUu6H8BSfsqnG8xXsTDjnWIRiaYRAu5kW21xA6j8srQZ
         XECISBlds4LZ8cTdKAYK1rS7Lh4mkb5RKfMUxmfH6WACSS4B9L1UK5WFB7lCYf8TeGyV
         Npng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782235807; x=1782840607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RzrzEGZb0ltwNCVmNPEJth41Ktgi1EiQYCAOhqDS73Y=;
        b=J9J05a9KMY6xW32mr7OKbRMOoeAD8QewN3Hk5I4jsoEpH5+xcXSF63jHK7gw6l9Ddu
         EO1FUbqhJ211k1e9PPFL7Q3QxTRQQJ1FrCD7+AQ0kJVD+G/Z+AUkb+C/X7/rxiyvIyJx
         A+931+hGFbxmambfFna/pxRwj9QCk9pXFyo2KeFAi3E85ZGV9UnO+Rm+T78qsuPnMsbc
         8LWM0jKF29VsTBDcRwitfPvGaeCuqBNfHbE2qFqOODGLQIKCRR6RzhQaJWtCHTnXpJGi
         hIJNvZxQaqPe28ZmtuGDeq9JLlGxCyacr5sY8Qfskx5xuiGpkfl70+3zis45tPQ2G1FX
         cwPg==
X-Forwarded-Encrypted: i=1; AHgh+RrqaWqAAmxgK1VuK8M5n8rVzvoXUscE4vKrtehsSGUR9XHWngQnPfeorVzD4+qrIOIi14fP6WyoBzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoXhczTloN3a365fn4hqiRMsLo5dntu301m3LRNZPHPfwxl8gt
	V/l2XyPY3K3i4I99HX/g2MEVLZ8vfnpKTBZDqPdgADFGHtoQIyv+I7dGqZXu0aGigOxKFeeV9Yt
	AdPFLZxyLhxCCn2UliGg/ZiIJYWwX/Qw=
X-Gm-Gg: AfdE7ckm8VKKKrazdEQ4vjEkHwUejhm/44dXYjOGsZusnicCjHVI5Vt0WVmFIB6G9F/
	w1AhKhfRWU7oT5k1itPhkwWwNfP6y8jvzZ4Ip2nrYLetfYnUTJzDY5ZZiCFv+0gb3lPJ1c9K+0z
	lXVq6A0nYa7dx8CXTSlUG6dHwIQ1C3UNWjTZMLqfYpGeuExBngZC6rOyCVq7Ef9fsJDqrLzr318
	cZys4SBXpPv6fPJB8u/bO7b3g1NAyzCgzdIXjPkbrrQZs+06BTF8AGDVntEp+gqzvnmvTEreHHZ
	avKCNqk572GtydP2KDXWOY3ebsQ4fxobUhknltS+AbFFetzLCoUQ
X-Received: by 2002:a05:6000:22c6:b0:460:3233:beed with SMTP id
 ffacd0b85a97d-4666348bb1dmr24453136f8f.41.1782235807180; Tue, 23 Jun 2026
 10:30:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623135208.1812933-1-hch@lst.de> <20260623135208.1812933-3-hch@lst.de>
In-Reply-To: <20260623135208.1812933-3-hch@lst.de>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 23 Jun 2026 10:29:54 -0700
X-Gm-Features: AVVi8Ccm_eFaYYj-vQlgAXEMOrnUjeoeLhiRjoMn01eUhrTiB_xWHROB6LeYb7s
Message-ID: <CAJnrk1agx-qUizNzCnzvZ6Marf7u-K4EtKOak4c2MQN1sJfgNA@mail.gmail.com>
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>, 
	Yifan Zhao <zhaoyifan28@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 6:52=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Currently the iomap buffered read path tries to build up read context
> (i.e. bios for the typical block based case) over multiple iomaps as
> long as the sector matches.  This does not take into account files
> that can map to multiple different devices.  While this could be fixed
> by a bdev check in iomap_bio_read_folio_range, the building up of I/O
> over iomaps actually was a problem for the not yet merged ext2 iomap
> port, as that does want to send out I/O at the end of an indirect
> block mapped range.
>
> So instead of adding more checks move over to a model where a bio only
> spans a single iomap.  Change ->submit_read to be called after each
> iteration, and pass a force argument to indicate that the bio must
> be submitted set on the last iteration.  Switch the bio based users
> to always submit, while keeping the single submit for fuse.
>
> Fixes: dfeab2e95a75 ("erofs: add multiple device support")
> Reported-by: Kelu Ye <yekelu1@huawei.com>
> Reported-by: Yifan Zhao <zhaoyifan28@huawei.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/exfat/iomap.c       |  4 ++--
>  fs/fuse/file.c         |  6 +++++-
>  fs/iomap/bio.c         | 11 +++++++----
>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>  fs/ntfs/aops.c         |  4 ++--
>  fs/ntfs3/inode.c       |  4 ++--
>  fs/xfs/xfs_aops.c      |  5 +++--
>  include/linux/iomap.h  |  5 +++--
>  8 files changed, 39 insertions(+), 23 deletions(-)
>
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 0f31e35567b4..f71aaaf60301 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -79,7 +79,8 @@ u32 iomap_finish_ioend_buffered_read(struct iomap_ioend=
 *ioend)
>  }
>
>  void iomap_bio_submit_read_endio(const struct iomap_iter *iter,
> -               struct iomap_read_folio_ctx *ctx, bio_end_io_t end_io)
> +               struct iomap_read_folio_ctx *ctx, bool force,

nit: might simplify things to drop the unused force arg

> +               bio_end_io_t end_io)
>  {
>         struct bio *bio =3D ctx->read_ctx;
>
> @@ -87,13 +88,15 @@ void iomap_bio_submit_read_endio(const struct iomap_i=
ter *iter,
>         if (iter->iomap.flags & IOMAP_F_INTEGRITY)
>                 fs_bio_integrity_alloc(bio);
>         submit_bio(bio);
> +
> +       ctx->read_ctx =3D NULL;
>  }
>  EXPORT_SYMBOL_GPL(iomap_bio_submit_read_endio);
>
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 8d4806dc46d4..06a216d37548 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
>
> @@ -642,12 +649,12 @@ void iomap_read_folio(const struct iomap_ops *ops,
>                 fsverity_readahead(ctx->vi, folio->index,
>                                    folio_nr_pages(folio));
>
> -       while ((ret =3D iomap_iter(&iter, ops)) > 0)
> +       while ((ret =3D iomap_iter(&iter, ops)) > 0) {
> +               iomap_submit_read(&iter, ctx, false);
>                 iter.status =3D iomap_read_folio_iter(&iter, ctx,
>                                 &bytes_submitted);

should the submit_read happen after the iomap_read_folio_iter() /
iomap_readahead_iter() instaed of before? From what I see, it looks
like iomap_submit_read() would hold the iter state of the next
mapping. It seems like in iomap_bio_submit_read_endio(), the
iter->iomap.flags would be the next extent's flags instead of the one
that needs to be submitted?

Thanks,
Joanne
