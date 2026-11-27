Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783487;
	b=Uh7BVX9Ol+hzZ3vMhC66CVq/n7lzL9sIMMmIQ76f64SICGOus/1h+O3ZDl475m62dVaj
	 UQ05ZSv4ee5ySsO1KhF6hg1KXq/JWiAogZbGgHNBq14LKM4jL51UZs12b8CT7QgK7E9UD
	 7pJU5FxaCH3eZKmOQI4Rt6aXfotis87URvRJ9PzfSxvMjxBTsoDiJDEGIoNz2BJefkbBy
	 gtCUi8eWikCxdZLhXkGZmE+CadgGdv0CCtm7QTlKKKpV4lozovC4kYA5d+1AypFwG5uFq
	 6OQxs1hVy3JOvf0FgNrWBNaNzNTIUOXofvr4NUHpfa7PSkhlnIuxPLNPkFRhfD9G0qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783487;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BxBd7ZrhVtgSV9+k4LOzKVE9A0u/94jVSEWlYBZhNK4=;
	b=0v1g3VAbG6bTO8IXzjY+4douU/WKzrh7DQW1FnzvM2i8szAdiGPfFXwW4JNDUcsSXVgU
	 Tbrfh/WrFRQI33y9y7cZrnXVpUpRwIVUxqfnbiQlS5zvsFYb/2sUk7DQMkjJUxNLyi051
	 y+5FbEm+w43jgmlVH3OL4MGazn4GbofrjlCJ8ITajD3Il+jm7nXn14ncxq6WnFzeRUS+R
	 iOtTNAWCWsW3U96z8KzI6k5QYl9E3MxuKR2TDy+ynuFNU52ws3YV+4NaveqvutiuUjUsU
	 lJRslZgYjck7/ig7pk4I7m2tiZurfPiNKCFsbK1UVV9hJfuQcSIJJ5U5KNuYsmL66jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIN3kDkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935EB606A31C;
	Fri, 27 Nov 2026 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIN3kDkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6C51F00897;
	Fri, 27 Nov 2026 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795783486;
	bh=BxBd7ZrhVtgSV9+k4LOzKVE9A0u/94jVSEWlYBZhNK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IIN3kDkIZvfcdUUjkTclzJQgOCXPBj8GcRDz3oZpg97tHIFP5keNlhQqsG/7M4xwS
	 TgZoUtsnN6ZM0D0eU04udfYMFst49UidgsBDxBWA7Ka0JCSseRkJ/GRlVEwDB4X/ZR
	 TYXXHecJ55qh4bjJ1aFv3C3V20Qdx5xci0lqaz5qnZf2LRBdGMHOQi/mm0UqZXDiAb
	 v4ckAA2PaBnE+lEStS8x+nUPCGZFL5yF51J32L273fMXmmZD99V3MD96oyCj1ULER3
	 +LYDI2VVUqJFa/3k9Q3eEhENh4LJXORwQ/2InqL5B+e4NK7AqwdGy0Wtp7WQz5NetH
	 yWKPuL5uzKjZw==
Date: Fri, 27 Nov 2026 13:44:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: Lauri Gates <lauri.gates@gmail.com>, koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, ocfs2-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
Message-ID: <20261127-disput-nestbau-wahlparty-c189ad680243@brauner>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261119153222.65195-1-lauri.gates@gmail.com>

On Thu, Nov 19, 2026 at 05:32:22PM +0200, Lauri Gates wrote:
> One constraint for that case: the flag has to stay out of
> FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
> FS_XFLAGS_MASK is reported as supported on every filesystem, so a
> plain flag there would read as "supported, not shared" on btrfs.

Right.

> Christian, with this mask on the way, would you take a plain flag
> (say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
> that filesystems advertise through fsx_xflags_mask? If so, I'll build
> the RFC on top of koraynilay's series instead of using the inverted
> FS_XFLAG_NOSHARED.

Yes, a plain flag is fine. It's simply the stx_attributes_mask model.
Filesystems that have support raise the flag in the mask and everyone
else just doesn't. I see that Amir's busy discussing some details in v2
so maybe base the RFC on that series, I guess.
