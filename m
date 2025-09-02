Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1936984039
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 02:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756779286; cv=none; b=U3U9/nRX3JZddgglaChp65Mx2exXxz9IJugcxbuVOmIQZQPxeys0k54s1HGZG2OTv4P7or12EsMTfqyaII5pbJYko8HX6SSUhapIiBZAuYN5aHYTi5gldEhohIYvPZZH+P85WJOlnE5pGzcmn47SkBqbaBcrvLe3yqKUnVDk+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756779286; c=relaxed/simple;
	bh=DNOwVSe4Kd0cbn/yf07PqXd6IvWQVI3DgAcaVtOkrR8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YqNYlU24e7PB2Jw/ans6m5LnQFpkWNQJbpK0MKeBkxRn7pFCmRTqTZyuFiak/t87L7qHQFLr5IZ/3jQ12pOhaEenQTNgQVJhUMuUsEP2D0W4+u4WCNKJk61qWJqUPMzLqkQuvQaS4WM0aeEvLx3dxcw/LFVBHaK41G6a8h76ARU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AX10Ivg9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AX10Ivg9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756779284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7k4llIX95IzyN3/ZS1And/av2kS6p21Fv0gumj0Ycvk=;
	b=AX10Ivg9j7J8hGbLnxaA99+bEW8sqgJ6zdK9xe/NkFgBlK54YDzrJnpYb9X7A02Bj7hXY4
	exbOTVmEdaH+Qs9MuK7Sau8qgrQgES63M5u/u6w8Gnnf5ApKOqb9GhBm0alzcm6oelbhMQ
	05jfFyKYPjnMiZyxoKGUQzH/YD727oc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-iuaKGCvqN-6FReZveplXkg-1; Mon, 01 Sep 2025 22:14:40 -0400
X-MC-Unique: iuaKGCvqN-6FReZveplXkg-1
X-Mimecast-MFC-AGG-ID: iuaKGCvqN-6FReZveplXkg_1756779279
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-24458345f5dso54705435ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 01 Sep 2025 19:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756779279; x=1757384079;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7k4llIX95IzyN3/ZS1And/av2kS6p21Fv0gumj0Ycvk=;
        b=qAU/G1wi/ZWnPC9MWVZWKgf638GLkj2FwTBV41Zhz0tdqrUoHUTSt7ouIHurvIV6zE
         m1E3382zgTDCiQsh4GQmKff8dSPWjm5JHiaRf7vqx9QjZnCu0S85RrWBoU0QPwXvNiC/
         xXji3z+xGOxqcZm69rvijCviBHjE+ZgBKkGhaEdSDmKtSYzAooIwRloISD7udQdI9yts
         gPJKPeEiQMEQdDhcROpPyX3Olf4AeX1K+LMwb3BLwcqn/z67YYmED7rENPq83hGTSvnE
         50VwtNzouozm8yQ7Ye94s7ZvJQresBzQXluz/CTncZZiqn/2bM9J/sHk8ThZwq6XVY85
         b4rw==
X-Forwarded-Encrypted: i=1; AJvYcCX/unUvR0SzamaYdpiS22v95N/RCAj6LA3w5dAQSXiR1S1yQCh+bKnWwaWUvRdCiaynsDtSwlW9GBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUWJ76E5gqdFYa2uoPoo62DCFLPaDYn4zx1sUAZNgnEUI3Cfj4
	xkGxm9ZF1P6mJ/xF43mHd0MdsI95+GBvu/nUQtt1A/Y6RWJ8ZCrspyWYC08a7Jm3CUZCAOnO0IB
	GBmjTvP7nZX9GkA4o9Mjh2hFTbLRk1dQ4XI+zIvEyLxm3m1kPyHOW2ZAan8uFag==
X-Gm-Gg: ASbGncsstDkf/E1nqN51Qy8D7r1wuD+5nqXmnoHPQKHFdQpnlAf2pBOF05VIcenegS/
	3B2yV9d8Ak5ZfAGaHYLKJXwZSsGNR8mpVBNeCad2X2fifxOOjWWF3hsfhnsKUd3utssu9A7iMJz
	MCctIj1r9/mtSmKPAt0mhypyscGB+AoENPxs/8WGWHshARh+8v6wHc1J4hDKV3B6MGgzfpcpduJ
	/iPYjCrwc6AdBe/oKdtJ0v3RBR+DE3XV1VQFV9VgfRXpHJ3V240cH5LZkls3aLlWQ5xiItMdRtd
	VIx+n9GPrRoBcxOMhNhOnW+gPljGVSt/ADz++sHoGZJz27mzEBreS0cZy7tfTFgWZpaRw4XTj2u
	kRXUeA1Bqc5g=
