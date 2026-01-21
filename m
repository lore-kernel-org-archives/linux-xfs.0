Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E235280324
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998227; cv=none; b=afgWrLkcAb3PZYlXtQpxm9KhhweFhH7YiQrJBUXiPUpaK0mcVkW9DX8JkEIoHwy47J4fVGSJJJtJBdBee+hcyTV6AC7dmnijOq+KEYAjr7UCXXZbQPTNFRCdHiGB6ePd02hjiu3+SfD/DkMjKJrYkwGMZhOgX/J23lb8lPM3XcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998227; c=relaxed/simple;
	bh=+CooiZbkve2KMLULNZLmkT5tjGwzBZuiCEHRB8r8v5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IOOW9sjAfplYe2qiOcGMZwf6ffcnUgJCxD3sQuwCrhaqseVf7jxgsE/fZT02ojKMQ2OzayKIlAlgnxxGPgyr2GomfKJicWVRkwpAHV6PfkQrdEV6EocChlq+TB2u6y8FR2pSGlKOEFJQYmiJ8nho6AZnduPpAAb8xON3eBHyk98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mxl046Kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mxl046Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E21C116D0;
	Wed, 21 Jan 2026 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998226;
	bh=+CooiZbkve2KMLULNZLmkT5tjGwzBZuiCEHRB8r8v5c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Mxl046KjY9v560kSKqbYiKbwGJZibfa9PKFE7+d1CNWG/OTwJTw5dwpU7dyeUO5yg
	 UVX94JXU5VTcDeiQ1SEyIsCgvGuvbveSk2ejivaAVjpqu4btlydZtnRNOe+Zl78mc2
	 GnFk8L2PWzO3Lwbszah2GjkIktltbephGKtLwzYvII3pG+/xl87GN99KHJwbTt6+aC
	 UMPstXzE65FrlPzD2Id5lzep5tOudX8PYQdjJz7LgnkRbnlFv/9gVoBxGrUg2/tgZ1
	 jRCIucEQNDjjCf7SuoxEOfExA4y/5evQCAD/mSW0GoKr5d4cLQv1GVaj+U+gknATg5
	 NSTg0hoCm+ung==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
In-Reply-To: <20260109151741.2376835-1-hch@lst.de>
References: <20260109151741.2376835-1-hch@lst.de>
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-Id: <176899822575.852789.16884969955086028170.b4-ty@kernel.org>
Date: Wed, 21 Jan 2026 13:23:45 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Fri, 09 Jan 2026 16:17:40 +0100, Christoph Hellwig wrote:
> The calling convention of xfs_attr_leaf_hasname() is problematic, because
> it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
> when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
> non-NULL buffer pointer for an already released buffer when
> xfs_attr3_leaf_lookup_int fails with other error values.
> 
> Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
> that the buffer release code is done by each caller of
> xfs_attr3_leaf_read.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: remove xfs_attr_leaf_hasname
      commit: 3a65ea768b8094e4699e72f9ab420eb9e0f3f568

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

