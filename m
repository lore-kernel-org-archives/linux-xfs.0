Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7312C3E63B6
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179480; cv=none; b=tRlqSx+Y34Uj+82s7ywvXsaKPBnkLN/zvv5wo5MhT5/wp9fdN8J/7DNzpw+hB5VsbbhPYA3i72mmNfF2uB9NeUCJygYLcibrMB2KE6xY0ia0H4Dmt2bVJ3qYERlrrhxHE5UDh4TxS9/BW45Rgi5hytxHhabmgc6BAKnHHtPHsYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179480; c=relaxed/simple;
	bh=uQUF9Xqx89luykxEpk3DwSoDVKAaGgQdsXZa7rBK+6Y=;
	h=Date:Cc:From:Mime-Version:References:In-Reply-To:Content-Type:To:
	 Subject:Message-Id; b=cJM6mUriRpaK6JxCdTfKDaNkx/q+j2rkpz/D9e/zXCt7C7WUQC5tVSI5D/J6nR+uxMEjNf6AnRwfp/YAd5GMFVKoPvd8Wzt64bn0tTABXVqYeIvdKUXFPA6+740EMOh4nujYUSSdgC+ZwwxyedHGxHl1UM1X5iU5gkAWYDYS2Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OqJFn4e8; arc=none smtp.client-ip=209.127.230.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OqJFn4e8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1781179473; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=HAqbApc74Vvmxdiwfv58VrOQf84K2/1rA7Lf7R9JEmI=;
 b=OqJFn4e8Iq9UB5tEsj3Uww/KgF3bk7ZlpuMtSJsdVPB405v6uI492a6wuINvd8no+PAsx5
 rjONwDxs7P7lgGamKKpDau7VdtzsaIkYhlDcJTOn12xy1SD02698Z6LkqUu4tefG8R1oAx
 M5DcNxYtDTFo2mAyMQP6LXSuLHmShF1KKd3Ge9jqXMivxkyDrXlCFUdi24CxpEEL7LKdn8
 hg0eXZHCqn4pchZu8yzOmgUqeiNWTEN8jrJlxs122a1Y/xxjOHwblFQRb/MfuAUfMeBz1Q
 LizppIP6rwJ4JpilajZbmaf57Cnt2k8PZfai18eky5tg02PQa6ejKrfMd1pWYg==
Date: Thu, 11 Jun 2026 20:04:14 +0800
Content-Transfer-Encoding: quoted-printable
Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<p.raghav@samsung.com>
From: "Fengnan" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260608073134.95964-1-changfengnan@bytedance.com> <mmbe4kdeqg6zlblhysi27qno22dtkaahv7bzslaqopsg4k3qs7@nofv525nnl6c>
In-Reply-To: <mmbe4kdeqg6zlblhysi27qno22dtkaahv7bzslaqopsg4k3qs7@nofv525nnl6c>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a2aa44f+b35cc0+vger.kernel.org+changfengnan@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Subject: Re: [PATCH v4] iomap: add simple read path for small direct I/O
Message-Id: <94fac0c6-13fe-4d5d-a794-04b43678a295@bytedance.com>
X-Original-From: Fengnan <changfengnan@bytedance.com>

=E5=9C=A8 2026/6/11 17:36, Pankaj Raghav (Samsung) =E5=86=99=E9=81=93:
>> +static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
>> +		struct bio *bio)
>> +{
>> +	struct inode *inode =3D file_inode(iocb->ki_filp);
>> +	ssize_t ret;
>> +
>> +	WRITE_ONCE(iocb->private, NULL);
>> +
>> +	ret =3D iomap_dio_simple_read_finish(iocb, bio,
>> +			blk_status_to_errno(bio->bi_status));
>> +
>> +	inode_dio_end(inode);
>> +	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
> Shouldn't the second parameter here be
> blk_status_to_errno(bio->bi_status)?
>
> I think that will be more meaningful for tracing here.
> trace_iomap_dio_complete(iocb, blk_status_to_errno(bio->bi_status), ret);
Makes sense. I=E2=80=99ll update it in the next version.

>
> <snip>
>> +	return ret;
>> +}
>> +
>> +	sr->iocb =3D iocb;
>> +	sr->dio_flags =3D dio_flags;
>> +
>> +	bio->bi_iter.bi_sector =3D iomap_sector(&iomi.iomap, iomi.pos);
>> +	bio->bi_ioprio =3D iocb->ki_ioprio;
>> +	bio->bi_private =3D sr;
>> +	bio->bi_end_io =3D iomap_dio_simple_read_end_io;
>> +
>> +	if (dio_flags & IOMAP_DIO_BOUNCE)
>> +		ret =3D bio_iov_iter_bounce(bio, iter, count);
>> +	else
>> +		ret =3D bio_iov_iter_get_pages(bio, iter, alignment - 1);
>> +	if (unlikely(ret))
>> +		goto out_bio_put;
>> +
>> +	if (bio->bi_iter.bi_size !=3D count) {
>> +		iov_iter_revert(iter, bio->bi_iter.bi_size);
>> +		ret =3D -ENOTBLK;
>> +		goto out_bio_release_pages;
>> +	}
>> +
>> +	sr->size =3D bio->bi_iter.bi_size;
>> +
>> +	if ((dio_flags & IOMAP_DIO_USER_BACKED) &&
>> +	    !(dio_flags & IOMAP_DIO_BOUNCE))
>> +		bio_set_pages_dirty(bio);
>> +
>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>> +		bio->bi_opf |=3D REQ_NOWAIT;
>> +	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
>> +		bio->bi_opf |=3D REQ_POLLED;
>> +		bio_set_polled(bio, iocb);
> This results in build failure as the following patch removed this call:
> https://lore.kernel.org/linux-block/20260518062917.506483-1-hch@lst.de/
>
> I think this call can just be removed as you are setting REQ_POLLED
> anyway.
You=E2=80=99re right. I=E2=80=99ll update that in the next version too.

Thanks.

>
>> +		WRITE_ONCE(iocb->private, bio);
>> +	}
>> +
>> +	if (wait_for_completion) {
>> +		sr->waiter =3D current;
>> +		blk_crypto_submit_bio(bio);
>> +	} else {
>> +		atomic_set(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING);
>> +		sr->waiter =3D NULL;
>> +		blk_crypto_submit_bio(bio);
>> +		ret =3D -EIOCBQUEUED;
>> +	}
>> +
> --
> Pankaj
