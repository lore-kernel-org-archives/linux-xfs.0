Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E8F537E9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 06:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737355238; cv=none; b=Jg2PSH5N8EU6Xi5Us3fTkVtAfFsIN9rcp88pHpQrSeida/f6HKfYhjl45CGGZopFo6+2tfLdKxpowOD0pzYPgGQmmcmHu68e2awPArZ7/BvCEooccZyMXfb1vmeUUNbF2wEVmqMGqJa6+R8hMSIhnyLhA06GcrxDtrZhnNqHh9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737355238; c=relaxed/simple;
	bh=Ncj5ZkrVXC6mAQCAF796PSsNjqvuqtSThiSQmi+pliw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=J+ZB0UA99oR1lguRL9676dcK/2apXVzU2k0z+JvqGWsjJtxQSqGusPxQnZ7Zc+8JOagYU8hnxmIuu9SxBTWvsAzL2tBZIE/a4pkBVeEqyCsSS6lbC6F9/i/GTtIfI+mrC6BlaNP5iShesk7ByHicX5rW64DcocsN+J5pWBYskYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klxwdj8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klxwdj8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1396C4CEDD;
	Mon, 20 Jan 2025 06:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737355237;
	bh=Ncj5ZkrVXC6mAQCAF796PSsNjqvuqtSThiSQmi+pliw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=klxwdj8i+xNt3WVhO1mTNLivJiMmiWuGPdq4DvwVmczJ4EoNaT5/jIKB3S49nETJH
	 zMB8IDYSKdWXYxDpWsvpkjbsACWP3bv+L3pLzGl8P4GqxyFcC7LLdoRY6AyfnfaxF0
	 f9BxhFDH8sOYeLN7RZCbEIhS8nb2NdPLiIgi+iVvASauId7Gg2mr+uc0WmNmFqSL8v
	 Ulz3TDGLpw3ofL4LHJbvjSCn2b1Lo9/6wENZqRkC6rUgbwrDzBAapxMCeTmun8KaPE
	 Y7ftgf1RsTDgoqwTvMMZsGrUl0CzDQ9Dw0NFj3vWbS7K4sQM3RLDp+R3ooH78xl4CD
	 ZAcd9/uqQfz8A==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20250116060151.87164-1-hch@lst.de>
References: <20250116060151.87164-1-hch@lst.de>
Subject: Re: fix buffer refcount races v2
Message-Id: <173735523458.885751.15154722931791171006.b4-ty@kernel.org>
Date: Mon, 20 Jan 2025 07:40:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 16 Jan 2025 07:01:40 +0100, Christoph Hellwig wrote:
> this series fixes two races in buffer refcount handling, that I've
> so far not actually seen in real life, but only found while reading
> through the buffer cache code to understand some of the stranger looking
> locking decisions.
> 
> One can cause a buffer about to be freed to be returned from
> xfs_buf_insert.  I think this one is extremely unlikely to be hit,
> as it requires the buffer to not be present for the initial lookup,
> but already being evicted when trying to add the new buffer.  But
> at least the fix is trivial.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: check for dead buffers in xfs_buf_find_insert
      commit: 07eae0fa67ca4bbb199ad85645e0f9dfaef931cd
[2/2] xfs: fix buffer lookup vs release race
      commit: ee10f6fcdb961e810d7b16be1285319c15c78ef6

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

