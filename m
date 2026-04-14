Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AE6356A38
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 06:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776148163; cv=none; b=b75BQ2DrCYVIqmhF7OF1LOfASDc+2eIeFqW2dwrYV4Bt/17iM70I/RfLP6Wmb6IWvCXd2SJNHRIUm3YHtVUEne+NQREL61vfkc4rfx9I/rw+B8S0XRMlAO9mSQAfEQiMG7zv2R7Ci3XVfecpHr0LRYWLqyP6wccEEoEtyH3BJpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776148163; c=relaxed/simple;
	bh=9zm3j017XYj9zrpbx343x2iiR3SJ7zWBkgBn9Hjhbl8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=XZKb/3XPWnaY1PbhUUGka3SjDXSQZBZclo6KPpOu1fryQ6xk8sDw0/hdsRheTYVslRiVJfu/OlwnE8W37LMjv/kr3EwUdWqc81OcG0nvBEBX1zdrEnbjZHmUjNd0yNb933lMPO6tgA0UOb4WJeuCalwqHtpQV305lrp6EI0Oczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nNv2H1G8; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nNv2H1G8"
Date: Tue, 14 Apr 2026 14:11:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776148157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9zm3j017XYj9zrpbx343x2iiR3SJ7zWBkgBn9Hjhbl8=;
	b=nNv2H1G85kN/YwQwF8iY+XpPcq53TnKgCJ35S0BeTsKQxFv9y9ZAGGFSZOCfB6LLRybf6m
	EyLX1atJnAKKZlgggaOxFgrVtRhi9I0lvwng6GLqCm/2eUNKa0HtbAo4tn43T0yjWUvefI
	UoS3dloZrebAhwFlOiXS9Onqm4Q5uT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj <pankaj.raghav@linux.dev>
To: Lukas Herbolt <lukas@herbolt.com>, Pankaj Raghav <p.raghav@samsung.com>
CC: linux-xfs@vger.kernel.org, bfoster@redhat.com,
 "Darrick J . Wong" <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 kundan.kumar@samsung.com, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
In-Reply-To: <3c2e979b144ecc02a5c6ea5eaa004bfd@herbolt.com>
References: <20260413133256.3378243-1-p.raghav@samsung.com> <3c2e979b144ecc02a5c6ea5eaa004bfd@herbolt.com>
Message-ID: <FC11AE42-0705-44FD-8F1C-C1A83BD41C37@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT




>> base-commit: e0dc9e0f8da83cb70e2a7e9a
>> @Lukas: I didn't notice any activity from you regarding this series
>> since last month, so I decided to send it after spending some time on
>> Dave's feedback=2E I hope it is ok with you=2E
>
>No worries=2E I have actually very similar patch ready but run into some =
issue
>with fsx that i wanted to check first=2E

Maybe it is the same issue I ran into as well=2E generic/363 ( fsx that en=
ables option to do mmap writes on EOF page) helped me debug the issue as it=
 fails instead of crashing the system=2E For example, generic/127 and xfs/1=
31 just crashed=2E=20

--
Pankaj Raghav
