Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8788F49;
	Fri, 28 Mar 2025 11:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743159693; cv=none; b=SJSOZp5cKgmbnmAPWcJ1YiS1tcqTwI8nT1j2L8zfrmBO3e2TP6/unYX3wu05khagJ2c7oVBsllfItBf3Pz9HuriiOUG3oNBii08GWC/MAR6n+Bm5cugIZL4r48SSPl3rjxBvh7pUdpztHUwakS8iX9ah4WRe4S7U70aKatHsgzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743159693; c=relaxed/simple;
	bh=WzGxv/o3Lj3GdtoDF20X8KTHMy2sJG6OPnAbS1jpSHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYVOicTp3dEA4BIGOvdZZParMyL2KaZLly/XD7Eje0GiCLojNTSRBxuMM675EWbMGGfhAWrkBnYZnqSQK/FdBktb5bEwA9SrgiEVrTWdZ2ThBEb0m7rttmQ+ukKdELwEUMYi0eTCkR9o2ibUtzBPqy8rcq1WmkRUU1GWb05G2VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B1A368AFE; Fri, 28 Mar 2025 12:01:27 +0100 (CET)
Date: Fri, 28 Mar 2025 12:01:27 +0100
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering
 zone GC
Message-ID: <20250328110127.GA20388@lst.de>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325091007.24070-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 25, 2025 at 09:10:49AM +0000, Hans Holmberg wrote:
> +Zoned Filesystems
> +=================
> +
> +For zoned file systems, the following attributes are exposed in:
> +
> + /sys/fs/xfs/<dev>/zoned/
> +
> + max_open_zones                 (Min:  1  Default:  Varies  Max:  UINTMAX)
> +        This read-only attribute exposes the maximum number of open zones
> +        available for data placement. The value is determined at mount time and
> +        is limited by the capabilities of the backing zoned device, file system
> +        size and the max_open_zones mount option.

This should go into 6.15-rc as a separate patch to fix my mistake of not
adding documentation for this file.  (Thanks for fixing that!)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
