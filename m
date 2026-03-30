Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446AB286D73;
	Mon, 30 Mar 2026 05:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774848865; cv=none; b=pXkNdM9QaWrgYg7NzfMAvuEGxOLeuQSpjRlRSp39CsVn0TVuZwF9r0o8eB2cJBG1SwNrDMsva6Gi736rioAoIoqqbdp0Zur3NumD1gn96FtK22xmC4b7hjwc6HQrg40zuEgkURSklWN5X0O9pVEdv9YvaxkEhyKgWnWJ10aOZ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774848865; c=relaxed/simple;
	bh=6iM1oEmmQ3xqQP0fsgiLy0YjTvqi/OFEacDuAQxRWJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvrUctBpi+4Hq/U0rOAsUKDGaR3KyqaYN8V57zo5Eq3F26l0oV12FnMj5U5NEIVyMre3KoQzt6nX0aHIysZ0u8GBtB6+2HQTXe+DQsjAZiT80VFzKTNWf6CAmYXZ71zCQBAH96qwm2Q679K3RTt0evSxBHopwiLvr3c+59B8JFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AFFF668B05; Mon, 30 Mar 2026 07:34:21 +0200 (CEST)
Date: Mon, 30 Mar 2026 07:34:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start
 gc for rw fses
Message-ID: <20260330053421.GC4876@lst.de>
References: <20260327123429.39330-1-hans.holmberg@wdc.com> <20260327123429.39330-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327123429.39330-3-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 27, 2026 at 01:34:29PM +0100, Hans Holmberg wrote:
> Test that writes to the sysfs attribute zone_gc_low_space triggers
> garbage collection for rw (but not ro) file systems.

.. and add common helpers for that.  I tend to split the helpers out
into separate commit, but I'm not sure if Zorro cares all that much
about it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

