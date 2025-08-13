Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FFB1BCA0E
	for <linux-xfs@vger.kernel.org>; Wed, 13 Aug 2025 02:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755051622; cv=none; b=hofKxsTjSZm1IbBGR8aHdCvw2VN8tt9MWDQuSg2kU5l4nlRl9Xq9suX2JCq+gLEU0JmMwfMWLgPRamKUf8Gvbk6hXo7ncuKssK7cNfj7AelfNcSnth36CF5bS/Xq+pdNi4Uc+aGS/+32xJz9xPzg9yIfzy6IwNBjlFoaXZpWrN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755051622; c=relaxed/simple;
	bh=zjEvlghWDamKQzF+I8s7BTGX6M71SR/rS7oy6DBq4vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehuJ1enLOZ2s13qImu2tsJJ8EYR+pCj5l2UymG05KDr2ISC872VDTot8a4yHOX5vUe+kNvb50T3VKxbl0vG7V3rX3XXtxoPOvrCFA6I921rPaAb+4RIkx7jcGQ8lXaaBtAIZlJSwThcS/Izd+GvuNnTrjqYOpg8yfcCJHfSTaZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek2dQ7yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek2dQ7yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4CFC4CEF0;
	Wed, 13 Aug 2025 02:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755051621;
	bh=zjEvlghWDamKQzF+I8s7BTGX6M71SR/rS7oy6DBq4vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ek2dQ7yBvuVgDBMKKT+Hfxp9O1rA6gT8hSemSg3B8c7kQDLUauAEwcbdnC2fj0Ck+
	 TvseRTXPkWY3r6ffFM3Sx0+VJmRaCXYv71e9Nx7dGmfWqfkdM6jM/14arWUahJ8Vmn
	 PCuLET2GG5IiBUvY7etTmqkpqYOAprNpCzayxlGXndnDLEud3emyudVWG/GmJAspas
	 mTX7qWybweuzp5V4sI5/gNk6f2Im5IM56Bu23fr0umo/X+qrstquS37xtwyElW7TfJ
	 G31h0Cq8+lyxnfPQCQXXSdisH9qOhtaaUENYqI69Gq1/gRT0oM4y4a3fCurUTu247z
	 6qFihl8vi3yag==
Date: Tue, 12 Aug 2025 19:20:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: sync xfs_log_recover.h with the kernel
Message-ID: <20250813022021.GR7965@frogsfrogsfrogs>
References: <20250812090557.399423-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812090557.399423-1-hch@lst.de>

On Tue, Aug 12, 2025 at 11:05:36AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> syncing changes to xfs_log_recover.h has been a bit of a pain.
> 
> Fix this my moving it to libxfs/ and updating it to the full kernel
> version.

Looks ok, but what's your motivation?  Just making libxfs-apply happy?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> 
