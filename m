Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AC432C8B
	for <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 07:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760167762; cv=none; b=NbNiE0/80vnghbR7+2gZpoQ3+6OZT79ceBUyHSlS4/KL1jNaPA/CN+RhQDSudHR6d5vT4lkjvfrVSy8r+bF+Y5O25IS0ovTRuNsF/r40kQXnVDFiM3vdqqY/VuMXA5WVk5epdNzoKU4DQHlfNsTDcdoaCMh9JxTwsulP/MEBGUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760167762; c=relaxed/simple;
	bh=qWL/9XtVeCyDX+lRVusvj6u9AqpQi1xAs486I1o3tXA=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=eeD6Weg2Psc+tlnvdAMFt+q2VK63dB+yV9Dxmx6KOoybYsV2yEwwsUef57MLZE+bPm3B0V7Jbbzz3OB/dDO53tApGvpU3BdFM1wsVTiEJsK/v6gRtksQmGEq8c0PR2IG+ouelqyDu7PEPR07EDUxXqafzin+j58iNODXDc64Dbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b=spIBUJlX; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=torsten.rupp@gmx.net header.b="spIBUJlX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1760167758; x=1760772558; i=torsten.rupp@gmx.net;
	bh=6cZns1h5Ei3reXWFn6XhynkyMgJN3lEIhbdzuxsqQLk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:To:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=spIBUJlXYFaoiytJ1Si6yWGCrDRJ329B0+Qdv6ySH4e8zLcUYx+0DGr+1ImIyJCj
	 X24ALgqrV/ocbs675jEBzw2VQXYHqnYoFbe3gmnulli19WtuXtM3QvXXyd7Ccp169
	 elOLYsxV3oKSUi8XFliyxzG/85vtFSzuIFgoAPCuUsgAyWWB8DGTJf42ObzXiI87N
	 QnwzGN+cJZ6RUIzdGswt7owkXvrqpynGOgxxtIVWTCk6vXA6VUpapLt1vWY2h2rCf
	 s7BJRjZVd4muOZaP8jrJctRmfe8FALWJAGTV2o8WUn7NS73AnuQYHA0Nk3sZtnEUo
	 YuB6a5oGG/o4AqPrVQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.22.10] ([77.3.250.132]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M1poA-1v5IBC05Oa-007fgx for
 <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 09:29:18 +0200
Message-ID: <91c6a2ac-783e-4718-a705-32ccdf678376@gmx.net>
Date: Sat, 11 Oct 2025 09:29:04 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Torsten Rupp <torsten.rupp@gmx.net>
Content-Language: de-DE
To: linux-xfs@vger.kernel.org
Subject: SegFault in cache code
Autocrypt: addr=torsten.rupp@gmx.net; keydata=
 xsDiBEO+wNARBAC9bu5L3kkV9iIY94Eihu5wccSTZ8p49M9FnJtgPu6rUvD+szor8e0yyreD
 TiBgf5ZRpWvNZ2zFdpj1+fwKNz/GTZJ7N88F9XfhuvPixFxK7GqfKzgPZT1gQ8FRimUF9eVj
 giELFdTVsAa0ipiAmYZLLZoAF6baJR3plcaE88GEzwCgpH+yfxAQx94gVLM1kDncbPTuUwcD
 /2uoevvNqQWyaoEbczevNDAyZtqj5rc0QmViopJX0mgQCMaDH2W1suVoBA+/jMWDOqsl/Aw+
 34Q/n45LXBsLglV0oKj3lT/UzT5yH3Yp9G1fnRMgKT2EH7d21CYmHKfGUKWmbmYJL9U3bknF
 XwcRwKpj6V8G0+JVODuolsWx6YQwBAC3ovtun+ZlbFeL58/M5qG/uKEejS69cUvpDHUjSNqZ
 yEO0fF7xxFKvX04KWyzUfzV44v1V3o3LYGU78FwMU0pdD8+XHvtDo3w6/POtvEU0H61QuDBC
 NnSJXoQe48dAi9K64HF6T7JYAuOBiEV30LXnTyYto0Op8DB4Z/XF5vJ9t80jVG9yc3RlbiBS
 dXBwIDx0b3JzdGVuLnJ1cHBAZ214Lm5ldD7CWwQTEQIAGwUCQ77A0AYLCQgHAwIDFQIDAxYC
 AQIeAQIXgAAKCRDWdxCwuabC6WlwAJ94+eEN8Gm59F4gZjmvzGUgPqtBRgCdEYK76JO/Dg2b
 SZXqtTqhHt2TAQDOwU0EQ77A6hAIANtZKko/D0jj707/6IqdhFLTBGmD3R6q+aWbciJlVmpX
 I3qXtvUWBaGVegAPUmxecJyIgOfSthWA2KA2KYfkJnmhCEMSbFccqKU/t0qpWbyR9G8tayWb
 W7dFhLrahneln0879jYPmg1+b1SoECCJdx1iUXktXB9WxpSztEmamkZy10S6EGt17HQRFQof
 ysk+8vfhYEv6CIUMQjpjrKEl5hQgdl61aXOYKJdJKgdJbs0XxvVDQ4IuoJrMOb7zKRswKsH+
 0tnzInx5tqvTbLeHlUZqKKTdMdURWQhNw8il+uc4CoqhbUx5Bny3UYVZMX5SU6Ulm0WJzFUU
 tKVX4FiLVOcAAwUH/iP6G63zA03VqweGUZKGgNkscrV9jaDJU1dQrZBkxWSyoBwxHq16lpGL
 XT9ieCevXkT8IqZ/7rXmpBEmI3HrQxN2muRVNV+Pt7CJ0t5317WZfC/YnQGEBGHI/n0gn0Cn
 icClYEciJow9zD5XF4auk48T8aD2qWxcHksON9L0enz8Ku/rz/pio/PSODTDwMtTJcq0Bjn2
 bboCGMDAlZPMfMNulusQFqnXhJI8L8AxZjmX9Xq+wi5TdpZYkQlTCzj+pLizvLWKBC+7OC04
 67YUiT1MekENsWUcdCOVwh4Gq6soCgOu3QHz3jez4R82KxuPbYEbMMGvcwQaMsxYbo2RoY3C
 RgQYEQIABgUCQ77A6gAKCRDWdxCwuabC6UbDAJ9RcXpuMPKWxGVOV8zDpiwV6v26GgCdFU22
 bk1TC0UY69vY5e/YkBX12pM=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:IryhdFThb6qH2z6VdGtrcou5BujtNuI5bkyDmG14YZ+mzFLKGXn
 ynYaHnvj27lJGQssyIajDHvESeovA0aKPbk8qvQzQ2EwLhaqoyOohVmRwNKfHc6tbM23JfX
 eZo8T3wLxhy520ooOVGd4wANp7DW/X73EsgChSecNjtMay1hh/6esme8+uijXPUzI2qg1Vd
 Hv1B85BlORlHBHoFgZhfA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HTIxf4cAfS4=;f6mBTxi3LHLcgFInmsHEaq45SXA
 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

Dear XFS developers,

I use the libxfs library from xfsprogs 6.16.0. With the following short=20
program I see a segmentation fault when I set the environment variable
LIBXFS_LEAK_CHECK, e. g.

gcc init_destroy_test.c -I../include -L../lib -lxfs -lfrog -lurcu -luuid
LIBXFS_LEAK_CHECK=3D1 ./a.out

=2D--cut---
#include <stdlib.h>
#include <stdio.h>

#include <xfs/libxfs.h>


int main(int argc, const char *argv[])
{
   struct libxfs_init libXFSInit;
   memset(&libXFSInit,0,sizeof(libXFSInit));
   libxfs_init(&libXFSInit);
   libxfs_destroy(&libXFSInit);

   return 0;
}
=2D--cut---

I'm not sure if this behaviour is known and intented.

A fix may be a NULL-pointer check in destroy_caches(). E. g. the gdb=20
stack trace says:

Program received signal SIGSEGV, Segmentation fault.
0x000055555555c130 in kmem_cache_destroy (cache=3D0x0) at kmem.c:35
35              if (getenv("LIBXFS_LEAK_CHECK") && cache->allocated) {
(gdb) bt
#0  0x000055555555c130 in kmem_cache_destroy (cache=3D0x0) at kmem.c:35
#1  0x000055555555bab9 in destroy_caches () at init.c:239
#2  libxfs_destroy (li=3D<optimized out>) at init.c:1059
#3  0x0000555555559d2b in main ()

Best regards,

Torsten Rupp

