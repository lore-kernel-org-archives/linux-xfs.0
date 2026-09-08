Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE98544898;
	Tue,  8 Sep 2026 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881182; cv=none; b=PxDm2NNZtuuEknWE27g3zj3VJnsIrc4fNneY5XMK9Wj6UVpLVX3N1/Te7NyvL69BoO3RqWiXp7m5wB6lc3pPKjfYftd4O+Kj71ME15JZuERt0nfM1ifgFbUIUJwPlZid69xkRPkEfQMvcNmHT/Gtnqx4lHK+1qWs3qkr1z1Of9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881182; c=relaxed/simple;
	bh=lM71MoOq8m7w/bKwihitgxNfGYQ+zsFbJrkU6LZZD1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cH8QzazIVEOAooU0svhyUM/SYmOLMgfnn+lawsZhjSYLNybuDcebm7tMevY8yd74LQbI9bn+bMAUcQ7izRBDZUNAW+HLJa3ep46NKX6xqNFo2yXRt7ny1zHw7BF9HY6dV0M/0D6Qx0UgHKiji63OFAyHAs7ufFQXqJnnoqAOZzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqq8D3yd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqq8D3yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA641F00A3A;
	Tue,  8 Sep 2026 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788881175;
	bh=//23ChfxTe+Ew0eBEIcqmG2+N/ngieDxQYGCRmyh9qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kqq8D3ydnf6SL+iUUfmirToJzWY3SoroK0OR8HsE5VhyR+YM8g1Bv6uRAvUqeLOkm
	 bIQR0rlXzLa5K0/Li4n0ba+ULamsgqCDVudEQAqF16vWEd8kFdO34Z+MORP3E+ZMvZ
	 hlbYY+Kb8ez5iLOXiqJfb7JtE92vWfVP/BPq8emd62OagHCwtG6J5yGQKG3n9rw4/t
	 ZtfNVRCqnC7zWxa/qJanaqdAIPITB+QP0xW5BxSje0sE63tHgo2czRwIuC9WhQGu+l
	 RONthPCOAKUKO7nST/gA0vssrQs53kyOuu9PbL/qURKaBUoTwIJ9pLChHHLeKrir4K
	 2Cdn4x0+f/p7A==
Date: Tue, 8 Sep 2026 10:25:57 -0500
From: Seth Forshee <sforshee@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
	Paul Moore <paul@paul-moore.com>,
	linux-security-module@vger.kernel.org,
	Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/27] fs: port to const struct mnt_idmap
Message-ID: <aqApBd1t3i1FIXK5@ubuntu-x1>
References: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>

On Tue, Sep 01, 2026 at 02:14:25PM +0200, Christian Brauner wrote:
> A mount's idmapping is immutable. The only thing that is allowed to be
> modified afterwards is the reference count and that is hidden behind
> mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
> from the idmapping. This is the same model that struct cred uses and the
> idmapping is also rather sensitive.
> 
> So make the idmap argument const wherever we can. The conversion is done
> from the bottom up so callers can continue to pass a non-const pointer
> to a const parameter until the conversion is finished.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good!

Reviewed-by: Seth Forshee <sforshee@kernel.org>
