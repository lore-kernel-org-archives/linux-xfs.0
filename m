Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200781;
	b=Dsv5+z+soXQQf9QFZZWGkz01moRjYJOPeXTY0zQKrC3rBiSbKmdIl+69pEGzqstmBHwG
	 JkAMrTKBSwaGXg0MXLWkhPUvSPjkoc74IdvlICSTOTjV11oyqX8Iu8dVUyXV2SKbISvf9
	 K5vmZ8E4wWQeyX0Ncbx4MnsOKG21UrG638ZAebQcsfdirAhvA0A281wBXcYsuLtLbysM1
	 V17Sm5zziXCE4Wdf2DYuG6tAvIfRO3+3kHFX47nXVZWyC+2Y9TsoMX3dHjRxvcYA6gjj+
	 QzhzOAcgRuSwbaWPrwEHutaCf+EmZAlBmaS3ibQCV3p5YFWZtuJxwoFaYoO3vT5b1TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200781;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=N7+mDIUz0DKphDB1jWSDWivCn2/hfCrcGv28CLhs5yY=;
	b=MRior8b+/L2knP86To326kiEm8+Kr3kogyaflrf9Tupmdihw44WMW2N+ywt3oDLEqW8Z
	 J5Wl3o1qJpwbAAFtG6CbifUT1VLqUTWxQvw0yLsu+R2W687iHbmTHCevRzvPYKsZP1PLd
	 K7FjGe/l5TVYGlVOCV3+5IrxZyy21ccNJPHGQFsgceuC+aINmK8QPI36W2+8ToQ3IMoJH
	 SFGhVBq3U4cy0GO8hsBnobtfYtTnAsRzyT5qNvB1GsOyUCzQ5NXXOyG0OoR7V4PgMAMFr
	 YI/qwzVLwVo/mFFdv32dlOKXBqUdy2mfCAZZFXLmiasv9FPGbuGlms0CZpkA9OWmriQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ipqlsqXJ;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91858606A31C;
	Wed, 28 Oct 2026 15:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91858606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ipqlsqXJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N7+mDIUz0DKphDB1jWSDWivCn2/hfCrcGv28CLhs5yY=; b=ipqlsqXJgj4/UhpM5GuRGgYDI+
	LRjZM2zcJkZ6keHzv/cJER65OxsAzPtpa0fDV9lf6QPwOYFgrAod9hW+gj/m9KZSFqIeSEHUmZ2Qm
	n9+RwikVcEKfom92fr/tdYSER71O3yLvfs+IbHzeGKVL/ZUwClQCbMRUGRkFmWPQiSHtKm2p2nPxR
	6ArNGczO6MO82e5+VEiTRRVJTQeMWZVl11ZSiPg1qo+1OJc2sYDfBcg4CpCUhYlnPqgiFh0Y3NfrO
	iPYRLuAeGISsADKkqhug+uZP9nGC/FooWJROFjL2FYUnfnlrjH5RAYMKVZidr8CNh8R0zM7poe2YP
	4lZecJoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xM5RB-00000007KUl-0kzA;
	Wed, 28 Oct 2026 15:19:37 +0000
Date: Wed, 28 Oct 2026 08:19:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: set SB_I_OVL_USE_SYNC_FS
Message-ID: <auISibZ1oCWFMruC@infradead.org>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
 <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
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
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-3-802e512379a6@toxicpanda.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 27, 2026 at 09:09:29PM +0000, Josef Bacik wrote:
> All metadata is logged, xfs_fs_sync_fs() forces the log, and there is no
> ->write_inode().
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa384..2f09d48b7e6f 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1924,7 +1924,7 @@ xfs_fs_fill_super(
>  		sb->s_time_max = XFS_LEGACY_TIME_MAX;
>  	}
>  	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
> -	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
> +	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;

Please name flags ater their behavior and not the user.

Even with the commit log I have no idea what this indicates.

