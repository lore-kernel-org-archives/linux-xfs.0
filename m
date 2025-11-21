Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D0427EFFA;
	Fri, 21 Nov 2025 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763708246; cv=none; b=s4hUETMMmkWYfIoH+bV8ECveBHxHn57ACmBarOXTx34SS2lIquBSYVTQFTk5unX5k2HrOxHHz0pZaZn3aKHvnYei0FYIG6jx893wgJq/L7MVdV7mLVhQngI+/YnKMo+9cxkyRXkyE9UpTMygWQyy5JLpHGNNrZNo8V0qnld04+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763708246; c=relaxed/simple;
	bh=2Y1QiltY2bcwIgT1gJ99wi52bf8w1dVBt4IqGpe4FlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAMwB+nNR6MbF9IysRSRWcijUwg0N5xrf0yba/ZrPCGnhpDxYNhW9wItBg5CGgl/qbJkjbDIt5ENRWwVhwxXi1p8oAm/z1HrkGvGibIhLIdB2Ocal2xUp5BGv162W9gZaIQ5G8hW8SRg3SIh4ZD3pH/E5LEKVzfEsN0o+NAIyTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D95867373; Fri, 21 Nov 2025 07:57:21 +0100 (CET)
Date: Fri, 21 Nov 2025 07:57:20 +0100
From: hch <hch@lst.de>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>, hch <hch@lst.de>,
	Hans Holmberg <Hans.Holmberg@wdc.com>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <20251121065720.GC29613@lst.de>
References: <20251120160901.63810-1-cem@kernel.org> <20251120160901.63810-3-cem@kernel.org> <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 21, 2025 at 06:51:31AM +0000, Johannes Thumshirn wrote:
> On 11/20/25 5:09 PM, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Add a regression test for initializing zoned block devices with
> > sequential zones with a capacity smaller than the conventional
> > zones capacity.
> 
> 
> Hi Carlos,
> 
> Two quick questions:
> 
> 1) Is there a specific reason this is a xfs only test? I think checking 
> this on btrfs and f2fs would make sense as well, like with generic/781.

Didn't f2fs drop zone_capacity < zone_size support because they only
care about their android out of tree use case?

But otherwise I'd agree.
