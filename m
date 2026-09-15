Received: from mta0.migadu.com (out-144.mta0.migadu.com [91.218.175.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF84ACC9A
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 15:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486914; cv=none; b=iFH1i3cptFLvz6AzWWs0QvYfHzDZKGabT0ypoEfFl37f55BLPDOjcTJe2rlh7AaG64vFpRktEEp86MNQGDqZeM3Nzc9SmJxUUvYUbLDDU5vIriY/rYrbM8e0azUoKoZSSOIsi1KB5UTvvalxd9RqyrP+xQUyqAggQf7JVF2zVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486914; c=relaxed/simple;
	bh=XoHDbXQlVytUY1/OtZnF5kVtFi86nkj4PDGcug/MKCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSqB7vVOCabxIjsonTqWj2nGTOykP1860j4Qy2p3jk8Vq8nJ59dH3DPyJ3lQ4UOQb8wThv+JIAwHqdqCj3Jl/5+jQ7mj04winPXocZXddb/4UpI9N1sfPlu3mmlQfAAh7LOLlbniaq744Y3DxZkPIE86k5QPsPjDCWZtnzCwadU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B/z0mUZA; arc=none smtp.client-ip=91.218.175.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B/z0mUZA"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XoHDbXQlVytUY1/OtZnF5kVtFi86nkj4PDGcug/MKCg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789486908; v=1; x=1790091708;
 b=B/z0mUZA/z0QuwiKPfppUvgy8SQlwn/fMTa70A0SqtyGmcCj8y0azKhbxd0bUTxkWbxPy5tH
 L+yz5nyymqMGYgOC7TAwt3mlCS1DS3U/Y53Rt5Y6Qg7VWdevAMGVFDtnbsZkBZfnLLilF/aBPm0
 1QeZz7Qr/5FtjXn6AcQRclEE=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id d9356d53b426894b;
	Tue, 15 Sep 2026 15:41:48 +0000
X-Mizu-Trace-ID: d9356d53b426894b
X-Migadu-Flow: FLOW_OUT
Message-ID: <db4ab609-af16-4c5d-aa98-c0655625a2df@linux.dev>
Date: Tue, 15 Sep 2026 16:41:43 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang again
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev> <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
 <20260915145046.GC2705364@frogsfrogsfrogs>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260915145046.GC2705364@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/26 15:50, Darrick J. Wong wrote:
>> thanks
>>
>> About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
>> CoW-based atomics could help avoid this issue as we seem to be bogged down
>> in lock contention.
> Which lock is being contended, anyway?  It looks like the ILOCK?

Yeah, I think so Re. ilock. I had some perf data illustrating this from 
last year, which I can't seem to find, so I will re-generate it.
