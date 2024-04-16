Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C110A22
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285960; cv=none; b=J4kr4TVoK9QBbvH97lcOylwvHhJwpaD1+BNafgIhDiPxNhWNdGcwQcAMYBbQ4BGXV1+P5ZPsf1hJTEAr8+j5U96sEddSPvo0/3HJA24LPEN5Jn5ksJrqwbU7+I4a17W53qBiqtzyoAhorPkTrjIKNaNtjTILlwWUs6Lg4cOSzmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285960; c=relaxed/simple;
	bh=yY/urgVR92vuyS7dmUEHcXw/MtINw5+QRm2mfptgOQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9rCt3A4ppD+gLx+x1Pbk83VtZ5g3pOgozzL2oZleFoCP1EvFPI1L48Xpuq8+lLoH50d+voTtVeAHqayvcuT8aY6RQc0kdGr77AGd/u5oUVKh5RsylZMfLVEwGcFAtaGvRF2zzBVUZTSgCkq5JmjmsVWAO3StZU9tGTH8alYjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xCToZJOb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xCToZJOb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QI4dPLJ1fsUnijknChmFAJLYna29BZ6teTfG29hP8zQ=; b=xCToZJOblJAy9w/f7f6/wMHSgf
	ie9M3VrLpqUlxYAX3Bloz/BjOVuM3+xG4RrpH0dlTF1UjzYNrs+MTkI//BZ/qA7a//WNMAzo7g63I
	1uwgq/xKts1xFvrKniGeNe+XdUxc9/IWLvnVAZUrtd+YAJLymxks5zMHsfjO3kadR0obkduAzwMu/
	IWtN1ZDoiPtycle4puCGmY8G0CI9sModWUTWz4pFiJj1dY7hSSKdP7eYJZKyts2xzkBaHGUah+WUb
	nOhARb7tijfARors7vQjYl7j43/jlvIHHui/chiuoaLRcv4PfJTl6xRd2qdFt3S/rSTlTpC0siJxM
	bcj7DEgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlwV-0000000D4EQ-0okO;
	Tue, 16 Apr 2024 16:45:59 +0000
Date: Tue, 16 Apr 2024 09:45:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_repair: make duration take time_t
Message-ID: <Zh6rRxuTO78gyIKk@infradead.org>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416123427.614899-3-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 02:34:24PM +0200, Andrey Albershteyn wrote:
> @@ -273,7 +273,7 @@ progress_rpt_thread (void *p)
>  	_("\t- %02d:%02d:%02d: Phase %d: %" PRIu64 "%% done - estimated remaining time %s\n"),
>  				tmp->tm_hour, tmp->tm_min, tmp->tm_sec,
>  				current_phase, percent,
> -				duration((int) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));
> +				duration((time_t) ((*msgp->total - sum) * (elapsed)/sum), msgbuf));

What is the point of the time_t cast the gets applied to the
final calculated expression?  Even if time_t is wieder than what
it was, it would only extent it after we've overlflow the original
type.  The whole thing also just is formatted and filled with useles
braces to make it look really odd.  Something like:

				current_phase, percent,
				duration((*msgp->total - sum) * elapsed / sum,
					msgbuf));

would be way more readable.
