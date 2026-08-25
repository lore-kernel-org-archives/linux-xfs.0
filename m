Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875F537EFFD
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 20:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787688430; cv=pass; b=f0IQyyjAnj2OUbxEI2VYW8/vkoLRUvHgWqr/b+i1dZSx7j5Berg+3f/+jp+egoh4/CLEV3CBMZezLYmFTk5tXat3dn5YicAUVl6ITxSKlw/inHVpSGn3dp7ud7WW/ysZ38vhCDilMYtLFk1Ohu08H+eY6n59XSUHExxuT4k0AcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787688430; c=relaxed/simple;
	bh=YuDwdWxWI5Vzf2u31gjFFz05KsfDHJyOtaNcUhXTBZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcH7YU2tm92QW7Psa5P61fyecfK71MoDLTps9eiLxE7T6lVG7zRfOks+6KF4TCfqF9XN4JBbbBQmkhUnqNcv+nEBDRkbWPmqVRc4XnE2KmTudAiQIw1/byBEELeB80Zhjyv+DlguXIqG5uxJHIGevddsr9kq8i920GCS2AJxh4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKpEO3uP; arc=pass smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKpEO3uP"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ccdf36f63dso33825ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 13:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787688429; cv=none;
        d=google.com; s=arc-20260327;
        b=l4kvV733nc1mXMCENoBMZuAC2X1CH/YebhiOy16+XC8b4wcDTvIsjt7bcp23t1+KVk
         mqfPPM/obZhRBoDb0I5b4sxDJ0mmd9ZwvlCCX0lxKcxliWNV2yvoPfeJMNjJoalodS78
         7ros/R+B65dWGEnw/avqSvxuSZ2HQIkRgKkJz/9s6CUr+cARJO01x8Pz5uzItwrImOv0
         66QtqKxvgbujFoT75QBR1f2RHXGA5i+1gak8/mx8vvVxnWYvNZogVhNLVf/fnwuKyH41
         P0yRNYA0VcZQN7hioO11jMa+W1oLg22hruobLsG8ZYWCaCekZs9MpGbv+Jj4hJxOXXVi
         tpJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        fh=cqR8X9XBrfvOe9Ua+YAae14NDLuvOIErjC9PYr2/mc0=;
        b=lB06QS6Z5idsLqMeAoKua/lPQceTvTRmbdNbf71daxFtLtop4Jfp3utW5N80EwL0Sm
         Rk7JIbZwOWqemhDiQYJB5Oasrzhc0Hcxkd/M3qNatzsLAIliIm9Pk0EEiF21Bfh1Kpu/
         OISI0ORODk11uqgLC1B3XsxDgbzmUbXTAJKZR4kslVyQaFBfEOHq3tGQidPmJumqNSOj
         TwQ4rPl6F/ICzJggMLD2NRsxC9KLZux9olwzx1a8jfXj6QNxCEiL6X189SEn904vBltS
         Plgo1t1SKcR5/lzE6rqMy6Cu8AzNZ5u+0NfbRZvUQhb39FRdhOkTjQRkt/vzbJ9WgIwn
         TUZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787688429; x=1788293229; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=NKpEO3uP3XiMvqGfLcqjvFeuJ8D5jsq8I30qKsRalF3gtJ3h4tH5Lafr1necQfKysZ
         XQRl7e2mqv37A2Y/hJoax2/URWgHbgF2/9EV7ks01fPYeDmugp3BOYx/jOQ5mfF4wh1q
         dwEZ1M8UNmRseI9gwbmaY8S1g6twVjXOhhGNJFTN0V6xYaVLSe5URyBq2sAcCeaW02zk
         lOtxG5ieucnN1r2q0ZuCkOW/k4vvZNLBGn5ByYKUilxok7L0S27kYw7+IVB08EPcvwU9
         g/orUJwfXzxLC72dfLYIKNoFLdSJ9opP8lsBuAR3J2zIgqq3dnNK+qz55nJ84H9kgK6p
         z7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787688429; x=1788293229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QmpPvlugr4sJVMK76hZIVWaN8XuXLrWZ5bMIrs2ohCE=;
        b=hWSl3qJKJBbAQeb68mPZkB6ki/k4Zzzy+zL5jSQj5PjUEvxSovuHcqS2m/YFNnjKam
         /SC58nimMQqbNfBy8MWYXXJ9WB9pmrnFvz30iqACZazA+CWzm5WttXC/lGMLd4dh655R
         NcQ5NbudPxOF7axjWy7oyvdVaVu2K/z8rp12RSAu/O8teEmhy745T4weZn0jyvq4aCvT
         xbm2XGxAvhEtz4AnEjnDJItgstLtuiz5AjY/puOe2SFreCMtpecG5YeKk6T4PZ5KhSdA
         /2QsChtYIJs6b6xPqDRJ8dfERgaHZxYXDq14BtNUPajQFWhm+paLZgxx//gqC/n1dal3
         PqhQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrl/h3BghA55k7+E+j9yF09rsv0IhSqwVs4j8w7uzPHo2OpXZXj7hs7uu9eWfFEM2R03VBFcGJkkcc=@vger.kernel.org
