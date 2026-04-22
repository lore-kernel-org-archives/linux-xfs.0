Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C913148CF;
	Wed, 22 Apr 2026 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776871713; cv=none; b=nJR8INE6CeG5NcOGuLbcsMAiSEKDeN+nkVzfTIuBI1kEeR0KRPezedqkbyfXRt9v01mymiaZSgbSkA8ZivLBXjz2r/Za/nqIKw3fp3hU1Gv6Uf9lzblYxJNU0rYGbyq/nMltNV+uS/lmdzkBcBB4X6+knxIIw5wmxkF0c9z85Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776871713; c=relaxed/simple;
	bh=JF+DhshXa4vQS+uchdEATDg703gV/8IV0HlxJThU9YQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bcjIqnjVTudbwRRhaZ1mWTjpH7Q4lZpEGyLuIeaL7l2MgkSOjNi9k+W/wmbmLLnFirL5+FA+X8VO1m5bdb4WpAJTNU9OyeAgs7gxaEXHGY1OqeyCNyXv++DBDVu8wuH+c1mTb8oKawiaJ8RF7W8MD+ZAht5GKo7aryhzwXBqFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o8L1Q9+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o8L1Q9+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E5C19425;
	Wed, 22 Apr 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776871712;
	bh=JF+DhshXa4vQS+uchdEATDg703gV/8IV0HlxJThU9YQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o8L1Q9+KeIhUDWKWZNgsdV/b52+nMsF18KI8cQaL2BtYXPnQm7mvuqM3DU+EBmIdD
	 u8wPOVNqc28w8Woz6yfvuYlWLuuTWEvoWDFa1d/NowJWPBCDLErorKM/ufganDegxM
	 KECnct3+mnmgJtvPqL0xIALTG630T7tyfNdq7HxvA8oh/0CqRKDXRwplI4qjn5cPKD
	 vDzXymCQw4+J3AoUIi+ViPQYpiUHZ9+7ijssKH1bh7s+9+ziSlykngAjZZ77dDyi1d
	 zEzvQCNhDV4Hacooj8T6LvPtNwx2A5s35znJWdrUr1ZPVVqTPHB5WWEAmLT3tf+bXP
	 g3z9PxKvuavFw==
Date: Wed, 22 Apr 2026 08:28:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, hyc.lee@gmail.com,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH] ntfs: use page allocation for resident attribute inline
 data
Message-ID: <20260422152832.GR7727@frogsfrogsfrogs>
References: <20260422104627.8193-1-linkinjeon@kernel.org>
 <aejFTDGOnDbQ3OJK@casper.infradead.org>
 <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd-RQrrpXH0R_Y87r53h0-KCDGVOtm5RaqTGETMEq-LYpg@mail.gmail.com>

On Wed, Apr 22, 2026 at 11:35:32PM +0900, Namjae Jeon wrote:
> On Wed, Apr 22, 2026 at 9:55 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Apr 22, 2026 at 07:46:27PM +0900, Namjae Jeon wrote:
> > > The current kmemdup() based allocation for IOMAP_INLINE can result in
> > > inline_data pointer having a non-zero page offset. This causes
> > > iomap_inline_data_valid() to fail the check:
> > >
> > >     iomap->length <= PAGE_SIZE - offset_in_page(iomap->inline_data)
> > >
> > > and triggers the kernel BUG at fs/iomap/buffered-io.c:1061.
> >
> > Hang on, hang on, hang on.
> >
> > First, maybe this check is too strict.  I'm sure it's true for EROFS,
> > but I don't see why it should be true for everybody.  Perhaps we should
> > delete this check or relax it?
> I agree that the current check might be unnecessarily strict for
> general cases. So I will prepare another patch to remove this trap for
> further discussion with iomap maintainers.
> >
> > Second, why are you calling kmemdup() to begin with?  This seems
> > entirely pointless; the iomap code is going to call memcpy() on it.
> > You're supposed to just be pointing into your data structures.
> In the initial implementation of NTFS with iomap, I pointed directly
> to the internal data structures. However, I encountered this BUG_ON
> trap during testing, so I switched to page allocation to avoid it.
> Then, during the review process for the NTFS series, I changed it to
> kmemdup() without much thought. If this BUG_ON trap can be removed, I
> could have simply pointed to the internal data structures as you said.

I think the check is wrong.  We rely on the filesystem to point
iomap::inline_data to kernel memory that is at least iomap::length bytes
in size.  If that crosses a PAGE_SIZE boundary that's fine, so long as
the caller actually mapped that much memory.  IOWs, if you have an
iomap:

{pos = 0, inline_data = 0xB0000, length = 32768, ...}

then we trust that you really did map all of the MDA text mode memory
and that memcpy'ing 100 bytes to pos 4090 is ok.

(Perhaps this is a relic of the bs<=ps days?)

--D
