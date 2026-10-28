Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218722;
	b=5XuhOB/shO60G171nZJLGGPTOzQ8+1o6tTKdEYdPLuFqIY2B9xWqREjCxa5aVTI+RaWD
	 p3To8qBSAYC3KrMLIdNLvbomG3wnuCY5ktA5rlHxVtcpc/cTBDwYGYCNyZvajDNsv9do8
	 Duci4zP6kVxFHWDkw9r1jWQ0H7jAky+gIL6yDItsTW2NwHWjtOc62GvTFwi8efc67fyaI
	 ZEYBIGdX8b3kUr3BCJx9NNIecbNZaaBGVZC+gMHXlwd+xkmhimwiWPqfIhVhrr2Cl29C+
	 SKvxwaxEOj6weIoLaK61Cp5V2qNQgQ2jR3K6FmZVB8c4gW9IdJ8W82Mssi6tjXTLBNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218722;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=RSrTlkhVWmWU2UtteB5T1G/zrBmRq0SBW9/gHy0RgtM=;
	b=AOJ6PG65MzqwzVtHbrGdiaa44fjJJhhi6JljWd/kq2wOmhFDf8QuV39jCJtbHAf8xBWH
	 XCMLp548KLbaXqON+R4MtuViZIfNJnt/zc23VDPA6GqPiFvscNUBgrczpcH3Eu9jorysq
	 9oMBttvNm8MSEqS7Eav7nNODU1e1QmiJUYKwGuFM2gkm67TCOqW13U/ZfrZFBv6M3qRH4
	 tzlaEzRZZyipoShSj2b/2DazOlNieJA8gYZJ35RQ5CuoJxHUeSxl4/ypQ79+jKTbhL3wD
	 9SqvH42HeEyGCi37fZwTl0gyGLgd939oOfVZsWAXr/Cse92vxwK1O2m6cN/xT5x+qMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFmDqLDX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB23606A31D;
	Wed, 28 Oct 2026 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TFmDqLDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AB31F031E1;
	Wed, 28 Oct 2026 20:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218722;
	bh=RSrTlkhVWmWU2UtteB5T1G/zrBmRq0SBW9/gHy0RgtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFmDqLDXWIzISJPe1oM+UfMOuiYoznxepPffBy04CevN1RGDQIk3DQaY8PXh8R2CT
	 YqCZ4JhdkvyfUch5dJuRf7h77VMRxMciKibKdz7sISoQd2EYUQdx/g4H7ZLqt+sjKY
	 QnVi5PGeqcpjejRiZ1iXnfNvvrfYdHwbhZEYBAH2QxK2J3DxK63B3jG1kVFmG0Uwi3
	 3QMbAIEFu8szgmX5yi0Vlb2WMKX/H94WwSmzMQq/G9gZ8trqZ+zcNMbVvxps/AndAl
	 SGfYGN+aAnPznOfnrZKUX1FaLZfSGCjspUwJJ9mJKnRs6PX1VbShoGZMCZR/esDiz3
	 L6RhXx23/f2sA==
Date: Thu, 29 Oct 2026 07:18:34 +1100
From: Dave Chinner <dgc@kernel.org>
To: =?utf-8?B?6ZOu?= <fengaojigui88@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] xfs: undersized log triggers assertion in xfs_log_mount()
Message-ID: <auJYmq07gDhTkJfe@dread>
References: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-4RZ25PZ5BM+83Vk8t5NUY3ksLGz5nzONrncipu2_MZhFSsg@mail.gmail.com>

On Wed, Oct 28, 2026 at 01:00:54AM +0800, 铮 wrote:
> Hi Carlos,
> 
> Executing the stored syzkaller testcases on Linux 7.3.0 ultimately triggers
> an assertion in xfs_log_mount():
> 
>   XFS (loop0): AAIEEE! Log failed size checks. Abort!
>   XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 597
>   kernel BUG at fs/xfs/xfs_message.c:102!
>   ...
>   xfs_log_mount+0x4e3/0x590
>   xfs_mountfs+0x10b9/0x2270
>   xfs_fs_fill_super+0x15cc/0x20b0
>   ...
>   Kernel panic - not syncing: Fatal exception
> 
> The log size check reports 516 blocks, below the required minimum of
> 636 blocks.
> 
> Is this an expected assertion with my XFS debug configuration, or should
> this malformed image be rejected without triggering a kernel BUG?

A brief look at the code the error message points at answers your
question:

                /*
                 * Log check errors are always fatal on v5; or whenever bad
                 * metadata leads to a crash.
                 */
                if (xfs_has_crc(mp)) {
                        xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
>>>>>>                  ASSERT(0);
                        error = -EINVAL;
                        goto out_free_log;
                }
                xfs_crit(mp, "Log size out of supported range.");
                xfs_crit(mp,
"Continuing onwards, but if log hangs are experienced then please report this message in the bug report.");


If you turn off CONFIG_XFS_DEBUG=y, then what happens to that
ASSERT(0)?

That's right, the ASSERT(0) goes away, and then an undersized log
causes the mount to fail with -EINVAL as it should. 

> I am reporting an observable assertion from a syzkaller reproduction. I am
> not claiming a new vulnerability or a specific root cause.

Please do a cursory code inspection next time, because the code
often makes it pretty clear what the answer to your question is....

-Dave.

-- 
Dave Chinner
dgc@kernel.org
