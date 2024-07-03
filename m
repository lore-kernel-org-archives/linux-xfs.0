Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7ED1DA313
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031711; cv=none; b=We19d2DtjUy6rZHWnx8RrFujesBpetSvG/zJVSGgDm88gCndK27DDuJV0nlrTUoe6P8M4FZifu0VXQm3x4iPtDIruEsGQvseNTxcgjAazgCws8HU6p6xcIo4IQTdA8xQy+vIERNVMX9dpPfgjXWx/YlWhFmnbnB8MuPLDTqeIf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031711; c=relaxed/simple;
	bh=pCpCGZTU/S2e+UXLaKYV+X+oWaade5T56Ko47D8Yq6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUSTB6jBzU0+tYZK8e9KoLlISaiO0om6KlwzfM+HqZSim7sYHWdIHmiGqwnvCg5IUl91Bvpqwasjp2piE1oIQLyagGu5houam5+IApy9SRQraHaMNXkIBWIqJ0KcX12B7euHlt4hB+caY7eyjDY9kXTJoB/UHHG/5MEukpIVRPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTwtJMeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTwtJMeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0CCC2BD10;
	Wed,  3 Jul 2024 18:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720031711;
	bh=pCpCGZTU/S2e+UXLaKYV+X+oWaade5T56Ko47D8Yq6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fTwtJMeRiBi1iT17su+eMTN/7pBafwgD0P5KBgrvNPqHImBPrR3m3IL/vnhSTdzl8
	 TE/FmjEiaYOfqSX7T9bxd+CALE6ub8a0qaY94qVKfeXiDQQSY9FA35Ya6AmvPuAx6k
	 6jsFFScT5Yov/sr56/knCyd242KTTP6QwsWhcxDcr1SLhx/5DFwMY4hVBTdLVyqer4
	 n3XhpL4cr3DD5QvmGY0UDLFuWt+YsBcVdw1/FbZpbgeUDxMkwmelDAnyzGcpcG/oSH
	 yKK334XWA3b4Tjv38wxy1/3c1U99wJK1uUIDLKaLPEJeLSFCOfvqIueYQQVU5LSSL8
	 OxdA8AYP1erSg==
Date: Wed, 3 Jul 2024 11:35:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
Message-ID: <20240703183510.GH612460@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
 <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
 <20240702052225.GF22536@lst.de>
 <20240703015956.GS612460@frogsfrogsfrogs>
 <20240703042732.GA24160@lst.de>
 <20240703050219.GC612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240703050219.GC612460@frogsfrogsfrogs>

On Tue, Jul 02, 2024 at 10:02:19PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 03, 2024 at 06:27:32AM +0200, Christoph Hellwig wrote:
> > On Tue, Jul 02, 2024 at 06:59:56PM -0700, Darrick J. Wong wrote:
> > > > > $ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
> > > > > $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt
> > > > 
> > > > Should this be automated?
> > > 
> > > That will require a bit more thought -- many distro build systems these
> > > days operate in a sealed box with no network access, so you can't really
> > > automate this.  libicu (the last time I looked) didn't have a predicate
> > > to tell you if a particular code point was one of the invisible ones.
> > 
> > Oh, I absolutely do not suggest to run the wget from a normal build!
> > 
> > But if you look at the kernel unicode CI support, it allows you to
> > place the downloaded file into the kernel tree, and then case make file
> > rules to re-generate the tables from it (see fs/unicode/Makefile).
> 
> Ah ok got it, will take a closer look tomorrow.

I'm not sure if there's a good way to automate this.  But let's go
through the grep output?

009F;<control>;Cc;0;BN;;;;;N;APPLICATION PROGRAM COMMAND;;;;

This one seems to render as Ÿ (Y with two dots above it) so I didn't put
this in the case statement.

034F;COMBINING GRAPHEME JOINER;Mn;0;NSM;;;;;N;;;;;

Doesn't seem to have any sort of rendering (i.e. if I type them into a
web browser, it doesn't render any glyph at all), so I put it in the
case statement.

200B;ZERO WIDTH SPACE;Cf;0;BN;;;;;N;;;;;
200C;ZERO WIDTH NON-JOINER;Cf;0;BN;;;;;N;;;;;
200D;ZERO WIDTH JOINER;Cf;0;BN;;;;;N;;;;;

These ones have 'zero-width' in the name, so I put these in the
denylist.

2060;WORD JOINER;Cf;0;BN;;;;;N;;;;;

https://www.unicode.org/reports/tr14/ says that this doesn't have
any rendering, nor does my web browser try one.

Come to think of it, I should probably add these two:

2028;LINE SEPARATOR;Zl;0;WS;;;;;N;;;;;
2029;PARAGRAPH SEPARATOR;Zp;0;B;;;;;N;;;;;

because it doesn't render either.

2061;FUNCTION APPLICATION;Cf;0;BN;;;;;N;;;;;

https://www.unicode.org/reports/tr25/tr25-6.html says this is a
metacharacter and doesn't have its own rendering.  It seems to be there
to indicate that this:

f(x + y)

is a function taking "x + y" as a parameter, and not shorthand for:

f*x + f+y

2062;INVISIBLE TIMES;Cf;0;BN;;;;;N;;;;;
2063;INVISIBLE SEPARATOR;Cf;0;BN;;;;;N;;;;;
2064;INVISIBLE PLUS;Cf;0;BN;;;;;N;;;;;

These have 'invisible' in the name, that seems pretty obvious to me.

2D7F;TIFINAGH CONSONANT JOINER;Mn;9;NSM;;;;;N;;;;;

This one doesn't seem to render either.  Unicode 15.1 says it isn't
visible rendered.

FEFF;ZERO WIDTH NO-BREAK SPACE;Cf;0;BN;;;;;N;BYTE ORDER MARK;;;;

Another 'zero-width' one, same as the others.

1107F;BRAHMI NUMBER JOINER;Mn;9;NSM;;;;;N;;;;;
11A47;ZANABAZAR SQUARE SUBJOINER;Mn;9;NSM;;;;;N;;;;;
11A99;SOYOMBO SUBJOINER;Mn;9;NSM;;;;;N;;;;;
13430;EGYPTIAN HIEROGLYPH VERTICAL JOINER;Cf;0;L;;;;;N;;;;;
13431;EGYPTIAN HIEROGLYPH HORIZONTAL JOINER;Cf;0;L;;;;;N;;;;;

When I typed these into a browser, I got *some* kind of rendering.  I
doubt I'm using them correctly, since they're likely supposed to be
surrounded by other codepoints from the same chart.

11F42;KAWI CONJOINER;Mn;9;NSM;;;;;N;;;;;

I don't even know about this one; it generated "tofu" (aka those horrid
rectangular boxes with the byte representation in them).  On the other
hand, https://www.unicode.org/notes/tn48/UTN48-Implementing-Kawi-1.pdf
says it's not visible by itself.  But paired with Kawi script, it's
supposed to affect the formatting.

I'm not sure how exactly to write a classifier here -- the 'invisible'
and 'zero width' ones are obvious, but the 'joiner' code points don't
seem to have any obvious trend to them.

For now I think I'll take the "conservative" approach and only flag
things that sound like they're supposed to be general metacharacters,
and leave out the modifier codepoints that are ok if they're surrounded
by certain codepoints.  But this is a rather manual process.

--D
