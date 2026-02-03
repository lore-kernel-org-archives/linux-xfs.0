Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84346372B49
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103788; cv=none; b=Jv28HdoXqMaO49QjS0paxE1+uu3NnMs0TfduR5u0sXcJnLbyW/rtiN1PWoKTAIUlbRdZsTAd46dxK26UIbhYS907Qxl/iUMOBVj0SO3++LrmKnIgVXLimsmjBQVUbMbzZvzLwwpCUfIfPcHnSmj5M81xkVMWrmLtv+5McMKtS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103788; c=relaxed/simple;
	bh=w/xDTvIeArD6kGET6XMulpNZXV7Ev+YC1n0YX49zxo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMB7Hp4YmajMMoNLdzFW9aT9I6yARLU4nFxQ9L56r80cYj+i83tPAuzazSgWjJb+xfDiDVOPbWKvzYzlTCM3rCwUNlhPy4sMS4bZDhZ6YZmvkBWD1Q86pA4Cw5JXbGkyIhV/QaUxzhy1O9OeDZcNMW83FSnLTJc/sI3Q+LZnSto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B6FD268AFE; Tue,  3 Feb 2026 08:29:43 +0100 (CET)
Date: Tue, 3 Feb 2026 08:29:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260203072943.GA19873@lst.de>
References: <20260202141502.378973-1-hch@lst.de> <20260202141502.378973-3-hch@lst.de> <00fa6edc7f0c324ceb95f7181682d04ce3f53839.camel@gmail.com> <20260203071434.GA19039@lst.de> <66aad774-2bfd-4a7c-8155-d11638643034@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66aad774-2bfd-4a7c-8155-d11638643034@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 03, 2026 at 12:54:55PM +0530, Nirjhar Roy (IBM) wrote:
> Okay, now I get it. Thank you. So we increment the stats for regular inode 
> (since this is more common) and later adjust if our assumption is wrong, 
> i.e, the inode turns out to be a metadir inode. Right?

Yes, although it would not really call it an assumption, but just the
fast path.

