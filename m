Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A4E57D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 00:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724890679; cv=none; b=uYEfMwKDXA6w/50uAnUXoHbowNyqdFKO0RFs96+cc9anmr/Sq3xCTIjhCrQj4mDrzIf/caun8fAS6CP0v6Z/g2bJO4z576cabPrFsosZQ33S6DxTwAzZHJn+FYaGciRUUjI7rxPDZYwljBZImfxxQZFL05NF69O8WOH31tuop6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724890679; c=relaxed/simple;
	bh=Dj5QY4Voa0Vvaz47pSE5eehEG7+xm+BEp4hsK/OPZw0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JSiulYxwjCHkB7PBYt3m+/AjvQSxSghxBpxoUR4AnlwZTE5Etfi/UlpYctf3l5AdqLbAgCjZFfUv5t+4aFfY85zqvnT5mbnLBUMVa43A2iRYXu6gI2iv3VWd9HCFNcX2zgM7ori5307YpsM5xSTPXMgm9NF8yH1Dta8SFTbMvgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: "Darrick J. Wong" <djwong@kernel.org>, Kees Cook <kees@kernel.org>
Cc: kernel@mattwhitlock.name,  linux-xfs@vger.kernel.org,  hch@lst.de
Subject: Re: [RFC PATCH] libxfs: compile with a C++ compiler
In-Reply-To: <20240828235341.GD6224@frogsfrogsfrogs> (Darrick J. Wong's
	message of "Wed, 28 Aug 2024 16:53:41 -0700")
Organization: Gentoo
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
	<20240827234533.GE1977952@frogsfrogsfrogs> <87le0hbjms.fsf@gentoo.org>
	<20240828235341.GD6224@frogsfrogsfrogs>
Date: Thu, 29 Aug 2024 01:17:53 +0100
Message-ID: <87y14g9o7i.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Wed, Aug 28, 2024 at 01:01:31AM +0100, Sam James wrote:
>> "Darrick J. Wong" <djwong@kernel.org> writes:
>>=20
>> > From: Darrick J. Wong <djwong@kernel.org>
>> >
>> > Apparently C++ compilers don't like the implicit void* casts that go on
>> > in the system headers.  Compile a dummy program with the C++ compiler =
to
>> > make sure this works, so Darrick has /some/ chance of figuring these
>> > things out before the users do.
>>=20
>> Thanks, this is a good idea. Double thanks for the quick fix.
>>=20
>> 1) yes, it finds the breakage:
>> Tested-by: Sam James <sam@gentoo.org>
>>=20
>> 2) with the fix below (CC -> CXX):
>> Reviewed-by: Sam James <sam@gentoo.org>
>>=20
>> 3) another thing to think about is:
>> * -pedantic?
>
> -pedantic won't build because C++ doesn't support flexarrays:
>
> In file included from ../include/xfs.h:61:
> ../include/xfs/xfs_fs.h:523:33: error: ISO C++ forbids flexible array mem=
ber =E2=80=98bulkstat=E2=80=99 [-Werror=3Dpedantic]
>   523 |         struct xfs_bulkstat     bulkstat[];
>       |                                 ^~~~~~~~
>
> even if you wrap it in extern "C" { ... };

Doh. So the ship has kind of sailed already anyway.

>
>> * maybe do one for a bunch of standards? (I think systemd does every
>> possible value [1])
>
> That might be overkill since xfsprogs' build system doesn't have a good
> mechanism for detecting if a compiler supports a particular standard.
> I'm not even sure there's a good "reference" C++ standard to pick here,
> since the kernel doesn't require a C++ compiler.
>
>> * doing the above for C as well
>
> Hmm, that's a good idea.
>
> I think the only relevant standard here is C11 (well really gnu11),
> because that's what the kernel compiles with since 5.18.  xfsprogs
> doesn't specify any particular version of C, but perhaps we should match
> the kernel every time they bump that up?

Projects are often (IMO far too) conservative with the features they use
in their headers and I don't think it's unreasonable to match the kernel
here.

>
> IOWs, should we build xfsprogs with -std=3Dgnu11?  The commit changing the
> kernel to gnu11 (e8c07082a810) remarks that gcc 5.1 supports it just
> fine.  IIRC RHEL 7 only has 4.8.5 but it's now in extended support so
> ... who cares?  The oldest supported Debian stable has gcc 8.

so, I think we should match whatever linux-headers / the uapi rules are,
and given I've seen flexible array members in there, it's at least C99.

I did some quick greps and am not sure if we're using any C11 features
in uapi at least.

Just don't blame me if someone yells ;)

(kees, any idea if I'm talking rubbish?)

tl;dr: let's try gnu11?

> [...]

sam
