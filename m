Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43B2690EC;
	Mon,  9 Feb 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648474; cv=none; b=E9KMPEpgTGB3LL1wSzWfFIOgdo8rK+A2TZiCNbM2uvGaN52lsmAxQ/y2K8ORWZdTilMaChIigH4NrNNGSpk8wntokHrrjo//8Y/pciFa+pG5VzukO5dqrSpHjsYzEq0m8M0q7GgpEVMB5+Iebmdb9+2bjVR1T3GVd86QQ4AVRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648474; c=relaxed/simple;
	bh=VEUjsNTk2xbi/qHEMjraTGXqthh4GkYa2if02SQ8WLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQEHiA3egzJz3aeFsegdcwZB5UCbKvwcg5mchwd7A6JsdyGHsxfep5Xw8xiMSV28KSm2OPYUP2D7No4oblloyTon/ovi8zNzmk6d/4ghUC+TDBLICIQeOlKF/OlKRMLjIlx8pBLF0F7Pbu8z+yvNSrRTkogjGg6g/VDIs09tOWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8058A68D09; Mon,  9 Feb 2026 15:47:50 +0100 (CET)
Date: Mon, 9 Feb 2026 15:47:49 +0100
From: hch <hch@lst.de>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: hch <hch@lst.de>, "djwong@kernel.org" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cem@kernel.org" <cem@kernel.org>
Subject: Re: [PATCH] xfs: add static size checks for structures in xfs_fs.h
Message-ID: <20260209144749.GB16995@lst.de>
References: <20260206030557.1201204-2-wilfred.opensource@gmail.com> <20260206060803.GA25214@lst.de> <41ea75676ea983281368c449647599aad9551d1b.camel@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41ea75676ea983281368c449647599aad9551d1b.camel@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 09, 2026 at 07:04:22AM +0000, Wilfred Mallawa wrote:
> As Dave mentioned, I did not consider the alignment requirements being
> different on 32b for example. So I did see some errors for the
> following structs from testbot:
> 
> 
> xfs_flock64
> xfs_fsop_geom_v1
> xfs_growfs_data_t
> xfs_growfs_rt_t
> xfs_inogrp
> 
> So we may have to omit these altogether? I'm not sure if this patch
> would cause issues for other configs the testbot isn't catching? Any
> thoughts?

Out of the Linux supported architectures there are basically five
kinds of differences a struct ABI can have:

 1) different pointer sizes
 2) different size of long for long derived types
 3) different alignment of u64 on i386 vs everyone else
 4) different alignment of u16 on arm32-oldabi vs everyone else
 5) configuration dependencies

5) is a no-go for exported types

4) doesn't happen in the current xfs uapi headers (it happens in on-disk
formats structs though..).

3) is clearly indicated by the x86-specific handlers in xfs_ioctl32.c

2) and 1) are indicated by the other handlers in xfs_ioctl32.c.

Based on that your above list is a good start, but incomplete.
The list of compat_ structures in fs/xfs/xfs_ioctl32.h should have
a complete list, and if doesn't that is a bug as we're missing
compat handlers.

