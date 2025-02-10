Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEBB158874
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 21:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739221779; cv=none; b=Mafg0qryUeXFd7hnGkCn8hWtyTOSLpyh5wEpmlhIo59w60RgnmvUllZQpLhkpMjGtq1O4fdYiis15HiMhdxt6iRi46ncRE/rfifAKL4xzWIlXULbBGAXXNh5j7GwQ87mKdDz9X8zVT3OZRmSPCop3VWbhVuCe2B6gnvRLooFhaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739221779; c=relaxed/simple;
	bh=rGS3l9svkVCQV+7p3ePr5amCKr5qXyuXTsz/cevrDWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV9rfaixww4IbUb9ZaEcVCoP71txiLfvezpHVDwUxUUhZ3hsNmOVZjJi7kYoROppoiqSYTdllzvLnA7eLlhQwGFgLV9u82kJSbyJ2bKe8FsnX1fnFm6UjccuA+fV80/2ErCIezGfKR2fsCYUdvMk/IfsedLNfiRE7G/ozL5Gbm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0tqMohDs; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0tqMohDs"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21c2f1b610dso118517265ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 13:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1739221776; x=1739826576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IXPg0jyHha5GFH3/W3a7yg3C3ItOrmF5W6ykDVRgdZQ=;
        b=0tqMohDsHKN/CaSamQ1vLs4zY4ZSqHYtwtxCzkePQDOYjlS2zv9k4VLu9xnUiL3RDW
         uGhxcl+UpAmTcfgYz57kLSy0pgY6wzeIG4TXdM7j3PztLjEq1xivpkHcTUfZNIRjU6+8
         /f4UORBAOGIjLxSoMWEoqpqajOKDK59sWldl5WsEyo4UYBNzu9xD78Sv/ZPoPkHEVj+C
         qiZ09347oYXahy7vt4kzyqFr7C0BhwSQczahF2U+HGDnS52qCH23gTGVLrL3+ijcWid2
         sSZys2rt/oNKKRm7SZcZ2OGAZjex57hoo6KEYECwQ3wBpjZrxvdl9A7rMwpL0WUeyNca
         lpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739221776; x=1739826576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXPg0jyHha5GFH3/W3a7yg3C3ItOrmF5W6ykDVRgdZQ=;
        b=qC+CYeRcXXVoENL1qXQy0YFl4ccJMXq8wr4yQUC7TrPqNVsT6+GyLzkaL6g8TH+ZOk
         jCpem2KI3Vi1D/SCJnNNFeGD0Ml+lyAehB048fDvLqEyQQ9Y+wu4YI3xMWf7VZdtxvan
         Yong/VmBjBsgZg+4CYVkVxxAcI3iDKaijoYB5l2hacQLBDN00ppae8dwVzSNrf0oqjyx
         UP4OlLzR3WkgU9Lf3mSUCRpyAFDqgX1dtcUlQd1zOlLnY1dGes/LfL8R768RccX9EHpM
         iXhFPsO7xAudck3onkG/svA6qmiYf3T99bHi94utQHU2XLCMS8w2xjWQPXfTXa0W07zK
         Z7Og==
X-Gm-Message-State: AOJu0YzqtBBJaiqQA9i3ahxP/EX2y8DFY1hSpsfTd+mkIIW+UgenHKCw
	bqSN2iMps49k8s7R3nDEDAzx9pWWx6Cs+GNaIIe6ylekN5KIty60LQAQJpfXvRpM/5RnVmyD4it
	0
X-Gm-Gg: ASbGncvopn7UAFxibl8U8JjKYcJAp6E4Wi7rDH26covJdUlb5QofCaSivaHTE6TA/ck
	/0zTHn2u9eC6gujd+JD1q1dSRWELz9fxudA0ECu7FKyo6x8QufVtjWuudHzUn2LWaT+KmmdZTmC
	yGd/gv9Uv/Le+i3xfz1z55zSkXUQY04ZZuVSthCfXjfvTEx0fkH4LF/ARq1qeaHaUbH6YN7laPm
	fSsUSlBb23TzJfZ9jzkbAgOpyp+cXcef5vhefqWj8Ytb23LPPllpZMl7ATb4npe2CTwf2YAeNbh
	A0esu7EVlL9nUTdHtD76BUDU8zDGOVaRQ8ZObHTQ6sFB/HqFhrs0UDVzkUP9GjGeMB4=
