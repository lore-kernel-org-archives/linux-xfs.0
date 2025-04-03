Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4670C24A079
	for <linux-xfs@vger.kernel.org>; Thu,  3 Apr 2025 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743677314; cv=none; b=c9FlgslnLcFUJiGU7gDmeDnovo45ijR4ni2xj4MG6HgOrL6kPT0ZD9LbjzPDJR4P4tZy8WSpaj8OxSAx2IBCBjee1kRTrq6ACm210D9sRDvLYaBs695/EXaUyVF7rAzw19vGwtclQvGTQrH9NBsg9F/m8AdbXULax1/nVwoy8dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743677314; c=relaxed/simple;
	bh=vCHnNOVUCefNmp4Y9lgek2Usukt9gfJ9VB4LF3SHZkE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=MQzeAdKoD6P9UyWO5HxdoN+8U8D9zTaLvhrKdDiooTZqULX0pmkVDG2sdzk7NWQlglGxSsgJ953wLowM021z7XYYtsp2zXKfRiPHb+TBvXk/57rqPpYaxaTdolbeT3yk8EP0MAb+CqHXiw7NUlgIspenXb5NvVwSftvVPesDaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwxdprAU; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwxdprAU"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-227aaa82fafso7266435ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 03 Apr 2025 03:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743677311; x=1744282111; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u5LRUoDFCSN4Fv7blrnKd31CHMMgSsTU84NkBWzd1ds=;
        b=cwxdprAU865GtfZEKQQtd7ac4s1aTCPkHG8hDHRInEGbwoQIQ2Lzfuu1Rc2zvjv2A/
         D0k2abjk8DQLJZLw7hd8+jR7YvMWeZzH2S4JgiVvyi7iGMs7M78WlVIP8DrBAM44ZGH7
         EtpjniOO8V3DYHKvXsBVzzyKTBN7viQkWmp69WhrgOQQmlgXV8EP4I0V6R2Cduc33G67
         MSHVjQkHoIBxTQ9LC6KyvlcLL3+gE4gCZ1klefjclKTEGggE4UDUSUVoytLOYmFQvHm+
         zYttCtp8e0YBBDTfHVqPogaAayR2swWT7pfq9QOZtDuq5USJJXhxnbbhNPbweHkwXgdq
         l/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743677311; x=1744282111;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u5LRUoDFCSN4Fv7blrnKd31CHMMgSsTU84NkBWzd1ds=;
        b=vBGlWNEoOrQk0fp/AFGaepHjV1zkDwl+GlbrUgQxnmLYzHJcF+XSQBKonWdbK3bUBR
         4ONT2itq8OCoBnB0lUVGJuO7AdzKEFMwIME9O6xcxjeop4wvsXQqE8hqqK0Lqm1c3YR2
         wLGEnrr5Wih8DZIXRh+0GPtMNFEec3YFcHbkq5xcRTRYKuVmjFgok9DtuQxToKVtx2Cc
         cL7vd6MqLK4zUiIb7OW4ekGV14LuXBBFK6iB+qOvVZjYcK4Swv4PUo73ulMmO2OSAPQB
         yS9EG+kOwFTp7wnZnij9myf3h1tp5xBtGWCqvZ71N8UDRP7ZoDUWKkILDt5X50y6lHQs
         Bn9g==
X-Gm-Message-State: AOJu0YwZCvpvORshW8RerejU4561mqkMY0rYpy0XP0QL7cvDh5nSsaaX
	HsJZC76NTj5N/1BdNb410tvS5zjjgTo6uK+BJFMEv1pyGDnyyvcL/qpS9Q==
X-Gm-Gg: ASbGncsa0EPPK+5q7VC+DAag1yFnoZ5rDstNopG7mJJKazUQ/SeUWwEn+wvVAg0IcGn
	Efe0K1Y80sb/gDNAIUH8kBiGmr+jSU/SRBvyovcGwhrYP9vZ53LSpdCOByBIs20/ukMRChx0Cx6
	6fnCek4IouBZjEDfb+jRCgRCCmFMQ3LoK+7vGQl32FR+3UpedwvuFJykiS8Cprc2Y8dCNe3N2Z0
	aiGlGrwCmknTbb09IioQ6wCb7PDt8kaZuMofF7abGhSf/0O+pIyzW8i+V67NADZrLe27dmanQwX
	ngr/+rTsGvp8zr+2zm1Hf0s374rpkkeYckcd
X-Google-Smtp-Source: AGHT+IERyNl4dQZSb18HmUBmKMEFxSpP1tKEm967LTJT9CiJZEqKuvLj/KfP6vh4R4Rl3lU9fAiyVw==
X-Received: by 2002:a17:902:d4c8:b0:21f:2ded:76ea with SMTP id d9443c01a7336-22977df28afmr25136835ad.36.1743677311399;
        Thu, 03 Apr 2025 03:48:31 -0700 (PDT)
Received: from dw-tp ([171.76.86.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297866cd1dsm11244085ad.159.2025.04.03.03.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 03:48:30 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC] xfs_io: Add cachestat syscall support
In-Reply-To: <20250403022829.GA6283@frogsfrogsfrogs>
Date: Thu, 03 Apr 2025 16:14:56 +0530
Message-ID: <87v7rl34nr.fsf@gmail.com>
References: <f93cec1c02eefffff7a5182cf2c0333cec600889.1742150405.git.ritesh.list@gmail.com> <20250403022829.GA6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Mon, Mar 17, 2025 at 12:15:29AM +0530, Ritesh Harjani (IBM) wrote:
>> This adds -c "cachestat off len" command which uses cachestat() syscall
>> [1]. This can provide following pagecache detail for a file.
>> 
>> - no. of cached pages,
>> - no. of dirty pages,
>> - no. of pages marked for writeback,
>> - no. of evicted pages,
>> - no. of recently evicted pages
>> 
>> [1]: https://lore.kernel.org/all/20230503013608.2431726-3-nphamcs@gmail.com/T/#u
>> 
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
> Just out of curiosity, is there a manpage change for xfs_io.8 that goes
> with this new subcommand?
>

Looks like I might have missed the man page entry change,...

>> ---
>>  configure.ac          |  1 +
>>  include/builddefs.in  |  1 +
>>  io/Makefile           |  5 +++
>>  io/cachestat.c        | 77 +++++++++++++++++++++++++++++++++++++++++++
>>  io/init.c             |  1 +
>>  io/io.h               |  6 ++++
>>  m4/package_libcdev.m4 | 19 +++++++++++
>>  7 files changed, 110 insertions(+)
>>  create mode 100644 io/cachestat.c

...else we would have seen an entry in man/man8/xfs_io.8 file. 

Since this is taken in for-next, I can submit a separate patch for the
man page entry update.

Thanks for catching it. 

-ritesh
