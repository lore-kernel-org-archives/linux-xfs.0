Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF52D46AB;
	Tue, 12 Aug 2025 07:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985103; cv=none; b=cxeMnEliVza7SCa76DGAIM9gVg+pGMDogSkpwPwNSmpXiK3csZ5mSj3z+DuB6/tgUWPQ5D2xT42XKwqbQxiR1JSX63ZIfZIwU6/y0mCAgQJLrauUgAAYxjj+pW+h47SLEcDR+a7DF2oNVkvBhf1HYd2angZzsmFMJwcjOSGTkkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985103; c=relaxed/simple;
	bh=vI/FrNY/ncVlMyuCYZypTddXFGvYbqgqV6uGU0x1VIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbUm2S5yEodDJz8EubX5P2OEGI8xYYkjsgDLavZx4yGb50m2xm66wTc+OJQmxUpsDQLRdotcm0qh6R1dYTn/m22E0b1HhqNmgrsCP1aCvNpv/KWVwdUPbBggK20QgtnF7e2r+XWAMPRkSGOVdGxkvNv5Upwl8aInyZjZgrbM8Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0239468AA6; Tue, 12 Aug 2025 09:51:37 +0200 (CEST)
Date: Tue, 12 Aug 2025 09:51:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
	ebiggers@kernel.org, hch@lst.de,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 03/29] fs: add FS_XFLAG_VERITY for verity files
Message-ID: <20250812075136.GA19693@lst.de>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org> <20250728-fsverity-v1-3-9e5443af0e34@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728-fsverity-v1-3-9e5443af0e34@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 28, 2025 at 10:30:07PM +0200, Andrey Albershteyn wrote:
> From: Andrey Albershteyn <aalbersh@redhat.com>
> 
> Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
> enabled.

This is independent of the XFS support and just offers the verity
bit over formally XFS and now VFS fsxattr interface, right?  If so
can you just sent it off to Eric after writing a more complete
commit log explaining this?

