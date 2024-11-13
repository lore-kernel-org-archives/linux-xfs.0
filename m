Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B2FB676
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731458345; cv=none; b=b3IpADOOHMK7UpCZu8P9lCzWf6FGWq9qrMTdp3ShSzFhbB9Q9Zst1hj4gn5xSwXu8kkdc7q8En+pYnEgKHDDhfBjzV8zQ4OVOvzMQU5RqRSTAqGTXT1RXiOj2TqdKIIDiY9V/8Q/l8vzEzbmNcKKVgnm/50CKMb0RSfVl3FrzGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731458345; c=relaxed/simple;
	bh=YpobwbtA2+vKxtJu8xZ2FUyLg/btakBlHfnLUEUx69o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hcUc34skMSqL3PP24lHXMGzpzaILWPSe/pFHZyMO/fmM2VhfLv8m54v/88/y8MpqNK5k2JAK+DcIaZvr0aKFA364zHaWUo31mNnRYu9qdGT5lF6engqVosgCHEQN8jOMMx254nufUTKPcTNJhVbNFhgNhXicg98ZmMMfmVD3nAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoE+xZvU; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoE+xZvU"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9eb3794a04so908726366b.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1731458341; x=1732063141; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HToIlSDY7cOn93fCLokqkKx9Z4UBbjM0FNxhpulJNm8=;
        b=EoE+xZvU6EDOKXSvsLLNaZJ9RmD6Fffex02A4Q4C3xXlUTc4oliTxpO+AKHeBUY130
         Od7ENT9349yuehtel68hjw6V06589TZmNnXGldpmdruBp02OUtC0GcAtx3KKQPc+XgOY
         w/yuR6jLbQux+QGscVnFDgk7Swp6D9d4z3ZL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731458341; x=1732063141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HToIlSDY7cOn93fCLokqkKx9Z4UBbjM0FNxhpulJNm8=;
        b=lHT9lJK8hCC7AyMhv+mHyxyLFq4thtOg2wcB06W0Jq+Uo+vDXoyw55c5Baao3mtxAk
         wHRoW8hjakh3pdMjzKTqV2BwfJDUyxxBBoECp9k2CYVGv23hhuxeTw1n1wZDams8iPTP
         Go8/Je2+jhcColxvgWqJrHRLJYDn5DJfVrNx5dtNlxI2+vIknBaqwAyV53q26qBfiTpc
         fTZ2jhb6eTV+J21wL79UuV2J/WNS50gE1nlq+gGQJHPbGv0CL2Bkmv49j6loyrAFfXkM
         kjHP8OBM3TwKUmTqQGmNhR4FFCDGODXw1LGbEe2Vx7qXUfDfCV6b/OQAJLt7f7neuidQ
         vgUA==
X-Forwarded-Encrypted: i=1; AJvYcCUkh4kVPSJGrRRCRMXySLi6PoeVJe1OIKc0SAM1JqcoBMeMJzX+2ub2xKmTvkb9T+sgbWK48v4LFJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA8sma1skHFBMkTQv+y6IFrJ3Rzk9C/MrW6TXJCmuNnUZmHoNW
	2qmqj2VQ5ZCB1OnGQA38XdHRVzr/t3YnfruWJw4LPHQ9ZLrYaHcohv4ii5F67zjYWFCVhA07pQN
	u79OXCA==
X-Google-Smtp-Source: AGHT+IGtTpD4SMxHmEhQA1NhQjWnQwJaGi8RnsVyHsE/ZJFMNdMTFSdv4MoTJHP+PgMwrOABWpCGPw==
X-Received: by 2002:a17:907:1c90:b0:a99:36ab:d843 with SMTP id a640c23a62f3a-aa1c57ae894mr423060366b.38.1731458341576;
        Tue, 12 Nov 2024 16:39:01 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0dc4c60sm799234166b.102.2024.11.12.16.38.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 16:38:59 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9ed49ec0f1so1062060366b.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 16:38:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWNXM0KzU77w2lH9KEMPC64nLHgRT29JjKC98pPfjar4cjV/d4hYtTaWp4NTCZcBW856ooKatDiETA=@vger.kernel.org
X-Received: by 2002:a17:907:1b0e:b0:a9a:1792:f05 with SMTP id
 a640c23a62f3a-aa1b10a45a5mr487896766b.31.1731458338247; Tue, 12 Nov 2024
 16:38:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731433903.git.josef@toxicpanda.com> <141e2cc2dfac8b2f49c1c8d219dd7c20925b2cef.1731433903.git.josef@toxicpanda.com>
 <CAHk-=wjkBEch_Z9EMbup2bHtbtt7aoj-o5V6Nara+VxeUtckGw@mail.gmail.com>
 <CAOQ4uxiiFsu-cG89i_PA+kqUp8ycmewhuD9xJBgpuBy5AahG5Q@mail.gmail.com>
 <CAHk-=wijFZtUxsunOVN5G+FMBJ+8A-+p5TOURv2h=rbtO44egw@mail.gmail.com>
 <20241113001251.GF3387508@ZenIV> <CAHk-=wg02AubUBZ5DxLra7b5w2+hxawdipPqEHemg=Lf8b1TDA@mail.gmail.com>
In-Reply-To: <CAHk-=wg02AubUBZ5DxLra7b5w2+hxawdipPqEHemg=Lf8b1TDA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Nov 2024 16:38:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgVzOQDNASK8tU3JoZHUgp7BMTmuo2Njmqh4NvEMYTrCw@mail.gmail.com>
Message-ID: <CAHk-=wgVzOQDNASK8tU3JoZHUgp7BMTmuo2Njmqh4NvEMYTrCw@mail.gmail.com>
Subject: Re: [PATCH v7 05/18] fsnotify: introduce pre-content permission events
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, brauner@kernel.org, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Nov 2024 at 16:23, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 12 Nov 2024 at 16:12, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Ugh...  Actually, I would rather mask that on fcntl side (and possibly
> > moved FMODE_RANDOM/FMODE_NOREUSE over there as well).
> >
> > Would make for simpler rules for locking - ->f_mode would be never
> > changed past open, ->f_flags would have all changes under ->f_lock.
>
> Yeah, sounds sane.
>
> That said, just looking at which bits are used in f_flags is a major
> PITA. About half the definitions use octal, with the other half using
> hex. Lovely.
>
> So I'd rather not touch that mess until we have to.

Actually, maybe the locking and the octal/hex mess should be
considered a reason to clean this all up early rather than ignore it.

Looking at that locking code in fadvise() just for the f_mode use does
make me think this would be a really good cleanup.

I note that our fcntl code seems buggy as-is, because while it does
use f_lock for assignments (good), it clearly does *not* use them for
reading.

So it looks like you can actually read inconsistent values.

I get the feeling that f_flags would want WRITE_ONCE/READ_ONCE in
_addition_ to the f_lock use it has.

The f_mode thing with fadvise() smells like the same bug. Just because
the modifications are serialized wrt each other doesn't mean that
readers are then automatically ok.

           Linus
