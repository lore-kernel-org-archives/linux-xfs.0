Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26EB386C18;
	Mon, 24 Aug 2026 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787549502; cv=none; b=ZzL8vNyilUMGgKSW2R9+ZTe0ZO8XMQn4qOTui1tb2f4VjuE+yhHpFBuZkcB3kfKibvNAX7TPmOmU9R459pbVbWxX1yePVlGCfeaYXNSusC6v7hn4E6XXofyrmgbDge43Wj3kwtR6OiAc3LMTWnraNceRux5nnW6x4ugu6aM8vnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787549502; c=relaxed/simple;
	bh=hL3W2i69T4vIVFrzzfRmTrM1EofqB8vyBE2NeAugSDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwCJXvFL1o4gfqW9MhX8vugvn6RZ+wAggZlK9qmsEem9I+xNAKVUwUJMFkSMACMJozaSWbJAbSX/FsvZe+gqmH9VsLYDDgeJxWpq6MzMNARUHWH2D9ypunPBnlZzM3DRf+AN+l2V2ywUSujUue3hZfkiXXME1aGug31PtGZYuys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrVqxsv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrVqxsv1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 41D841F000E9;
	Mon, 24 Aug 2026 05:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787549490;
	bh=FpKFLsTffJ0QokoJpPvbRB4QKpZ0+mT8aywFQ7R7CY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZrVqxsv1AP7DZS9YnIBDY3xWcVWBmb7Cj7Znvl2xbP172u7qwRMnFAcoPIdbtVC30
	 MaLgUk4arBTh42ah6dfAXga9RrblJx43eQPFNhFHvVzlr9BQbGP3J90PJNMJnJCXBJ
	 wwkTG2GKYpfdP4eUJeZls+/gndDa2xhKwSB6lRuMFHBptzjUhrlbA6gfZftQvD9q2C
	 LT7at6vXtmEH+opWEBHHV9KaB6pNcBnZNtImKDX90mq9lUc1RZAiUziYlqjuRcgCDC
	 TnoF5+siOz6XWlMKTP7w9Wwqr56j9ks/r+VugELGqtXyZvAJQQE3sEBZwTF+KWiq0X
	 cFLoeWAyI9Hiw==
Date: Sun, 23 Aug 2026 22:31:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix media verification ioctl for internal rt volumes
Message-ID: <20260824053129.GD6110@frogsfrogsfrogs>
References: <20260821035806.GJ6072@frogsfrogsfrogs>
 <20260824045053.GA29508@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824045053.GA29508@lst.de>

On Mon, Aug 24, 2026 at 06:50:53AM +0200, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I'm starting to wonder if operating on FSBs instead of BBs in the media
> verification ioctl would clean up much of this.  But I guess we care about
> being able to pinpoint media errors to sub-FSB ranges?

It would probably clean things up ... but OTOH all the other userspace
APIs use BBs and don't expose the segmented FSB/RTBs to userland.

Anyway thanks for reviewing :)

--D
