Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2513451CF;
	Thu, 26 Feb 2026 08:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094226; cv=none; b=jJJhUJHr1+a67dqWb6WErXeFBECGJa8x6wJS9aF8fYnUIXawpjslEhVepayAxqsWuvxtNtmWlyC6xAbJNUESNrIRonGEcSAM17OIOxgtSD3xKuP0lFwl0l1Y2flGXC7enB3r7z/4m3wUIcQV2HAlBJXS4/ITIrrphIReT65ANlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094226; c=relaxed/simple;
	bh=9UTL05T45jVAVEyq9bj9rPEbOxgONPJewtdQnNrLGag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZsQScwXONNpZZnL44Jrv2TBfQ7eqNHnx8VWUas/5DCdQWtf+8SW+eD9pECt2ddCYZmSTtog+l15T3MyEnEoFk1TpSMZOB5YgaBKFshQDxo1bNMNyGrTfJDY8dFrLi4atk7gqc9sjQi7pyr4LlJeBGqyAoDSuCG8hCBhqaORfYCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3CeIa8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3CeIa8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EAFC19424;
	Thu, 26 Feb 2026 08:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772094225;
	bh=9UTL05T45jVAVEyq9bj9rPEbOxgONPJewtdQnNrLGag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3CeIa8zV0lNze7dfMNQs3U71TXcKVvchAp0nBteMimOgXEhrwrEViQZ8HLWqqr7W
	 dPQH6lfqlWSrqqlET7SXDw5qdVk+AseBmBm1wxuNMtx2OxJds0Z531kbG9gdvnnGZx
	 vJjTyeq+jWiTqEr6DegABUAjZmLlQL8v1QG7ve01Bdm4FrJ0m9FTQU6qrB4pWpawB/
	 ZbXdioKOgmACc5I9pTXFyLTUTLoV0mHcctOqum0zh4KjrZuqLWpJxA1eylyOuaeuW/
	 ql6IA6ahZNXFJfOotrLrWiqgkNg07AUHAJYU70hax142Ilg1UCaFH91lHODHcgZK51
	 MOihfApvQ3gAg==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] iomap: don't report direct-io retries to fserror
Date: Thu, 26 Feb 2026 09:23:39 +0100
Message-ID: <20260226-wolfsrudel-vulkan-ec9c79c916ca@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224154637.GD2390381@frogsfrogsfrogs>
References: <20260224154637.GD2390381@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1193; i=brauner@kernel.org; h=from:subject:message-id; bh=9UTL05T45jVAVEyq9bj9rPEbOxgONPJewtdQnNrLGag=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQuYOYVEGyRTfo27f3bC2HtW/OnPGcVYO1infQhXu5Rh YOLZt6jjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImY5jH895r7+5jC5l2zGE8J CFfeSZb6e2BhBf/8I821Kzs2X56XZMXI8FjWXPOO4b4dTcwuM2WfB1m91vtvcsSMW83Oy0V+okM XDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 24 Feb 2026 07:46:37 -0800, Darrick J. Wong wrote:
> iomap's directio implementation has two magic errno codes that it uses
> to signal callers -- ENOTBLK tells the filesystem that it should retry
> a write with the pagecache; and EAGAIN tells the caller that pagecache
> flushing or invalidation failed and that it should try again.
> 
> Neither of these indicate data loss, so let's not report them.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] iomap: don't report direct-io retries to fserror
      https://git.kernel.org/vfs/vfs/c/cd3c877d0468
