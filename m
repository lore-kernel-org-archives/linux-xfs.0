Received: from mail.cloudnuke.org (mail.cloudnuke.org [163.123.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5218B22E3F0
	for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.123.236.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789840179; cv=none; b=HlSfMfVdhmF0NUsEYb7Buam9SgMLUYBHAKLePu5wO+LFAx22mfY9pIJVF13Bp6C7+N5sp68zEAXALRZYe6fKYgq2ZthdSCgItC9Vty9ndzK2wQ0aGoiwJ86S/Q+TojzYcFNEkdsuWIAJuca/mRbJkl4Oz69HTXzSwoCkTj/V8vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789840179; c=relaxed/simple;
	bh=/6CyoFIG0WMkGBjelv0bN1odg5oZtH8gfwu4jJcjpqw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=eLz2rorV+D2nRIq6G9wv9VR6SDFpWGRu7PslsMnW/LK9oAPSF1strIu5aYshg+UoFbMdoS/OwKyEMCzaYGSfNa+OKzA7NC/7pv91eQQ849y5+3h5odi08l3JonbwLcOowrmFCNvQRjzirJHjxbcD+bW8yOAxjEdQCnjhp9KngZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=cloudnuke.org; spf=pass smtp.mailfrom=cloudnuke.org; dkim=pass (4096-bit key) header.d=cloudnuke.org header.i=@cloudnuke.org header.b=Vu+cQjXU; arc=none smtp.client-ip=163.123.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=cloudnuke.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudnuke.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=cloudnuke.org header.i=@cloudnuke.org header.b="Vu+cQjXU"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DC6C719062A
	for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2026 12:49:35 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudnuke.org;
	s=dkim; t=1789840176; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=LfkmsjtvFkEOwQPMov7FbSKXajKpah06HD84yse5InU=;
	b=Vu+cQjXUS0AP0iGasXJomi+txzcXTQh6+9f68oEKEXAzyHwU8G76Cv7f9rBtZhOQRqsPzR
	YJ4AICrFJv1NcZYvpGNYnDwMme/gjXj/nfrtcT4M6XCq2ELfwxfVUp6ZvJmEd1NpU1Cjn+
	E0avg4LX0f+bsHp1yFbZ6tGfPOhPRh1wyQAAQQAbBYFX8/r3Na/zoD9YUIERHSFV4dmtN6
	xtrysCtp0B9rHL/rC9VRm5imV5RukJ3jRdrtXp7hCABBT9I05rAr9QORT44gxi8Wsxjj3F
	joe0PhQwyK8jkYfJEA32899wma79Y0UukWAFr1OTZvCkecPV90GWCtsdlx26vgYEPQExRs
	VZLND1YnmQWpRWaGfN7h/7vYQo5/j0mPbKkgM4ItoPqHuRS8y2dY8IdlUGT61RAoI8dNDL
	fupPie5CFj1Mk7bXBVQbg62vzTWmdJXHz5UUJLBgEZWBhLk8U1aRA7HxW/rr/5XpxWcaPm
	n41ibwqfEWXtRcjB2J0BHE8OYiPZrSQsbdl5EPQ8iGbHIaNnnTZFGGgIDYpeMYpZOg5tgL
	nVu/X/HrLyK/CHo8+yX9ra3Dq0Gn/a9D39v8htvygulMpbFhRaVHTe70PLJVFEDxnGkr4c
	+xiESFDpcJf9ophQ3Yql2crwANdnPRl8hozBibVOET3+2vyY63mrg=
Message-ID: <f2a3da21-c3cc-4445-ad5b-44489c726d2e@cloudnuke.org>
Date: Sat, 19 Sep 2026 11:49:34 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: xfsprogs-7.2.0: build failure on musl (undefined reference to
 'mallinfo')
From: Theron York <theron.york@cloudnuke.org>
To: linux-xfs@vger.kernel.org
References: <a4d94be7-f779-4118-855d-a3c3bc35af69@cloudnuke.org>
Content-Language: en-US
In-Reply-To: <a4d94be7-f779-4118-855d-a3c3bc35af69@cloudnuke.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3


On 9/18/26 6:07 PM, Theron York wrote:
> Hi,
>
> xfsprogs-7.2.0 fails to build on a musl-based system. The link step
> for xfs_scrub dies with an undefined reference to mallinfo(). This
> has also been reported in Gentoo as bug 982752:
>
>   https://bugs.gentoo.org/982752
>
> I'm reporting it here because it's a musl libc compatibility issue
> rather than a distribution-specific packaging bug.
>
> System:
>   - Gentoo, amd64, musl profile (x86_64-pc-linux-musl)
>   - binutils 2.47, gcc (or clang) as the toolchain, both reproduce
>   - xfsprogs-7.2.0 from upstream tarball (also reproduced via Gentoo 
> ebuild)
>   - musl version: 1.2.6-r1
>
> Error (with gcc + bfd, same with clang + lld):
>
>   ld.bfd: .../ltrans1.ltrans.o: in function `phase_end':
>   <artificial>:(.text+0xdb7): undefined reference to `mallinfo'
>   collect2: error: ld returned 1 exit status
>   gmake[2]: *** [../include/buildrules:65: xfs_scrub] Error 1
>
> The call site is scrub/xfs_scrub.c in phase_end():
>
>   #ifdef HAVE_MALLINFO
>       ...
>       mallinfo();
>       ...
>   #endif
>
> The build is being compiled with -DHAVE_MALLINFO on the command line,
> so the configure check is reporting mallinfo() as available when it
> is not. musl does not provide mallinfo() at all (nor mallinfo2()).
> Both are glibc extensions, and mallinfo() itself is deprecated in
> glibc since 2.33 in favor of mallinfo2().
>
> I suspect the autoconf check in configure.ac (or the relevant m4
> macro) is doing a compile-only or declaration-only test that passes
> on musl even though the symbol is never defined by the C library.
> Whatever the mechanism, HAVE_MALLINFO ends up defined and the link
> fails.
>
> A minimal fix would be to make the mallinfo() check a link test, or
> to gate it on __GLIBC__ specifically. Something like:
>
>   #if defined(HAVE_MALLINFO) && defined(__GLIBC__)
>
> in scrub/xfs_scrub.c would also work as a local workaround, but the
> root cause is in the configure check.
>
> I've also reproduced this with clang + lld; the error is identical
> apart from the linker driver. Happy to provide that log as well if
> useful.
>
> I checked the list archives first but couldn't find a recent thread
> covering this exact failure on 7.2.0. If there's a known fix or an
> existing patch I've missed, a pointer would be appreciated.
>
> Thanks,
> Theron York,
>
>
> after further review it’s expected behavior. Sorry for the noise; this 
> can be closed,
