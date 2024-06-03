Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4755C3AC0C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 07:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717398514; cv=none; b=MOk/EYIeHvtF1AXIwMpj7RULMPhabS5fWNEvIJKNajVdz+1CweemLxMGf7J+WVh9V9CNxwRWE4C5e2UVmDW38k0K4TjPOt0yYjfeF7jUhPQSqZR3gMVDcvZVtWU2vImpsouHJuvv0Y1N+9rGTQl0TTLUjEKbmlhA5lWvSF7xO5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717398514; c=relaxed/simple;
	bh=SE+o1rEGCqj/qkQMBoTIrXRvJlXnl93yOBoFpvQwKfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmOGTIyRUCCNM1qHsAmaK+zjnTQexE04kOxV2BDtC2vVbzrtRgwXJqtJ4ysex0jdok6RFZt1sboMH5TrR62vnoQkBDlCwtdsWc/w5S1kC4n2xHnWjdPK0AM18VwvLxYnSYYTV1o7ksqnBQlKPcQSiB0iNLrRDt36IPg9iOT8Kug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XS4/ZMNM; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XS4/ZMNM"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dfa7790b11aso2626799276.3
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2024 00:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717398511; x=1718003311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6+8RHiPBbfpsl0IHI1QwyO6YCZwwc/aC//eUrmLbKI=;
        b=XS4/ZMNMiogOUwDt5l8Dthb3n3sYPG0I7ED57DIvY35jqXB9sYpHKLyu/GnvPWUeUz
         l/pJXaiZ4Z3rJDeVBPxdLkqxbSWituAHQWAIz2jSnMLEnO2d1jytIzfabXXo6VowDDkV
         etB0pQ6I8cO4y6jL5tShZkWMUBA8T9YaCKdZnmGxDCXZYtcd9hx/3HWYbkH1Mpa9mnUA
         TDiQx1pm9C6R9IsHs0I/EFT5oQeGf+eecjbsjnScuTw9RkNb8wZwEoA3CaYpCEj51MDt
         VhwTyJCBre5h+/0JMnqhtLVDaOVWKWDbr6vffmxz2q0gAi3113+GFl8ZJX9c+zhr/ons
         7omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717398511; x=1718003311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s6+8RHiPBbfpsl0IHI1QwyO6YCZwwc/aC//eUrmLbKI=;
        b=SN4LnqL/btH+azNNPoOkvY0XQmDsPz28faxq4GG1g16mojfgTuU8MDAemalopVJcTi
         BP5XJDq82dE6EDGwPhBjZpOMUsMYLLbhfVdqds+F7+GMc7vCbx1YuAGmIFiyvJNKlmwQ
         38pUJqOPMgzeLD+YVFAspA4EORbo1ZYTbxbEpy/alHnQn+IkUrCN+cekvcyzxrXSc4EF
         MIL3QkYxQfospR9C5EBKQE9YYWtDBrQ7dUdyFFEA2rxqmp0t8ymMHrqnt6q0EpHuvUsf
         fscDuNrmpRLxkVOo7ruVfTe17Y7pBgp2/J7W4X2ZYHZ7vZz8oxRPN/WZKzJzmbI6FHyh
         gYhw==
X-Forwarded-Encrypted: i=1; AJvYcCWvj0LnVOsAFb7Zch+t/SplMW1eLuD0toTRJZ8Ddkgj7ccyMYH+GwTntrtIEsUViAwMPUVhxV1+kkayhfqHkMO+amCtiAtQYcAh
X-Gm-Message-State: AOJu0Yx6jwn9V7dKqc7UEsK2iSf3HVY4DNF7EyJ5gVitHLi3gpv0N3YY
	7gu9p7DYf9bwD1Li2teOBXkZN8XvYmHm7I75feD/ZX/400V7BxD06b7VOaewPCWTVUaZ+Ho/ASl
	/1JUwGdnQkfgzJpaEqbH2LqbNjNo=
X-Google-Smtp-Source: AGHT+IE3GkVjEVmCgvnYKyn3z841ekjpqT5WBYdd2UKouk1UUreAQfbUMXPLzaRMN/J4Eib5UXYVHiGKAPeZ9NsTJ1A=
X-Received: by 2002:a25:d682:0:b0:dfa:4780:2990 with SMTP id
 3f1490d57ef6-dfa73dbfe8emr7567688276.56.1717398511174; Mon, 03 Jun 2024
 00:08:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529225736.21028-1-llfamsec@gmail.com> <Zlfmu4/kVJxZ/J7B@dread.disaster.area>
 <CAEBF3_ayLsCJVPdZQCb=gHtiFCNG9C3xcGv4_cnUpmS8TQRdYw@mail.gmail.com> <Zl1bequjV5u9QjXD@dread.disaster.area>
In-Reply-To: <Zl1bequjV5u9QjXD@dread.disaster.area>
From: lei lu <llfamsec@gmail.com>
Date: Mon, 3 Jun 2024 15:08:19 +0800
Message-ID: <CAEBF3_bwJZfr6NQNzgxLb4cNah5isG=Z7sLGjikwKfeDZRDGGA@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't walk off the end of a directory data block
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Got it. I will send a V2 patch to do a proper validation.

On Mon, Jun 3, 2024 at 1:58=E2=80=AFPM Dave Chinner <david@fromorbit.com> w=
rote:
>
> On Thu, May 30, 2024 at 11:10:57AM +0800, lei lu wrote:
> > Thanks for your time.
> >
> > I just add check for the fixed members because I see after the patch
> > code there is some checks for dup and dep. "offset +
> > be16_to_cpu(dup->length) > end" for dup and "offset +
> > xfs_dir2_data_entsize(mp, dep->namelen) > end" for dep.
> > =E2=80=9Cxfs_dir2_data_entsize(mp, dep->namelen)=E2=80=9D ensures the a=
lignment of the
> > dep.
>
> Sure, but go back and read what I said.
>
> Detect the actual object corruption, not the downstream symptom.
>
> IOWs, the verifier should be detecting the exact corruption you
> induced.
>
> Catching all the object corruptions prevents a buffer overrun.
> We abort processing before we move beyond the end of the buffer.
>
> IOWs, we need to:
>
> 1. verify dup->length is a multiple of XFS_DIR2_DATA_ALIGN; and
> 2. verify that if the last object in the buffer is less than
>    xfs_dir2_data_entsize(mp, 1) bytes in size it must be a dup
>    entry of exactly XFS_DIR2_DATA_ALIGN bytes in length.
>
> If either of these checks fail, then the block is corrupt.
> #1 will catch your induced corruption and fail immediately.
> #2 will catch the runt entry in the structure without derefencing
> past the end of the structure.
>
> Can you now see how properly validating that the objects within the
> structure will prevent buffer overruns from occurring without
> needing generic buffer overrun checks?
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
