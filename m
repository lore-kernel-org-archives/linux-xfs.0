Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4330E2FC891;
	Thu, 20 Nov 2025 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763621834; cv=none; b=MI2N+utyKRjRMSXC/84w4ZZVUMvZhexdXOeJLf6/6Xdqb3RjUcotzV6bcudR7t9trIkSsjxy0nseDt5lUPSH9QvK2fuAeNV8A4lCOJ8zxfrIIqZaTeT+EQCoyweYFZ9gY5hyyUhWEccuAu7Fbd9JI/YjFa1x9/Ml8DZQgMbuZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763621834; c=relaxed/simple;
	bh=NqUOY97kQoS5aujNKYF6TkjSrAtmB2UCH9Tij9I1fPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBHwDPRRyHi+PE1h25rR6344kkDsdIEEJB8x6AsVHSy7OMaBmf4uEKThwZzk6XF8yDZk8reXamp1wX50/Rb8dW/S9C1EX4kq4wTDvz5G8wYCK6wDUAoxKMgiSb+oN+98sCAIIEB5DHShMq+ug1a5svVMyW8Hqrllk8P0jmBGQSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wg37cGJ3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wg37cGJ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GlwArYfl1YSefG/AhoLwp+2/acjKoUipIln3OrRomUE=; b=wg37cGJ3MmaRbLFeIQY38dFPaq
	6cUBVuOnt2DnmNhmUuDpILnXf/mqF/361sivyy7Ne0gTS7hOMHn9ZBVpM55h6jH3LaWmp1HvxID4e
	ZoHKZkIVgeUnHGoHaVBlUjMN/AZSes6YVeroyW7MIZUQ+hg+TgNPXAqVhnLQcWHYnhxVVGj9oPvna
	5Qqv+j+K7/xZPljnCFF09NfzRcnHzOnJWVMVpJBtzDXbWgQ2aPTyZ0L7MhaIm/hTQ0WQkWXFijRjS
	x/beHklQqLfqkAWZdIXY947teA2M4Yia/g9q6RkKxq7qlppzkC0zD5mRfUvMnT5gsRzkYOMqAftgq
	1RTQQq6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLybN-00000006GI5-3the;
	Thu, 20 Nov 2025 06:57:09 +0000
Date: Wed, 19 Nov 2025 22:57:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
Cc: cem@kernel.org, chandanbabu@kernel.org, djwong@kernel.org,
	bfoster@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] xfs: validate log record version against superblock
 log version
Message-ID: <aR67xfAFjuVdbgqq@infradead.org>
References: <aRzU0yjBfQ3CjWpp@dread.disaster.area>
 <20251119153721.2765700-2-rpthibeault@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119153721.2765700-2-rpthibeault@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 19, 2025 at 10:37:22AM -0500, Raphael Pinsonneault-Thibeault wrote:
> Syzbot creates a fuzzed record where xfs_has_logv2() but the
> xlog_rec_header h_version != XLOG_VERSION_2. This causes a
> KASAN: slab-out-of-bounds read in xlog_do_recovery_pass() ->
> xlog_recover_process() -> xlog_cksum().
> 
> Fix by adding a check to xlog_valid_rec_header() to abort journal
> recovery if the xlog_rec_header h_version does not match the super
> block log version.
> 
> A file system with a version 2 log will only ever set
> XLOG_VERSION_2 in its headers (and v1 will only ever set V_1), so if
> there is any mismatch, either the journal or the superblock has been
> corrupted and therefore we abort processing with a -EFSCORRUPTED error
> immediately.
> 
> Also, refactor the structure of the validity checks for better
> readability. At the default error level (LOW), XFS_IS_CORRUPT() emits
> the condition that failed, the file and line number it is
> located at, then dumps the stack. This gives us everything we need
> to know about the failure if we do a single validity check per
> XFS_IS_CORRUPT().
> 
> Reported-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9f6d080dece587cfdd4c
> Tested-by: syzbot+9f6d080dece587cfdd4c@syzkaller.appspotmail.com
> Fixes: 45cf976008dd ("xfs: fix log recovery buffer allocation for the legacy h_size fixup")
> Signed-off-by: Raphael Pinsonneault-Thibeault <rpthibeault@gmail.com>
> ---
> changelog
> v1 -> v2: 
> - reject the mount for h_size > XLOG_HEADER_CYCLE_SIZE && !XLOG_VERSION_2
> v2 -> v3: 
> - abort journal recovery if the xlog_rec_header h_version does not 
> match the super block log version
> v3 -> v4: 
> - refactor for readability
> 
>  fs/xfs/xfs_log_recover.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 

> +	if (XFS_IS_CORRUPT(mp, !h_version))
>  		return -EFSCORRUPTED;
> +	if (XFS_IS_CORRUPT(mp, (h_version & ~XLOG_VERSION_OKBITS)))
> +		return -EFSCORRUPTED;
> +
> +	/*
> +	 * the log version is known, but must match the superblock log
> +	 * version feature bits for the header to be considered valid
> +	 */
> +	if (xfs_has_logv2(mp)) {
> +		if (XFS_IS_CORRUPT(mp, !(h_version & XLOG_VERSION_2)))
> +			return -EFSCORRUPTED;
> +	} else if (XFS_IS_CORRUPT(mp, !(h_version & XLOG_VERSION_1)))
> +			return -EFSCORRUPTED;

I'd use the chance to stop pretending h_version is a bitmap.  Given
that only 1 and 2 are defined that's actually still possible.
I.e., kill XLOG_VERSION_OKBITS and replace the four checks in the quoted
code above with:

	/*
	 * The log version must match the superblock:
	 */
	if (xfs_has_logv2(mp)) {
		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_2))
			return -EFSCORRUPTED;
	} else {
		if (XFS_IS_CORRUPT(mp, h_version != XLOG_VERSION_1))
			return -EFSCORRUPTED;
	}

