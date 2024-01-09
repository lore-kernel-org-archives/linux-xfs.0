Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D85A36084
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 10:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUa7S/GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625ECC433F1;
	Tue,  9 Jan 2024 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795901;
	bh=aYvduXu4Up1zrIAnmTHrJjTvomxT2pH8kHNcIHGcM6o=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=cUa7S/GG+SHWc47xwBXGLLQMKEyg2NygzCC5A9gQN+TlfpGUjuZgFT8MDaok++bwd
	 CmF42rsqOsEIzYD1VqaRbLdHYu+mO0ZH37MdpsZ2h3x8n9gPzERW3Zq56OlLcu1mfs
	 p6GWfutm6LCQUcj6ABbvNas8htEo/ZTZQ6eHKkEw8RcRO0Z5B6Y6A1OMLST0T+wWmR
	 fyRBbSNW6tIdGcuz68n4kJgsjXzodIDcNaZn9MTwTRmawHPlIkvC1cmOx4U9RWxcBv
	 O5buzcXV/Q3tfGGfqhO10tLFdnZsaI46d9P/qw1FjcLX+scN5UGkB3NCnl8K85a4Bj
	 qIVXeEWtDO29g==
References: <20240109021734.GB722975@frogsfrogsfrogs>
 <ZZzNQ4/QkDxa0JIW@infradead.org> <20240109050848.GD723010@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chandan Babu R
 <chandanrlinux@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Date: Tue, 09 Jan 2024 15:53:06 +0530
In-reply-to: <20240109050848.GD723010@frogsfrogsfrogs>
Message-ID: <87wmsihkhx.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jan 08, 2024 at 09:08:48 PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 08, 2024 at 08:36:19PM -0800, Christoph Hellwig wrote:
>> On Mon, Jan 08, 2024 at 06:17:34PM -0800, Darrick J. Wong wrote:
>> > From: Darrick J. Wong <djwong@kernel.org>
>> > 
>> > We're only allocating from the realtime device if the inode is marked
>> > for realtime and we're /not/ allocating into the attr fork.
>> 
>> Hmm, interesting how this survived all my rtalloc tests.  How did you
>> find this?
>
> I actually found it while reabasing the rt reflink patchset atop
> for-next, because you unified the bmap allocator accounting functions
> instead of copy-pasting them like I did.  Then I tried generic/476 and
> it blew up the first time it encountered a reflink file.
>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Thanks!  Chandan, can we get this merged?

I have picked up the patch and will update for-next soon. I will send the
second pull request for v6.8-rc1 on coming Monday if everything goes well.

-- 
Chandan
