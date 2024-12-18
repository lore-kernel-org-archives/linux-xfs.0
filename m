Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD6214A624
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 07:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734506011; cv=none; b=PGQzesvi3ghtb0uqysQxVp7Wln09OpNFo5uqt7WDzfGuMrywKBLxB8RdldmYMb2KnVq8pixSE3LPNn/Q9fA9928trLVo7kQqtWLL83+C42M9ijnXJKMa2mDNn/+zkdBwhWpGkJkj4R5mPC6q9gJxMo003aSWvnj6JUJx3Cf64vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734506011; c=relaxed/simple;
	bh=AAP9pEvrOsYXdZRQzXH8jQkBCe6eYWoKtVCnZz2KhzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bYoCO6Hi5EOtssQ4oO2WF+N6ZgNg302TNmWr+CaTjzL2TMvOVrW9cZm5e7vOSLQ0N/a+AgOrCFox6vhTUhbfM59mEwhCKvdGJrwa4IzoPa3hJaiAsWqpU/ASK1KnhM2tm+TZJ6ipXvhgsk/LqWjhJ2MHPWe8iUawpflwOYdB380=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 24EB268AA6; Wed, 18 Dec 2024 08:13:25 +0100 (CET)
Date: Wed, 18 Dec 2024 08:13:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/43] xfs: implement zoned garbage collection
Message-ID: <20241218071323.GC25652@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-27-hch@lst.de> <20241213221851.GP6678@frogsfrogsfrogs> <20241215055723.GF10051@lst.de> <20241217012753.GE6174@frogsfrogsfrogs> <20241217040655.GA14856@lst.de> <20241217174233.GM6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217174233.GM6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 17, 2024 at 09:42:33AM -0800, Darrick J. Wong wrote:
> Also: while I was poking around with Felipe's ficlone/swapon test it
> occurred to me -- does freezing the fs actually get the zonegc kthread
> to finish up whatever work is in-flight at that moment?

Looking at the code it probably does not.  Let me see if I can come up
with a test to expose that, i.e. heavy GC activity, freeze, mark the
underlying device RO and see if something explodes (based on my reading
it should right now).
