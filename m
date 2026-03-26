Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B7039D6D4;
	Thu, 26 Mar 2026 06:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774505325; cv=none; b=N7mCPg/qNhQDk1EJi68ec6aVfZh1tZAsFhcldZZr9D5E2JOT6nDZppDBGjOYojMIQv9iLvpUEhXtHkKX/JZLDJkbsVGAqGcY7IK+qfpxL60YOfWUZyXHkl5dtrqLdcyGd63MQmVfNsj+AX/M46f3hxzQ3WM97ZlyY8MBYcIUesU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774505325; c=relaxed/simple;
	bh=IGBz7634ql8MU/T2Y4f0LGAcRXRpaV0P0K09NrMZOt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGMGyyeNnB2oT+NoxC+X3jgMJ4yJgeI7XkKAeVI/5MUYwNhjHJNarpNtmurI06aDLkO5ehgfbezMczLkp8plWRB79jc+Tk/slLxJvcL6620ABSY/TQD2Dkl8vHVbxicJA+kf8E5hgGqW+o1a31o/jIh+xwIzF6s5mj96OcNe7hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CEFB968B05; Thu, 26 Mar 2026 07:08:40 +0100 (CET)
Date: Thu, 26 Mar 2026 07:08:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
Message-ID: <20260326060840.GA23733@lst.de>
References: <20260325124312.26349-1-hans.holmberg@wdc.com> <acSfSmE_IBjWl_cR@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acSfSmE_IBjWl_cR@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 26, 2026 at 01:51:54PM +1100, Dave Chinner wrote:
> > - Added a new helper to wake up the gc thread in stead of unparking it,
> >   which is required to make this work properly.
> > - Added protection against races with unmounts as sysfs gets torn down
> >   after the zone info struct is freed. This also avoids unneded
> >   wakeups during remount.
> 
> Isn't that a deadlock vector?
> 
> i.e. unmount takes s_umount, concurrently userspace writes a new
> value to sysfs file. sysfs file write blocks on s_umount, unmount
> blocks holding s_umount waiting for sysfs file reference count to go
> to zero to destroy it?

Given that the code does a trylock it should not.

