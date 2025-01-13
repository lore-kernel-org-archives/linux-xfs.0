Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD12D13777E
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 16:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736785295; cv=none; b=K91/dGwfTVEj2LxdKKYpXUKhz1vRqFsLc55kHQwIjRjMzvOMLszXH18QzmxA4Q2SbDvkzgaTgDc0YqYNE4h3vEHAcrOwmZv4w+LQtMATV61orHNqv6sje65MIkkcHDnFukdqoDttWFnHGZ0X7nsSQafeb1b04H9RTlSWrURkJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736785295; c=relaxed/simple;
	bh=kJteNvDnFUhburUUVDUBpI9dScA8llaNLudSQV6ETH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6PQIj6B1IfUoE3/+MvjzV6iS1zAyP5ctcvLxHFFcKi9uf6EEfFIe0LkkQZuBZb7y58j3wavdSRKxqEZTKO8T+NpIrJpV+2eV4ZPDyXX7v2XvEd1RDrYR5LbOZa14+zf0P5LS7te+AFyskri9wAdk2rc8OS/dRFb4/pYg00Dz6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ShhIzzeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShhIzzeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFAAC4CED6;
	Mon, 13 Jan 2025 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736785295;
	bh=kJteNvDnFUhburUUVDUBpI9dScA8llaNLudSQV6ETH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ShhIzzeg+aN0KCxWQJm/cMf0GU0xu0An7ldjnuGQXANpIgz5/iszKC8i6iuSvVbYa
	 4aL4gWNSEzKbxs3cQ1M33l7pPLDRsgiwP02SuxZiL8IZxq6e9bZYWrTPeHv3mqlfYR
	 wRPR88BYjCr7V3cuDlI8Z5AmfHwlPXwhmuqt/lFA5HmSpWoI819LwfKeYvJtAGcw+3
	 peOx9gJIuT5zjoQ2UYfDnfcPMkwhnApKnnc8MVYcvJ5eq0uUzCa2ElIF9G6Ot1Novh
	 Zllv/az1cJ6wJszJEjv2HBBOQKifs4P5vdswWGTgO1PpHbqDsz2TDrKjgWLfyXzZjh
	 YXC4RjpHGm2Ig==
Date: Mon, 13 Jan 2025 08:21:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: lock dquot buffer before detaching dquot from
 b_li_list
Message-ID: <20250113162134.GD1306365@frogsfrogsfrogs>
References: <20250109005402.GH1387004@frogsfrogsfrogs>
 <173677158754.21511.9707589214851624907.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173677158754.21511.9707589214851624907.b4-ty@kernel.org>

On Mon, Jan 13, 2025 at 01:33:07PM +0100, Carlos Maiolino wrote:
> On Wed, 08 Jan 2025 16:54:02 -0800, Darrick J. Wong wrote:
> > We have to lock the buffer before we can delete the dquot log item from
> > the buffer's log item list.
> > 
> > 
> 
> Applied to next-rc, thanks!
> 
> [1/1] xfs: lock dquot buffer before detaching dquot from b_li_list
>       commit: 4e7dfb45fe08b2b54d7fe2499fab0eeaa42004ad

Um... you already pushed this to Linus, why is it queued again?
(albeit with the same commit id so I don't think it matters)

--D

> Best regards,
> -- 
> Carlos Maiolino <cem@kernel.org>
> 
> 
