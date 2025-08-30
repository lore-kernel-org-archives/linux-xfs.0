Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C1B199237
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 18:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756579178; cv=none; b=IgNdXEpQKxUavqt9d+wiaJFf6rxCNzu+vmrZBlsIuOPhvMh3Ya2rRweyft2RPZePOVQlFyJvPigAbQzHeQFSYnx/nlWLbXz/y7PXsFHNCo3o4yr91x2EZMf0zphkqgwAdAok8kAm5W8cKI05j00sGw6ljmvAxpB+c+F7yIgElSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756579178; c=relaxed/simple;
	bh=shqWf4JXNWBCyHkeWFeIoXCVFeQefaYS33T6MEPmdwI=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gSYuS1G9g750oMRtJx70K9K0WIsFZMH0/OG0jlfuYlibBdxvpAmuJ3hOS4vFprIczpVZvbseeucAo3ZVPrk/oYFk9Ra5MzWn6pF8uLO8bYKZmY19TDXzsNRwwX579jB4JijlSACc2YHXnpqXca8DIBq+R6Tgoa3S/U+yS/5dHJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b347a18.dip0.t-ipconnect.de [91.52.122.24])
	by mail.itouring.de (Postfix) with ESMTPSA id 4A13D103762;
	Sat, 30 Aug 2025 20:39:32 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 189656018B7C9;
	Sat, 30 Aug 2025 20:39:32 +0200 (CEST)
Subject: Re: xfsdump musl patch questions
To: Adam Thiede <me@adamthiede.com>, linux-xfs@vger.kernel.org
References: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
 <81fc13da-9db8-3cf2-2a17-30961e0543d5@applied-asynchrony.com>
 <1ad4a974-b18f-4bca-99df-5e7b93e5d852@adamthiede.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <222e77f3-7e15-cda3-3818-d5125c41a77b@applied-asynchrony.com>
Date: Sat, 30 Aug 2025 20:39:32 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1ad4a974-b18f-4bca-99df-5e7b93e5d852@adamthiede.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-08-30 20:10, Adam Thiede wrote:

> Thanks - using -D_LARGEFILE64_SOURCE also fixes the issue without the enormous patch. However the following small patch is necessary since alpine builds with -Wimplicit-function-declaration
> 
> diff --git a/invutil/invidx.c b/invutil/invidx.c
> index 5874e8d..9506172 100644
> --- a/invutil/invidx.c
> +++ b/invutil/invidx.c
> @@ -28,6 +28,7 @@
>   #include <sys/stat.h>
>   #include <string.h>
>   #include <uuid/uuid.h>
> +#include <libgen.h>
> 
>   #include "types.h"
>   #include "mlog.h"
> diff --git a/common/main.c b/common/main.c
> index 6141ffb..f5e959f 100644
> --- a/common/main.c
> +++ b/common/main.c
> @@ -38,6 +38,7 @@
>   #include <string.h>
>   #include <uuid/uuid.h>
>   #include <locale.h>
> +#include <libgen.h>
> 
>   #include "config.h"

aargh..basename again!

We fix it like this:
https://gitweb.gentoo.org/repo/gentoo.git/tree/sys-fs/xfsdump/files/xfsdump-3.1.12-mimic-basename-for-nonglibc.patch

It's trickier than it looks since you need to actually audit the
call sites, else you might get crashes at runtime.

> I think this one would be good to include at the very least.

The thing is that your longer patch is conceptually the better way
forward, just a bit incomplete as it is. We just discussed this on
IRC and I can quote what our resident toolchain guru Sam had to say,
which provides some background as well:

[19:52:50] <sam_> the patch is wrong as it is, at least without some rationale & checking that AC_SYS_LARGEFILE is used (to guarantee off_t is 64-bit on 32-bit glibc systems)
[19:53:05] <sam_> in general, the stat64, off64_t, etc types should go away (they're transitional)
[19:53:12] <sam_> the issue is when getting rid of them, people often get it wrong
[19:53:25] <sam_> the types were added into glibc to allow people to have dual ABIs in their headers
[19:53:26] <sam_> it never took off
[19:53:45] <sam_> you can look at the thread where I ported xfsprogs itself

The thread he's referring to starts here:
https://lore.kernel.org/linux-xfs/20240205232343.2162947-1-sam@gentoo.org/

Of course the shorter workaround route should be good as first fix too.

I guess it depends on what the xfsdump maintainer prefers.

cheers
Holger
