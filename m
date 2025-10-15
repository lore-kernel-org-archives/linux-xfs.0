Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACAA21885A
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 15:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760541273; cv=none; b=AhBnoqSiOqHXOmLSo8AnZalRVXFgij6iylPD5DK1ToEKKRaRQgQPbN0LlAnIcKFKeLk+iCUahEDyuMFn+luYUVdQD221iRelDZ2C+NIqwKhB6oHU5rGWTozOCbpo7My+MydYuCWmWlUkVLYMnM3+exnDcAE7L59qogwAyiBx1z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760541273; c=relaxed/simple;
	bh=zl7CKxPW3rGp/tzT4zjLV0AVXIMByI3wJaBb5g8f8nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cditlAPkObgLkf5vAPsmbpIgIXeV+L+AtSWYGzFgtk0Gn43wkz5vOTZLKEuT1BaUu/lUhNbJTNDRN/xQZ/RqQMdhD0q6FBscoLPNEzO4sAXboivIiffcNgGBBJMM5BC6dGk/sOGbXlycK3AScYxAcmWaRmzAgtg6/TciG/ke6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=XN7dLolz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="XN7dLolz"
Received: from trampoline.thunk.org (pool-173-48-113-184.bstnma.fios.verizon.net [173.48.113.184])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 59FFDrk7013069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 11:13:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1760541238; bh=/8PdHQt80eigPDJZ5EBlPY1pQSNfCt+AMOYaxY9njWE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=XN7dLolzgmYMYPpg8AxvRudqr3f2lce7C+Lv57v8XFtyyzlXrX7+KqVp6ejSQE3RC
	 ItRezbFf35T3vLyabBS1b1RnKyfAkCkctiBzJpcx7TohOH3kQW8Eo3y+47ULuV6Knu
	 YmjH2S0GJSWQxBMu6lVG8Fx46llx0flAfVn+rL/kFu30B6RkudQELJTvTpZK6wOM4/
	 KO0/7nE8zzghZW2boAGMIj+3WvG/wL7QI6DEGGzv847giX4dLRRnRN2gR/mOgzVG+3
	 K3tzDOKYkPSx5IqSvFe7ajOMWyD0OB9LjZdGlju1aN2FRUCp/rR3iFJhfmWUDhsg2U
	 nASEg5ZKrF1kg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 97EBD2E00D9; Wed, 15 Oct 2025 11:13:53 -0400 (EDT)
Date: Wed, 15 Oct 2025 11:13:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Carlos Maiolino <cem@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
        dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251015151353.GA786497@mit.edu>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-3-hch@lst.de>

On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.

I wonder if we should bump the default; and if the concern is that
might be problematic for super slow devices (e.g., cheap USB thumb
drives), perhaps we can measure the time needed to complete the
writeback, and then dynamically adjust the value based on the apparent
write bandwidth?

We could have each file system implement something like this, but
maybe there should be a way to do this in fs generic code?

	      	    	      	       - Ted
