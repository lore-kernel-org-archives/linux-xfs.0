Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B225A344;
	Wed, 30 Apr 2025 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746017791; cv=none; b=j/yJDFPNb638FENik3JF8Kx5f9/fVmP26YCCE4ztamey23UVyoxSY623e3rUDO1fpKU1rjMqi3H+RjElEjnHEOsJpGf6TK55K13Sn45ILtjyV0oxeB61d+T8GKrGuObBNO+1rzG6/MgheWfiUwPlpLaFnOg/Z4bhj+jRfG9qoE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746017791; c=relaxed/simple;
	bh=6+8+oieslYF6fLMzUCNK8FByOyxhBOOfE+iO0YpIpXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjFAjZFGOzCbSq2sQmVgIStPE4XZ+o6DftpyfCX+RO9mnYeo6FE/dW2IPF+Pek+m98wh2YGDNOKZKS42PwMAcmEUdYAk568i/sDDq0DBpn6v2d3PxwTl7SFRsy2O8Jb1VaEbgKs816Bg4Ak5uB5Olzuyoc71h11C/o4ExkMK1bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A63FF67373; Wed, 30 Apr 2025 14:56:18 +0200 (CEST)
Date: Wed, 30 Apr 2025 14:56:18 +0200
From: hch <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Message-ID: <20250430125618.GA834@lst.de>
References: <20250425090259.10154-1-hans.holmberg@wdc.com> <20250425090259.10154-2-hans.holmberg@wdc.com> <20250425150331.GG25667@frogsfrogsfrogs> <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com> <20250429145220.GU25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429145220.GU25675@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 29, 2025 at 07:52:21AM -0700, Darrick J. Wong wrote:
> And come to think of it, weren't there supposed to be pmem filesystems
> which would run entirely off a pmem character device and not have a
> block interface available at all?

That support never materialized, and if it at some does it will need a
few changes all over xfstets, so no need to worry now.

