Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CA031717E;
	Wed,  1 Apr 2026 06:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024824; cv=none; b=G9wR2xm3EpCv/w+qbJ/oo6qg2mkx1jdlQInmmjfqEhFV21rXCnpRHuEEwlUVpBd9Mk9a3Afn2nEOpq/ps8f0GccMCcU7hs4WUDplHF0xENjmKGvVEbkB3iO3DdAHpANfudTDaj8r9pen9oK8qb3EaxYSMYbHv1pbC5UZN3PKQkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024824; c=relaxed/simple;
	bh=BPyb9KK0KgIdBW0N0Y1mh8pAR45CoohCM3ukLu6iucg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTxNd244gU8EjcwvbrYoT7B9oR9PqTeMZU/nxpjU5nyee/LVaLu4E3B/MIJfcjFog2X+q9z6hk4eiY3SbvNunJVh6YRNu1qkcNAx+DwVyahFJ/4XEuOFbCp2TfYMlDHT8yR33WtmWliKz5xpfFgyin3XrBoJuzKUkBuk/qOQjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4154168AFE; Wed,  1 Apr 2026 08:27:00 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:27:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 02/22] fsverity: expose ensure_fsverity_info()
Message-ID: <20260401062700.GA24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org> <20260331212827.2631020-3-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-3-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +/**
> + * fsverity_ensure_verity_info() - create verity info if it's not in memory yet
> + * @inode: the inode for which verity info should be created
> + *
> + * Ensure this inode has verity info attached to it. Read fsverity descriptor
> + * and creates verity based on that. Inodes opened outside of
> + * file_operations->open will not have any verity info attached. This
> + * info is required for any fsverity related operations.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_ensure_verity_info(struct inode *inode);

kerneldoc comments go next to the definition, not the prototype.

