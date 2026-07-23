Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACC63A3E97;
	Thu, 23 Jul 2026 04:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784782528; cv=none; b=EcAJMtRxioC+8tYWus2cXL0tqV/4WLzUK7fAMvlRe5lfD+E/M4GG1iiwK/HQBiiOlANZoK8lMTihwFxpD2MZedx0MoTSOv2PkS8Ula2pivvFkSXDZear6Ad/f2adAqwSglqAgwoeou8AN9UDlyb9/eQHCT0Paj0oatvGe9QQbsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784782528; c=relaxed/simple;
	bh=Jg+yM564uG6A0A/3JuKMuFdUmvJ7hd/pfKr6cCLyYuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqIRZ8zmQsKG6NMhCga5wcf6y8QQxm0Q24Jr17LoqpflsKzgkYznyJYKGZorYOQzt65P2OmaYjm9s73pqjBcCa+vQpnaU0qlKFjdfqPi9Y5ObUlEgp/N6MCLlRD3tDNRtURRPYu2nu+ABykFLI6igzBNn/+Zw8kTsRMSrmDT3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C6A468AFE; Thu, 23 Jul 2026 06:55:18 +0200 (CEST)
Date: Thu, 23 Jul 2026 06:55:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: changfengnan <changfengnan@bytedance.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <20260723045517.GB6641@lst.de>
References: <20260722124931.3159664-1-hch@lst.de> <20260722124931.3159664-3-hch@lst.de> <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com> <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.fb281486.dc82.4049.92e1.5b912f7e663c@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.fb281486.dc82.4049.92e1.5b912f7e663c@bytedance.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 10:17:49AM +0800, changfengnan wrote:
> Yes, there is an issue with the handling of the inode_dio_end event in the
> synchronization scenario.
> How about this ?

Yes, minus the label naming that is exactly what I came up with
yesterday and it has survived testing over night.  Looks like xfstests
currently never triggers the sychronous error return path, I'll see
if I can increase coverage for that.
