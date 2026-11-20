Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795213067;
	b=NpOjs8ZXilvZE6mEECFCUT6hktrWlrSlPuNiXjLQOpAFFL8MI3SOS968MNh6srdFfHMO
	 PxomZZdb1dqnTkMCWnRISoesHmQy5IKMR5I9zLINtt5B8+YpqWpBBUDuWRrmwy+9iOu3q
	 1pgmumbLRMN4VEva2HnEo/mL5NCbLnwlyQxpowRIYfG3u2ldvA/CVqv5TOAHrT5P7vk9Z
	 KGWWn7fWWe81L32vr0L49UIZ9eKaaLjdoRXLmuw3D1KA/0B+Ln/amfLwPEnXGgIyyQHIo
	 fD8gv9M9PxA2A7FCLxuUyH3FyBl1Ghjdv3afpY1prTZ2yWXl1P2qzx0CQuFqUT15L7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795213067;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=khFB9XB534fgekb/CoE+7bFIpuAhIcZTTRU6XFAnt0g=;
	b=3xWpOLOFBEm2bC+y9OgOKZGMAOIOi19u9Z1IaOVw9WjIWuE/Szx4HOhRUS3l9Vz3gAXh
	 gclyTHhV/n649ZUFbuYIbKFcmkPHXb10Zh+CEvEOut4x1Olg2UULefS5i+/VqTk8DaTce
	 w8kDS6fuVOq1yoBHFApX36yYcK+kRKPhscujtris7SjoDoSZBT2Ci+Uya3kHLX06M+PfR
	 wy7YcHqZeqJoN1Fdtj4313ZLex8fYbxRj5p0R1f449MlKYWuC53rovLeniZAKMijQ3Hgu
	 Ju097MAkI7gLkSEM9q8C7Xdts5G6cnPqn+aT5ccJvd4hFVc+B2v5CJiLcuy0XqDIezw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWUwWl3D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D639606A334;
	Fri, 20 Nov 2026 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWUwWl3D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE581F000CA;
	Fri, 20 Nov 2026 22:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795213066;
	bh=khFB9XB534fgekb/CoE+7bFIpuAhIcZTTRU6XFAnt0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RWUwWl3Dzutjwu7Cy5jDblMhQtXMeEMH4EURZs10qbRLcoXjIZ7zcCpQAVc+Naejb
	 l/HCvk8+QixPPXRUj7W2pxs1bVmhbNVSQCR2qD+y/1Ux9RSGs6CE2n8X2DCp5zGjbQ
	 /CZYQdVIC93EmoqO8hA8heVbGIFhudDBJ1uC2HxllmaCFeSNbqBKrjHt4hqwXwr663
	 ljXB95Jbz6123HBoN4nK/hmKhn/5h7romjkMCkp1itCWaHuiw0yaD7gAkCoOyZBqgA
	 hVOZEJOOYcMRoCo6oadpSJYrrkm1Jc1fTUZC8H0aul3fHOIdrLW6xv+TBKRnrfKvXw
	 3UOjZpRfSTChA==
Date: Fri, 20 Nov 2026 22:17:44 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>,
	fsverity <fsverity@lists.linux.dev>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-f2fs <linux-f2fs-devel@lists.sourceforge.net>,
	linux-xfs <linux-xfs@vger.kernel.org>, dsterba@suse.com,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	chao@kernel.org, jaegeuk@kernel.org, viro@zeniv.linux.org.uk,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/7] fs,fsverity: add I_VERITY_BUILDING inode state
 flag
Message-ID: <20261120221744.GB3048696@google.com>
References: <20261120155032.187246-1-aalbersh@kernel.org>
 <20261120155032.187246-4-aalbersh@kernel.org>
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
In-Reply-To: <20261120155032.187246-4-aalbersh@kernel.org>

On Fri, Nov 20, 2026 at 04:50:25PM +0100, Andrey Albershteyn wrote:
> + * I_VERITY_BUILDING	fs-verity is being enabled on the inode: the Merkle
> + *			tree is under construction.  The file is effectively
> + *			read-only to userspace; the only writes happening are
> + *			for the fs-verity metadata.

Existing dirty data can still be written out though, right?

> diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
> index 61fe96ccdff6..e02f79682e33 100644
> --- a/include/linux/fsverity.h
> +++ b/include/linux/fsverity.h
> @@ -36,11 +36,12 @@ struct fsverity_operations {
>  	 * @filp: a readonly file descriptor for the file
>  	 *
>  	 * The filesystem must do any needed filesystem-specific preparations
> -	 * for enabling verity, e.g. evicting inline data.  It also must return
> -	 * -EBUSY if verity is already being enabled on the given file.
> +	 * for enabling verity, e.g. evicting inline data.
>  	 *
>  	 * i_rwsem is held for write.
>  	 *
> +	 * I_VERITY_BUILDING is set on the inode for the duration of enabling.
> +	 *
>  	 * Return: 0 on success, -errno on failure
>  	 */
>  	int (*begin_enable_verity)(struct file *filp);

The new sentence doesn't seem relevant here, as the flag isn't set
during this method call.

- Eric
