Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794192989;
	b=e4Njip/Fg453L2ENF1FJP7B5y+dQy/FknwtNlA29/Jmu0DsQ8umLLjdaWkf13RoWTtxy
	 o5pO+biH7Wb+cxGnbDGP/0vkctz0bUrjJwy98FacTvmVaiZK60rC1LbcZ7e5OXoHkLEkZ
	 RqalYtN/HSvuXJZD09X6AgOrUA9J36A776J6xrSGgmkTwrLaL0YZQvcu4kRR6V8d7ciHL
	 12odCUqDJ9N4zM97DXWerYT3VlBwwdGOyp0g64J0IJJjV1Zrkv43/Y7UfmoMhjJcO5Ezq
	 tM8MXD8NUXRALt6uH2EPFPvG1dbkLfSxpD8KtVSD0Dm6rlH5hH7+chYn+GRtQ3vYA/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794192989;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=n+4TwEwtUO3KwUkahtVVwASlPtdRGoMNVNlYwVFyhNM=;
	b=LU8YjEZQW5HXIc/QGToM4GhKkeH77tpOOe5JGThRE7g0oFx90YtylGicYzjOYCl+0RB+
	 mEOxZ/Ak31i2p++VAX8P47h3CExR11aY2osogs5au8Ih0ypMwRqmQKCfdIc0L2nu2Tibq
	 PBF1K4ORzMxgIolP7NCHstUrvhRwHPTh1jfAQQ9QQFBoulJoMO9DENBYwPlyxLQdXk858
	 2z+uvapB4U7GDftU4OLz2TOUNQlSNqaXTvlKQeAPo29SyGWBleXQqmDiTnq98KCpAz8Gj
	 vnbzkFxPql+NtGfQX43BK9OCcw9yGalCPIGCkTdTWjy7XHk8A7lG3tXlTEzzi4gJZJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dLqtx658;
	arc=none smtp.remote-ip=95.215.58.251
Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D94606A325
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 02:56:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4D94606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dLqtx658
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=E6nbi2q9BWguhq7sUJJq5GhBbCo7Z1GUqwFoBaxZTl4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192987; v=1; x=1794797787;
 b=dLqtx658wixUpSvGUIYbocKc3P4pgfJX8GTgBwqreDl3IuJU6xbu+Lu0V4Umg9JCwNa60YC9
 TXnhYXjCKoABDlBeUDyWdbEosq2Ehcab/fUJtYs9+j5MXJSm2RKsiD2PjThwK0KisbmXtWAPIOk
 Hcc2N5mMkDWoyD9t1jt7md5o=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f9c8e6b6d36b6895;
	Mon, 09 Nov 2026 02:56:26 +0000
X-Mizu-Trace-ID: f9c8e6b6d36b6895
X-Migadu-Flow: FLOW_OUT
Message-ID: <f7f034f6-cc88-4f54-a37f-9e9fd2dbb62f@linux.dev>
Date: Mon, 9 Nov 2026 10:56:11 +0800
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted
 inodes
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-6-mengmeng.zhao@linux.dev>
 <20261106104403.GC5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104403.GC5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/26 18:44, Christoph Hellwig wrote:
> I think contents-encrypted should be content-encrypted.
> 
> But we really need to find a way to make these checks more
> systematic instead of sprinkling them everywhere.  E.g. have a flag
> in file->f_mode to allow it, which then only leaves the direct I/O
> to buffered I/O fallback as a special case.
> 

Agreed, adding the check to every file system is quite tedious.
We'll look into redesigning the implementation based on your
suggestion. Thanks for your time!
