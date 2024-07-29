Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E03C155382;
	Mon, 29 Jul 2024 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722263237; cv=none; b=CzNsLdTh1sVRDqfQYEKrhJrIGVtOoFK9zDHxqlYunn9L1qu4Q5w3oqm4RfFIQyVDQ0UGuQWJfGeEl7FkuQogNYWXaLXyQniIIAE9xWAMUI434c9uuvl8XYFq6lig7SR0yHMPtWM/8/RGYuN2+cjkIhM2cMOlZoXt6l46BXl02Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722263237; c=relaxed/simple;
	bh=F5zQH4vukkVnbsCzOW+qqmN7RCwJ8bdVBNj5kk31YdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8n5c+ZeXLgONRivHmRA0BCdadGbCJXXvU4Rm7Fx5eE7tdMSMq/rQZBXQWQQ8w/z6A3aMd3RpA4zDCL1WVvCZnMqri6O6ZhHqGBHQ9AY+E3+skG01ihxgO7plYqnFew4dwIu1KlvoYEG8CDvIlKeTXGEmFVlroACpbOolnFFo5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E99D68D07; Mon, 29 Jul 2024 16:17:31 +0200 (CEST)
Date: Mon, 29 Jul 2024 16:17:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common: _notrun if _scratch_mkfs_xfs failed
Message-ID: <20240729141731.GA28016@lst.de>
References: <20240723000042.240981-1-hch@lst.de> <20240723000042.240981-3-hch@lst.de> <20240728145408.mu2hmmqmzxb2amrd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240728145408.mu2hmmqmzxb2amrd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 28, 2024 at 10:54:08PM +0800, Zorro Lang wrote:
> But this line blocks the merging process. I can't find "_scratch_xfs_force_no_metadir"
> in xfs/178, and even the whole xfstests. Could you help to rebase this patchset on
> offical xfstests for-next branch, then send it again? This patch is too big, It's hard
> for me to merge it manually ( I'm glad to know if there's an easy way to deal with this
> conflict manually :)

Sorry, I've been working off Darrick's queue to include the rt
improvements once again.  I'll rebase it to your latest tree.