X-Received: by 2002:a17:903:32d2:b0:242:a1ee:6c3f with SMTP id d9443c01a7336-24944871fa4mr104762165ad.4.1756779279493;
        Mon, 01 Sep 2025 19:14:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAYKDy8eMO1EwsQRF8xxBKIeEdp2zzol6O8UKNKKXragwjc0dT5Wee+K5iWDBv1V74HPjl2g==
X-Received: by 2002:a17:903:32d2:b0:242:a1ee:6c3f with SMTP id d9443c01a7336-24944871fa4mr104762075ad.4.1756779279079;
        Mon, 01 Sep 2025 19:14:39 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b1589e4b7sm3408495ad.43.2025.09.01.19.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 19:14:38 -0700 (PDT)
Message-ID: <081af947-f8d1-4eaa-a8b4-6db43f3cf4cc@redhat.com>
Date: Tue, 2 Sep 2025 12:14:35 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfsdump musl patch questions
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Adam Thiede <me@adamthiede.com>, linux-xfs@vger.kernel.org
References: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
 <81fc13da-9db8-3cf2-2a17-30961e0543d5@applied-asynchrony.com>
 <1ad4a974-b18f-4bca-99df-5e7b93e5d852@adamthiede.com>
 <222e77f3-7e15-cda3-3818-d5125c41a77b@applied-asynchrony.com>
Content-Language: en-US
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <222e77f3-7e15-cda3-3818-d5125c41a77b@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 31/8/25 04:39, Holger Hoffstätte wrote:
> On 2025-08-30 20:10, Adam Thiede wrote:
> 
>> Thanks - using -D_LARGEFILE64_SOURCE also fixes the issue without the 
>> enormous patch. However the following small patch is necessary since 
>> alpine builds with -Wimplicit-function-declaration
>>
>> diff --git a/invutil/invidx.c b/invutil/invidx.c
>> index 5874e8d..9506172 100644
>> --- a/invutil/invidx.c
>> +++ b/invutil/invidx.c
>> @@ -28,6 +28,7 @@
>>   #include <sys/stat.h>
>>   #include <string.h>
>>   #include <uuid/uuid.h>
>> +#include <libgen.h>
>>
>>   #include "types.h"
>>   #include "mlog.h"
>> diff --git a/common/main.c b/common/main.c
>> index 6141ffb..f5e959f 100644
>> --- a/common/main.c
>> +++ b/common/main.c
>> @@ -38,6 +38,7 @@
>>   #include <string.h>
>>   #include <uuid/uuid.h>
>>   #include <locale.h>
>> +#include <libgen.h>
>>
>>   #include "config.h"
> 
> aargh..basename again!
> 
> We fix it like this:
> https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-fs/xfsdump/files/xfsdump-3.1.12-mimic-basename-for-nonglibc.patch
> 
> It's trickier than it looks since you need to actually audit the
> call sites, else you might get crashes at runtime.

My initial feeling is to just include libgen.h in include/config.h.in as

#if !defined(__GLIBC__)
#include <libgen.h>
#endif

Its less targeted than your patch which only touches files using
basename, but xfsprogs resolved this by including libgen.h in
platform_defs.in unconditionally somewhere after string.h

>> I think this one would be good to include at the very least.
> 
> The thing is that your longer patch is conceptually the better way
> forward, just a bit incomplete as it is. We just discussed this on
> IRC and I can quote what our resident toolchain guru Sam had to say,
> which provides some background as well:
> 
> [19:52:50] <sam_> the patch is wrong as it is, at least without some 
> rationale & checking that AC_SYS_LARGEFILE is used (to guarantee off_t 
> is 64-bit on 32-bit glibc systems)
> [19:53:05] <sam_> in general, the stat64, off64_t, etc types should go 
> away (they're transitional)
> [19:53:12] <sam_> the issue is when getting rid of them, people often 
> get it wrong
> [19:53:25] <sam_> the types were added into glibc to allow people to 
> have dual ABIs in their headers
> [19:53:26] <sam_> it never took off
> [19:53:45] <sam_> you can look at the thread where I ported xfsprogs itself
> 
> The thread he's referring to starts here:
> https://lore.kernel.org/linux-xfs/20240205232343.2162947-1-sam@gentoo.org/

Thanks for the context, I noticed the comment about _LARGEFILE64_SOURCE
in the release notes you mentioned earlier
https://musl.libc.org/releases.html

In general xfsdump should follow how xfsprogs builds.

Ill also look over the other changes made to the xfsprogs build and
see if there's anything else that's been missed.

Don

