Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057F51FFC6B
	for <linux-xfs@vger.kernel.org>; Fri, 14 Mar 2025 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741958837; cv=none; b=q8pMgAchXYJGxCQbXgaLhTulikiskqE7sK0v7+hKrv3OwfluVp06fgc/XvuNIW5hnZt2zVIZn9cxTgmvdT4ner1cud4HJlAPUBew8TqQVX0kvGTFOHLUt6B7AAZJHUGxoUp3yPI7jfYNOIk0xNesOy/uMLPIkceUXQm/NIyfvUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741958837; c=relaxed/simple;
	bh=oKanJfBzbZ3X1/j38Q1vfIStKE+iIHwTht3JD1WaAnI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gjpNfA+Q/t6j4zhISWyiEMeUMODgSWbc6jPSlk7dVCOQD7ufAjsHblP1SmnACqZmKaf2/EoAKThcVVfm+EGjU0d+DNbUEpjhxlz9G21Xi8nkKsjHLEE6hpvBTPQlgmyWX9kbv1+mFybGX9n8xIU/IBCGyZCli4cQHYqO9M+x/xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6ri7pPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6ri7pPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64454C4CEE3;
	Fri, 14 Mar 2025 13:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741958836;
	bh=oKanJfBzbZ3X1/j38Q1vfIStKE+iIHwTht3JD1WaAnI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=c6ri7pPmMNljIIOqsCx8ggH51AbNqsIGv3GfuApEU9XzQ/fqSgf8P4aJVEJCbSCYz
	 Rv+pKugidR24cNMHx7KDGGl10hagJQAdX7tozrKBXggwmr1SAVkIYqUZfFqEOYMBrD
	 TnCf4kWbWY2weCD13LIyv+Zto/Psq5/onBb9iWqxYnBl/l+GFtnfEvCGS9ffQuzCXj
	 F1KFKzQ0zJecnMa0Mm5eIt8k2D/gLu6xilgj1/Y9QRxleTGDASmfL80sGC3zBa06My
	 Z2Bnd/8iXh9AGMjynQIyBG0B7kW0X1k5dJP6bhKrINO4cSHLeIaPdOWXNlgMBA3u8i
	 PldcT8gW3OXVg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20250310131917.552600-1-hch@lst.de>
References: <20250310131917.552600-1-hch@lst.de>
Subject: Re: use folios and vmalloc for buffer cache backing memory v3
Message-Id: <174195883507.416085.1719150270205198201.b4-ty@kernel.org>
Date: Fri, 14 Mar 2025 14:27:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 10 Mar 2025 14:19:03 +0100, Christoph Hellwig wrote:
> this is another spin on converting the XFS buffer cache to use folios and
> generally simplify the memory allocation in it.  It is based on Dave's
> last folio series (which itself had pulled in bits from my earlier
> vmalloc series).
> 
> It converts the backing memory allocation for all large buffers that are
> power of two sized to large folios, converts > PAGE_SIZE but not power of
> two allocations to vmalloc instead of vm_map_ram and generally cleans up
> a lot of code around the memory allocation and reduces the size of the
> xfs_buf structure by removing the embedded pages array and pages pointer.
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: unmapped buffer item size straddling mismatch
        commit: 69659e46b7588d2fd5e4644dec9e61127bbfd5f3
[02/12] xfs: add a fast path to xfs_buf_zero when b_addr is set
        commit: f2a3717a74c2cf01e29ea3aba355e171eb0d5f5f
[03/12] xfs: remove xfs_buf.b_offset
        commit: 51e10993153adc14e8caf2a13d6defc8403dfb4c
[04/12] xfs: remove xfs_buf_is_vmapped
        commit: 48a325a4eec3251c2ead7ad7dad304bbdc1460a0
[05/12] xfs: refactor backing memory allocations for buffers
        commit: 50a524e0ef9be0e862207fc822ab4b7dcb0c4310
[06/12] xfs: remove the kmalloc to page allocator fallback
        commit: 4ef39828318220f11050984fb8dbc372c9c03960
[07/12] xfs: convert buffer cache to use high order folios
        commit: 94c78cfa3bd1858eec3c462aedeb7f297d38d768
[08/12] xfs: kill XBF_UNMAPPED
        commit: a2f790b28512c22f7cf4f420a99e1b008e7098fe
[09/12] xfs: buffer items don't straddle pages anymore
        commit: fd87851680edcb931b2ec4caf23b4abbea126fc3
[10/12] xfs: use vmalloc instead of vm_map_area for buffer backing memory
        commit: e2874632a6213b4687e53cd7d837c642c805c903
[11/12] xfs: cleanup mapping tmpfs folios into the buffer cache
        commit: e614a00117bc2d46219c66a287ddde0f0a04517c
[12/12] xfs: trace what memory backs a buffer
        commit: 89ce287c83c91f5d222809b82e597426587a862d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

