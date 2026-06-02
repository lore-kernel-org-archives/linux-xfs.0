Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2322B35F5E0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381912; cv=none; b=TW5YOZmKIVM6la2YcqTK/v0JvgQPBLY5YWcTqqI+xTgNt3Sg7UbSSE7Jmx51bfukLOVYhGpDXQBbGvfe01HS24a7N7CDUkPM8ug1IfHK2FQLy1cXYtw8MVxiaNTAQx6u9UYSu0fX7OeIMP0slt0KXIl4LMPVLfrURFy7YYtENKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381912; c=relaxed/simple;
	bh=Jsw56Ngy4SuTU0PkAV7j0UqLkKLny6FIk80Dj1nmH68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6boUSVFod7I8QaBPm6skxpW8SPFhIB5/sgMI9AbKjoySXYT4/WXwcDjSbItbOvd4NQz03PqDgYVg4B4mj0og4ROIo1XcZGENl2oY4jhYAc0tqz6uR36MkYoDpuPRpoNWjgMC2jgkUV6M0HhNBwtxOmVRKByhFBae9wxuPb/T/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD45B68B05; Tue,  2 Jun 2026 08:31:48 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:31:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/7] xfs_healer: recommend offline fsck for XCORRUPT
 repairs
Message-ID: <20260602063147.GB2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627080.588879.10740056483979935139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627080.588879.10740056483979935139.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:58:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the kernel thinks the repair succeeded but the re-scrub cannot
> complete the cross-referencing checks, we should recommend an offline
> repair instead of reporting the repair as completely successful or
> unnecessary.  Codex noticed the omitted flag check here.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

