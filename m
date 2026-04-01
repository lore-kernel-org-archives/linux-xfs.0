Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BD83BD647;
	Wed,  1 Apr 2026 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775058142; cv=none; b=aEfQHNncTAZxivkqO+iHtXmvGxB7S8GmjFHmpbn3xVDLOzSBsdpuJ4yhOqVhyGJIZ/0U4Tjk9AW+UJjIrnHYMIiwaw4VMiWGIkzvzop4c1Vd40gLS5apHglFHWGSAWX3WC4Chwi1BN6MUlaLsqY+QTmaUGACS+ZSbaXojGkzk7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775058142; c=relaxed/simple;
	bh=XK+9qjFKAk126mMbj3nliik1I7MZXVOWe0mqMuD6uHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMnerAXm8wpXDy02i4VuOMzPKF9fjgTx++r5H74hnsrDcZeeNRd1DenIINl4QL9Pc9LlBNPnm8qTiqflQ8cYm2DaVSovP8ayFL0QQMFgKSb/sxVu4T3xNhX4cU5kQ5JXcr+13FwuscTISTxh7Crqr2vw7nZIL38vm539eRen788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GRXfXG/X; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GRXfXG/X"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fm8PS3DZWz1XM6J9;
	Wed,  1 Apr 2026 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775058137; x=1777650138; bh=93FvwZAfOxQT/hK3tPgtvS0b
	MOUizbjEOGhFR/chf94=; b=GRXfXG/XVe3ITogmHa4nyVDPnSrfl7ltg9WITYbx
	rsb43wZo8LNNZIB+mSydZ7OZ9Wlbo57sGWRLk3ichlf+0LfCzBeGIJXAYwbnDR1W
	KYDgsoYrHtNMBJwSiMQNmWd7UWind3Fyu3Eh49yfBcgaC5+8mZY7MwEZ6Bstb8Ec
	/+gIKj4o1K/N6va/ql6m1MTPHjpOY8BIUCJ1enHusXAGus+T8h4sQmislUBBBDW0
	/AE83P9pJtHrTRcSrTagVuQDN/SL1wTYuvFkoVfgp5Wk9ifg3OUgggu7synY51SB
	ai5jr90w+dcmKBedVMiiRxLtmp6tBaV0YY3SXr1em+yU8g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tU4a6xyZ9kUt; Wed,  1 Apr 2026 15:42:17 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fm8PN1Xpwz1XM31H;
	Wed,  1 Apr 2026 15:42:15 +0000 (UTC)
Message-ID: <dcb49ff0-fafd-42a1-addc-768912fba4f6@acm.org>
Date: Wed, 1 Apr 2026 08:42:15 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: add a bio_submit_or_kill helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260401140433.125924-1-hch@lst.de>
 <20260401140433.125924-4-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260401140433.125924-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/26 7:03 AM, Christoph Hellwig wrote:
> Factor the common logic for the ioctl helpers to either submit a bio or
> end if the process is being killed.  As this is now the only user of
> bio_await_chain, open code that.

There are two changes in this patch:
- Inlining of bio_await_chain().
- Introduction of bio_submit_or_kill().

Please consider splitting this patch into two patches such that it
becomes easier to review these changes.

Thanks,

Bart.
