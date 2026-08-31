Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A573B3BEF
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159515; cv=none; b=QDDGdPlCGO2LCMwVgYItzKBWFbBbUGzeMyyaYnrTycwv8teK0r3PUMK33C/Iwy5bJlS002gF7V53yhPvwfeLoKl4sjXEtVJ8o/IcHxz9+NM+iRvYcFUNgnxz9JpsYvTg0tnxGUGIrM97sPD3kNXBI7GoE3ttH8ovqgioPRZVZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159515; c=relaxed/simple;
	bh=9zoSE27y+UXVX7WFyT/1KeRfquU9zJ9fmchKnbRRH2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6T/l8Lz58YgRnxslj5D0uqHxjGucT58qkK1BfH0x9TGooCgBVDT7Fcq6FT001upMeU5cJ576tGnhff+DdNVydMBKlxZo+tw2vfqWNZWxywz1etwZvIMZ1sCSGUy2P6QV7x03gCU3CCvFBSC3Iz/i3Q4Yf5vnnrMRDfAOl2PW+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A20868BEB; Mon, 31 Aug 2026 08:58:26 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:58:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <20260831065826.GC24602@lst.de>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs> <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 26, 2026 at 10:32:59PM -0700, Darrick J. Wong wrote:
>  struct xfs_healthmon_event {
> -	struct xfs_healthmon_event	*next;
> +	struct list_head		list;

Call this entry to make clear it's a list entry and not the list?

> +static inline struct xfs_healthmon_event *xfs_healthmon_alloc_event(void)
> +{
> +	struct xfs_healthmon_event		*event =
> +		kzalloc_obj(struct xfs_healthmon_event, GFP_NOFS);
> +
> +	if (event)
> +		INIT_LIST_HEAD(&event->list);
> +	return event;

There is no need to initialize a list_head only used as an entry.

> +}
> +
> +static inline struct xfs_healthmon_event *
> +xfs_healthmon_dup_event(
> +	const struct xfs_healthmon_event	*template)
> +{
> +	struct xfs_healthmon_event		*event =
> +		kmemdup(template, sizeof(struct xfs_healthmon_event),
> +				GFP_NOFS);
> +
> +	if (event)
> +		INIT_LIST_HEAD(&event->list);
> +	return event;

Same here.

