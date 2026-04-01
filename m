Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB85C272E7C;
	Wed,  1 Apr 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057457; cv=none; b=ZSD0VGcYaz3s/77OfBqCIC8Ii77n3bZXq0niOjs+AeqK91gAXIFAy6TOskizoX4c2lyzkkHtJsgbmljwTexB/O7V/tY0EMER9yCgccanKxzBd8yYhzDW+Ni4zmgDtkmF92xpR57J/WEq7vuZf0nTC4PX/atBhDwMchhad4kZUjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057457; c=relaxed/simple;
	bh=9fjAq1EzlPOEevt29hjfTWEWMqnHIWg5ZBruZTP06W4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3WlLh4sLMWRFI6KIcDzbiqy1eMF64PvgbkRlgWBi22xXbKPPE7atVfIoU/ZEzIN0natZlTBlJFrxpQwskL9mR+LsnezHrDN/6KW8DELd/FNMEdh/QVUZ4qmy0GbpEfN8Em4ySs6A93Ygrsxip/J+jiGKWortpE05jjgPitIbf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jeCh81wV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jeCh81wV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fm88F3ZPzzlh2rZ;
	Wed,  1 Apr 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775057446; x=1777649447; bh=9fjAq1EzlPOEevt29hjfTWEW
	MqnHIWg5ZBruZTP06W4=; b=jeCh81wVdws7Qqw+7Trg1lGYQzquMTiPEdbJovoN
	NeDhVVHMyTDvdgEbxqYCE+bOS2E4pRmnboQddWLFwTdyQ4bO42rtuB9cK15tL2Xl
	w+3IzsQc7FHLvK9kdmFRmU7hDXK/z+94CMZRjUnp82V9OBBC3UnarrSclg8gBEwv
	VNS5qMzEu5OjA9qyPFd3pSM+om1LVcDLs0MxftxviFNUEqXXJg+5B/N5cyvg/9QB
	Wh49etcVulPGPbJprCgG2Pt8CJJLS7gP0ZFvmPz2dX25dfmDgPhVVPQpPmdmoVoL
	Zw2WyE5MSDWC3ohjFaoM25DomTjkTc1q+CbS0b341s2BZg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s9OF2Og8iycP; Wed,  1 Apr 2026 15:30:46 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fm8851dCqzlh2gB;
	Wed,  1 Apr 2026 15:30:44 +0000 (UTC)
Message-ID: <8480aae5-40c5-40ad-b6a0-8f6563ff6f62@acm.org>
Date: Wed, 1 Apr 2026 08:30:43 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] block: unify the synchronous bi_end_io callbacks
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, linux-block@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20260401140433.125924-1-hch@lst.de>
 <20260401140433.125924-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260401140433.125924-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/26 7:03 AM, Christoph Hellwig wrote:
> Put the bio in bio_await_chain after waiting for the completion, and
> share the now identical callbacks between submit_bio_wait and
> bio_await_chain.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
