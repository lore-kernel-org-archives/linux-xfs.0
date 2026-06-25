Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2298B2DF6E6;
	Thu, 25 Jun 2026 13:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392992; cv=none; b=JMHhWFnX8cz1U9X89yw+f6C0TII4NJYr2Yzzb0FXnNZQP0dDScG3IAaWLFg1ab+ukUPHnj+uLy1z4v+OUOpo+B4873Qk2Qlehs+DjdAqIzdNyH5OdACssmKu/IagUuurKe4Qe9Mg0YvB4c8RjmtOYZ6+YJTmAHAv6I1/lhrTr7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392992; c=relaxed/simple;
	bh=+7DpwbI7bR6lFXl72qYQyngKBUMGJpeYF+kWWqUlNL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mztai79LcofIGbKaoqdalXvGxqwh0rEv8RdY6A5Jz6bHxUOZmwhHgjKeFdPx0z0cxtK3VswtciYTwbx3ug1iFOmraRo3BWRkFP5wiPbnX4TF2UXLUC6PzPYcUQ9l463Y0256PdpJHzcNh0CvhxlZ76nLyqtlwc1JIqtpV17pkQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C75E68B05; Thu, 25 Jun 2026 15:09:46 +0200 (CEST)
Date: Thu, 25 Jun 2026 15:09:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <20260625130946.GA23875@lst.de>
References: <20260623142109.1838702-1-hch@lst.de> <rbrncqfmzbnj5o2yvieqtpl3dkb4qzafsai3sarmbta4fsqc6f@yruai3zv5llu> <20260624134950.GA6471@lst.de> <ecyxpdw5jcqiw5lq26pi4af76tygoiqshj23hp7jkguvbn6o3z@bd3hnhglc4bo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecyxpdw5jcqiw5lq26pi4af76tygoiqshj23hp7jkguvbn6o3z@bd3hnhglc4bo>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 01:12:05PM +0200, Jan Kara wrote:
> Hum, right. XFS users are used to tweak
> /sys/block/<dev>/queue/read_ahead_kb
> which would stop influencing anything. I guess that could indeed break some
> people's expectations.

Yeah.

> One more idea: We already cache bdi's ra_pages in struct file_ra_state on
> file open. It wouldn't be that hard to allow filesystem to override the
> values in its open method (currently it isn't possible only because
> file_ra_state_init() is called after ->open). For io_pages we currently
> always go to the bdi so we'd have to add it to struct file_ra_state.

It has to be called after ->open because ->open can change
file->f_mapping.  Now we could require any instance changing it to also
call file_ra_state_init, but I think bloating every struct file with a
new field might not win a lot of friends.  OTOH having a local copy
of ra_pages but not io_pages is really weird.  But so is this whole
cascading set of indirections for the readahead parameters.

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
---end quoted text---
