Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE333E868D;
	Wed, 25 Mar 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774454545; cv=none; b=BTET6zQBr3k9K3EHt7UmiCKCCWnk31NBZQlBY49QOzDLhsRfinZSpgB8xFwLVs110j784uJBue/dV3YNKQkpmceojsmUZ+YkGVBv+qZAvFK7+QDnTOTuTzBe2x+MRhFtHV3mzuCMbKQUhkL6wjCVZcAJe5XjL8CGSiyrZ191sK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774454545; c=relaxed/simple;
	bh=vJ5xGASjMp/TlxhmM7CCfj7w6GupzT6n+xYGWNCGtRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hr7T/QCGwZb7qmKrgrJyIHozFxgYM8FKSadqHjaa0Yja2dknTyQ8tLwB9pBdinxIvjGYK0lNVLanyDGNe/Mb3JVpUyzVmH8xhPI/euqShrTR5n99Wd3sZlHXAAc0FOFRTiqEEN+8dvHC1j4H0B3JD7F/wSRX6AoDoz/BOgUMjwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+2FchYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+2FchYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ACCC2BCB3;
	Wed, 25 Mar 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774454544;
	bh=vJ5xGASjMp/TlxhmM7CCfj7w6GupzT6n+xYGWNCGtRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+2FchYbbkhWOofwvjIv9Q9SCnlXi2yRnZCJyFCjE/4lIXvKo7/3kCKeDOLwQg/34
	 ZiDtgzoi/papPZGLWU9JlD52PxCDTJ980jG5ZuhDQGf/bgZzvD5effQuMJ6p16xp/F
	 VBK9/3dNU7Vc1H6G6Fg5kZq9BP22TEMnWs/dKZiaQTlPnPT1yT7hcAB5v1MXGP0q4j
	 SXTJ1/xW7qVVP9awRDMj5dxDxCTO34dPiQfePoIKCM9W280FQ7CfsnbJDhMI0ONFZ+
	 za9Vojisydqn+4vOQVw8wIxrFjFDVNSpFv4rltLNOSvB8dTcoLnW0gxg6J2rBsbpe+
	 KlR96DzdoON3g==
Date: Wed, 25 Mar 2026 09:02:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <20260325160224.GT6223@frogsfrogsfrogs>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
 <20260319170231.1455553-2-aalbersh@kernel.org>
 <20260325075402.GA952@lst.de>
 <3lllvimldwcgi7crh3kgwy3a5z2ng2ugcka52ab47o5mwx4dnu@xyzbelhykn7n>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3lllvimldwcgi7crh3kgwy3a5z2ng2ugcka52ab47o5mwx4dnu@xyzbelhykn7n>

On Wed, Mar 25, 2026 at 12:41:23PM +0100, Andrey Albershteyn wrote:
> On 2026-03-25 08:54:02, Christoph Hellwig wrote:
> > On Thu, Mar 19, 2026 at 06:01:48PM +0100, Andrey Albershteyn wrote:
> > > Reported verification errors to fsnotify through recently added fserror
> > > interface.
> > 
> > Looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> Thanks!
> 
> > 
> > Btw, would it make sense to enhance the interface to tell why the
> > data vs considered lost?  i.e. checksum failure vs
> 
> > (part of) device disappeared?
> 
> isn't it something filesystem should report even before fsverity
> gets the page?

Since the verification code is mostly called from read(ahead)
completion, doesn't a merkle tree verification failure result in the
folio remaining !uptodate?  And all that gets compressed to EIO...

--D
