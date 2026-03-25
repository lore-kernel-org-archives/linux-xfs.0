Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8009C38F949;
	Wed, 25 Mar 2026 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425378; cv=none; b=IuXj3JzWhnQkxzg1qGvsoQoQmNaOCP9vox/93Tfp2+0APe6rcy+c6e4z/ID0N4iSy5oWqFaUmHbxLVml5AjES78upGbaHk9CFTLc3tPVSl8LlvOj7mSCQ/ZvnPbdOZIhIdj+9e/guUrvOXDsfn0vy8f85ifCp1I3fAcEkF9i1Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425378; c=relaxed/simple;
	bh=omp26RJziVlztCI+JMpRUhx7/joUYji5MmDyrc6lGjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hE1Fenvq6F08iwEKy5NnvuWRwU9tV3mhiuzrnIxgarSYAzeGrnhnQBa+16er/23co5fMH7TcGuaYGeEzh26Jzf0qjTIQOXIuzemdpgBcHHqxQo3hamZo6wyo/RBA17rq3Vd2ILKaUmbLQR1nZip9MAlf+oh3x69AqZeIGBzOcLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B87BB68C4E; Wed, 25 Mar 2026 08:56:11 +0100 (CET)
Date: Wed, 25 Mar 2026 08:56:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 02/25] fsverity: expose ensure_fsverity_info()
Message-ID: <20260325075611.GB952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-3-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -static int ensure_verity_info(struct inode *inode)
> +int fsverity_ensure_verity_info(struct inode *inode)

This should grow a kerneldoc comment.

> +static inline int fsverity_ensure_verity_info(struct inode *inode)
> +{
> +	WARN_ON_ONCE(1);
> +	return -EOPNOTSUPP;
> +}

We should not need a stub for this as the only non-fsverity caller
already checks fsverity_active and the compiler will eliminate the
dead call.

