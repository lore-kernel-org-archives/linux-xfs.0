Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F382EAE6;
	Wed, 22 Jan 2025 06:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737525898; cv=none; b=GUcjecB/qxivqXDgiD9g+H0lPXxNhXSNlrRhtVABl3NuGbWi5SU+CkcoU5DGV8o74WK2EchM53HpwULjfmJZnUbl+YE3fHpfbg9VxnSYOTX7FsErOZhpHtqiUQoiKlhdKsFuCuknt8P8kOnLC2sQ4cF2q/zst1/WkadgdXNUlk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737525898; c=relaxed/simple;
	bh=2VhlgwGI3WqFEgL92FHAEGJebLxTm87qvLaAixYx4nQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5vr1XG5ryvci0XYRhwV4hMDHd04Su+c6iAHbkSaMlBGKdWJbJOiP9TJQHw1SIRbTash+3bweP+48aq5RUCvRWe8J2NGoa1LC9FnxFvGv3U4kJysXai3hXKTdvjsbmulMx/rWX4AU+VP2YvKNdXrM5hwZYajzFkYadvRXVMX2yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E58F968D05; Wed, 22 Jan 2025 07:04:51 +0100 (CET)
Date: Wed, 22 Jan 2025 07:04:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: xfs_repair after data corruption (not caused by xfs, but by
 failing nvme drive)
Message-ID: <20250122060451.GA30504@lst.de>
References: <20250120-hackbeil-matetee-905d32a04215@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250120-hackbeil-matetee-905d32a04215@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

As Dave said this looks like the secondary superblocks got messed up.
repair really should not fail because of that, we can look into it.

If you still have the fs around for a metadump image that would help,
but otherwise it should be possibly to craft a reproducer.

