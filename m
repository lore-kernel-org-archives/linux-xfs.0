Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2329405
	for <linux-xfs@vger.kernel.org>; Sun,  6 Oct 2024 14:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728224940; cv=none; b=tpnAsWS26xpwiPBjO+Q6j3mAvx1MYqqygGfcTEzfLcVaDBMwQoCGdedJMufu4bmVfE7fXM+bigZru1s2gx5m3xj++Wpx89vLDqY3x9seBjZSURP4bpK5IzOKRXsMYHk3hlXlBMTM+bIOEAhGVdO+QhY9nb6B2XgoOZtGSomJ/Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728224940; c=relaxed/simple;
	bh=cvh1VNDKgVQtS0kqZZTJM4ITFk0EyN0F03KA/hlcgRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oLt9eBWNS5hEqXMrYc47npaTmSQYxs9SIlYIJai7mEbU8zC5QCIXhF4Z/3kK1f1KTW3IF/2w/TrHdSX6pRqRy41cZNSt43+CMEZ2NkgjtO5yyseUPqyYetjz31r9f85s2+sd8ZbAocF6ntdJUSKT43SJTQe4anVYXWATZDKgGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=a7wAsigS; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="a7wAsigS"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5c8952f7f95so4297316a12.0
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 07:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728224937; x=1728829737; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cvh1VNDKgVQtS0kqZZTJM4ITFk0EyN0F03KA/hlcgRk=;
        b=a7wAsigS5KIW3PMQtmb31aKgweL8Wu+uluAFdSiVe7P/vEPZT/mXnWkMEPuWFnvNUC
         PyLAMuIuUjt5jwDR3UJo8Ncn6+TXiBmPYskawrZ/Pv/3Fn65wTUUQmR3CCSzhyTM40nv
         1yODh4aQqQH1NwsFvMX/Xa0wanoMLES8JevOc21PZs9URxAsn6RRGLGSDgw+gfkFqjsG
         wXhKLDing37MOZpsQic8c5ZlJDL+heLllM6w/DA7O75EAC2gaipoYqILxiOtKGQ8YT2I
         q3sUmqQVbwKJ07Xg2r1yX+ThgHmgwZvLJWjnR9cr3Z2rIiOhosv+rNAYlHh3/ORFT4pO
         a+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728224937; x=1728829737;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cvh1VNDKgVQtS0kqZZTJM4ITFk0EyN0F03KA/hlcgRk=;
        b=d8hoV14zPVgj7ddmaNUPF4O2Mout3/KRttESSsqwMHLWNu76r91NP5buoFOXuSOc7d
         6RiBy83ZIblSuG9ol9My2Qjqjwm6It+JBoJAMQla1ihUcF8LjQn6yvpzShLKFsk4ATTQ
         N8M4zCNSHwJ0tiytlQippAndEfeLTRJnbS/Q79sqH2Yr51fkf7yM6+or8x6hoFWwbvFb
         y9sRx7r/aBXOCtsc9jHUtjr5YJs/fOECfphCLozJO42jrCeYt4UzW+qbkxJwefOwRPU0
         PMa3xZxrwPFMvQRz/Dau7yZ60LrYzZIwBia376QEjkCGa04K/hk5lctC5dy54ojQiFoe
         uFoA==
X-Forwarded-Encrypted: i=1; AJvYcCX30Y9TAy2hu9Wtxsd5s0McmR9WBffi4sXtK33OLfzWFxS8SkSQAEFOh/NAfAmfJ6an/LC1ErYAZZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR9wntPiHK/MbG1kJlUXaFD3fP5oWC+mkcoptIhRlN6iR+sxzk
	5AE+fyoEhG9dO8w4GLp/FEoFvgPYjIHppmI0cjcDAVfXNeHEDX+Q4P0cEt9fM35ZfrQl3S6JwhY
	YR5dPqGp921xulQrFx/DFd6CvgbympKIfDWbzOw==
X-Google-Smtp-Source: AGHT+IERmoeIAzbY//wPQ0ALN0hsGZOsI5Ri64LPZKPMVqcGOVQM6SZuK6lN209r8+tDeh3E7y0WZX9FnBRU4TONBKA=
X-Received: by 2002:a05:6402:3512:b0:5c8:97dd:3b03 with SMTP id
 4fb4d7f45d1cf-5c8d2e9ef80mr6600615a12.33.1728224937414; Sun, 06 Oct 2024
 07:28:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241002130004.69010-1-yizhou.tang@shopee.com>
 <20241002130004.69010-4-yizhou.tang@shopee.com> <Zv1OYxSYWUHarUrL@infradead.org>
In-Reply-To: <Zv1OYxSYWUHarUrL@infradead.org>
From: Tang Yizhou <yizhou.tang@shopee.com>
Date: Sun, 6 Oct 2024 22:28:45 +0800
Message-ID: <CACuPKxn=XaJPcANC4VwtSX63EaVpYJA5FJ9mcN+LR+XmMpASiA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: Fix comment of xfs_buffered_write_iomap_begin()
To: Christoph Hellwig <hch@infradead.org>
Cc: willy@infradead.org, akpm@linux-foundation.org, chandan.babu@oracle.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 2, 2024 at 9:45=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Wed, Oct 02, 2024 at 09:00:04PM +0800, Tang Yizhou wrote:
> > From: Tang Yizhou <yizhou.tang@shopee.com>
> >
> > Since macro MAX_WRITEBACK_PAGES has been removed from the writeback
> > path, change MAX_WRITEBACK_PAGES to the actual value of 1024.
>
> Well, that's an indicator that this code need a bit of a resync with
> the writeback code so that the comment stays true.

Thanks for your advice. I will rewrite the code following the logic of
writeback_chunk_size().

Yi