X-Google-Smtp-Source: AGHT+IHBUF1XZswRKHhmiD8Z1Iyf4SRQnxGXx/l+ZuM390GPZQvY5eu9U/7UQ4xzyam2eKtVd1YJRQ==
X-Received: by 2002:a17:903:2451:b0:21f:6c81:f77 with SMTP id d9443c01a7336-21f6c81116cmr167613195ad.23.1739221775261;
        Mon, 10 Feb 2025 13:09:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f9a712da8sm23063155ad.246.2025.02.10.13.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 13:09:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1thb23-0000000HCCS-3TVd;
	Tue, 11 Feb 2025 08:09:31 +1100
Date: Tue, 11 Feb 2025 08:09:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	Avi Kivity <avi@scylladb.com>
Subject: Re: Possible regression with buffered writes + NOWAIT behavior,
 under memory pressure
Message-ID: <Z6prC2fBbd6UE49r@dread.disaster.area>
References: <CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKhLTr1UL3ePTpYjXOx2AJfNk8Ku2EdcEfu+CH1sf3Asr=B-Dw@mail.gmail.com>

On Mon, Feb 10, 2025 at 03:12:24PM -0300, Raphael S. Carvalho wrote:
> While running scylladb test suite, which uses io_uring + buffered
> writes + XFS, the system was spuriously returning ENOMEM, despite
> there being plenty of available memory to be reclaimed from the page
> cache. FWIW, I am running: 6.12.9-100.fc40.x86_64
.....

> In the patch ''mm: return an ERR_PTR from __filemap_get_folio', I see
> the following changes:
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -468,19 +468,12 @@ EXPORT_SYMBOL_GPL(iomap_is_partially_uptodate);
>  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos)
>  {
>         unsigned fgp = FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE | FGP_NOFS;
> -       struct folio *folio;
> 
>         if (iter->flags & IOMAP_NOWAIT)
>                 fgp |= FGP_NOWAIT;
> 
> -       folio = __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
> +       return __filemap_get_folio(iter->inode->i_mapping, pos >> PAGE_SHIFT,
>                         fgp, mapping_gfp_mask(iter->inode->i_mapping));
> -       if (folio)
> -               return folio;
> -
> -       if (iter->flags & IOMAP_NOWAIT)
> -               return ERR_PTR(-EAGAIN);
> -       return ERR_PTR(-ENOMEM);
>  }
> 
> This leads to me believe we have a regression in this area, after that
> patch, since iomap_get_folio() is no longer returning EAGAIN with
> IOMAP_NOWAIT, if __filemap_get_folio() failed to get a folio. Now it
> returns ENOMEM unconditionally.

Yes, I think you are right - FGP_NOWAIT error returns are not
handled correctly by __filemap_get_folio().

> Since we pushed the error picking decision to __filemap_get_folio, I
> think it makes sense for us to patch it such that it returns EAGAIN if
> allocation failed (under pressure) because IOMAP_NOWAIT was requested
> by its caller and allocation is not allowed to block waiting for
> reclaimer to do its thing.
> 
> A possible way to fix it is this one-liner, but I am not well versed
> in this area, so someone may end up suggesting a better fix:
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 804d7365680c..9e698a619545 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1964,7 +1964,7 @@ struct folio *__filemap_get_folio(struct
> address_space *mapping, pgoff_t index,
>                 do {
>                         gfp_t alloc_gfp = gfp;
> 
> -                       err = -ENOMEM;
> +                       err = (fgp_flags & FGP_NOWAIT) ? -ENOMEM : -EAGAIN;
>                         if (order > min_order)
>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>                         folio = filemap_alloc_folio(alloc_gfp, order);

Better to only do the FGP_NOWAIT check when a failure occurs; that
puts it in the slow path rather than having to evaluate it
unnecessarily every time through the function/loop. i.e.

 		folio = filemap_alloc_folio(gfp, order);
-		if (!folio)
-			return ERR_PTR(-ENOMEM);
+		if (!folio) {
+			if (fgp_flags & FGP_NOWAIT)
+				err = -EAGAIN;
+			else
+				err = -ENOMEM;
+			continue;
+		}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
