Received: from mail.cloudnuke.org (mail.cloudnuke.org [163.123.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDE929408
	for <linux-xfs@vger.kernel.org>; Sat, 19 Sep 2026 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=163.123.236.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789776962; cv=none; b=c7oyX9FAV+dyvuxDdd51F0m8r5AYjhjv4fveNjVO/FhZKaoyrQ3hAJe9JIjku+aXld37bPcSziS1fozYBjwfkGhWuE0uZoGuRq9HoJ60ytvSBCtljVECnWpKBwkrdt+MCcP3Ga3+F++/C9QlsNkRk/LWNjGY0xQVv4HcaFbrNLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789776962; c=relaxed/simple;
	bh=wE0A3cRNrsnc7cZRj6FtKbmPElwnlCjofzDLH5trdLg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=qPQiZhXAif0kAH6pEd1jmkd/W6MSGLCiUQg7f22Zq4JphbDIh++9PCMVNfOq+HNowWqPY+LEjJ3C0bKUbWPMJnSD4g4H43ywpgAwzRIG+J0ub22yQmtG8C6O5jxwv+JYyaQwmBp15j2LFSkHrOOiZTReimMQ3Jqye1vOD+78GFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=cloudnuke.org; spf=pass smtp.mailfrom=cloudnuke.org; dkim=pass (4096-bit key) header.d=cloudnuke.org header.i=@cloudnuke.org header.b=p2+FBN7j; arc=none smtp.client-ip=163.123.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=cloudnuke.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudnuke.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=cloudnuke.org header.i=@cloudnuke.org header.b="p2+FBN7j"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 821AD190649
	for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2026 19:07:13 -0500 (CDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudnuke.org;
	s=dkim; t=1789776434; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding:content-language;
	bh=ChicDlVJ0N2Tov65avAzsnNTq9QWU+/j/bQt6faldGk=;
	b=p2+FBN7jmrUUlKWluV238pfqowr1J9lWEM10UPOiJ53KWv+e1NwxP+x/pce2oaKocDnwg1
	xAazAPCqCKwkMzuRP7/77YnjAZZrC653ITukUH0JVia88EtVvg/XatpOZMq1Hn6XPtcIYW
	EUt92DRGP15eaOUb3Il8pjtukyirFJtyMkkh4Cp0jXDlRSlaw2eIOB/d8MC61q3szMSTe+
	sQgD6H6eHUwjR6F/oKeBQOSSJLYKliuS5hOMz4K6JEtbud2+JjH7clPel6Ejv7q9UXkD8u
	+bLZ2EnB02o/kztJjfU1mv3747Ais0h+BRDk7C9FPKr0uSCJTYyihuEKYQgW2CPDRQ7wT6
	BEAMAI7xwdqs761v1gKyaPyA0YJratf8BGbj1CqiqHGonRr5CNn7GemuLKyEKuoKoZaPsT
	RmVUFQkmk0vEHpnK4QyVpnrn+gm6xF0ccqlotAsmgA0neyCow6mWlWZdFmm4WLiOZS7VDD
	DsoMGjKhdcI1Glj+xn3PUIB96UrptguS6cXcu6UY4bNeubK5VECxPvUDobv0oRbxCGXQ0N
	x90fzIaQdnCDECAROexM+ymtfuGuLhu+apaeD44tkDA4ghx/2VCW8GCaA48yhnzeezNuxV
	viRa991Wl0+nTswaGtXZF92VlFUvcvNDjSulIFYITRMGvT9pUXPa4=
Message-ID: <a4d94be7-f779-4118-855d-a3c3bc35af69@cloudnuke.org>
Date: Fri, 18 Sep 2026 18:07:12 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Content-Language: en-US
To: linux-xfs@vger.kernel.org
From: Theron York <theron.york@cloudnuke.org>
Subject: xfsprogs-7.2.0: build failure on musl (undefined reference to
 'mallinfo')
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

xfsprogs-7.2.0 fails to build on a musl-based system. The link step
for xfs_scrub dies with an undefined reference to mallinfo(). This
has also been reported in Gentoo as bug 982752:

   https://bugs.gentoo.org/982752

I'm reporting it here because it's a musl libc compatibility issue
rather than a distribution-specific packaging bug.

System:
   - Gentoo, amd64, musl profile (x86_64-pc-linux-musl)
   - binutils 2.47, gcc (or clang) as the toolchain, both reproduce
   - xfsprogs-7.2.0 from upstream tarball (also reproduced via Gentoo 
ebuild)
   - musl version: 1.2.6-r1

Error (with gcc + bfd, same with clang + lld):

   ld.bfd: .../ltrans1.ltrans.o: in function `phase_end':
   <artificial>:(.text+0xdb7): undefined reference to `mallinfo'
   collect2: error: ld returned 1 exit status
   gmake[2]: *** [../include/buildrules:65: xfs_scrub] Error 1

The call site is scrub/xfs_scrub.c in phase_end():

   #ifdef HAVE_MALLINFO
       ...
       mallinfo();
       ...
   #endif

The build is being compiled with -DHAVE_MALLINFO on the command line,
so the configure check is reporting mallinfo() as available when it
is not. musl does not provide mallinfo() at all (nor mallinfo2()).
Both are glibc extensions, and mallinfo() itself is deprecated in
glibc since 2.33 in favor of mallinfo2().

I suspect the autoconf check in configure.ac (or the relevant m4
macro) is doing a compile-only or declaration-only test that passes
on musl even though the symbol is never defined by the C library.
Whatever the mechanism, HAVE_MALLINFO ends up defined and the link
fails.

A minimal fix would be to make the mallinfo() check a link test, or
to gate it on __GLIBC__ specifically. Something like:

   #if defined(HAVE_MALLINFO) && defined(__GLIBC__)

in scrub/xfs_scrub.c would also work as a local workaround, but the
root cause is in the configure check.

I've also reproduced this with clang + lld; the error is identical
apart from the linker driver. Happy to provide that log as well if
useful.

I checked the list archives first but couldn't find a recent thread
covering this exact failure on 7.2.0. If there's a known fix or an
existing patch I've missed, a pointer would be appreciated.

Thanks,
Theron York,

