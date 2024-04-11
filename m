Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F651C0DE7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 04:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712809850; cv=none; b=XRt3aY9d2tcUqJqmHm3h41ZttJrNeEzDF7jZ+djN/bkMZ4ah2y99E+j+7Bt0zDg0e63eAdYO44zqinjStfrggq9w0dgtqnAIWgO/LrYUXAynM1FcsHSKyJ2Ah/Nck1iiOugsYnh+9DHpokwxCKnTcVFprnUYtpISVSIsW6Dv5Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712809850; c=relaxed/simple;
	bh=hBDzAbKTMp+6WVcbCU6nMD8B4zxoBZ64dHKCa2xazaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oi7rQgGaPJ8bt+ARoC1U/7mqtPRfFB7jKbBKW/huegBsqoaxtU2ewR6XjjbLz4psvxFWTDi+B1G+RlLZH7VAZWcZdg3QdEAXaQD2s2YV5mW1w+HhaBOTU71z2hx8u/EO9EonhYIPWN+8DERrMF+O7SAZw1OiXTHsg/xr1Ku4qTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSC9VKR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSC9VKR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DFC433F1;
	Thu, 11 Apr 2024 04:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712809849;
	bh=hBDzAbKTMp+6WVcbCU6nMD8B4zxoBZ64dHKCa2xazaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSC9VKR/e5b1ooDE/W/sts3YuDKHSQJe2mJcSugIJ98fhRO97B9sJajEKonyCJMSd
	 TYfbe0hDgRyZM1QzKexhkhzk087jOlVwfRpD4Iqc0AMje4YGPJ2idM++emZQxOjHbL
	 Grn/9mp/4dMfMi9rLA3oW0BFjlVRFLLPSxm+YJfB1TCEXqv6IaGPn3ctWE1B/1KqOA
	 aLG2DW7l4N34I6+oL7maG/CIZu0NdlILcEh9soXj2irkSwOt0LoZTI2ugyxeYnlC0a
	 MljyulXxnD6/ejc3EAogak6O0G9xYf+9aAnR/ysn84NWnfmOFgC4RAntDgII2M6xWv
	 RJ5SMWD9mLrUA==
Date: Wed, 10 Apr 2024 21:30:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/14] xfs: add xattr setname and removename functions
 for internal users
Message-ID: <20240411043048.GU6390@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971004.3632937.5852027532367765797.stgit@frogsfrogsfrogs>
 <ZhYvG1_eNLVKu3Ag@infradead.org>
 <20240410221844.GL6390@frogsfrogsfrogs>
 <ZhdZ3IjRjdvqtppH@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhdZ3IjRjdvqtppH@infradead.org>

On Wed, Apr 10, 2024 at 08:32:44PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 03:18:44PM -0700, Darrick J. Wong wrote:
> > > Is there a good reason to have a separate remove helper and not
> > > overload a NULL value like we do for the normal xattr interface?
> > 
> > xfs_repair uses xfs_parent_unset -> xfs_attr_removename to erase any
> > XFS_ATTR_PARENT attribute that doesn't validate, so it needs to be able
> > to pass in a non-NULL value.  Perhaps I'll add a comment about that,
> > since this isn't the first time this has come up.
> > 
> > Come to think of it you can't removename a remote parent value, so I
> > guess in that bad case xfs_repair will have to drop the entire attr
> > structure <frown>.
> 
> Maybe we'll need to fix that.  How about you leave the xattr_flags in
> place for now, and then I or you if you really want) replace it with
> a new enum argument:
> 
> enum xfs_attr_change {
> 	XFS_ATTR_CREATE,
> 	XFS_ATTR_REPLACE,
> 	XFS_ATTR_CREATE_OR_REPLACE,
> 	XFS_ATTR_REMOVE,
> };

Heh, I almost did that:

enum xfs_attr_change {
	XAC_CREATE	= XATTR_CREATE,
	XAC_REPLACE	= XATTR_REPLACE,
	XAC_UPSERT,
	XAC_REMOVE,
};

(500 patches from now when I get around to removing xattr_flags & making
it a parameter.)

> and we pass that to xfs_attr_set and what is current xfs_attr_setname
> (which btw is a name that feels really odd).  That way repair can
> also use the libxfs attr helpers with a value match for parent pointers?

I think this is a good idea.  Maybe even worth rebasing through the
tree.

--D
