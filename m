Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD54085B
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144689; cv=none; b=X7a5wq/1vl//0Bsta1uDy9SsVmFz0QycepvciWu5PUz/mwx06Ad8aHRvirSCtZwFVtlICgKzo9zogZ4LwgQ3Ri4Ym7/L1eiaeTPg7z9wddBYMBysqlshXy2PAEH+/OGjL6NVewZyKXcTVKGFQNv9MDVS9ix1l8e5rTtzf/MtAx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144689; c=relaxed/simple;
	bh=5y5BXiJWXc89Mn3GWApwnWnytc7ojs+r4wD3NiyqDNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAtwZofQXll7E1CJLTljQnPK/FXSWENUp+ujncgel4tEHEoAUHxZO1gdz4kMmO8w899hFsVy27T16LmwiHXd7U2p5Eo1qxT0CKLa2HzX7YrEt0Z+HAWYSa2cys0VxSpRec9fMBr71PZPkUil9rMNPt/ElqZBTpgNRrLGyfQZz4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ej9bZkaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej9bZkaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20AEC433F1;
	Wed, 28 Feb 2024 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709144688;
	bh=5y5BXiJWXc89Mn3GWApwnWnytc7ojs+r4wD3NiyqDNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ej9bZkaMxvUBPfIRFR+mPYx6Un/htI/G4qhlDDOyqTtAiXxJioLOv+/xBBKu5aDpy
	 ntEgM91q2m2bqp6rKofqUQy09aEVo5s7yiJrxGKOEzqD/BwzPImPjpTDQzNpIMg81R
	 tDhkKdQI3EU/Q/Rdz+BNV/jDQpgXitEeWz1eEbqAwlrUVpUgSgrAQNls/GNQ8/VvMe
	 vkB+B52CC+kHF/3oitf1I6bVAcAQ0Ou7iB9jPQJ0VvHYIT1abny3qWAnYkcf7P9053
	 uRRuSEeFSybqBnFMgcMrqFBU5HT+Zu0lXXpvWkMBVxt4vlzDMN49625nAK9X83gU1o
	 nHuZk0meU97Vg==
Date: Wed, 28 Feb 2024 10:24:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/4] xfs: ask the dentry cache if it knows the parent of
 a directory
Message-ID: <20240228182448.GN1927156@frogsfrogsfrogs>
References: <170900014444.939516.15598694515763925938.stgit@frogsfrogsfrogs>
 <170900014522.939516.4778985900477583664.stgit@frogsfrogsfrogs>
 <Zd9reRana7Fue2pN@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9reRana7Fue2pN@infradead.org>

On Wed, Feb 28, 2024 at 09:20:57AM -0800, Christoph Hellwig wrote:
> > +	parent = dget_parent(dentry);
> > +	if (!parent)
> > +		goto out_dput;
> > +
> > +	if (parent->d_sb != sc->ip->i_mount->m_super) {
> > +		dput(parent);
> > +		goto out_dput;
> > +	}
> 
> ->d_parent can't point to outside the current sb.

I know, I was being paranoid.  Granted if the dcache is broken then
there are probably bigger issues going on. :)

I'll change it to an ASSERT.

--D