X-Gm-Message-State: AFuF++mW8P5fiLIIcNqt0uKW06rBPdohz7MPSgfI5TwRQYJiBnDE6FiS
	OnX55ZDfWUoOj21TGNaviBs8Fpnp8WtKDAZ4+9+dZDH9LtrYKV2Eh8deDmV1QwuAFJYseUCBMeD
	+lHsGXkKtq6Sr4bLMCXrQaeT3LHRcX1Hll5j/AGJ/
X-Gm-Gg: AR+sD10r1LZjkiFqzEIzcm6ZTPMcsXjC7GcJ/XIyCI4XHX2QwH2cAMLKUfxBy4hTW2O
	RQRS7I1TYBpI9nsMb2+Hs2tXZtiKPlZveaMvUIwRw49WjVvQBm2Eoxj1IWt1wKbcTne7I/is8Ef
	4IwTXvh7zi2ipP3L4eUfbzNE0HdBWjAPw1cQCU24dZLr7haJ0PNOjbVJ5dOVAO0trA5vduqhSPF
	uQ/fmAsm/WHAWRt2GU93TyRLdd59sNp8ucEBIiyOHP3tLnlPZndf3b7jDIU6RqA7b5lVWoQ+zMr
	ceETSUdsGCCMKL5gXljrGoLgQxyy4nY5HLBqKWHiuXpNCyEKEh8X5E6O4f2EhwdImjolbjl5Szq
	GVkSIelR8kl+u2AL+CwbgXmdInW8TNw==
X-Received: by 2002:a17:903:4b4f:b0:2d5:c090:3810 with SMTP id
 d9443c01a7336-2d70baa1fdemr376215ad.2.1787688428259; Tue, 25 Aug 2026
 13:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
In-Reply-To: <ao3y8TtEGjniZ_4f@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 22:06:30 +0200
X-Gm-Features: AcwNN1U7imKfFFWcqWcxt2X9g3kXc7_YW65q6sOXIrpi9lP4BGYdXKwulbCkr7w
Message-ID: <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
Subject: Re: Removing ->dirty_folio
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 9:54=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > Could we strictly ban using get_user_pages*() for write access, and
> > use the unpin_*() helpers to somehow enforce that folios are always
> > dirtied on unpin? I guess the problem with that is that we have no
> > state that tracks whether the pin was read-only, and finding free bits
> > in struct page to keep track of this is hard?
>
> We'd need a count, not just a bit or two.  A pincount for all folios
> is on its way (eventually) but I wans't planning on tracking writable vs
> read-only pins.

My thinking was that once a folio has been pinned writably one time,
it should be fine to mark it as dirty every time it is unpinned, even
if some of those pins were read-only?
