Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034883019AA;
	Wed,  3 Jun 2026 13:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780494132; cv=none; b=iN4TU9Pi7FD87mtYldybu8UsiawYnaY4eVxoHr3Efu0/FXYPAq9oxoWHOH9TeNcwV1KUkSly/twz7NiH41ALh9KLmiyiW2eDedBmXoArR4XW1YAZCGELaGdBCH/hMGaQGrZFilfYFt/KZM2v2KU2XlBfypVEZp2rYp4w2HKDhYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780494132; c=relaxed/simple;
	bh=20NIHqWNkYzNtWsw5gcXIpkfj7VXIC9slkxS6qDvrqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuBwSDkkf+PPe9xeulw9YkSL1oMc1TyGec+TQvWMwS9FuSWL6rhyqFomlZW2C4HgVA3il0L7XdQU2mF0LMvjuOYWmUELXejr2x9cijXNl+8V2MTXmfRMFQ98zInotHPT3reEmVksqTA0D+ky87fzl4LZOKLRM9MN45tPa0/O6nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kkHGJzvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kkHGJzvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F8C1F00893;
	Wed,  3 Jun 2026 13:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780494131;
	bh=20NIHqWNkYzNtWsw5gcXIpkfj7VXIC9slkxS6qDvrqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kkHGJzvFmAwfe3z2sRaxyWOciskIY5l8XO36H8XCn7X5GWfWbSBONcHL3hBYcW/gY
	 ZlqPSY13HQrlaQOmPDtp35fUJLoonxsA9tJYNvzbrqbhfD3CFuDndt7/P6fdcBhamn
	 XgXphrAI0uEyeDchylT4q46uU76+EIBZTAR8mBPW/a4pifkUFt9gqDWjnbzsrvbSgg
	 G76X7bKtjuPCY+Lfmw6SN7GU01neZ5VaSqQSXKKxdaBZ5Y1znFYNcEYK3ODCsorEO0
	 M4H/hTOFuTRLsflTDrUSEfNcd4ZzTlc+om3ghi5m8D1Ly+p3ITZcQyXtaDPJFhXkhL
	 OBM8VgOGRJ8EQ==
Date: Wed, 3 Jun 2026 15:42:05 +0200
From: Christian Brauner <brauner@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC 7/8] erofs: open via dedicated fs bdev helpers
Message-ID: <20260603-nieder-ausdehnen-siebdruck-aa96f40ebec6@brauner>
References: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
 <20260602-work-super-bdev_holder_global-v1-7-bb0fd82f3861@kernel.org>
 <7c5bfcf0-36a3-4cc6-bf31-6af4fc901c37@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c5bfcf0-36a3-4cc6-bf31-6af4fc901c37@linux.alibaba.com>

> May I ask if it's an urgent 7.2 work? If not, I could

No no, it's way too late for that this cycle.

> make a preparation patch for the upcoming 7.2 cycle
> to handle erofs_map_dev() failure here so you don't
> need to bother with this in this patchset.

Sounds good. I take it you can just do this yourself without me.

> I will seek more time to resolve the recent todos

Thanks!

> yet always intercepted by other unrelated stuffs.

:)
