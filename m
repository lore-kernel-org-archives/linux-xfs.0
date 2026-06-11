Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F02322579E
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781185516; cv=none; b=Rg8dubEvuI+yDQSh1LsI1PWnEwQVXgHhhTVXP885C+UJRjY2DgQzHXdeswW8VvC1hIOIGMVOR18IOkdiZCIYE6W0UhE3EfnsjV1LkYHB7Ba8DU7pZsSKVmccxB9NMST4uJvrij4773jf6fK70EyPXyTPTNmLnJXQra3pIktEpGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781185516; c=relaxed/simple;
	bh=bG7r+KKnqvi635v3+Zok9WccIkFJd+7wBA9THfZS8vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpxxSxEA3ev4+G6r68EKeKXLVA+9GqUerCuY2IRY9iyX/WXEI558ooaa9108o/a2IPs0wq3IHq9IkqaQkF0Za3FAcfDIvu+QaLMLAi6Si67ChWR4ONUjsYjNwRNzRwhhIgvnYLrVbVMl/aB+GaUQE3rzfuwHd0CrjwjtoGtHQEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=veJRKqRA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="veJRKqRA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d2/2GzrnxkeroJcHKVwSN2bQMzrhRbp8smlB8paABCI=; b=veJRKqRAIDXjrRKWCJB8I2rVum
	7HHHv7EAiwVX4O3gcYwaKkNw26ls03gxf2bMYUHhSonMsTyvha5c7iEVQaqOeB/CPUmXhXc0sAhho
	7BweIjRFDftqbN4hXhPy4/1mlzqcN/OPEbLO0/WtIPnIOtL844s+8kl47IiKg9vk+JVpH5zvgqO3h
	SYqzXQ7n86vZ6I58rMQp5i3sbmc6ZV1gvk6S9kX7eDOCo3WCmY28lsW7g4YGuo795k/MZSheV539l
	gkL3U+LNPvjf77r4emcbj09mGKJ8magUcZgyCHg3iliaFNrit4h/TKV73QgrAN35FqJjBEJemK4F3
	G24O7SNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfiT-00000009Y5v-3lio;
	Thu, 11 Jun 2026 13:45:05 +0000
Date: Thu, 11 Jun 2026 06:45:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yao Sang <sangyao@kylinos.cn>
Cc: hch@infradead.org, cem@kernel.org, djwong@kernel.org,
	dlemoal@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: shut down zoned file systems on writeback errors
Message-ID: <aiq74YOg20v4RtfU@infradead.org>
References: <aipNIhAyRkSWIlDF@infradead.org>
 <20260611103712.1999740-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611103712.1999740-1-sangyao@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 11, 2026 at 06:37:12PM +0800, Yao Sang wrote:
> I first hit it while investigating xfs/643 and xfs/646 on an external
> ZNS realtime device using an NVMe ZNS multipath namespace.  Tracing
> showed regular REQ_OP_WRITE I/O being submitted to sequential zones
> through the multipath head.

> With that bug present, the lower NVMe device reported:
> 
> nvme0c0n1: I/O Cmd(0x7d) @ LBA 32768, 128 blocks, I/O Error (sct 0x1 / sc 0xb9) DNR

Ah, makes sense.  So not actually a write error from the device, but
a bug in the I/O stack..

> After fixing the NVMe multipath bug, I used EIO injection to reproduce
> the same XFS-side failure mode in a controlled way.  So the injection was
> used to verify the behavior after a non-retryable lower-layer error had
> already reached XFS, not to discover the original problem.

Cool.

> For the XFS side, ioend completion does not seem to have enough
> information to recover locally.

I agree that we can't recover, but I don't think the state is really
the problem, the problem is that we have no way to recover.  I.e.
for the actual bug you hit we'd just run into misaligned write pointers
again.


> I agree this should be treated as part of a broader zoned writeback error
> handling model, not just as a local ioend fix.  I would like to help work
> on that model, including the GC path, whether we need a more specific
> shutdown reason, and fault-injection coverage for the lower-layer EIO
> case.

Step 1 is merging your patch.  I have a few minor nitpicks I'll
reply directly.

Can you also submit your reproducer for xfstests?

Step 2 is defining a new shutdown reason for irrecoverable data write
error.  Do you want to look into this or should I?  I'll also prepare a
document on the current model the zone allocator is written for, in
which trying to recover from write errors that bubble up to the file
system do not make sense, and we'll see if we get any disagreements
with that, or examples for cases that we should and could handle.

