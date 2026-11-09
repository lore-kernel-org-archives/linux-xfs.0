Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794259360;
	b=hRqpjRK2I8NR2oVF3UChMnQsuKOgo/+ZHzUGNZB3hG+k9KsKah2FcjZVSboN0D0GGXOk
	 ZZNAb+gxVPq3gzhhUlWuY6vnMDBPR603TSDBWC7toMTReGRNAcUoNLJOkkRuiBDDkmxtn
	 TH5l9BFP3E8g29EN84zcu8agfdPle7b20Jz35nA8f47w1vuxHXSKKJTn6rNNhZ1hMHvJP
	 Jg2S7a+faeKIKa48Osk72PbJgxO30d2nqmsWp9zRWcuZ6zAJ/dcVVbhFzmL8PSMJo6bya
	 fosMpMWzFRGg0Lt9kQFS0/Ao4K+WLan1uhWBJ+u8RJqwMHUu0KX/x/qD/BIDFqcT23Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794259360;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VmmPcPYItsebb9mMOGyfQXCmYH44K+FyjGDQHy364M8=;
	b=d6MRLlSZDWY/hXeku99fICr1OX1xH8Y6TRu5jfEaySLtL32SmRpcgLm+YQpzpJVZ3GtI
	 yP1JSOap/UNAYVEejuxOniRFjYAFuPq+KnYq7TUtQw2o0YkFgm0FvZyiAwvcKNJOyNhIx
	 Makcs87savCxCUDqEELyUjK2Ob4ckvj4hz3cTxeRf4v/F6a4huVG7d4YfNefryUW4hX7F
	 mVCOGMh0hgJ26LHQQB8DPTrFcNv4T+RzG4dpV63FFEs0owgn+TLuRQ86jo4DgQvxE9cXM
	 ffO2w+Km4QhyB9hZLSV45Kde+dTMievMaAHL00j+yLLEBozSZusvsXTfKScBwocCQ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inxSYfS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E79606A31C;
	Mon,  9 Nov 2026 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=inxSYfS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941D01F008A1;
	Mon,  9 Nov 2026 21:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794259359;
	bh=VmmPcPYItsebb9mMOGyfQXCmYH44K+FyjGDQHy364M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=inxSYfS+teFi+rkdT4zveK5+NxxXxU7Gwm2jfBeWtn8X0ABqz8LLSL5uZ9j809dc7
	 HxgJJ0H50tKopZN+xHrCwSONFOZXP4gwl9eHSV4MrIsVFrE5JgMHjYWIHaZtweJxXB
	 Dp3pTMG2wEtGSGr24/PI3RIL2sMt7wNcCTiwWMOIjMH4iyN9zUTfLrFaL0hsUccRk+
	 CCJFwUHbQboQNH3WM45CQiZvOMz0JVUaGFqCrYbvdk1m6CAGGd6uGzA9XwujgVuq8G
	 4zlihCXJa0OGSYdw/g97MXi+rsx32iZujd7prYgiaggFDGc70epDh6SWpQ/owztvBV
	 DEhP4w7boG7pw==
Date: Tue, 10 Nov 2026 08:22:31 +1100
From: Dave Chinner <dgc@kernel.org>
To: Guikun Yang <yangguikun19@qq.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: xfs: XLOG_WAS_CONT_TRANS on a transaction with no buffered
 regions reads ri_buf[-1] - null deref Oops during mount log recovery
Message-ID: <avI5l1074Qgn-ypN@dread>
References: <tencent_11C734248ADE0736CA2735F63B7064C76905@qq.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_11C734248ADE0736CA2735F63B7064C76905@qq.com>

On Sat, Nov 07, 2026 at 10:00:00AM +0800, Guikun Yang wrote:
> Hi,
> 
> Mounting an XFS volume whose log record after the transaction header
> carries an operation header with the XLOG_WAS_CONT_TRANS flag panics
> the kernel during log recovery - on a stock kernel, no sanitizer
> configuration needed:
> 
>   BUG: unable to handle page fault for address: fffffffffffffff0
>   #PF: supervisor read access in kernel mode
>   Oops: Oops: 0000 [#1] SMP KASAN PTI
>   RIP: xlog_recover_add_to_cont_trans+0xf9/0x460
>    xlog_recovery_process_trans
>    xlog_recover_process_ophdr
>    xlog_recover_process_data
>    xlog_recover_process
>    xlog_do_recovery_pass
>   Kernel panic - not syncing: Fatal exception

Please stop with all these bug reports about things we -already know
are not validated- and -are already being fixed-.

https://lore.kernel.org/linux-xfs/20261013060204.3138690-1-dgc@kernel.org/

Please run all your tests and analysis on the log verification
series that addresses all these problems, and find holes in that
series that still need to be plugged.

Do *not waste our time* reporting known problems that we are
actively fixing. Make yourself and your LLM tokens useful by
creating fstests reporducers for all the issues and then -testing
the proposed fixes- and giving feedback on the fixes that already
exist.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
