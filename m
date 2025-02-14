Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148D614D28C
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 18:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739557549; cv=none; b=mTURV5zpUldTMIeL3TyCXZgtPfbcuZ3+x5oU80CLrR1W4v8i8NOgwZIf229g2kt6XWLvK438z6HbZ1d6MfITeznnCtwNiPleCXZwso3hy1eXopx5ZqtwSO15MkBNcYe/UlPVXSJRBmoHYy6sA4urA8l/gvtvCyi3yA4RjB7PVGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739557549; c=relaxed/simple;
	bh=h6ed2cw63acPNVueRjeDaRAv2ZpyJOe83YGso3m++20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVzahu3KNbpkY4y2zsoNUhRGX7hLLZGcLy4QTX6JwFqwAxfZtSiXAAFFfhQI0cACi8EbijMzxD+5t36QQbssMjWz4qrAdPmrFAbIxjzhMPl4f3VCDDsKATLHUdUxSUDknTAwtumOvNeFKWNB7D402TkpLUMCNYuCL5YK+meaNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHwrzJQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHwrzJQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F799C4CED1;
	Fri, 14 Feb 2025 18:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739557548;
	bh=h6ed2cw63acPNVueRjeDaRAv2ZpyJOe83YGso3m++20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UHwrzJQHJX+jE/wF7jZVgrsFa5uPMLClqXKNcEfGOL52tm0VM8KtInJUhVA0MBgS3
	 g4pTAfO7dhiTJs21lWrjLUkhGFQ6vN0uxqkcaDOdjxyhz18eRzsAGtY0cv/4IAR09Y
	 H3f30cZ6ujjXHys20eGj1Fx0lK2XQxLhCaqVLXnnmODXzHPznDBQP/d3PC8kU0DD+s
	 uTxeafVdkgz0Av/GCoX2jvBbFZweR03dbTgu4dGL9vP1Bhe/OnnQuX0sN2Y4VSU9+6
	 eOcO6whXYMOugFo2Isqnt/h6roP6+tgBuOvAhmxYgA6oGmXjmiWZJgSc+v609OzICX
	 ZHoi4qLoI2R2Q==
Date: Fri, 14 Feb 2025 10:25:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: add support for zoned space reservations
Message-ID: <20250214182546.GZ21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-24-hch@lst.de>
 <20250207175231.GA21808@frogsfrogsfrogs>
 <20250213051749.GD17582@lst.de>
 <20250213220943.GU21808@frogsfrogsfrogs>
 <20250214062054.GA25903@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214062054.GA25903@lst.de>

On Fri, Feb 14, 2025 at 07:20:54AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 13, 2025 at 02:09:43PM -0800, Darrick J. Wong wrote:
> > > > I think you're supposed to have initialized reservation.entry already.
> > > 
> > > What do you mean with that?
> > 
> > I think the reservation was declared to be initialized as zeroes, but
> > there was never an INIT_LIST_HEAD(&reservation.entry) to set the
> > pointers to each other?
> 
> Only the head of the list needs a INIT_LIST_HEAD, the entries which just
> happen to use the list_head structure don't need any initialization out
> of the list_add/list_add_tail call.

Huh.  Ok, that explains why despite people telling me to fix my code to
do that, I've never gotten any of the warnings about broken list usage.

--D
