Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10398146A88
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367438; cv=none; b=fGzN+fOjReCvoWpjhC9L7L8WowYyhIbt3qMszBSsEaP68DGvYIuwbcd3m4wH4ojrHGWH7hc963kO5snnS1PEEBJ1ZYdCjJqL9NU9Ali7n+7qdTSzMt/jUGmg6+1IoThnOXv0HMzfN5/PtKwn9r4rzPbS58iufqq4yztpY/iGFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367438; c=relaxed/simple;
	bh=u7GrAkRnhpbSO42E3lLRW/c3z7kETRIeaImkWjpUn4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d/ZK0+V3bCLhjvKTySohGx0aQvoq4+rtpVNZW+yV7UgWR+8ALRdGGUmNUquFp1o1NAjGZlACzktH1sS2bsOsLrme9rE0j/XhKWEGDqfAj+FCRHB+3FhFUrST9lb+RomXvfu/n5Cf2K5OqOf/AjmFDhF7IU3z5zUwkZa36Yi/rxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tn5PmUm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tn5PmUm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984BC2BD11;
	Wed, 17 Apr 2024 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367437;
	bh=u7GrAkRnhpbSO42E3lLRW/c3z7kETRIeaImkWjpUn4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tn5PmUm+AFqj0VAMUTga7ydLD7wcWXcQTQGsITddB/eA4TSOAs8CbUPusSd3yYylW
	 BeNDHASSyq5x0+rhz8NgjVr/VL9kv3aVkGmCd5haZ7j3+1bEE5g5ZwUL9TabCct80G
	 lkOy+k2FnU/Co/XmW3YURHCxlc+gXt3kkVcE0nkRy3A7/EX5psRDN0K42Mlw0pD5oA
	 15o2U0RWKknjyJtqjZcQ4zu81r1khdUnFaXJY8oTiwKHps9dtB/WjkkEs/vazZWs0/
	 7gl7S/CVZBBknA2IAYdcQhc71kBAKQpk0p3ypZjtKNtgY+p6TGtdJEggF8oaxsF68l
	 k9v4x2S7mLvuA==
Date: Wed, 17 Apr 2024 08:23:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <20240417152357.GW11948@frogsfrogsfrogs>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <20240417151834.GR11948@frogsfrogsfrogs>
 <Zh_ok7hsmUTpiihC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh_ok7hsmUTpiihC@infradead.org>

On Wed, Apr 17, 2024 at 08:19:47AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > > on the list and not included in this update, please let me know.
> > 
> > Ah well, I was hoping to get
> > https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> > and
> > https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> > in for 6.7.
> 
> Shouldn't we have a 6.8 follow pretty quickly anyway?

Yes, but right now you can't build a 6.7 debian package without

https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/

and libxfs doesn't match between kernel 6.7 and xfsprogs 6.7 without:

https://lore.kernel.org/linux-xfs/171142126323.2211955.1239989461209318080.stgit@frogsfrogsfrogs/

--D
