Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C323161B1;
	Thu, 26 Feb 2026 23:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772148838; cv=none; b=Ck8Iokc9lBjoHz6lEnooV+0LOiY8sH/4vb22/uV0iYHrDj60CmzBFsGOsDtaiZ7YSbJFGI7ca8GG9JfR6XigqCYa1Pp44e5/0ujoXcBWGBjqF8L399+nrLFOlW+9BGXD4EoSTOH/6qqXDgOCXOqfrdD77mZvKyV9FV1b/nsTzdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772148838; c=relaxed/simple;
	bh=QfdBUntYV/mcbXGlWCIhhV4IojVZUoxAE5wVxUGZaD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKpNkZWIXCuAql6705b84FwSYk5Jba344B/D+tb08ejHAbWAjDyabz9ALHAOaVHWqwc97FLDsGhExRXeQegfAB2N9V6tSanOfTWq+oQltHo4OPrwskgk4VksQzAVYnixVYX+I5Pen1qvW4fR5vZ+TTBF0iDyPXCbjBaoIyT+iuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ig64LGLg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ig64LGLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04027C116C6;
	Thu, 26 Feb 2026 23:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772148838;
	bh=QfdBUntYV/mcbXGlWCIhhV4IojVZUoxAE5wVxUGZaD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ig64LGLgMKwmVGmfBrdDqezbOLoqYkpjowzwV0FCCXocsNFvndeCZE/l8vwmFALSk
	 QGWzoAVy0HttwPOx9oJiROEVoElaVzRyzv0OOqjoIsjYmEwcdJrw0SHNdIHH5As9VJ
	 DxwpKItyFkVyfKEK5PsaGafa36eKD9CSKEqp+ioP+KVBh3YQyQUR6KXWbb7g/llYR6
	 CAqMKE6EVXU1GlnP2NoNH9/Ie29KTF6u532udqpEmpkEgS/N/9meB8Qep5UBmDE/mR
	 wFEpVK95Iv2GCWBkJbiMpexSL1yvOUdT6mlW5W7l71nn2XePzh3B+MMKRTU1tva5gR
	 gxA4Tv8N7AqeA==
Date: Thu, 26 Feb 2026 15:33:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] iomap: reject delalloc mappings during writeback
Message-ID: <20260226233357.GG13853@frogsfrogsfrogs>
References: <20260226180058.GF13853@frogsfrogsfrogs>
 <aaC7QX9slCI3jN7l@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaC7QX9slCI3jN7l@infradead.org>

On Thu, Feb 26, 2026 at 01:29:37PM -0800, Christoph Hellwig wrote:
> On Thu, Feb 26, 2026 at 10:00:58AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Filesystems should never provide a delayed allocation mapping to
> > writeback; they're supposed to allocate the space before replying.
> > This can lead to weird IO errors and crashes in the block layer if the
> > filesystem is being malicious, or if it hadn't set iomap->dev because
> > it's a delalloc mapping.
> > 
> > Fix this by failing writeback on delalloc mappings.  Currently no
> > filesystems actually misbehave in this manner, but we ought to be
> > stricter about things like that.
> 
> Maybe switch to to explicitly listing the acceptable types and rejecting
> the rest instead?

Yeah, that's a better solution, particularly if we ever add a new
mapping type.

--D

> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index e4d57cb969f1..2dd49677905f 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -169,17 +169,18 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  	WARN_ON_ONCE(!folio->private && map_len < dirty_len);
>  
>  	switch (wpc->iomap.type) {
> -	case IOMAP_INLINE:
> -		WARN_ON_ONCE(1);
> -		return -EIO;
> +	case IOMAP_UNWRITTEN:
> +		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
> +		fallthrough;
> +	case IOMAP_MAPPED:
> +		break;
>  	case IOMAP_HOLE:
>  		return map_len;
>  	default:
> -		break;
> +		WARN_ON_ONCE(1);
> +		return -EIO;
>  	}
>  
> -	if (wpc->iomap.type == IOMAP_UNWRITTEN)
> -		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
>  	if (wpc->iomap.flags & IOMAP_F_SHARED)
>  		ioend_flags |= IOMAP_IOEND_SHARED;
>  	if (folio_test_dropbehind(folio))
> 
