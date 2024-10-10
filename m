Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6CE64D;
	Thu, 10 Oct 2024 06:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728542915; cv=none; b=t1mM8M12ZMwBr9yQaiO6jfvOxoQUB+PqH15JcgjaTDDYC3UEFDEOuEw6zQW26jHnoc776CzjUDhex6fdw3hrbSLLkUJwMfvnjDyOw4/annYwBFPPmy0KUvlhDEgh7WWByTF6epb+PetRYTbRj0quQem4I9Y5Ux0Jde02Unf1yHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728542915; c=relaxed/simple;
	bh=hdLGx4sCQY3IQTyyuCIwgMHT42pwdh2t3gFJVbsw4gY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9puDM+jhgdIk5yzag5tEdR8KVLgXqVYj2/mTvbDlI7DUNUHRNT9bQmRmxhtPBX2KdAbWWVHC2J0GcZdmp9f5jxhjF6xi09N3hYu9/9To7YE5LLdesKgS7OtlLdF6nVZ4vx10aCkQ4xjJtxQX+c+o7hDXJkZTM/f4zeyJgFhRl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JLXBKQfE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JLXBKQfE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iVsCjrjUVGkyDrGz/5v9GR6eRnt67kS6CddzSgVmS5U=; b=JLXBKQfE//CMLG+4v+vSRYYqq4
	qXW6K+XJAqGhvhZpV4tehgKXGKleOaDX9iLRcZY05OUAUmlM9/ZmjWLrwdSx5uYlsVkeWmdDfamaU
	zFj2lbZni7Z2OGeSAAWhJ07AXkerPRvk6JQl4EFLRynLjImKbslZVGEZtx8vGCwvaP9FdT1Jk1XLW
	czeyXl+CJ4hPF/V2Lg+8e5ct7y2B3lxxeAo1f6tfXVt5IrCLGVKE/DE/uLaX7NnkrkmKS9wFy1MD9
	IimStoIqSWZs3Kn7UUijf2Ps0Ju2wLO3n1LK7rmXtU3vKAhoujPkuhiDyLG5uUnt4rnpPukjlTw92
	TSUBx2yQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1symyN-0000000BjJc-1SeY;
	Thu, 10 Oct 2024 06:48:31 +0000
Date: Wed, 9 Oct 2024 23:48:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+8a8170685a482c92e86a@syzkaller.appspotmail.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com
Subject: Re: [syzbot] [xfs?] KFENCE: memory corruption in xfs_idata_realloc
Message-ID: <Zwd4vxcqoGi6Resh@infradead.org>
References: <6705c39b.050a0220.22840d.000a.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6705c39b.050a0220.22840d.000a.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

[adding the kfence maintainers]

On Tue, Oct 08, 2024 at 04:43:23PM -0700, syzbot wrote:
> dashboard link: https://syzkaller.appspot.com/bug?extid=8a8170685a482c92e86a

[...]

> XFS (loop2): Quotacheck: Done.
> ==================================================================
> BUG: KFENCE: memory corruption in krealloc_noprof+0x160/0x2e0
> 
> Corrupted memory at 0xffff88823bedafeb [ 0x03 0x00 0xd8 0x62 0x75 0x73 0x01 0x00 0x00 0x11 0x4c 0x00 0x00 0x00 0x00 0x00 ] (in kfence-#108):
>  krealloc_noprof+0x160/0x2e0
>  xfs_idata_realloc+0x116/0x1b0 fs/xfs/libxfs/xfs_inode_fork.c:523

I've tried to make sense of this report and failed.

Documentation/dev-tools/kfence.rst explains these messages as:

KFENCE also uses pattern-based redzones on the other side of an object's guard
page, to detect out-of-bounds writes on the unprotected side of the object.
These are reported on frees::

But doesn't explain what "the other side of an object's guard page" is.

Either way this is in the common krealloc code, which is a bit special
as it uses ksize to figure out what the actual underlying allocation
size of an object is to make use of that.  Without understanding the
actual error I wonder if that's something kfence can't cope with?

