Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A9C2561B5
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740413766; cv=none; b=nEGDGlL68YAtzoI3VDLjXy65L1xgGvZyGW5MtpP+Yhv6FHENuapeS/Pl9t/ynmb4eVKcLYTzI0S5ioEnfpVTI1dsenhfSAqHfTEU6IrJDLCZOqc0eT93xg0VvjeTJ70Acl3yQu5vPjEowniefYWY3BEV6o4JdK1PHZWGtffyj/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740413766; c=relaxed/simple;
	bh=znP639qDra56/4CUkzxbXJtwHv7Db21X2va2+tu0sYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gt0DFul5aTicE3Oq8a1gXHMg6soPKc06PfUlJjFWGgyrVF9hTAFDQ4Y63PqPLvBylnJ7C0JvXcKiT6afT+LtOB7TV3rg4Z4ucyx1TZy7UKmEVR0UmKzpsRMaXWoDYuyP19M/9blYSEFl41bkIaDKjZIsUJB4MJDTv+vXnL6sc4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com; spf=pass smtp.mailfrom=scylladb.com; dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b=lnahq4jv; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=scylladb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scylladb.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=scylladb.com header.i=@scylladb.com header.b="lnahq4jv"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-220bff984a0so97384855ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 08:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb.com; s=google; t=1740413764; x=1741018564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VbFIiyVBu03rSNrD6SoQF/QaduESan/tbVEXpCDAIFo=;
        b=lnahq4jvtuhPxtHg0lUUhB7W4b5zdBMChBao31Gl7voRCMDBISD0SI5MY/EXw9/wGz
         4ufHSu+DiQtNAAobMlQHgEhACdgMCIAYn+ZuDROPFREvJtQm+3qC+MiLLBTSt+VZXVQb
         ey9fJA5oPNnx9UUeh/HuSxvtiSGt8iN9i3NSPcn/Yyy+h3FOmuwfF40vTLR5dwP61QFu
         NgOspP9pXU4yk6hjuCy28pyf2cF3QZ6GHR+IXNf7G4PBYXA88CMGhW6nEQVcxDSHTWUK
         4wpm9CnOm+svkLvzP9AEOrTUAsEi4xVYY+fpbEfsWVRO6BPjsCkRmlsidujNUTD6CUYH
         mVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740413764; x=1741018564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VbFIiyVBu03rSNrD6SoQF/QaduESan/tbVEXpCDAIFo=;
        b=qebHcZZUAH4gHyUJL03JvJoHYNykIu413O9ew54dy3edVz/RtIbo4WmTYNXaHo1AFH
         orMnRsWSeBmgAGIsmA6Q7PUOjkmJIOgEFaIYWfrek8A6FvgDZ9t7Hofpm4k1ZqNmUDxt
         RX6GiWTE5VI6Wh/xdGTyfZkoYMUUKbhu09ObAtY+p7LKhEZmV5U+UxqNLfQeoEEb9xpF
         nCmUKtmFi2vxeI730+vAbf1N2MoatF1UtU/UmYzJRNlw6E5CoqE5EgmiqMtUQNhYxSVj
         9geQi/3l/yF8OsLZzO/RLXzQL+uq8d0Tj/Y9hlFrVlkTqpfYmrYOTKisrYfk95WgRpO/
         kjiA==
X-Forwarded-Encrypted: i=1; AJvYcCUVeT/aGUHdsofHXmZPiurFbhQ8XWYr2QMREHHp8KSmVsHNTuugiGnjPcRpNyxTWCjr+qo5FtWQHOc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyodKabjyNHkRK5YZQK2ggqYte0RsaMMUCwbP/cnmsL8WnqZuUZ
	xwoXg6Q4eTpK68Fm5YQWm7QXHmVBENgkKrMcbJCRQOzmsuHfhvCmdLuyDGtGwC2tCYwnl3RTp2s
	KZlTGbkr/EApDAVIJjjIpCHj8rrZbiXQ2dYvNLSBCCs9fef6Jh1vo4X+yprAy1ggiDaJtEy+OHG
	VMkR5x+tQ4nWdVO8eq3BRoEn25hHZJY38iGFAFkfnTBRueQ17uJVXeE41KOpuWLOdaTtD1OrjF9
	Z4S1P7/2ATwQMf/MwnapC38I1M+llJHoJJmD2kq1cAGP2ziasqgwSrWGapUvlI+8SzNb5saax5U
	2QUcQNHEdobBvjTEUrQ9fX9LeMr6TrvSc0oD0XQR3OES9+n3foRZD/0LUkRG8CqkwVgn0jN2JFc
	GFfkcc7n4
X-Gm-Gg: ASbGncuNMuPbhu9uf97BdJo22qSO6xy4roOTftGZaFnELLd1ek0jsoMaB65SvZaGxPB
	G5WRjoPSNzNXPSMOGukFfTLoKNkGkdBvWCmltP9zKZptsdwyTwmAYqUW1knYhNELWDobLoJCJmL
	vTZ5y6ufoTjUUQlF7ZY39n6w==
X-Google-Smtp-Source: AGHT+IEQcUqXWyzW7txhoFxLDejkrVizVTPPzSveJ2vrUrEWjOUz5Sv5py/r8tfjXiTPcGqGgkDF7WJoXP7Am8Q34zY=
X-Received: by 2002:a17:902:e74b:b0:220:efc8:60b1 with SMTP id
 d9443c01a7336-2219ffb68c7mr179690365ad.39.1740413763937; Mon, 24 Feb 2025
 08:16:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250224081328.18090-1-raphaelsc@scylladb.com>
 <20250224141744.GA1088@lst.de> <Z7yRSe-nkfMz4TS2@casper.infradead.org> <20250224160209.GA4701@lst.de>
In-Reply-To: <20250224160209.GA4701@lst.de>
From: "Raphael S. Carvalho" <raphaelsc@scylladb.com>
Date: Mon, 24 Feb 2025 13:15:46 -0300
X-Gm-Features: AWEUYZlaokoekDAILx5r9gFW_X8gGLcj_ZVwIHgsDoW_nk-h_xzSP63aCt62qg4
Message-ID: <CAKhLTr0bG6Xxvvjai0UQTfEnR53sU2EMWQKsC033QAfbW1OugQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix error handling in __filemap_get_folio() with FGP_NOWAIT
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylladb,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0
X-CLOUD-SEC-AV-Sent: true
X-CLOUD-SEC-AV-Info: scylla,google_mail,monitor
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Mon, Feb 24, 2025 at 1:02=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Mon, Feb 24, 2025 at 03:33:29PM +0000, Matthew Wilcox wrote:
> > I don't think it needs a comment at all, but the memory allocation
> > might be for something other than folios, so your suggested comment
> > is misleading.
>
> Then s/folio/memory/

The context of the comment is error handling. ENOMEM can come from
either folio allocation / addition (there's an allocation for xarray
node). So is it really wrong to say folios given the context of the
comment? It's not supposed to be a generic comment, but rather one
that applies to its context.

Maybe this change:
-                         * When NOWAIT I/O fails to allocate folios this c=
ould
+                         * When NOWAIT I/O fails to allocate memory for fo=
lio

Or perhaps just what hch suggested.
