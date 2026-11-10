Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351671;
	b=t+pKooJxglbQIE/frwCFkDsr1qzHja4aMOtN3nGm23MTPSeIvy6YnB75i5H3u5RjCoGW
	 GIjzmVKZRjdM59+R2YW6kuubXN2LZ9HkrZJcOKur2s3B7pfc8cOT5OiQfxbvoOK3hYpaZ
	 LvNZlYaznZ10ByWxeOMCpbBSRUX8o0aZCaCM6VxsOtKGJb+eo53ONgHhF3fUOji1f6puE
	 +OmkEd9klI14VWk5hXQiVm/VInNA+2jcHA1fy6SX7N9JQdqmNQQnBcQcNQkzVU2AK5pLo
	 m4nUlLbd7XpdnxBkfdKuoS5BVHR50AnkwD+Nb6uA2vPAvXgB/HJnvTP0DbUc6iGlnPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351671;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=oYVduWeFdLHpkSE+FvHjAfBb/fTBb+zGdaWmZL4J7Wk=;
	b=DKPrXosNUC9CDIDNDDV0P99UN7AzA0LUL3I3TxqqvGjhgpT+0a5fuA3APhvLwHuS6q1d
	 yCgbtfib2vCYtM2i8EDp32NPTieYIEb6m1DoYK5iRFbfUCH1cnS1r/7z4OwyXdFCP/WJL
	 baWs31efHAhBvAPdRIYsIC/M847tfSCO2bL8R866TAZZgzpKjK0LuQysSwuDY6Oj5/6l6
	 f9LkKly4b5HdP+h6WejpsYNd3Tl+6lWwIvnZY9FsKkMNpZyoh4aPBs3XzEifF3Y+4CKjE
	 jbFDR6oHVWKYOvm8aapD6mmXVFMnmLcZCun5wnOd77SwJkvPeeQ6vYv49Nn7EYvhlnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j2wbnJ7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E060F606A31C;
	Tue, 10 Nov 2026 23:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j2wbnJ7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF511F0093D;
	Tue, 10 Nov 2026 23:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794351670;
	bh=oYVduWeFdLHpkSE+FvHjAfBb/fTBb+zGdaWmZL4J7Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j2wbnJ7r+jV6D2sUFFgdMC5pGUSMdi6CH9DFXl/JpqU3LmvM/RS9UjvMJfbN+Vt5T
	 6uG+XRcYWOSIywH/xg32gcrCKeiyyLYiFjr2QDTc7loU6hF0Nshb9m73bWG2ZZK3mk
	 elTy3DMsvN5Urbwb2K7RZu0CKCdr+OvQjuBDknd3ssgclM7WNEY9P5o+qqxt6QnH9X
	 5PYHtansI+gM5fIrPJHVCp1DmmjoaIlOiJlPBxRgKKqF7oH3LabLx27zD1t0Lz13Dc
	 lSecYCae4oyrjYK1yRu5tlCzIdLcFRddUJ05iIp9/jtMI8esq3Tl/YXEtBn0czZogg
	 eysqhyVu3PsuA==
Date: Tue, 10 Nov 2026 15:01:08 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 4/5] ext4: use I_VERITY_BUILDING instead of private
 flags
Message-ID: <20261110230108.GH1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-5-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-5-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:29PM +0100, Andrey Albershteyn wrote:
>  	/*
> -	 * Write all pages (both data and verity metadata).  Note that this must
> -	 * happen before clearing EXT4_STATE_VERITY_IN_PROGRESS; otherwise pages
> -	 * beyond i_size won't be written properly.  For crash consistency, this
> -	 * also must happen before the verity inode flag gets persisted.
> +	 * Write all pages (both data and verity metadata). For crash
> +	 * consistency, this also must happen before the verity inode flag gets
> +	 * persisted.
>  	 */
>  	err = filemap_write_and_wait(inode->i_mapping);

The deleted sentence (which wasn't deleted properly, as it left the
"this also must happen" clause dangling) actually still applies.  Just
it should be updated to use the new flag name, or else refer to
->end_enable_verity() returning instead.

- Eric
