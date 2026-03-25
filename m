Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FE0351C37;
	Wed, 25 Mar 2026 06:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774420708; cv=none; b=g0RpsLghhBHTXyw8NF1vl2mnLs+D5sP/3x49Sf3uLEkd84gSbqyo5CCvKGkybRqKo/jbwje81bW2LAhJ4wT5n19urnUvfGZKBuUtZxi+j8G9/cuWnzOieVih21zAueFn6V5WUjljF+U3Bq6bfRLX+/uXKs4hSt21U+jgRFcGwtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774420708; c=relaxed/simple;
	bh=UTEEbLYVD1iCwPqVU6o4ZZ7/W47w6mxB6HPoVBwbjCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p87ZERQXNOGl88tEnl+iS6furpwe55M/DzE1qhH7Ozd85U23z1AUDu11zn5C+b6RyePXZezZUiqS+HAGjTDK+PNsqxb9206jWXUd9NvsBDHwWnHC++gfhvnbNYcDDmxJ1Ftd2RN12/qIu2xRa/Ni7vSq5+6jr/JWA/2Es2sIhBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A4ED68B05; Wed, 25 Mar 2026 07:38:22 +0100 (CET)
Date: Wed, 25 Mar 2026 07:38:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Morduan Zang <zhangdandan@uniontech.com>, dgc@kernel.org,
	brauner@kernel.org, cem@kernel.org, dchinner@redhat.com, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com,
	tytso@mit.edu, viro@zeniv.linux.org.uk, zhanjun@uniontech.com
Subject: Re: [PATCH] xfs: defer lazytime timestamp updates to inodegc
 during eviction
Message-ID: <20260325063822.GA32067@lst.de>
References: <absSoRi8oxXSuSZ7@dread> <6EBD01CF561B83EC+20260320100353.220462-1-zhangdandan@uniontech.com> <tet44nv2qc7i7uhrip4gcd7cur2cpn4mmgyh4v6hquaju2xtih@i5s2uco5wemr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tet44nv2qc7i7uhrip4gcd7cur2cpn4mmgyh4v6hquaju2xtih@i5s2uco5wemr>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 24, 2026 at 04:14:23PM +0100, Jan Kara wrote:
> Isn't this problem already fixed by Christoph's patch
> https://lore.kernel.org/all/20260317134409.1691317-1-hch@lst.de ?

It should.  My question to Ted what we're even trying to do in this
context is also still outstanding.

