Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EF4283FEF;
	Wed, 25 Mar 2026 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774425851; cv=none; b=Ke8MEICNmgz1bEC5rUWJrnT7MMelrRLtCXmrlvnCR6hAoUUAjzL0NTI5Vp+NiZwPgwBsbm8zf2Xrywc767c3+/dO/sBmr/izpw3Bga6TbZRzW7m4IoQqhtkRPAlyUFGRHH7cpqE+DIIoOAONzco2BJufZ0N7/2lKXK3Jy32McY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774425851; c=relaxed/simple;
	bh=CqpBI3ep4iVvARiMtkkBkHpwoIjCRBWYb9KojQM1hto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cw1kc83D/adeTHjE49DXSSFi2Z1ePQpeUIrrECeUVtUURRSv4erhgzHVmpEB/4dfxJeRsbNzPHhjNL+n+yQqFkrRi6rE+apD5kUDjpPVdvEMpUhg47kr+Svn+TuyGRukgU1n9PkK8uX6rdsKbyLEzc2MHc+2CSIVhsTSTyw0sPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85D3968D09; Wed, 25 Mar 2026 09:04:07 +0100 (CET)
Date: Wed, 25 Mar 2026 09:04:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v5 09/25] iomap: issue readahead for fsverity merkle
 tree
Message-ID: <20260325080407.GG952@lst.de>
References: <20260319170231.1455553-1-aalbersh@kernel.org> <20260319170231.1455553-10-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170231.1455553-10-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 19, 2026 at 06:01:56PM +0100, Andrey Albershteyn wrote:
> Issue reading of fsverity merkle tree on the fsverity inodes. This way
> metadata will be available at I/O completion time.

Patches 8 to 10 really look like they should be merged to me.  They
all add the actual fsverity support to the iomap buffered read path,
and merging them and having a single explanation of the side seems
helpful both for review and future archeology

