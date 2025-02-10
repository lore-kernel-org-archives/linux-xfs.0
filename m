Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7705C22FDE5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Feb 2025 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739195490; cv=none; b=IiGIQJS2KSsEEruCB5UweCObfbpQYGob8YDt5iBm3OJN/Gk6oDdtOqtkfDo8dLcSqP+dKVy/ZeBmJyqFU83boM3cfCu0o0gEQWJBGSB5Vx8cH/SWObI5TmOmZK3NKihGioX5LF5x2GPjQQJ8nbzEFnf4VfHw7/GDKVf4xmAL1io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739195490; c=relaxed/simple;
	bh=ssq0pRiuWElhzvqyoinsdeJoJxzK7Dvf0U18IEqUdp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9o2zP/hVu9pWE+qZGpBFJ/VPX7jgoggyLwIKpyUASLgdi+I96NlhA+htW15M4rtE65wHb78q79CH4+2ot46MmfVQDNyNK/6XMP2/mnZ/VToWnYUzuLiLX4DGaFpO73EkM76yjwzJMEVQDN/VcULTpVfOj9zq3grNFkCl+63eig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2QdsSkK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2QdsSkK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739195487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m7AEPPXemtTVz+m14x4ldqwRAJexKSHplimP3IxyU5Y=;
	b=S2QdsSkKS5Qwri9J2ptQi8tfeSZ7Gb5I/xdgeSICf1e+7Oj0ySI+lWRuZ581nS8KSn0iRK
	vS45/F1FzjCHgdA0zr6WVdr5DS0M0eM2aYSAMTSMgehu7j2kfK2RxLN3RNBG6eG8JEjs/g
	N4JlXJltTQTry4O1nVw2YFxKlf9/KfM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-uLoD5BdtN6uT-ld5MOJ-Zw-1; Mon,
 10 Feb 2025 08:51:24 -0500
X-MC-Unique: uLoD5BdtN6uT-ld5MOJ-Zw-1
X-Mimecast-MFC-AGG-ID: uLoD5BdtN6uT-ld5MOJ-Zw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 767701956094;
	Mon, 10 Feb 2025 13:51:22 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.88])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B4A0195608D;
	Mon, 10 Feb 2025 13:51:21 +0000 (UTC)
Date: Mon, 10 Feb 2025 08:53:46 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v6 00/10] iomap: incremental per-operation iter advance
Message-ID: <Z6oE6kabjh7gS_Lh@bfoster>
References: <20250207143253.314068-1-bfoster@redhat.com>
 <20250210-umrahmen-ortseinfahrt-7a20d8b89df2@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210-umrahmen-ortseinfahrt-7a20d8b89df2@brauner>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Feb 10, 2025 at 12:48:14PM +0100, Christian Brauner wrote:
> On Fri, 07 Feb 2025 09:32:43 -0500, Brian Foster wrote:
> > Just a couple comment changes, no code changes from v5.
> > 
> > Brian
> > 
> > v6:
> > - Comment updates in patches 6 and 7.
> > v5: https://lore.kernel.org/linux-fsdevel/20250205135821.178256-1-bfoster@redhat.com/
> > - Fixed refactoring bug in v4 by pulling 'processed' local var into
> >   patch 4.
> > v4: https://lore.kernel.org/linux-fsdevel/20250204133044.80551-1-bfoster@redhat.com/
> > - Reordered patches 1 and 2 to keep iter advance cleanups together.
> > - Split patch 3 from v3 into patches 3-6.
> > v3: https://lore.kernel.org/linux-fsdevel/20250130170949.916098-1-bfoster@redhat.com/
> > - Code style and comment fixups.
> > - Variable type fixups and rework of iomap_iter_advance() to return
> >   error/length separately.
> > - Advance the iter on unshare and zero range skip cases instead of
> >   returning length.
> > v2: https://lore.kernel.org/linux-fsdevel/20250122133434.535192-1-bfoster@redhat.com/
> > - More refactoring of iomap_iter[_advance]() logic. Lifted out iter
> >   continuation and stale logic and improved comments.
> > - Renamed some poorly named helpers and variables.
> > - Return remaining length for current iter from _iter_advance() and use
> >   appropriately.
> > v1: https://lore.kernel.org/linux-fsdevel/20241213143610.1002526-1-bfoster@redhat.com/
> > - Reworked and fixed a bunch of functional issues.
> > RFC: https://lore.kernel.org/linux-fsdevel/20241125140623.20633-1-bfoster@redhat.com/
> > 
> > [...]
> 
> @Brian, you would help me a lot if you keep adding the full cover letter
> message in each series. I always retain the cover letter when I merge
> series such as this. So for work like yours it serves as a design/spec
> document that we can always go back to when we see bugs in that code
> months/years down the line.
> 

Ah. Sorry, I wasn't aware of that. I tend to use the cover letter of the
series as a quick update and/or message to reviewers, which ultimately
evolves from the high level technical description in v1 to more brief
notes as the changelog shrinks.

Going forward I'll try to keep the high level technical description from
v1 as its own section and carry that forward in subsequent versions.
Thanks for the feedback.

Brian

> ---
> 
> Applied to the vfs-6.15.iomap branch of the vfs/vfs.git tree.
> Patches in the vfs-6.15.iomap branch should appear in linux-next soon.
> 
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
> 
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-6.15.iomap
> 
> [01/10] iomap: factor out iomap length helper
>         https://git.kernel.org/vfs/vfs/c/abb0ea1923a6
> [02/10] iomap: split out iomap check and reset logic from iter advance
>         https://git.kernel.org/vfs/vfs/c/2e4b0b6cf533
> [03/10] iomap: refactor iomap_iter() length check and tracepoint
>         https://git.kernel.org/vfs/vfs/c/f47998386623
> [04/10] iomap: lift error code check out of iomap_iter_advance()
>         https://git.kernel.org/vfs/vfs/c/9183b2a0e439
> [05/10] iomap: lift iter termination logic from iomap_iter_advance()
>         https://git.kernel.org/vfs/vfs/c/b26f2ea1cd06
> [06/10] iomap: export iomap_iter_advance() and return remaining length
>         https://git.kernel.org/vfs/vfs/c/b51d30ff51f9
> [07/10] iomap: support incremental iomap_iter advances
>         https://git.kernel.org/vfs/vfs/c/bc264fea0f6f
> [08/10] iomap: advance the iter directly on buffered writes
>         https://git.kernel.org/vfs/vfs/c/1a1a3b574b97
> [09/10] iomap: advance the iter directly on unshare range
>         https://git.kernel.org/vfs/vfs/c/e60837da4d9d
> [10/10] iomap: advance the iter directly on zero range
>         https://git.kernel.org/vfs/vfs/c/cbad829cef3b
> 

