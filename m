Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F921335BB4
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 06:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774247815; cv=none; b=A6p5I850PQ0zLm4WvUmSEG4vrBorpa2XuoU5L0AkMqgTWkowiquswrAD8+6RsneFVTBAohobr7aNb0fmU7yFUZj+qmxjbbf2d322fhxalLQ3wYSzMDJHIdVwJbCznxfdFr5bdLZxeWl7d2XwYyrmg9MQIJfRqfdLpluwslp4I3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774247815; c=relaxed/simple;
	bh=PPBrm3tluzE92Dob1eASvBA7sI1A86cNofXcvxDJXgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7MReo7XEyTFkCjNkOkX4H2HQ1O+EVAjNHBDQxMXsQ75QG58Uqz3hsvRrxrt57toSInzALilf5iXoFHzviCU1u6DkQcEFhD7y5Z+xcZhJ033UKfMzDrNPmKkr15jQ6Dok4wPDUjffD1/3YBsdUbGm21HI3TmKIdku3Ve+l8KNG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 87BE768AFE; Mon, 23 Mar 2026 07:36:41 +0100 (CET)
Date: Mon, 23 Mar 2026 07:36:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260323063641.GA24722@lst.de>
References: <20260320130256.35225-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320130256.35225-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +		mp->m_zonegc_low_space = val;
> +		if (!xfs_is_readonly(mp))
> +			xfs_zone_gc_start(mp);

Do we need to take s_umount here to prevent races with remount?
(Not that it has any major effect, but we might as well get it
tight).

Otherwise looks good.  Do we want a test to ensure this takes
effect?  And one that it doesn't do anything stupid on a hard
read-only file system?

