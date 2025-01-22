Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9837214A619;
	Wed, 22 Jan 2025 06:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737526093; cv=none; b=BKA6bSlJnUC9tKDLMXKvzKiMjTwKHFuFeveg8zh9OMgLibaVWHKbpQzGjYWxuyoLg7rL2XR55KNBcmryQYt06BsKuA0fxFayYO/sQUjCboejY1/kWhddu4+G4jo37E74BiWcJe+rznuCPQV8thorUveRMRHF7onRSIW9/OUBv2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737526093; c=relaxed/simple;
	bh=KjJMs8fHVwKHv6OEfexa9LSO1lfvBeAQDSndd5UClnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sjz1lFrdk9L1z0IcgPzdI4QvjcDQ6EJUh6VY9Acj3Tz2nBDOS7Pqw9yKYze0rdEDzWZx7GO5JaJ+NfSixWcjQolnTOh6gkvORuRoms76soo6V4dBvcjF1YF088MNxWD8uOPM0+i6FgQgjwCel9vkGYzJMJWBP0ncakTnKMVBbZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lGzK/p2a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lGzK/p2a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=esCE0uoIt2v9CGg9foXrw4Ks2MQtiIQdLM2LCx2319Y=; b=lGzK/p2ahqdQfJRAUt7dvNrjBT
	EE99qi+u4vGdUSqzRVDlyfSdNdrsE5XWjNtTrt9jMn0FKoxFo4yhnWHD9tH6vTkftD5fKyGfD5t4W
	wN90pWOopUXJlQda8fnOAFANxzYGUqSCGImm3zFWR2mKHjsg+Sl0fiDsKj+vf4xbjSKRN/Kmmv4JQ
	6DBURcXUYx5d1FyDzDs0T3vzM3F07HKxaWCkc3+L4AGr83PC8UxNomi8PR81qwdbeKNX8twJsCZoe
	xvx2SwgvJrne01qzvO3mleqSkGCwCYgiVojWtN+pKO8ZNvSJe7Ps5LDlB+rDHLH/371/kBjj4E8fB
	IVeTEPAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1taTuM-00000009STs-08pS;
	Wed, 22 Jan 2025 06:08:10 +0000
Date: Tue, 21 Jan 2025 22:08:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chi Zhiling <chizhiling@163.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>,
	John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
Message-ID: <Z5CLSmrBvp66WHPP@infradead.org>
References: <20250108173547.GI1306365@frogsfrogsfrogs>
 <Z4BbmpgWn9lWUkp3@dread.disaster.area>
 <CAOQ4uxjTXjSmP6usT0Pd=NYz8b0piSB5RdKPm6+FAwmKcK4_1w@mail.gmail.com>
 <d99bb38f-8021-4851-a7ba-0480a61660e4@163.com>
 <20250113024401.GU1306365@frogsfrogsfrogs>
 <Z4UX4zyc8n8lGM16@bfoster>
 <Z4dNyZi8YyP3Uc_C@infradead.org>
 <Z4grgXw2iw0lgKqD@dread.disaster.area>
 <CAOQ4uxjRi9nagj4JVXMFoz0MXP_2YA=bgvoiDqStiHpFpK+tsQ@mail.gmail.com>
 <Z4rXY2-fx_59nywH@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4rXY2-fx_59nywH@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Jan 18, 2025 at 09:19:15AM +1100, Dave Chinner wrote:
> And, quite frankly, the fact the bcachefs solution also covers AIO
> DIO in flight (which i_rwsem based locking does not!) means it is a
> more robust solution than trying to rely on racy i_dio_count hacks
> and folio residency in the page cache...

The original i_rwsem (still i_iolock then) scheme did that, but the
core locking maintainers asked us to remove the non-owner unlocks,
so I did that.  It turns out later we got officially sanctioned
non-owner unlocks, so we could have easily add this back.  I did that
5 years ago, but reception was lukewarm:

http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/i_rwsem-non_owner
