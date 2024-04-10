Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22A1836E4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783591; cv=none; b=FU1Qv0CAaLF8HU3ybLXfQ/JROVEUdapXb+wGaUqdjnHxkHuMYD1y9xOi/dB0KiU7LSa3rthbeB2tkzM0dnvGpldyRAwBlcnZzSgJGOOyLOUHcWwAvHJhJQ236cWydhbEJX+TPffnm1d5xoDt7KTfM1CmpKY1OxPeLhoQ2OSseMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783591; c=relaxed/simple;
	bh=ZHsfokBeSLBixEF3NCev4pVgCMatdc+sTCwkAx+DLt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcUrWOIW8jcNpgdUwH/OgNXLS2a0QINXGLmMon/0QoTb0tSqjPnE3VNuKfApbkz3UG9QAjWIsZWTkjJHP0tgVF/9niZSWhBOU9yPH7Cilx1TM+JNA2mUo22DDXasFhEigeVtv+gnYfACaDZdHQ3+PQ9r2cYQb6ET0gvB/71YmdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUZUf4nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUZUf4nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD81CC433A6;
	Wed, 10 Apr 2024 21:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712783590;
	bh=ZHsfokBeSLBixEF3NCev4pVgCMatdc+sTCwkAx+DLt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mUZUf4ndZUVsHxk4pohVjfWDgrT7LP2ESMDBdogYNMqskjJJ2QjhOYRqD1g/9ZToX
	 CJsKyIqyrUen8sjjYyoCgTKXtJe4oMTm95TV6eMn0ovQVM7KhxWOsL3XkptJPWpQqj
	 F+yLNlMaNKq6aeE2JeGijcKOBRKpQWTFxWY5Nc6ZZrhhiwyu6lmysrLtyON5IsH1Ey
	 Eiism6Nml1PppvbOs3Zn6WvlghbMUiZHFcIU1io7FfIQVKRBuVQwRPU53+NlpJrvha
	 15cQjz9xjXudWm7Vvz6kiM+UXMOn7xBE1rWLbgQrRvc86eiub7wx31enk1DyE7HEIh
	 uATS/712wE93w==
Date: Wed, 10 Apr 2024 14:13:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/32] xfs: allow xattr matching on name and value for
 local/sf attrs
Message-ID: <20240410211310.GD6390@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969674.3631889.16669894985199358307.stgit@frogsfrogsfrogs>
 <ZhYgylDdpjtxHdvY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYgylDdpjtxHdvY@infradead.org>

On Tue, Apr 09, 2024 at 10:16:58PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:55:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a new XFS_DA_OP_PARENT flag to signal that the caller wants to look
> 
> The flag doesn't actually exist, the match is done on the
> XFS_ATTR_PARENT namespaces.

How about:

"xfs: allow xattr matching on name and value for local/sf pptr attrs

"If a file is hardlinked with the same name but from multiple parents,
the parent pointers will all have the same dirent name (== attr name)
but with different parent_ino/parent_gen values.  To disambiguate, we
need to be able to match on both the attr name and the attr value.  This
is in contrast to regular xattrs, which are matched only on name.

"Therefore, plumb in the ability to match shortform and local attrs on
name and value in the XFS_ATTR_PARENT namespace.  Parent pointer attr
values are never large enough to be stored in a remote attr, so we need
can reject these cases as corruption."

> >  
> > @@ -2444,14 +2477,17 @@ xfs_attr3_leaf_lookup_int(
> >  			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
> >  			if (!xfs_attr_match(args, entry->flags,
> >  						name_loc->nameval,
> > -						name_loc->namelen))
> > +						name_loc->namelen,
> > +						&name_loc->nameval[name_loc->namelen],
> > +						be16_to_cpu(name_loc->valuelen)))
> 
> If we'd switch from the odd pre-existing three-tab indent to the normal
> two-tab indent we'd avoid the overly long line here.
> 
> >  				continue;
> >  			args->index = probe;
> >  			return -EEXIST;
> >  		} else {
> >  			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
> >  			if (!xfs_attr_match(args, entry->flags, name_rmt->name,
> > -						name_rmt->namelen))
> > +						name_rmt->namelen, NULL,
> > +						be32_to_cpu(name_rmt->valuelen)))
> 
> ... and here.

Believe it or not that's what vim autoformat does by default.
But yes, I'll reduce it to two indents to reduce the indentation and
overflow.

> The remote side might also benefit from a local variable to store the
> endian swapped version of the valuelen instead of calculating it twice.

Ok.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
