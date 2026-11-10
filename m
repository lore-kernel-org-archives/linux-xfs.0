Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351835;
	b=PAel/PIlIoffLTWvXgutBcxiBOpEW5WgbRKtldr+7JyHz3DocLKp/v+xIv7+K8kQy73u
	 w8XdOJvf96rMdDyhFFiayvjLkJUfF5mITg33WnfGQs6NCaJZp8nIFGRMoLt5eJh0m/2kH
	 nmtc3ie9624m0YbSsDhE+HfS4ySwOJYOTKIFGbOxBKHiC3F0OctrPYGIZMz2xNNpWE+Zr
	 i42Q5M0KZ4vRqXfnCGQlOd/UbS6AlIyp3a2EszdNCYR5sQj6qBqbEX6fjxUWfxgwdG5AB
	 rSyhclHx/mCwggK9HGtNTbsLtJW28/kuwgmt8tcvWzcSQnfUZ4eRBBNn5VFpNVKIFjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351835;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=2pIaRdIwsMurNh146HSaQSteAZp0sNsCvcBlMEMyjn0=;
	b=DGqZ+Hm4bFVRk/RMt39s8X1LEYjZMByZlc0eBXu8aT8wFGmfZfDnbgiA55j7Oh4HatSx
	 sfr9ys0pvRkHe+tvRppusTNvQueyBOaXWSmS/Awpjr6n5lgpachyG77/e/zJteBWbEgyV
	 /H3jUsD0m3ommG7GUIBjJYmoPbnS3uD4GIIKWHrYEECObVdm0057p+77UtG3rTZmoGHuU
	 EAN130lV8yabJBaQoVYj/G9OfzHpNrnQ+O95dE2jb+UjkUnAXCZKfUt4N+eHDFFWupLEB
	 AmHcBE6t+DyEdo8WlvwewUBoZPI8TpEeANFvwOp8j9FAv0Mm9MQAAQ1PBImr2OYmcRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBTW1rxq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CD2606A32A;
	Tue, 10 Nov 2026 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBTW1rxq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AB91F00A04;
	Tue, 10 Nov 2026 23:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794351834;
	bh=2pIaRdIwsMurNh146HSaQSteAZp0sNsCvcBlMEMyjn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kBTW1rxq9WZhdtKSM6ZrjLcJDA8KX7zpquW0WCtTZj93ht9JZWcFZTmPvobJNFp5p
	 W7fw8ONKkd7a9uW9Mg/qf4xDHmOd8hlnRbFF4foksH2xX7qk3QGzGbJYkAa75ekFwJ
	 OzRNYXI4MvxDD+4HZGPSx2NnRi9PmevHAGdVkVYZRdLMTwDjyRsnAHYGk68OvDDay8
	 rDnhbCiAaL/Brr0qiCC6247tRAhK2n7XP0yf/xOtZuuMjJqM4qWjPWN7jzk4Svxfvw
	 pqYkF6OUqIPT5t0qg/xeybx0vaHstfPqOrvFTHTSgBMM/vz9TsD1LPwReRhbFj1B84
	 7XfdQtupW+l0w==
Date: Tue, 10 Nov 2026 15:03:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 5/5] f2fs: use I_VERITY_BUILDING instead of private
 flags
Message-ID: <20261110230353.GI1907@quark>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-6-aalbersh@kernel.org>
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
In-Reply-To: <20261105115532.613467-6-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:30PM +0100, Andrey Albershteyn wrote:
>  	/*
> -	 * Write all pages (both data and verity metadata).  Note that this must
> -	 * happen before clearing FI_VERITY_IN_PROGRESS; otherwise pages beyond
> -	 * i_size won't be written properly.  For crash consistency, this also
> -	 * must happen before the verity inode flag gets persisted.
> +	 * Write all pages (both data and verity metadata). For crash
> +	 * consistency, this also must happen before the verity inode flag gets
> +	 * persisted.
>  	 */

Same as ext4 patch: the deleted sentence (which wasn't deleted properly,
as it left the "this also must happen" clause dangling) actually still
applies.  Just it should be updated to use the new flag name, or else
refer to ->end_enable_verity() returning instead.

- Eric
