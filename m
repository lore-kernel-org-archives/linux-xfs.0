Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07893F0743;
	Thu, 11 Jun 2026 12:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781182670; cv=none; b=cZxvoA3TlOSwru6jhAOt93AMqAEytnzBELX+Mv/AUZ3a7BhQC1AgPaNj/q9ehhFs8DdF8d3I/n9y+hWoAgOFkr3kXIzKtw1eXWU1IQalsYIbA3SROLpC3Ji0Qsz/LPfpquF8OH0/QOAczWk5jrOyCB5tbnFBo8Jir+qiMSMT8ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781182670; c=relaxed/simple;
	bh=7bZGVRT0DhiWZNeC8c4lB5IolUZPRHoFVK8bVkRGXkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F9n/dBqDZcmfTLbld61zCDX3mBXkFF+AWLnV8GQxRJ33r31LtnxQsKwItvIGhCx7laIlJ1z89WbxRvJCl0rBswdDlswjyxhMFzgfVupBKnnxfnH7FFOKHKx9pk94+tOriurjUhTWP8ILVF29osxciaRkG6gxDa+O9HqDYkZ8PTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDGya4v/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDGya4v/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083931F00893;
	Thu, 11 Jun 2026 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781182669;
	bh=1ctt5OAwkKL514gYSQNmnyp3VCA1JVT2AtlVpBHYAww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDGya4v//RF7fwWtpssMjfATwauPkYxd0rgrv3YSJZgFPihbx0nN9aNT1oJBZqS3G
	 TK7aoh+GVEAJWOENOq/nLrdm1zT4W9lMChHe6R/K3Q2ARWhYJXXxRdf507NdLd1rhL
	 fpJqV/J9rHUiz1mCGU0KNtEEVbSBujkUo8Xdqwr9Vk9Df9cFtczhr9CPWprkbc6SYx
	 E/7qnj2ItKejT3+iTbJRCBzGqsOSIAEy9/Qqzd6iJbGCxDoATPYGF0Pqr9/Q4Xbthc
	 LQe+/neVuoGGqBOXkz6sFhb38nYvn86eqnG49VrTZ3EhDsC+IM09yt9wSt9hbmIcrR
	 WItNWZbk/eGvQ==
Date: Thu, 11 Jun 2026 06:57:47 -0600
From: Keith Busch <kbusch@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, brauner@kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] iomap: enforce DIO alignment check in iomap
Message-ID: <aiqwy5DfHI79KXuZ@kbusch-mbp>
References: <20260610145218.141369-1-cem@kernel.org>
 <20260611055744.GA18538@lst.de>
 <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiqBvF93P4NjfaDR@nidhogg.toxiclabs.cc>

On Thu, Jun 11, 2026 at 12:05:22PM +0200, Carlos Maiolino wrote:
> The passed in address 0x1003af80001 is one byte misaligned and shouldn't
> (at least in theory) ever be accepted no? Or am I missing something
> else?

It's entirely possible a device supports byte aligned addresses. The
block layer just doesn't let a driver report that. So either it really
was successful because you found a bug that skips the alignment checks,
or your device silently corrupted your payload.

Anyway, my earlier suggestion should work. Ming thinks it may go to far,
though, in not taking the optimization when it was possible. So here's
an alternative suggestion that should get things working as expected:

---
diff --git a/block/blk.h b/block/blk.h
index 1a2d9101bba04..4c31762d6fb5f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -404,6 +404,9 @@ static inline bool bio_may_need_split(struct bio *bio,
        bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
        if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
                return true;
+
+       if ((bv->bv_offset | bv->bv_len) & lim->dma_alignment)
+               return true;
        return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
 }
 
-- 
