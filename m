Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897161FF7C4
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 06:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739514070; cv=none; b=fK3LSLZETRTHJkJbHuwvxnx6nLKsPvp6YIhv+23clZgDfo9OLN0+CwVRbgKacdXkCV+aT+WJ1wL5c+Up1vBr8hygPDx9DSU68hdtOOy2UHK+kRS0jqbRvvAin9p6I1+bHC+OfwOr8GDapouYjJ4fBdn9903jp1nNM/15eFImKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739514070; c=relaxed/simple;
	bh=WMg49SlsCTiymmjAHXLpjXAyG+c7SDhhLeke3KHTC5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7rCDaXAwjNQnRxMqWIcGz8Dupvj2Sdm4T7nz1yoop0Pg467e1E+ajyVNI6T4UlaVkwFOLK6CQLu5SppjKH5cvorawMcrXT+b7/FbVJceMZ6D+2rTekrwW8nb5lAX1wpwcs4xuBZ4ETeW0ibcJj1Nars914v+RiCJXxSOC4GSSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 820E468D12; Fri, 14 Feb 2025 07:20:55 +0100 (CET)
Date: Fri, 14 Feb 2025 07:20:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: add support for zoned space reservations
Message-ID: <20250214062054.GA25903@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-24-hch@lst.de> <20250207175231.GA21808@frogsfrogsfrogs> <20250213051749.GD17582@lst.de> <20250213220943.GU21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213220943.GU21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 13, 2025 at 02:09:43PM -0800, Darrick J. Wong wrote:
> > > I think you're supposed to have initialized reservation.entry already.
> > 
> > What do you mean with that?
> 
> I think the reservation was declared to be initialized as zeroes, but
> there was never an INIT_LIST_HEAD(&reservation.entry) to set the
> pointers to each other?

Only the head of the list needs a INIT_LIST_HEAD, the entries which just
happen to use the list_head structure don't need any initialization out
of the list_add/list_add_tail call.

