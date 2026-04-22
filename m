Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D423ED12F
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776868546; cv=none; b=TQ6VhARTuaXod+F7ettdbBhFzJYJeyUaU0vDHlkJZ1POGeIMCpowuDsMufr0hURDf2bLiKTmu8SANz8ol/V5niixuG5ADXPgSyntbAOKWdRMlqVhHAi7uOZgym8kDOfsGATbAkmMI59Y+fIIs8ZzONMSorg5bdYdlPPdzuXtggQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776868546; c=relaxed/simple;
	bh=fnt+H+AYWcPJuVRI22snOFX5iURgkUf0ut1I7GfBW1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lpCzbFrz/Scg7Uqu2gH+dFDCxB5SFLvIL60kCLCSkxtvhJYwwh7LZT1dccg4c3U53+GeRWM0ajhPiwSxdTkQdEF4HtdiKGbpohCjE7xWP6BQwrRXQAAZ71TnRyIjSZV6s06TOmYCIVuGRGHr75nBxD4C1KsE8ZlEPkhMdCWBsHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbA9zorR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbA9zorR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C819C2BCB4
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776868546;
	bh=fnt+H+AYWcPJuVRI22snOFX5iURgkUf0ut1I7GfBW1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fbA9zorRcCsT6KKhroBxToHCLwJxg0D2BiK1q1Ag40RWAtEZF61gDqqyfaDito5Jq
	 Fhek7E01zeEWNb4aVK7PcP6BncgTUmp9KxoxGTpGHq2L6hDuF4gqjwJ4b7GvyKGaFE
	 959SxyvJKXbbA6pSSuYK4SNLsnI+GwHwvOmCRWBiSEgsJQztJuxivve97u5jTSEo/5
	 VfQedq0suB8mjVly+qXX+QNeZF72rGta2yvHh6ynd0AokqfGK1A0eN4OKRr9TXRA44
	 d9amh5jYcAozdvCUh1mmJ43uJxqCUGbUM95Awm+BWjdI5oIm3XsUh68jw1gnC/VWps
	 UwNj1L5J2CGyg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-676e62faf2bso1872608a12.1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 07:35:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+d+7GMkTRjbHdH1UQ/dmcn/8hUZDmgA8Z7ybb0+JrbzLxvu8REbl1MjKeIek6RY8b14alEjcXBj4M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxFBwimMwp2tmVKXF93cRh7aG5dXdTvY78wPFi+P6Naa7fjqmo
	RBhmSlewlERQeHLvy16u0YLrWsmPgSt0rMciy7gmaxUqJlVtucfEf+FurJXNpOidJTR2Wpo61cY
	wi6z5SElScVuPAJPUymGwvr6uQ+CcUH0=
X-Received: by 2002:a05:6402:24cd:b0:66b:aa56:ee5c with SMTP id
 4fb4d7f45d1cf-672bffd3a22mr9113953a12.28.1776868544704; Wed, 22 Apr 2026
 07:35:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260422104627.8193-1-linkinjeon@kernel.org> <aejFTDGOnDbQ3OJK@casper.infradead.org>
In-Reply-To: <aejFTDGOnDbQ3OJK@casper.infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Apr 2026 23:35:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>
X-Gm-Features: AQROBzDpCKU8qBGW19QJ_UWzEd2vnI8PeNhbwkx9UEJced-qCbsBp7FCJlLhYAg
Message-ID: <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline data
To: Matthew Wilcox <willy@infradead.org>
Cc: hyc.lee@gmail.com, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	Gao Xiang <xiang@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 9:55=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Apr 22, 2026 at 07:46:27PM +0900, Namjae Jeon wrote:
> > The current kmemdup() based allocation for IOMAP_INLINE can result in
> > inline_data pointer having a non-zero page offset. This causes
> > iomap_inline_data_valid() to fail the check:
> >
> >     iomap->length <=3D PAGE_SIZE - offset_in_page(iomap->inline_data)
> >
> > and triggers the kernel BUG at fs/iomap/buffered-io.c:1061.
>
> Hang on, hang on, hang on.
>
> First, maybe this check is too strict.  I'm sure it's true for EROFS,
> but I don't see why it should be true for everybody.  Perhaps we should
> delete this check or relax it?
I agree that the current check might be unnecessarily strict for
general cases. So I will prepare another patch to remove this trap for
further discussion with iomap maintainers.
>
> Second, why are you calling kmemdup() to begin with?  This seems
> entirely pointless; the iomap code is going to call memcpy() on it.
> You're supposed to just be pointing into your data structures.
In the initial implementation of NTFS with iomap, I pointed directly
to the internal data structures. However, I encountered this BUG_ON
trap during testing, so I switched to page allocation to avoid it.
Then, during the review process for the NTFS series, I changed it to
kmemdup() without much thought. If this BUG_ON trap can be removed, I
could have simply pointed to the internal data structures as you said.
