Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43E324B33;
	Wed, 25 Mar 2026 21:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774472648; cv=none; b=Kpg3GmOf0cmIp+VesM5BymwL5kfE6mfQHH901BaCBEzXh1JxKwkqmEHCMQm63SIg936MGX20r31/2/cOONYla1uLQSnuTgU+4fL4fhR6vuDM8o13BdQABwdOrcUL2orYICyToxqGXKyMRXk3DDf0xG91KMh86xe+YieXKOOfkcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774472648; c=relaxed/simple;
	bh=LMWHjGbw+sX+3z/kmSDjzVnY3mVcrSIcPE9m+3Za9So=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYGBowmXqS/80nTxNnetY1fK4CNBFiybtnoV1M8ARIKZV/WGnH6PPtZq3RJlGY07ZIbeS4E+gOv6CklJiokX2jiyJQwFOW3vlz53kO37xnxuN72b9fjeOoRpbpjRSOn1Aeg/foQPrWaMm/Z0wMxLuUnMyY0YCSlUC4mUeR4EIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d+SBetD5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d+SBetD5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fgzsy2sJbz1XM0nj;
	Wed, 25 Mar 2026 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774472628; x=1777064629; bh=97Z41foFc+tZXOntpL6elWdJ
	fICUWmGkxy05YMBEDcM=; b=d+SBetD5T0ANFFheTW1fVKWSFv622BZGQ6g+ZEyE
	UNlC3HQ/P0Ll2JB997Q6LcPJtI+v0U1Clqwcx1FhJR3izYI6raLBgB1ccBDpql9t
	SDsR2f20v2xMEnwl7XT54GdVTWWDvNYTSv0vTutu8ugaRgu7qeWcu9ryU8tlZaiM
	RQighKsSFMsM51W+FZM4BSWFc1MifYA5yFIdIvcKQqOvkbzyWC4jlEIZR2qMwknu
	Lftj++TFcm7/uLSgSjaZUhsBBP5nLMq8N9BuXEWTMmmbMBrjtXdBYQDgpEeH90j/
	wJoddw+Wy4daftuF0ePYNFACEC9w5GPMp1Ze9+4w1dZ0Mw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VRWQ3mJKAFHd; Wed, 25 Mar 2026 21:03:48 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fgzsW1yFlz1XMG4r;
	Wed, 25 Mar 2026 21:03:42 +0000 (UTC)
Message-ID: <8f554173-4864-46fc-85e0-0a7f3ca70210@acm.org>
Date: Wed, 25 Mar 2026 14:03:40 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
To: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/25/26 11:43 AM, Tal Zussman wrote:
> +	schedule_work_on(smp_processor_id(), &batch->work);

Since schedule_work_on() queues work on system_percpu_wq the above call
has the same effect as schedule_work(&batch->work), isn't it? From the
workqueue implementation:

	system_percpu_wq = alloc_workqueue("events", WQ_PERCPU, 0);

[ ... ]

	if (req_cpu == WORK_CPU_UNBOUND) {
		if (wq->flags & WQ_UNBOUND)
			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
		else
			cpu = raw_smp_processor_id();

Thanks,

Bart.
