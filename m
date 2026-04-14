Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF6396B67;
	Tue, 14 Apr 2026 08:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154385; cv=none; b=WhaFjDwWukW2z3O1En8IieF3Lu791l3qtAHO4Ns+cv7a+14KDbCFfsp3CVFs1ZN1r6Xvh2Vvcx1uqqVOgsx4sjNDAY1/KiWqnmuWUSra7KuovUKaIhqOKjikJ+Q7KXIChlP82pPu89F6NoBR4WUQxFEmwk+u2Oxl1Pz//VMAWxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154385; c=relaxed/simple;
	bh=TOlD53df3PVubCkQcP5ysMkOAf2PlO8vqK9cIzo4l44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVy/QWYa9C65G3irMSpK11zh7rrE4bhIqnPAF70JPVfQ7h+k13L/bNYufsaD5YeRqU3GTyfw2FApkx2crK57aU0oV+09My4srrNHMLKXSDyh4HjMto3L+O8GkMib/ivFGkjAztlGxCDiA9BlNUBHIRTU38gWZAyymgkb5NQk6O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BD21E68CFE; Tue, 14 Apr 2026 10:13:01 +0200 (CEST)
Date: Tue, 14 Apr 2026 10:13:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260414081301.GB11138@lst.de>
References: <20260409131404.1545834-1-aalbersh@kernel.org> <20260409131404.1545834-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409131404.1545834-4-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 09, 2026 at 03:13:35PM +0200, Andrey Albershteyn wrote:
> -	if (!fsverity_active(inode) && IS_VERITY(inode)) {
> -		/*
> -		 * If this inode was not yet opened, the verity info hasn't been
> -		 * loaded yet, so we need to do that here to force it into memory.
> -		 */
> -		filp = kernel_file_open(datapath, O_RDONLY, current_cred());
> -		if (IS_ERR(filp))
> -			return PTR_ERR(filp);
> -		fput(filp);
> -	}
> +	if (fsverity_active(inode))
> +		fsverity_ensure_verity_info(inode);

fsverity_ensure_verity_info already is a no-op for !fsverity_active,
so the check could be remove.  Also we should probably propagate the
error return from fsverity_ensure_verity_info here.

