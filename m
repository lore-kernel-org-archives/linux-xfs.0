Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FF421255A;
	Tue, 24 Mar 2026 08:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340117; cv=none; b=alqYjY9EwSSuGFazmFkD5QXTMnaFo8iU7/89sCIDDx4Lrp6A/zI5df6wDaXh82AzhcJiO2ff1uFi3OiLcEc82zVGwj58JHcT7WMMohv3j1zpZ3yFt3N5yBUVv7BG21ddsGk416AxP0njv6aJJ3kNlAcmHH2xWV4fctftp/SN/8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340117; c=relaxed/simple;
	bh=5MYqorQudYffiTKGRTSo9+dnbAoLAr5nxTBkcx7TgPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GbisSFY1nLq1heJDXrnY7xnShC9oMDEDeP178IfaMEpJWb5Rxq0du4Bai5BiHb+DjOHpHnmAOrAF5L5zoiO79UzAR171h2OUi5oKld271uCTBGcvg8qIGAwN0/eF3nMleLkd+UawFO5M7Kf0CSlG8GlY86HX1KPoq3FUNWvnfCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/vOtotT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/vOtotT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE17C19424;
	Tue, 24 Mar 2026 08:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774340116;
	bh=5MYqorQudYffiTKGRTSo9+dnbAoLAr5nxTBkcx7TgPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/vOtotTLc/rSEfGnEAAfhYptViAS2McS3oaZFXf4283vE7G5VOTZpQ0bbGCNT2cP
	 kRH3XjgCbcWjktvkP48VnGdUshHi9y9BKn3v26ytIA0Al9NThs2NceTg5mFJTR+Zg7
	 ubVX3Z1p9Yu3U+kq5XY7NXh/LIdwlvcLdKOAERuGKhKD5tY6TPNDpOeB24X1XyqNgG
	 a0wpwXowOxVdjmmRbQMOO6jE+Bcn5eCZfARIzq2BPuYK7lbQsJrw86OnbUnD5f1k0C
	 TlvQW3gq93001lOo1VU3A5W4/pBZALJXLSeHPN0lUfv2mIkWTgDE4C3mnmF7nkPp67
	 QMpjK6piliJhA==
From: Christian Brauner <brauner@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org,
	Tal Zussman <tz2294@columbia.edu>,
	axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] iomap: fix lockdep complaint when reads fail
Date: Tue, 24 Mar 2026 09:15:10 +0100
Message-ID: <20260324-zurechnen-sturheit-10ba083e2f06@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323210017.GL6223@frogsfrogsfrogs>
References: <20260323210017.GL6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1504; i=brauner@kernel.org; h=from:subject:message-id; bh=5MYqorQudYffiTKGRTSo9+dnbAoLAr5nxTBkcx7TgPA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQe8uCXlQlZMtfz1r7nD3bpuxh3f+ko5l91RWbX1dXPW XfO2pWzuKOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiN8wZ/vt85HLfcm3H7Ksb 1Y9EGb9ZPWOP/NPDFqcsMuP75Jn91SIZ/hdrbhSUiTrRvvHSbTuD4NTrAXL/2CcnyR/bdyv/T2i APz8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:00:17 -0700, Darrick J. Wong wrote:
> Zorro Lang reported the following lockdep splat:
> 
> "While running fstests xfs/556 on kernel 7.0.0-rc4+ (HEAD=04a9f1766954),
> a lockdep warning was triggered indicating an inconsistent lock state
> for sb->s_type->i_lock_key.
> 
> "The deadlock might occur because iomap_read_end_io (called from a
> hardware interrupt completion path) invokes fserror_report, which then
> calls igrab.  igrab attempts to acquire the i_lock spinlock. However,
> the i_lock is frequently acquired in process context with interrupts
> enabled. If an interrupt occurs while a process holds the i_lock, and
> that interrupt handler calls fserror_report, the system deadlocks.
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

[1/1] iomap: fix lockdep complaint when reads fail
      https://git.kernel.org/vfs/vfs/c/f621324dfb3d
